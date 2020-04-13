output "public_ip_address" {
    value = module.frontend-webserver-server.public_ip_address
}

output "public_dns_url" {
    value = module.frontend-webserver-server.public_url
}