terraform {
    backend "s3" {
        bucket          = "sales-order-system-terraform-state-s3-bucket"
        key             = "live/dev/backend-services/user-service/terraform.tfstate"
        region          = "eu-west-2"
        dynamodb_table  = "sales-order-system-S3-state-lock"
    }
}

provider "aws" {
    region = "eu-west-1"
}

data "terraform_remote_state" "roles" {
    backend = "s3"
    config = {
        bucket  = "sales-order-system-terraform-state-s3-bucket"
        key     = "live/dev/app-network/terraform.tfstate"
        region  = "eu-west-2"
    }
}

locals {
    ami         = "ami-06ce3edf0cff21f07"
    key_pair    = "MyIrelandKP"
    server_name = "user-service"
    http_port   = 8080
    ssh_port    = 22
    protocol    = "tcp"
}

module "backend-server" {
    source      = "../../../../modules/backend-servers"

    ami         = locals.ami
    key_pair    = locals.key_pair
    server_name = locals.server_name
    security_groups = aws_security_group.security_group
}

resource "aws_security_group" "security_group" {
    name        = "user_service_security_group"
    description = "The SG for normal web access & SSH from a Bastian Host (Management Server)"
    vpc_id      = data.terraform_remote_state.roles.outputs.vpc_id

    ingress {
        from_port   = locals.http_port
        to_port     = locals.http_port
        protocol    = locals.protocol
        cidr_blocks = ["10.0.1.0/24"]
    }

    ingress {
        from_port   = local.ssh_port
        to_port     = local.ssh_port
        protocol    = local.protocol
        cidr_blocks = ["10.0.3.0/24"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}