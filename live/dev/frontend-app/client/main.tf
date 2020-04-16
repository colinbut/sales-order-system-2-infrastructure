terraform {
    backend "s3" {
        bucket          = "sales-order-system-terraform-state-s3-bucket"
        key             = "live/dev/frontend-app/client/terraform.tfstate"
        region          = "eu-west-2"
        dynamodb_table  = "sales-order-system-S3-state-lock"
    }
}

provider "aws" {
    region = "eu-west-1"
}

data "terraform_remote_state" "app_network" {
    backend = "s3"
    config = {
        bucket  = "sales-order-system-terraform-state-s3-bucket"
        key     = "live/dev/app-network/terraform.tfstate"
        region  = "eu-west-2"
    }
}

locals {
    ami             = var.ami
    key_pair        = var.key_pair
    server_name     = var.server_name
    environment     = var.environment
    http_port       = var.http_port
    ssh_port        = 22
    protocol        = "tcp"
    any_port        = 0
    any_protocol    = "-1"
}

module "frontend-webserver-server" {
    source                  = "../../../../modules/backend-servers"

    ami                     = local.ami
    key_pair                = local.key_pair
    server_name             = "${local.server_name}-${local.environment}"
    enable_public_facing    = true
    subnet_id               = lookup(data.terraform_remote_state.app_network.outputs.subnets, "app_public_subnet_a").id
    security_groups         = [aws_security_group.security_group.id]
}

resource "aws_security_group" "security_group" {
    name        = "${local.server_name}_security_group"
    description = "The SG for normal web access & SSH from outside"
    vpc_id      = data.terraform_remote_state.app_network.outputs.vpc_id

    ingress {
        from_port   = local.http_port
        to_port     = local.http_port
        protocol    = local.protocol
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = local.ssh_port
        to_port     = local.ssh_port
        protocol    = local.protocol
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = local.any_port
        to_port     = local.any_port
        protocol    = local.any_protocol
        cidr_blocks = ["0.0.0.0/0"]
    }
}