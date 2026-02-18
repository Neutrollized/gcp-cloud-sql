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


#--------------------------
# Private networking
#--------------------------
variable "private_network_name" {
  description = "Private GCP network to connect to"
  type        = string
  default     = "default"
}

variable "private_subnet_name" {
  description = "Private GCP subnetwork connect to for PSC"
  type        = string
  default     = "default"
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

variable "machine_tier" {
  description = "Cloud SQL instance tier machine type."
  type        = string
  default     = "db-f1-micro"
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

variable "availability_type" {
  description = "High availability or single zone"
  type        = string
  default     = "ZONAL"

  validation {
    condition     = contains(["ZONAL", "REGIONAL"], var.availability_type)
    error_message = "Accepted values are ZONAL or REGIONAL"
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
  default     = "NOT_REQUIRED"

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
    #      name  = "cloudsql.iam_authentication"  # postgres
    #      value = "on"
    #    },
    #    {
    #      name  = "log_connections"
    #      value = "on"
    #    }
  ]
}

variable "ipv4_enabled" {
  description = "Whether a public IP address is assigned"
  type        = bool
  default     = true
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

variable "enable_private_path_for_gcp_services" {
  description = "Whether GCP services such as BigQuery are allowed access to data in this instance over a private IP connection"
  type        = bool
  default     = false
}

variable "allowed_consumer_projects" {
  description = "List of consumer projects allowed to connect via PSC"
  type        = list(string)
  default = [
    #    some-project-123,
    #    another-project-789,
  ]
}

variable "connection_pooling_enabled" {
  description = "Whether Managed Connection Pooling is enabled"
  type        = bool
  default     = false
}

variable "connection_pooling_flags" {
  description = "List of configuration options for managed connection pooling"
  type        = list(map(string))
  default = [
    #    {
    #      name  = "max_client_connections"
    #      value = "1000"
    #    },
    #    {
    #      name  = "max_pool_size"
    #      value = "60"
    #    }
  ]
}


#---------------------------------------------
# backup & maintenance configuration
#---------------------------------------------
variable "retain_backups_on_delete" {
  description = "Whether backups are retained after instance is deleted based on backup retention settings"
  type        = bool
  default     = false
}

variable "backup_enabled" {
  description = "Whether backup configuration is enabled"
  type        = bool
  default     = false
}

variable "binary_log_enabled" {
  description = "Whether binary logging is enabled. This is for MySQL databases only!"
  type        = bool
  default     = false
}

variable "pitr_enabled" {
  description = "Whether point-in-time recovery is enabled. This is for PostgreSQL databases only!"
  type        = bool
  default     = false
}

variable "backup_start_time" {
  description = "The daily schedule time in HH:MM format (e.g., 08:30, 23:59). HH must be 00-23, MM must be 00-59."
  type        = string
  #default     = "02:00"
  default = null

  validation {
    # This regex ensures:
    # ^          - Start of the string
    # (?:        - Non-capturing group for hours
    #   [01]\d   - 00-19
    #   |        - OR
    #   2[0-3]   - 20-23
    # )          - End of hours group
    # :          - Literal colon separator
    # [0-5]\d    - 00-59 for minutes
    # $          - End of the string
    condition     = var.backup_start_time == null || can(regex("^(?:[01]\\d|2[0-3]):[0-5]\\d$", var.backup_start_time))
    error_message = "The 'daily_schedule_time' must be in HH:MM format. HH must be between 00 and 23, and MM must be between 00 and 59."
  }
}

variable "backup_location" {
  description = "Region where backup will be stored.  If none provided, will default to the same region as the Cloud SQL instance"
  type        = string
  default     = null
}

variable "transaction_log_retention_days" {
  description = "The number of days transaction logs are retained for PITR restore (1-7). For ENTERPRISE_PLUS editions, the number of days can be up to 35"
  type        = number
  default     = 7
}

variable "retained_backups" {
  description = "The number of backups retained. Excess are deleted"
  type        = number
  default     = null
}

variable "maintenance_window_day" {
  description = "Day to roll out maintenance update. Starts on Monday"
  type        = number
  default     = 1

  validation {
    condition     = var.maintenance_window_day >= 1 && var.maintenance_window_day <= 7
    error_message = "Accepted values are '1-7', starting on Monday"
  }
}

variable "maintenance_window_hour" {
  description = "Hour to roll out maintance update"
  type        = number
  default     = 4

  validation {
    condition     = var.maintenance_window_hour >= 0 && var.maintenance_window_hour <= 23
    error_message = "Accepted values are '0-23'"
  }
}

variable "maintenance_window_update_track" {
  description = "Controls how much advance notification you receive before updates are rolled out. 'canary' is 7-14 days, 'stable' is 15-21 days, and 'week5' is 35-42 days."
  type        = string
  default     = "stable"

  validation {
    condition     = contains(["canary", "stable", "week5"], var.maintenance_window_update_track)
    error_message = "Accepted values are 'canary', 'stable', or 'week5'"
  }
}
