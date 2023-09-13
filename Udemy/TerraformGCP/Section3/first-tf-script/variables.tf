# New variable named "filename1"
# This will be accessible by referencing: var.filename1
variable filename1 {
    # [required] type of variable
    type        = string
    # default value
    default     = "sample1.txt"

    # description = "description"
}

# New variable named "content1"
# This will be accessible by referencing: var.content1
variable content1 {
    # [required] type of variable
    type        = string
    # default value
    default     = "I am loving Terraform"

    # description = "description"
}
