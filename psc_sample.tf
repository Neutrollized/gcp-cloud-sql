#------------------------------------------------------------------------------------
# NOTE
# The infrastructure provisioned here creates a PSC endpoint in
# the same project & default VPC that the Cloud SQL instance is peered to
#
# The purpose is to show the resources & setup required 
#------------------------------------------------------------------------------------

#-----------------------
# PSC endpoint
#-----------------------
resource "google_compute_address" "default" {
  count        = length(var.allowed_consumer_projects) > 0 ? 1 : 0
  name         = "psc-compute-address-${google_sql_database_instance.main.name}"
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = data.google_compute_subnetwork.private_subnet.name
}

resource "google_compute_forwarding_rule" "default" {
  count                   = length(var.allowed_consumer_projects) > 0 ? 1 : 0
  name                    = "psc-endpoint-${google_sql_database_instance.main.name}"
  region                  = var.region
  load_balancing_scheme   = ""
  target                  = google_sql_database_instance.main.psc_service_attachment_link
  network                 = data.google_compute_network.private_network.name
  ip_address              = google_compute_address.default[count.index].self_link
  allow_psc_global_access = true # clients from all regions can access this fwding rule
}


#-----------------------------------
# DNS
# https://cloud.google.com/sql/docs/mysql/configure-private-service-connect#configure-dns
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone
#-----------------------------------
resource "google_dns_managed_zone" "private_zone" {
  count       = length(var.allowed_consumer_projects) > 0 ? 1 : 0
  name        = "cloudsql-private-zone"
  dns_name    = "${var.region}.sql.goog."
  description = "Private DNS zone for Cloud SQL"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.google_compute_network.private_network.id
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set
resource "google_dns_record_set" "cloud_sql_psc_dns" {
  count = length(var.allowed_consumer_projects) > 0 ? 1 : 0
  name  = google_sql_database_instance.main.dns_name
  type  = "A"
  ttl   = 300

  managed_zone = google_dns_managed_zone.private_zone[count.index].name

  rrdatas = [
    google_compute_address.default[count.index].address,
  ]
}
