output "_01_cloudsqlproxy_command_PUBLIC_IP" {
  value = google_sql_database_instance.main.settings[0].ip_configuration[0].ipv4_enabled == true ? "cloud-sql-proxy --quiet ${google_sql_database_instance.main.connection_name} &" : "N/A - no public IP assigned"
}

output "_01_cloudsqlproxy_command_PRIVATE_IP" {
  value = google_sql_database_instance.main.settings[0].ip_configuration[0].private_network != null ? "cloud-sql-proxy --quiet --private-ip ${google_sql_database_instance.main.connection_name} &" : "N/A - no private IP assigned"
}

output "_01_cloudsqlproxy_command_PSC_ENDPOINT" {
  value = length(var.allowed_consumer_projects) > 0 ? "cloud-sql-proxy --quiet --psc ${google_sql_database_instance.main.connection_name} &" : "N/A - Private Service Connect not enabled"
}
output "_02_GET_USER_PASSWORD" {
  value = "gcloud secrets versions access ${google_secret_manager_secret_version.db_password.secret_data_wo_version} --secret=${google_secret_manager_secret.db_secrets.secret_id}"
}

output "change_user_password" {
  value = "gcloud sql users set-password ${google_sql_user.db_user.name} --instance=${google_sql_database_instance.main.name} --prompt-for-password"
}

output "cloud_sql_psc_svcattachment" {
  value = length(var.allowed_consumer_projects) > 0 ? google_sql_database_instance.main.psc_service_attachment_link : "N/A - Private Service Connect not enabled"
}


# all client connection commands go here for better organization & readability
locals {
  psql_connect_cloudsqlproxy    = "psql -U ${google_sql_user.db_user.name} -h 127.0.0.1 -p 5432 -d ${google_sql_database.database.name}"
  psql_connect_public_ip        = var.ipv4_enabled == true ? "psql -U ${google_sql_user.db_user.name} -h ${google_sql_database_instance.main.public_ip_address} -p 5432 -d ${google_sql_database.database.name}" : null
  psql_connect_private_ip       = google_sql_database_instance.main.settings[0].ip_configuration[0].private_network != null ? "psql -U ${google_sql_user.db_user.name} -h ${google_sql_database_instance.main.private_ip_address} -p 5432 -d ${google_sql_database.database.name}" : null
  psql_connect_psc_endpoint_ip  = length(var.allowed_consumer_projects) > 0 ? "psql -U ${google_sql_user.db_user.name} -h ${google_compute_address.default[0].address} -p 5432 -d ${google_sql_database.database.name}" : null
  mysql_connect_cloudsqlproxy   = "mysql -U ${google_sql_user.db_user.name} -h 127.0.0.1 --get-server-public-key --port=3306 -p ${google_sql_database.database.name}"
  mysql_connect_public_ip       = var.ipv4_enabled == true ? "mysql -U ${google_sql_user.db_user.name} -h ${google_sql_database_instance.main.public_ip_address} --get-server-public-key --port=3306 -p ${google_sql_database.database.name}" : null
  mysql_connect_private_ip      = google_sql_database_instance.main.settings[0].ip_configuration[0].private_network != null ? "mysql -U ${google_sql_user.db_user.name} -h ${google_sql_database_instance.main.private_ip_address} --get-server-public-key --port=3306 -p ${google_sql_database.database.name}" : null
  mysql_connect_psc_endpoint_ip = length(var.allowed_consumer_projects) > 0 ? "mysql -U ${google_sql_user.db_user.name} -h ${google_compute_address.default[0].address} --get-server-public-key --port=3306 -p ${google_sql_database.database.name}" : null
}

output "_03_connect_client_via_CLOUDSQLPROXY" {
  value = startswith(var.db_version, "POSTGRES") ? local.psql_connect_cloudsqlproxy : local.mysql_connect_cloudsqlproxy
}

output "_03_connect_client_via_PUBLIC_IP" {
  value = var.connector_enforcement == "NOT_REQUIRED" ? (google_sql_database_instance.main.settings[0].ip_configuration[0].ipv4_enabled == true ? (startswith(var.db_version, "POSTGRES") ? local.psql_connect_public_ip : local.mysql_connect_public_ip) : "N/A - no public IP assigned") : "No direct connections allowed - Cloud SQL Auth Proxy is REQUIRED"
}

output "_03_connect_client_via_PRIVATE_IP" {
  value = var.connector_enforcement == "NOT_REQUIRED" ? (google_sql_database_instance.main.settings[0].ip_configuration[0].private_network != null ? (startswith(var.db_version, "POSTGRES") ? local.psql_connect_private_ip : local.mysql_connect_private_ip) : "N/A - no private IP assigned") : "No direct connections allowed - Cloud SQL Auth Proxy is REQUIRED"
}

output "_03_connect_client_via_PSC_ENDPOINT_IP" {
  value = var.connector_enforcement == "NOT_REQUIRED" ? (length(var.allowed_consumer_projects) > 0 ? (startswith(var.db_version, "POSTGRES") ? local.psql_connect_psc_endpoint_ip : local.mysql_connect_psc_endpoint_ip) : "N/A - Private Service Connect not enabled") : "No direct connections allowed - Cloud SQL Auth Proxy is REQUIRED"
}
