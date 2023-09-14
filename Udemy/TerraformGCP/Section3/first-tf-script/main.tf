# terraform {
#     required_providers {
#         random = {
#             source= "hashicorp/random"
#             version = "2.3.1"
#         }
#     }
# }

# provider "random" {

# }

# Create a resource block
# resource type = local_file (provided by resource provider)
# resource name = sample_res (we provide this)
# resource local_file sample_res {
#     # The file contents will be set by the variable "content1"
#     # defined in variables.tf
#     content = var.content1["name"]

#     # The file connametents will be set by the variable "filename1"
#     # defined in variables.tf
#     filename             = var.filename1
# }

# Create a resource block
# resource type = local_file (provided by resource provider)
# resource name = name (we provide this)
resource local_file name1 {
    # The file contents
    content = "This is the random string from RP : ${random_string.name2.id}"

    # The file name
    filename             = "explicit.txt"

    # This tells terraform we explicitly depend on random_string.name2
    depends_on = [random_string.name2]
}

# Create a resource block
# resource type = random_string (provided by resource provider)
# resource name = name (we provide this)
resource random_string name2 {
    # [required] - length of string to generate
    length  = 10
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

resource random_integer myint {
  min = 20
  max = 300

  lifecycle {
    # This tells terraform to only delete the existing
    # instance after the new instance is created
    create_before_destroy = true

    # Tells terraform to prevent this resource from being
    # destroyed (terraform destroy)
    prevent_destroy = false

    # Tells terraform to not recreate the resource if the
    # "min" attribute changes
    ignore_changes = [min]
  }
}

# Create a data source
# Data source type = local_file
# Data source name = df
# The file contents will be accessible via: data.local_file.df.content
data local_file df {
    # Read from this file
    filename = "sample1.txt"
}
