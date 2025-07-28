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
# database
#-----------------------
variable "sql_database_name" {
  description = "Database name"
  type        = string
}


#-----------------------
# Cloud SQL instance
#-----------------------
variable "sql_instance_name" {
  description = "Cloud SQL instance name prefix"
  type        = string
}

variable "machine_type" {
  description = "Cloud SQL instance tier machine type."
  type        = string
  default     = "f1-micro"
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

variable "db_version" {
  description = "The MySQL or PostgreSQL version."
  type        = string

  validation {
    condition     = contains(["MYSQL_5_6", "MYSQL_5_7", "MYSQL_8_0", "MYSQL_8_4", "POSTGRES_9_6", "POSTGRES_10", "POSTGRES_11", "POSTGRES_12", "POSTGRES_13", "POSTGRES_14", "POSTGRES_15", "POSTGRES_16", "POSTGRES_17"], var.db_version)
    error_message = "Accepted values are MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, MYSQL_8_4, POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, POSTGRES_14, POSTGRES_15, POSTGRES_16, or POSTGRES_17"
  }
}


#------------------------------
# Cloud SQL configuration
#------------------------------
variable "deletion_protection_enabled" {
  description = "Protection against accidental deletion. Applies to API, gcloud, Cloud Console, and Terraform."
  type        = bool
  default     = true
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

variable "disk_autoresize_limit" {
  description = "Max size to which storage can be automatically increased. 0 means unlimited"
  type        = number
  default     = 0
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


#------------------------------
# Cloud SQL settings
#------------------------------
variable "database_flags" {
  description = "Database flags that allow granular customization of your instance."
  type        = list(map(string))
  default = [
    #    {
    #      name  = "autovacuum"
    #      value = "off" # default: "on"
    #    },
    #    {
    #      name  = "log_connections"
    #      value = "on" # default: "off"
    #    }
  ]
}

variable "authorized_networks" {
  description = "List of authorized networks allowed to connnect to public IP. 'expiration_time' is optional"
  type        = list(map(string))
  default = [
    #    {
    #      name            = "home"
    #      value           = "123.45.67.89/32"
    #      expiration_time = "2025-08-01T21:00:00.000Z" # optional
    #    }
  ]
}

variable "ssl_mode" {
  description = "SSL enforcement"
  type        = string
  default     = "ENCRYPTED_ONLY"

  validation {
    condition     = contains(["ALLOW_UNENCRYPTED_AND_ENCRYPTED", "ENCRYPTED_ONLY", "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"], var.ssl_mode)
    error_message = "Accepted values are ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, and TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
  }
}
