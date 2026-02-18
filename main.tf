resource "google_project_service" "sql-component" {
  service = "sql-component.googleapis.com"
}

resource "google_project_service" "sqladmin" {
  service = "sqladmin.googleapis.com"
}

resource "google_project_service" "secretmanager" {
  service = "secretmanager.googleapis.com"
}


# need to generate a unique suffix for Cloud SQL sql instance 
# as the name cannot be reused for ~7 days after deletion
resource "random_pet" "sql_instance_suffix" {
  length    = 2
  separator = "-"
}

#-------------------------------
# Cloud SQL instance
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
#-------------------------------
resource "google_sql_database_instance" "main" {
  name             = "${var.sql_instance_name}-${random_pet.sql_instance_suffix.id}"
  database_version = var.db_version
  region           = var.region

  settings {
    availability_type           = var.availability_type
    deletion_protection_enabled = var.deletion_protection_enabled

    # Second-generation instance tiers are based on the machine type
    # i.e. "db-f1-micro"
    # There's more high-perf tiers that are named differently,
    # see the full list with `gcloud sql tiers list`
    tier                  = var.machine_tier
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
      private_network                               = data.google_compute_network.private_network.id
      ssl_mode                                      = var.ssl_mode
      enable_private_path_for_google_cloud_services = var.enable_private_path_for_gcp_services

      dynamic "psc_config" {
        for_each = length(var.allowed_consumer_projects) > 0 ? [1] : []
        content {
          psc_enabled               = true
          allowed_consumer_projects = var.allowed_consumer_projects
        }
      }

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

    connection_pool_config {
      connection_pooling_enabled = var.connection_pooling_enabled
      dynamic "flags" {
        for_each = var.connection_pooling_enabled ? var.connection_pooling_flags : []
        content {
          name  = flags.value["name"]
          value = flags.value["value"]
        }
      }
    }

    retain_backups_on_delete = var.backup_enabled ? var.retain_backups_on_delete : null
    dynamic "backup_configuration" {
      for_each = var.backup_enabled ? [1] : []
      content {
        enabled = var.backup_enabled

        binary_log_enabled             = startswith(var.db_version, "MYSQL") ? var.binary_log_enabled : false
        point_in_time_recovery_enabled = startswith(var.db_version, "POSTGRES") ? var.pitr_enabled : false

        start_time                     = var.backup_start_time
        location                       = var.backup_location != null ? var.backup_location : var.region
        transaction_log_retention_days = var.transaction_log_retention_days # postgres setting

        dynamic "backup_retention_settings" {
          for_each = var.retained_backups != null ? [1] : []
          content {
            retained_backups = var.retained_backups
            retention_unit   = "COUNT"
          }
        }
      }
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
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
      condition     = var.edition == "ENTERPRISE" && var.connection_pooling_enabled == false || var.edition == "ENTERPRISE_PLUS"
      error_message = "Managed Connection Pooling is only supported by ENTERPRISE_PLUS edition"
    }
    precondition {
      condition     = var.edition == "ENTERPRISE" && var.transaction_log_retention_days >= 1 && var.transaction_log_retention_days <= 7 || var.edition == "ENTERPRISE_PLUS" && var.transaction_log_retention_days >= 1 && var.transaction_log_retention_days <= 35
      error_message = "The number days you can set for transaction log retention is 1-7 for ENTERPRISE edition and 1-35 for ENTERPRISE_PLUS edition"
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
      settings[0].connection_pool_config,
      settings[0].disk_size,
    ]
  }
}


#---------------------
# database
#---------------------
resource "google_sql_database" "database" {
  name     = var.sql_database_name
  instance = google_sql_database_instance.main.name

  depends_on = [
    google_sql_user.db_user,
  ]
}
