# New "output" block:
# output name = "name2"
output project_configuration {
    # [required] The value to be displayed to output
    # Set the value to output to the result of the
    # random integer generation above.
    value       = "Configuring GCP Project: ${var.gcp_projectid} - ${var.gcp_region}:${var.gcp_zone}"

    # sensitive   = true
    # description = "description"
    # depends_on  = []
}

output auto_vpc_id {
    value = google_compute_network.auto-vpc-tf.id
}

output custom_vpc_id {
    value = google_compute_network.custom-vpc-tf.id
}
