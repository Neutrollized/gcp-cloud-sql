output "_connection_string" {
  value = google_sql_database_instance.main.connection_name
}

output "_cloud_sql_proxy_command" {
  value = startswith(var.db_version, "POSTGRES") ? "cloud_sql_proxy -instances=${google_sql_database_instance.main.connection_name}=tcp:0.0.0.0:5432" : "cloud_sql_proxy -instances=${google_sql_database_instance.main.connection_name}=tcp:0.0.0.0:3306"
}
