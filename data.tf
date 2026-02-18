data "google_compute_network" "private_network" {
  name    = var.private_network_name
  project = var.project_id
}

data "google_compute_subnetwork" "private_subnet" {
  name    = var.private_subnet_name
  region  = var.region
  project = var.project_id
}


#-----------------
# unused
#-----------------
data "google_netblock_ip_ranges" "health-checkers" {
  range_type = "health-checkers"
}

data "google_netblock_ip_ranges" "iap-forwarders" {
  range_type = "iap-forwarders"
}
