#-----------------------
# provider variables
#-----------------------
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region to deploy GCP resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone to deploy GCP resources"
  type        = string
  default     = "us-central1-c"
}

variable "sql_instance_name" {
  description = "Cloud SQL instance name"
  type        = string
}

variable "machine_type" {
  description = "Cloud SQL instance tier machine type."
  type        = string
  default     = "g1-small"
}

variable "db_version" {
  description = "The MySQL or PostgreSQL version."
  type        = string

  validation {
    condition     = contains(["MYSQL_5_6", "MYSQL_5_7", "MYSQL_8_0", "MYSQL_8_4", "POSTGRES_9_6", "POSTGRES_10", "POSTGRES_11", "POSTGRES_12", "POSTGRES_13", "POSTGRES_14", "POSTGRES_15", "POSTGRES_16", "POSTGRES_17"], var.db_version)
    error_message = "Accepted values are MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, MYSQL_8_4, POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, POSTGRES_14, POSTGRES_15, POSTGRES_16, or POSTGRES_17"
  }
}

variable "edition" {
  description = "Edition of the instance."
  type        = string
  default     = "ENTERPRISE"

  validation {
    condition     = contains(["ENTERPRISE", "ENTERPRISE_PLUS"], var.edition)
    error_message = "Accepted values are ENTERPRISE or ENTERPRISE_PLUS"
  }
}
