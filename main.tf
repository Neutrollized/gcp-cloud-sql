resource "random_pet" "sql_instance_suffix" {
  length = 2
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
    tier                  = "db-${var.machine_type}"
    edition               = var.edition
    connector_enforcement = var.connector_enforcement

    disk_autoresize = var.disk_autoresize
    disk_size       = var.disk_size
    disk_type       = var.disk_type

    enable_dataplex_integration  = var.enable_dataplex_integration
    enable_google_ml_integration = var.enable_vertexai_integration

    #    ip_configuration {
    #  ipv4_enabled = true
    #}
  }

  # need to set and "terraform apply" before you can delete
  # this only applies to Terraform
  deletion_protection = var.deletion_protection_enabled

  lifecycle {
    precondition {
      condition     = (startswith(var.disk_type, "PD_") && var.disk_size >= 10) || (startswith(var.disk_type, "HYPERDISK_") && var.disk_size >= 20)
      error_message = "If disk type is a HYPERDISK, the disk_size should be at least 20GB"
    }
    ignore_changes = [
      settings[0].disk_size,
    ]
  }
}
