data "google_compute_network" "default_network" {
  name    = "default"
  project = var.project_id
}


# need to generate a unique suffix for Cloud SQL sql instance 
# as the name cannot be reused for ~7 days after deletion
resource "random_pet" "sql_instance_suffix" {
  length    = 2
  separator = "-"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
resource "google_sql_database_instance" "main" {
  name             = "${var.sql_instance_name}-${random_pet.sql_instance_suffix.id}"
  database_version = var.db_version
  region           = var.region

  settings {
    deletion_protection_enabled = var.deletion_protection_enabled

    # Second-generation instance tiers are based on the machine type
    # i.e. "db-f1-micro"
    # There's more high-perf tiers that are named differently,
    # see the full list with `gcloud sql tiers list`
    tier                  = "db-${var.machine_type}"
    edition               = var.edition
    connector_enforcement = var.connector_enforcement

    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    disk_size             = var.disk_size
    disk_type             = var.disk_type

    enable_dataplex_integration  = var.enable_dataplex_integration
    enable_google_ml_integration = var.enable_vertexai_integration

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value["name"]
        value = database_flags.value["value"]
      }
    }

    ip_configuration {
      ipv4_enabled                                  = var.ipv4_enabled
      private_network                               = data.google_compute_network.default_network.id
      ssl_mode                                      = var.ssl_mode
      enable_private_path_for_google_cloud_services = var.enable_private_path_for_gcp_services

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          # 'name' is technically optional, but I'm making it required in my case
          name            = authorized_networks.value["name"]
          value           = authorized_networks.value["value"]
          expiration_time = contains(keys(authorized_networks.value), "expiration_time") ? authorized_networks.value["expiration_time"] : null
        }
      }

    }
  }

  # need to set and "terraform apply" before you can delete
  # this only applies to Terraform
  deletion_protection = var.deletion_protection_enabled

  lifecycle {
    precondition {
      condition     = var.edition == "ENTERPRISE" || var.edition == "ENTERPRISE_PLUS" && contains(["MYSQL_8_0", "MYSQL_8_4", "POSTGRES_12", "POSTGRES_13", "POSTGRES_14", "POSTGRES_15", "POSTGRES_16", "POSTGRES_17"], var.db_version)
      error_message = "Selected db_version is not supported by ENTERPRISE_PLUS edition"
    }
    precondition {
      condition     = (startswith(var.disk_type, "PD_") && var.disk_size >= 10) || (startswith(var.disk_type, "HYPERDISK_") && var.disk_size >= 20)
      error_message = "If disk type is a HYPERDISK, the disk_size should be at least 20GB"
    }
    precondition {
      condition     = (var.disk_autoresize == true && var.disk_autoresize_limit == 0) || (var.disk_autoresize == true && var.disk_autoresize_limit > var.disk_size) || var.disk_autoresize == false
      error_message = "Your specified disk_autoresize_limit should be greater than your disk_size"
    }
    ignore_changes = [
      settings[0].disk_size,
    ]
  }
}

resource "google_sql_database" "database" {
  name     = var.sql_database_name
  instance = google_sql_database_instance.main.name
}
