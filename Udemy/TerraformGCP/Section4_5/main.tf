# Resource type = Google Storage Bucket
# Resource name = GCS1
# https://console.cloud.google.com/storage/browser?referrer=search&project=${var.gcp_projectid}
resource google_storage_bucket "GCS1" {
    # [required] Bucket name in GCP
    # NOTE: This must be GLOBALLY unique across ALL of GCP
    name = "${var.gcp_projectid}-${var.gcp_region}-gcs1"   
    
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
        # retention_period = 864000
        retention_period = 60
    }
}

# Resource type = Google Storage Bucket Object
# Resource name = image1
# Storage Objects will upload a file or create a file inside the specified bucket
resource "google_storage_bucket_object" "image1" {
    #[required] Bucket to create the object in
    #           (Refers to another resource)
    bucket = google_storage_bucket.GCS1.name

    #[required] Name of the object in GCP
    name = "bloom"

    #[mostly-required] Path to the file to upload
    # (only required if "content" is not defined)
    source = "${var.gcs1_image1}"
}

# Resource type = Google Compute Network VPC
# Resource name = auto-vpc-tf
# This will create a Virtual Private Container with ~28 subnets
# automatically instantiated
resource "google_compute_network" "auto-vpc-tf" {
    #[required] Name of the VPC in GCP
    name = "${var.gcp_projectid}-${var.gcp_region}-auto-vpc-tf"
  
    # Tell it to automatically create subnetworks
    auto_create_subnetworks = true
}

# Resource type = Google Compute Network VPC
# Resource name = custom-vpc-tf
# This will create a Virtual Private Container with 0 subnets
# automatically instantiated
# We will add specific subnets to this VPC
resource "google_compute_network" "custom-vpc-tf" {
    #[required] Name of the VPC in GCP
    name = "${var.gcp_projectid}-${var.gcp_region}-custom-vpc-tf"
  
    # Tell it not to automatically create subnetworks
    auto_create_subnetworks = false
}

# Resource type = Google Compute Subnetwork
# Resource name = custom-vpc-tf-sub-us
# This subnetwork will be assigned to the "custom-vpc-tf" VPC
resource "google_compute_subnetwork" "custom-vpc-tf-sub-us" {
    #[required] Name of the subnetwork in GCP
    name = "${resource.google_compute_network.custom-vpc-tf.name}-sub-us"

    #[required] Terraform ID of the google_compute_network
    # this is assigned to
    network = google_compute_network.custom-vpc-tf.id

    #[required] IP range for the subnet
    ip_cidr_range = "10.1.0.0/24"

    #[required] Region for the subnet
    region = "us-east4"

    # turn on private google access for this subnet
    private_ip_google_access = true
}

resource "google_compute_firewall" "custom-vpc-tf-allow-icmp" {
    #[required] name
    name = "${resource.google_compute_network.custom-vpc-tf.name}-allow-icmp"

    #[required] network the firewall rule applies to
    network = google_compute_network.custom-vpc-tf.id

    # Allow icmp traffic
    allow {
        protocol = "icmp"
    }

    # Only allow traffic from my IP address
    source_ranges = [var.secret_my_ip_address]

    # Priority (0-65536)
    priority = 455
}