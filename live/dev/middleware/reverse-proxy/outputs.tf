output "public_ip_address" {
    value = module.api-gw-reverse-proxy.public_ip_address
}

output "public_dns_url" {
    value = module.api-gw-reverse-proxy.public_url
}