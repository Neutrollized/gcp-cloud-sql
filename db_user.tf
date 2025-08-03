# https://www.hashicorp.com/en/blog/ephemeral-values-in-terraform
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/ephemeral-resources/password
ephemeral "random_password" "db_password" {
  length           = 12
  override_special = "!#$%&*-_=+?"
}

resource "google_secret_manager_secret" "db_secrets" {
  secret_id = "sql_db_password"

  labels = {
    instance = google_sql_database_instance.main.name
    user     = var.sql_user
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret = google_secret_manager_secret.db_secrets.id

  secret_data_wo         = ephemeral.random_password.db_password.result
  secret_data_wo_version = 1
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
resource "google_sql_user" "db_user" {
  name                = var.sql_user
  instance            = google_sql_database_instance.main.name
  password_wo         = ephemeral.random_password.db_password.result
  password_wo_version = google_secret_manager_secret_version.db_password.secret_data_wo_version

  depends_on = [
    google_sql_database_instance.main,
  ]
}
