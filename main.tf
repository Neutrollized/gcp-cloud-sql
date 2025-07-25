resource "random_pet" "sql_instance_suffix" {
  length = 2
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
resource "google_sql_database_instance" "main" {
  name             = "${var.sql_instance_name}-${random_pet.sql_instance_suffix.id}"
  database_version = var.db_version
  region           = var.region

  settings {
    # Second-generation instance tiers are based on the machine type
    # i.e. "db-f1-micro"
    tier    = "db-${var.machine_type}"
    edition = var.edition
  }

  # need to set and "terraform apply" before you can delete
  deletion_protection = false
}
