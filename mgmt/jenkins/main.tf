provider "aws" {
    region = "eu-west-2"
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "sales-order-system-mgmt-vpc"
    cidr = "10.0.0.0/16"

    azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    
    enable_nat_gateway = false
    enable_dns_hostnames = true

    tags = {
        Terraform = true
        Environment = "dev"
    }
}

resource "aws_security_group" "jenkins_security_group" {
    description     = "Security Group for accessing Jenkins"
    name            = "jenkins_security_group"
    vpc_id          = module.vpc.vpc_id
    
    ingress {
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_instance" "jenkins_master" {
    ami                         = "ami-0089b31e09ac3fffc"
    instance_type               = "t2.micro"
    associate_public_ip_address = true
    key_name                    = "MyLondonKP"

    vpc_security_group_ids      = [aws_security_group.jenkins_security_group.id]
    
    tags = {
        Name = "Jenkins-Master"
    }
}