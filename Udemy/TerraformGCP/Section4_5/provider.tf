terraform {
    required_providers {
        # Require the Google Cloud Platform provider (latest)
        google = {
            source = "hashicorp/google"
            version = "4.82.0"
        }
    }
}

# Set up Google Provider
# These variables are defined in "variables.tf"
# And overridden in terraform.tfvars (unmanaged by Git)
provider "google" {
    # The GCP Project to Configure
    project = var.gcp_projectid
    # The GCP Region to work in
    region = var.gcp_region
    # The GCP Zone
    zone = var.gcp_zone
    # Service Account Credentials to Authenticate to GCP
    credentials = var.gcp_crendentials
}