output "jenkins_master_public_ip_address" {
    value = aws_instance.jenkins_master.public_ip
}

output "jenkins_slaves_public_ip_address" {
    value = aws_instance.jenkins_slave[*].public_ip
}

output "jenkins_master_public_url" {
    value = aws_instance.jenkins_master.public_dns
}

output "jenkins_slaves_public_url" {
    value = aws_instance.jenkins_slave[*].public_dns
}

output "jenkins_slaves_private_ip_address" {
    value = aws_instance.jenkins_slave[*].private_ip
}