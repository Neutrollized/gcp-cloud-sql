data "google_compute_network" "default_network" {
  name    = "default"
  project = var.project_id
}

data "google_compute_subnetwork" "default_subnet" {
  name    = "default"
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
