output "_01_cloud_sql_proxy_command" {
  value = startswith(var.db_version, "POSTGRES") ? "cloud_sql_proxy -instances=${google_sql_database_instance.main.connection_name}=tcp:0.0.0.0:5432 &" : "cloud_sql_proxy -instances=${google_sql_database_instance.main.connection_name}=tcp:0.0.0.0:3306 &"
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
