locals {
    ssh_port        = 22
    any_port        = 0
    tcp_protocol    = "tcp"
    any_protocol    = "-1"
    ami             = "ami-06ce3edf0cff21f07"
    instance_type   = "t2.micro"
    key_pair        = "MyIrelandKP"
}

resource "aws_security_group" "bastian_host_security_group" {
    name        = "bastian_host_security_group"
    description = "The SG for the Bastian Host only allow SSH"
    vpc_id      = module.app_vpc.vpc_id

    ingress {
        from_port   = local.ssh_port
        to_port     = local.ssh_port
        protocol    = local.tcp_protocol
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = local.any_port
        to_port     = local.any_port
        protocol    = local.any_protocol
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "bastian_host" {
    ami                         = local.ami
    instance_type               = local.instance_type
    key_name                    = local.key_pair
    associate_public_ip_address = true
    subnet_id                   = lookup(module.app_public_subnets.subnets, "app_public_subnet_b").id
    vpc_security_group_ids      = [aws_security_group.bastian_host_security_group.id]

    tags = {
        Name = "Bastian Host"
    }
}