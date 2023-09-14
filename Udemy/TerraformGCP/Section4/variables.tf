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
