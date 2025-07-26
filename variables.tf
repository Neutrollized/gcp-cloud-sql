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


#-----------------------
# Cloud SQL user
#-----------------------
variable "sql_user" {
  description = "Database user"
  type        = string
}


#-----------------------
# Cloud SQL instance
#-----------------------
variable "sql_instance_name" {
  description = "Cloud SQL instance name prefix"
  type        = string
}


variable "db_version" {
  description = "The MySQL or PostgreSQL version."
  type        = string

  validation {
    condition     = contains(["MYSQL_5_6", "MYSQL_5_7", "MYSQL_8_0", "MYSQL_8_4", "POSTGRES_9_6", "POSTGRES_10", "POSTGRES_11", "POSTGRES_12", "POSTGRES_13", "POSTGRES_14", "POSTGRES_15", "POSTGRES_16", "POSTGRES_17"], var.db_version)
    error_message = "Accepted values are MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, MYSQL_8_4, POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, POSTGRES_14, POSTGRES_15, POSTGRES_16, or POSTGRES_17"
  }
}


#------------------------------
# Cloud SQL settings
#------------------------------
variable "deletion_protection_enabled" {
  description = "Protection against accidental deletion. Applies to API, gcloud, Cloud Console, and Terraform."
  type        = bool
  default     = true
}

variable "machine_type" {
  description = "Cloud SQL instance tier machine type."
  type        = string
  default     = "g1-small"
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

variable "connector_enforcement" {
  description = "Control enforcement of Cloud SQL Auth Proxy or Cloud SQL connectors for connections."
  type        = string
  default     = "REQUIRED"

  validation {
    condition     = contains(["REQUIRED", "NOT_REQUIRED"], var.connector_enforcement)
    error_message = "Accepted values are REQUIRED or NOT_REQUIRED"
  }
}

variable "disk_autoresize" {
  description = "Enables auto-resizing of storage size"
  type        = bool
  default     = true
}
variable "disk_size" {
  description = "Size of data disk in GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Type of data disk"
  type        = string
  default     = "PD_SSD"

  validation {
    condition     = contains(["PD_SSD", "PD_HDD", "HYPERDISK_BALANCED"], var.disk_type)
    error_message = "Accepted values are PD_SSD, PD_HDD, or HYPERDISK_BALANCED"
  }
}

variable "enable_dataplex_integration" {
  description = "Enable integration with Dataplex"
  type        = bool
  default     = false
}

variable "enable_vertexai_integration" {
  description = "Enable integration with Vertex AI"
  type        = bool
  default     = false
}
