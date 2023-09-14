terraform {
    required_providers {
        # Require the Google Cloud Platform provider (latest)
        google = {
            source = "hashicorp/google"
        }
    }
}

# Set up Google Provider
# These variables are defined in "gcpvars.tf"
# And overridden in gcpvars.tfvars (unmanaged by Git)
provider "google" {
    # The GCP Project to Configure
    project = var.gcp_projectid
    # The GCP Region to work in
    region = var.gcp_region
    # The GCP Zone
    zone = var.gcp_zone
}

# Resource type = Google Storage Bucket
# Resource name = GCS1
# https://console.cloud.google.com/storage/browser?referrer=search&project=${var.gcp_projectid}
resource google_storage_bucket "GCS1" {
    # Bucket name in GCP
    # NOTE: This must be GLOBALLY unique across ALL of GCP
    name = "${var.gcp_projectid}_${var.gcp_region}_bucket_up"   
    # [required] - where to host the bucket (must be newer than the training)
    location = "US"
}