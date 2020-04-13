# output "subnet_ids" {
#     # the output of just the resource(aws_subnet.subnets) is a map so require to convert it to list first
#     # in order to access the individual attributes the elements (each subnet)
#     value = values(aws_subnet.subnets)[*].id
# }

output "subnets" {
    value = {for subnet in aws_subnet.subnets : subnet.tags.Name => subnet}
}