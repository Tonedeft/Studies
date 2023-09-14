
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

output dataout {
  value       = data.local_file.df.content
}
