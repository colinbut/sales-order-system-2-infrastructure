output "public_ip_address" {
    value = aws_instance.server.public_ip
}

output "public_url" {
    value = aws_instance.server.public_dns
}

output "private_ip_address" {
    value = aws_instance.server.private_ip
}

output "private_url" {
    value = aws_instance.server.private_dns
}