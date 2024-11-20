terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  backend "gcs" {
    bucket  = "sharath-gaudiy-terraform-state"
    prefix  = "terraform/state"
  }
}