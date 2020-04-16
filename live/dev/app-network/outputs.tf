output "vpc_id" {
    value = module.app_vpc.vpc_id
}

output "subnets" {
    value = module.app_public_subnets.subnets
}

output "public_ip_address" {
    value = module.backend-server.public_ip_address
}

output "public_dns_url" {
    value = module.backend-server.public_url
}