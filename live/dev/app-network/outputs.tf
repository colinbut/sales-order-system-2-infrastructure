output "vpc_id" {
    value = module.app_vpc.vpc_id
}

output "subnets" {
    value = module.app_public_subnets.subnets
} 