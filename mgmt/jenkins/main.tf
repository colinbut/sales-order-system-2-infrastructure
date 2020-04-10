terraform {
    backend "s3" {
        bucket = "sales-order-system-terraform-state-s3-bucket"
        key     = "mgmt/jenkins/terraform.tfstate"
        region  = "eu-west-2"
    }
}

provider "aws" {
    region = "eu-west-2"
}

module "mgmt-network" {
    source = "../network/"
}

locals {
    ami                         = "ami-0089b31e09ac3fffc"
    instance_type               = "t2.micro"
    key_name                    = "MyLondonKP"
    associate_public_ip_address = true
}

resource "aws_instance" "jenkins_master" {
    ami                         = local.ami
    instance_type               = local.instance_type
    associate_public_ip_address = local.associate_public_ip_address
    key_name                    = local.key_name

    vpc_security_group_ids      = [module.mgmt-network.jenkins_security_group_id]
    subnet_id                   = module.mgmt-network.vpc_network_subnet1_id
    
    tags = {
        Name = "Jenkins-Master"
    }
}


resource "aws_instance" "jenkins_slave" {
    ami                         = local.ami
    instance_type               = local.instance_type
    associate_public_ip_address = local.associate_public_ip_address
    key_name                    = local.key_name

    vpc_security_group_ids      = [module.mgmt-network.jenkins_security_group_id]
    subnet_id                   = module.mgmt-network.vpc_network_subnet1_id

    count                       = 2
    
    tags = {
        Name = "Jenkins-Slave-${count.index+1}"
    }
}