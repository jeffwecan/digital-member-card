terraform {
  backend "gcs" {
    bucket = "lv-digital-membership-tfstate"
    prefix = "env/production"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "google_app_engine_application" "digital_membership" {
  project     = google_project.digital_membership.project_id
  location_id = regexall("[-a-z]+", var.gcp_region)[0]
}

# TODO: hook this up with a bot user's oauth creds (not jeffwecan...)
resource "google_sourcerepo_repository" "digital_membership" {
  name = "github_${replace(var.github_repo, "/", "_")}"
}

