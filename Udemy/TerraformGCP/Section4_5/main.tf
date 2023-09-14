# Resource type = Google Storage Bucket
# Resource name = GCS1
# https://console.cloud.google.com/storage/browser?referrer=search&project=${var.gcp_projectid}
resource google_storage_bucket "GCS1" {
    # [required] Bucket name in GCP
    # NOTE: This must be GLOBALLY unique across ALL of GCP
    name = "${var.gcp_projectid}_${var.gcp_region}_bucket-from-terraform"   
    
    # [required] - where to host the bucket (must be newer than the training)
    location = "US-EAST4"

    # Storage Class (standard, nearline, coldline, archive)
    storage_class = "NEARLINE"
    
    # Labels to apply to the resource
    labels = {
      "env" = "tf_env"
      "dep" = "compliance"
    }

    # Should this have "uniform" bucket access (vs. fine-grained)
    uniform_bucket_level_access = true

    # NOTE: By default, buckets are created with Google-managed encryption key

    # Set lifecycle rules for this bucket
    lifecycle_rule {
        # Rule will transform objects to ARCHIVE storage class
        action {
            type = "SetStorageClass"
            storage_class = "ARCHIVE"
        }
        # Rule triggers when object is older than 5 days
        condition {
            age = 5
        }
    }

    # Define the retention policy
    # CAUTION: locking the retention policy is irreversible
    retention_policy {
        # Retention period is set in seconds
        retention_period = 864000
    }
}

# Resource type = Google Storage Bucket Object
# Resource name = image1
resource "google_storage_bucket_object" "image1" {
    #[required] Bucket to create the object in
    #           (Refers to another resource)
    bucket = google_storage_bucket.GCS1.name

    #[required] Name of the object in GCP
    name = "bloom"

    #[mostly-required] Path to the file to upload
    # (only required if "content" is not defined)
    source = "secrets/bloom.JPG"
}