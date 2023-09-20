# Resource type = Google Storage Bucket
# Resource name = GCS1
# https://console.cloud.google.com/storage/browser?referrer=search&project=${var.gcp_projectid}
resource "google_storage_bucket" "GCS1" {
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
      type          = "SetStorageClass"
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
  source = var.gcs1_image1
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
  ip_cidr_range = var.gcp_subnet_range

  #[required] Region for the subnet
  region = var.gcp_region

  # turn on private google access for this subnet
  private_ip_google_access = true
}

# Resource type = Google Compute Firewall
# Resource name = custom-vpc-tf-allow-icmp
# This will create a firewall rule that will be applied
# to the GCP asset running in custom-vpc-tf
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

# Resource type = Google Compute Firewall
# Resource name = custom-vpc-tf-allow-icmp
# This will create a firewall rule that will be applied
# to the GCP asset running in custom-vpc-tf
resource "google_compute_firewall" "custom-vpc-tf-allow-ssh" {
  #[required] name
  name = "${resource.google_compute_network.custom-vpc-tf.name}-allow-ssh"

  #[required] network the firewall rule applies to
  network = google_compute_network.custom-vpc-tf.id

  # Allow tcp traffic on port 22 (ssh)
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Only allow traffic from my IP address
  source_ranges = [var.secret_my_ip_address]

  # Priority (0-65536)
  priority = 455
}
/*
# Resource type = Google Compute Instance
# Resource name = gce-instance
# This will create a virtual machine
resource "google_compute_instance" "vm-from-tf" {
    #[required] name for instance
    name = "${var.gcp_projectid}-${var.gcp_region}-vm-from-tf"

    #[required] zone to operate the VM
    zone = var.gcp_zone

    # https://cloud.google.com/compute/docs/general-purpose-machines
    machine_type = "e2-micro"

    # This allows you to resize the VM after it is started
    # the first time
    allow_stopping_for_update = true

    # Which network and subnet does this VM belong to?
    # Referring to previously defined assets
    network_interface {
        network = resource.google_compute_network.custom-vpc-tf.name
        subnetwork = resource.google_compute_subnetwork.custom-vpc-tf-sub-us.name
    }

    # Defines OS and Hard Disk parameters
    boot_disk {
        initialize_params {
            # > gcloud compute images list
            image = "debian-11-bullseye-v20230912"
            # 10 GB Hard Disk
            size = 10
        }
        # Tell it to keep the disk when recreating the instance
        # Otherwise it deletes the hard drive
        auto_delete = false
    }

    # Can apply labels to assets with "labels"
    labels = {
        "env" = "tflearning"
    }

    # Details about up-time and availability for this instance
    scheduling {
        # Don't allow Google to preempt this instance
        preemptible = false
        # Automatically restart this when it fails
        automatic_restart = true
    }

    # Give access to this VM from a service account
    service_account {
        email = var.service_account_email
        # Access to cloud platform
        scopes = ["cloud-platform"]
    }

    # Ignore changes to the attached disk
    lifecycle {
        ignore_changes = [ attached_disk ]
    }
}   

# Resource type = Google Compute Disk
# Resource name = disk10gb
# This will create a hard drive to attach to a VM
resource "google_compute_disk" "disk10gb" {
    #[required]
    name = "${var.gcp_projectid}-disk-1"

    #[required] Size in GB
    size = 10

    #[required] zone to host the disk (same as VM?)
    zone = var.gcp_zone

    #[required] type of hard drive
    type = "pd-ssd"
}

# Resource type = Google Compute Attach Disk
# Resource name = attacheddisk10gb
# This will attach a defined hard drive to a defined VM
# NOTE: This requires on the google_compute_instance:
# lifecycle {
#     ignore_changes = [ attached_disk ]
# }
# By default, this will not have an image, but will attach
# another 10gb hard disk for storage to the existing VM
resource "google_compute_attached_disk" "attacheddisk10gb" {
    #[required] The Instance of google_compute_disk we're attaching
    disk = google_compute_disk.disk10gb.id

    #[required] The Instance of google_compute we are attaching to
    instance = google_compute_instance.vm-from-tf.id
}
*/

/*
resource "google_cloud_run_service" "run-app-from-tf" {
    #[required]
    name="${var.gcp_projectid}-run-app-from-tf"

    #[required]
    location=var.gcp_region

    template {
        spec {
            # What container is running in the cloud run?
            containers {
                # Hello world image from Google
                # https://console.cloud.google.com/gcr/images/google-samples/global/hello-app
                # image = "gcr.io/google-samples/hello-app:1.0"
                image = "gcr.io/google-samples/hello-app:2.0"
            }
        }
    }   

    # traffic {
    #     revision_name = ""
    #     percent = 50
    # }
    # traffic {
    #     revision_name = ""
    #     percent = 50
    # }
}

# This IAM Policy allows all users (even non-Google users)
# to invoke the Cloud Run API (access the service)
# The online course said to use roles/viewer as the role,
# but https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service
# says to use run.invoker instead.
data "google_iam_policy" "pub_iam_policy" {
    binding {
        role = "roles/run.invoker"
        members = [
            "allUsers",
        ]
    }
}

# Attach the pub_iam_policy to the Cloud Run service
# allowing allUsers to invoke the service API
resource "google_cloud_run_service_iam_policy" "pub_access" {
    #[required]
    service = google_cloud_run_service.run-app-from-tf.name
    #[required]
    location = google_cloud_run_service.run-app-from-tf.location

    #[required]
    policy_data = data.google_iam_policy.pub_iam_policy.policy_data
}*/


/*
data "archive_file" "cloud_function_zip" {
  type        = "zip"
  output_path = var.gcs_func_source_code_zip
  source_dir = var.gcs_func_source_code_dir
}

# Resource type = Google Storage Bucket
# Resource name = cloud-function-source
# https://console.cloud.google.com/storage/browser?referrer=search&project=${var.gcp_projectid}
resource "google_storage_bucket" "cloud_function_source_bucket" {
  # [required] Bucket name in GCP
  # NOTE: This must be GLOBALLY unique across ALL of GCP
  name = "${var.gcp_projectid}-${var.gcp_region}-cloud-function-source"

  # [required] - where to host the bucket (must be newer than the training)
  location = var.gcp_region

  # Storage Class (standard, nearline, coldline, archive)
  storage_class = "STANDARD"

  # Labels to apply to the resource
  labels = {
    "contents" = "source-code"
  }

  # Should this have "uniform" bucket access (vs. fine-grained)
  uniform_bucket_level_access = true

  # NOTE: By default, buckets are created with Google-managed encryption key

  # Set lifecycle rules for this bucket
  lifecycle_rule {
    # Rule will transform objects to ARCHIVE storage class
    action {
      type          = "SetStorageClass"
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
resource "google_storage_bucket_object" "cloud_function_source_code" {
  #[required] Bucket to create the object in
  #           (Refers to another resource)
  bucket = google_storage_bucket.cloud_function_source_bucket.name

  #[required] Name of the object in GCP
  name = "index.zip"

  #[mostly-required] Path to the file to upload
  # (only required if "content" is not defined)
  source = var.gcs_func_source_code_zip
}

resource "google_cloudfunctions_function" "fun_from_tf" {
  name        = "${var.gcp_projectid}-function-from-tf"
  runtime     = "nodejs20"
  description = "This is my first function from terraform."

  # Memory available to run the function
  available_memory_mb = 128

  # Which bucket and object contains the cloud function source code
  source_archive_bucket = google_storage_bucket.cloud_function_source_bucket.name
  source_archive_object = google_storage_bucket_object.cloud_function_source_code.name

  # Allow triggering via http request
  trigger_http = true

  # This is the function out of index.js that is called
  # when the function executes
  entry_point = "helloHttptf"
}

resource "google_cloudfunctions_function_iam_member" "allowaccess" {
  # Which cloud function are we binding IAM to?
  region = google_cloudfunctions_function.fun_from_tf.region
  cloud_function = google_cloudfunctions_function.fun_from_tf.name

  # Give public access to this cloud function
  role = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
*/

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "ds_from_tf"
}

resource "google_bigquery_table" "table_tf" {
  table_id = "${var.gcp_projectid}_${var.gcp_region}_table_from_tf"
  
  dataset_id = google_bigquery_dataset.dataset.dataset_id
}