output "jenkins_master_public_ip_address" {
    value = aws_instance.jenkins_master.public_ip
}

output "jenkins_slave_1_public_ip_address" {
    value = aws_instance.jenkins_slave[0].public_ip
}

output "jenkins_slave_2_public_ip_address" {
    value = aws_instance.jenkins_slave[1].public_ip
}

output "jenkins_master_public_url" {
    value = aws_instance.jenkins_master.public_dns
}

output "jenkins_slave_1_public_url" {
    value = aws_instance.jenkins_slave[0].public_dns
}

output "jenkins_slave_2_public_url" {
    value = aws_instance.jenkins_slave[1].public_dns
}