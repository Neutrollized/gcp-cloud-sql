output "_01_cloud_sql_proxy_command" {
  value = google_sql_database_instance.main.settings[0].ip_configuration[0].ipv4_enabled == true ? "cloud-sql-proxy --quiet ${google_sql_database_instance.main.connection_name} &" : "cloud-sql-proxy --quiet --private-ip ${google_sql_database_instance.main.connection_name} &"
}

output "_02_get_user_password" {
  value = "gcloud secrets versions access ${google_secret_manager_secret_version.db_password.secret_data_wo_version} --secret=${google_secret_manager_secret.db_secrets.secret_id}"
}

output "_03_client_connection_string" {
  value = startswith(var.db_version, "POSTGRES") ? "psql -U ${google_sql_user.db_user.name} -h 127.0.0.1 -p 5432 -d ${google_sql_database.database.name}" : "mysql -u ${google_sql_user.db_user.name} -h 127.0.0.1 --get-server-public-key --port=3306 -p ${google_sql_database.database.name}"
}

output "_04_cleanup" {
  value = "Don't forget to kill the Cloud SQL Auth Proxy running in the background when you're done!"
}

output "change_user_password" {
  value = "gcloud sql users set-password ${google_sql_user.db_user.name} --instance=${google_sql_database_instance.main.name} --prompt-for-password"
}

output "sql_instance_public_ip" {
  value = google_sql_database_instance.main.settings[0].ip_configuration[0].ipv4_enabled == true ? google_sql_database_instance.main.public_ip_address : "N/A - no public IP assigned"
}

output "sql_instance_private_ip" {
  value = google_sql_database_instance.main.settings[0].ip_configuration[0].private_network != null ? google_sql_database_instance.main.private_ip_address : "N/A - no private IP assigned"
}
