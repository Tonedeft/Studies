# The overridden defaults are defined in terraform.tfvars,
# which is intentionally withheld from the GitHub repo.

variable gcp_projectid {
    # [required] type of variable
    type        = string
    # default value
    default     = "demo-project"
}

variable gcp_region {
    # [required] type of variable
    type        = string
    # default value
    default     = "us-central1"
}

variable gcp_zone {
    # [required] type of variable
    type        = string
    # default value
    default     = "us-central1-a"
}

# GCP Credentials for the service account are managed here:
# https://console.cloud.google.com/iam-admin/serviceaccounts?project
# Open the Service Account and click Keys.
# Keys can be created and downloaded to .json files.
# They must be kept secret.
variable gcp_crendentials {
    # [required] type of variable
    type        = string
    # default value
    default     = "demo_credentials.json"
}


variable gcp_subnet_range {
    # [required] type of variable
    type        = string
    # default value
    default     = "0.0.0.0/0"
}


variable gcs1_image1 {
    type = string
    default = "null_image.jpg"
}

variable secret_my_ip_address {
    type = string
    default = "0.0.0.0/32"
}

variable service_account_email {
    type = string
    default = "test@google.com"
}