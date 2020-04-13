resource "aws_route_table" "route_table" {
    # for_each only works on "maps" or "sets of strings"!
    for_each    = {
        for route in var.route_tables : route.resource_name => route
    }

    vpc_id      = var.vpc_id

    route {
        cidr_block = each.value.cidr_block
        gateway_id = each.value.gateway_id
    }

    tags = {
        Name = each.value.resource_name
    }
}