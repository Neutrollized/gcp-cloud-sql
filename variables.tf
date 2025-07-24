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

variable "db_version" {
  description = "The MySQL, PostgreSQL or SQL Server version."
  type        = string

  validation {
    condition     = contains(["POSTGRES_9_6", "POSTGRES_10", "POSTGRES_11", "POSTGRES_12", "POSTGRES_13", "POSTGRES_14", "POSTGRES_15", "POSTGRES_16", "POSTGRES_17"], var.db_version)
    error_message = "Accepted values are POSTGRES_9_6, POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, POSTGRES_14, POSTGRES_15, POSTGRES_16, or POSTGRES_17"
  }
}

variable "machine_type" {
  description = "Cloud SQL instance tier machine type."
  type        = string
  default     = "g1-small"
}
