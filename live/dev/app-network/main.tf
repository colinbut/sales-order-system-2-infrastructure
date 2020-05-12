provider "aws" {
    region = "eu-west-1"

}

resource "aws_eip" "app_elastic_ip_address" {
    vpc = true
}

module "app_vpc" {
    source          = "../../../modules/networking/vpc"
    resource_name   = "sales-order-system-app-vpc"
}

module "app_internet_gateway" {
    source = "../../../modules/networking/internet_gateway"
    vpc_id = module.app_vpc.vpc_id
}

module "app_public_subnets" {
    source = "../../../modules/networking/subnet"

    vpc_id              = module.app_vpc.vpc_id

    subnets = {
        "01-app_public_subnet_a"   = {
            availability_zone   = "eu-west-1a"
            public_ip           = true
        }
        "02-app_public_subnet_b"   = {
            availability_zone   = "eu-west-1b"
            public_ip           = true
        }
        "03-app_private_subnet_a"  = {
            availability_zone   = "eu-west-1a"
            public_ip           = false
        }
        "04-app_private_subnet_b"  = {
            availability_zone   = "eu-west-1b"
            public_ip           = false
        }
    }
}

module "app_route_tables" {
    source = "../../../modules/networking/route_table"
    vpc_id = module.app_vpc.vpc_id

    route_tables = [
        {
            cidr_block      = "0.0.0.0/0"
            gateway_id      = module.app_internet_gateway.igw_id
            resource_name   = "public-route-table-a"
        },
        {
            cidr_block      = "0.0.0.0/0"
            gateway_id      = module.app_internet_gateway.igw_id
            resource_name   = "public-route-table-b"
        },
        {
            cidr_block      = "0.0.0.0/0"
            gateway_id      = module.app_nat_gateway.nat_gateway_id
            resource_name   = "private-route-table-a"
        },
        {
            cidr_block      = "0.0.0.0/0"
            gateway_id      = module.app_nat_gateway.nat_gateway_id
            resource_name   = "private-route-table-b"
        }
    ]
}

module "public_route_table_association_a" {
    source          = "../../../modules/networking/route_table_association"
    
    subnet_id       = lookup(module.app_public_subnets.subnets, "app_public_subnet_a").id
    route_table_id  = lookup(module.app_route_tables.route_tables, "public-route-table-a").id
}

module "public_route_table_association_b" {
    source          = "../../../modules/networking/route_table_association"
    
    subnet_id       = lookup(module.app_public_subnets.subnets, "app_public_subnet_b").id
    route_table_id  = lookup(module.app_route_tables.route_tables, "public-route-table-b").id
}

module "private_route_table_association_a" {
    source          = "../../../modules/networking/route_table_association"
    
    subnet_id       = lookup(module.app_public_subnets.subnets, "app_private_subnet_a").id
    route_table_id  = lookup(module.app_route_tables.route_tables, "private-route-table-a").id
}

module "private_route_table_association_b" {
    source          = "../../../modules/networking/route_table_association"
    
    subnet_id       = lookup(module.app_public_subnets.subnets, "app_private_subnet_b").id
    route_table_id  = lookup(module.app_route_tables.route_tables, "private-route-table-b").id
}

module "app_nat_gateway" {
    source = "../../../modules/networking/nat_gateway"
    
    allocation_id   = aws_eip.app_elastic_ip_address.id
    subnet_id       = lookup(module.app_public_subnets.subnets, "app_public_subnet_b").id
    depends         = [module.app_internet_gateway.igw]
}

