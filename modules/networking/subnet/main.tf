resource "aws_subnet" "subnets" {
    for_each                = var.subnets
    vpc_id                  = var.vpc_id
    cidr_block              = cidrsubnet("10.0.0.0/16", 8, index(keys(var.subnets), each.key) + 1)
    availability_zone       = each.value.availability_zone
    map_public_ip_on_launch = each.value.public_ip
    tags = {
        Name = substr(each.key, 3, -1)
    }
}