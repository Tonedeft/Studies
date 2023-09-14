
# Create a resource block
# resource type = local_file (provided by resource provider)
# resource name = sample_res (we provide this)
resource local_file sample_res {
    # The file contents will be set by the variable "content1"
    # defined in variables.tf
    content = var.content1["name"]

    # The file connametents will be set by the variable "filename1"
    # defined in variables.tf
    filename             = var.filename1
}

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

# New resource:
# resource type = random_integer (provided by random provider)
# resource name = rint
#
# The result of this random integer generation is 
# accessible by referencing: random_integer.rint.result
#
# NOTE: By default, this will not change the next time you
#       run terraform plan/apply unless you change the contents
#       of this block
resource random_integer rint {
    # [required]: minimum integer
    min = 80
    # [required]: maximum integer
    max = 200
}

# New "output" block:
# output name = "name1"
output name1 {
    # [required] The value to be displayed to output
    # Set the value to output to the result of the
    # random integer generation above.
    value       = random_integer.rint.result

    # sensitive   = true
    # description = "description"
    # depends_on  = []
}

resource random_string rstring {
    # [required] - length of string to generate
    length  = 15
    
    # upper   = true
    # lower   = true
    # number  = true
    # special = true

    # keepers = {
    #     id = value
    # }
}

# New "output" block:
# output name = "name2"
output name2 {
    # [required] The value to be displayed to output
    # Set the value to output to the result of the
    # random integer generation above.
    value       = random_string.rstring.result

    # sensitive   = true
    # description = "description"
    # depends_on  = []
}