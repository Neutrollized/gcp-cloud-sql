output "_connection_string" {
  value = google_sql_database_instance.main.connection_name
}

output "_cloud_sql_proxy_command" {
  value = startswith(var.db_version, "POSTGRES") ? "cloud_sql_proxy -instances=${google_sql_database_instance.main.connection_name}=tcp:0.0.0.0:5432" : "cloud_sql_proxy -instances=${google_sql_database_instance.main.connection_name}=tcp:0.0.0.0:3306"
}

output "change_root_password" {
  value = "gcloud sql users set-password ${google_sql_user.db_user.name} --instance=${google_sql_database_instance.main.name} --prompt-for-password"
}
