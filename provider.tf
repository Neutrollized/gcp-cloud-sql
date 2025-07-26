terraform {
  required_version = ">= 1.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.45"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.45"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
