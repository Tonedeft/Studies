# Create a resource block
# resource type = local_sensitive_file (provided by resource provider)
# resource name = cat_res (we provide this)
#
# Note: local_sensitive_file will not display the content during "terraform plan"
# + resource "local_sensitive_file" "cat_res" {
#      + content              = (sensitive value)
# local_sensitive_file also sets file permission to 0700 instead of 0777 by default
resource local_sensitive_file cat_res {
    # These are resource arguments/attributes
    
    # file name
    filename = "cat.txt"

    # file content (sensitive, won't display in logging)
    content = "I love Cats"

    # Sets file permission to root only (this is default for local_sensitive_file)
    file_permission = "0700"
}

# Create a resource block
# resource type = local_file (provided by resource provider)
# resource name = dog_res (we provide this)
resource local_file dog_res {
    # These are resource arguments/attributes
    
    # file name
    filename = "dog.txt"

    # file content (sensitive, won't display in logging)
    content = "I love Dogs"
}

