# New variable named "filename1"
# This will be accessible by referencing: var.filename1
variable filename1 {
    # [required] type of variable
    type        = string
    # default value
    default     = "sample1.txt"

    # description = "description"
}

############# number variable ####################
# New variable named "content1"
# This will be accessible by referencing: var.content1
# variable content1 {
#     # [required] type of variable
#     type        = number
#     # default value
#     default     =  23

#     # description = "description"
# }

############# bool variable ####################
# New variable named "content1"
# This will be accessible by referencing: var.content1
# variable content1 {
#     # [required] type of variable
#     type        = bool
#     # default value
#     default     =  true

#     # description = "description"
# }

############# list variable ####################
# New variable named "content1"
# This will be accessible by referencing: var.content1[index]
# Indexing is 0-based. 
# var.content1[1] == "green"
# variable content1 {
#     # [required] type of variable
#     type        = list(string)
#     # default value
#     default     =  ["red","green","blue"]

#     # description = "description"
# }

############# tuple variable ####################
# New variable named "content1"
# This will be accessible by referencing: var.content1[index]
# Indexing is 0-based. 
# var.content1[1] == true
# variable content1 {
#     # [required] type of variable
#     type        = tuple([string,bool,number])
#     # default value
#     default     =  ["red",true,23]

#     # description = "description"
# }

############# map variable ####################
# New variable named "content1"
# This will be accessible by referencing: var.content1[index]
# Indexing is dictionary-based. 
# var.content1["name"] == "Name"
variable content1 {
    # [required] type of variable
    type        = map
    # default value
    default     =  {name = "Name", age = 35}

    # description = "description"
}