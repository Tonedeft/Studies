# Create a resource block
# resource type = local_file (provided by resource provider)
# resource name = sample_res (we provide this)
resource local_file sample_res {
    # These are resource arguments/attributes
    
    # file name
    filename = "sample.txt"

    # file content
    content = "I love Terraform"
}