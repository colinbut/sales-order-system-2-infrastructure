output "public_ip_address" {
    value = module.backend-server.public_ip_address
}

output "public_dns_url" {
    value = module.backend-server.public_url
}