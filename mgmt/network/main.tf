module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "sales-order-system-mgmt-vpc"
    cidr = "10.0.0.0/16"

    azs = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
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

    # allow ssh
    ingress {
        from_port   = 22
        to_port     = 22
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