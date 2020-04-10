output "jenkins_security_group_id" {
    value = aws_security_group.jenkins_security_group.id
}

output "vpc_network_subnet1_id" {
    value = module.vpc.public_subnets[0]
}