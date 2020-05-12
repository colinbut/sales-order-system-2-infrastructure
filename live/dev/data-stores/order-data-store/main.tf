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
    http_port       = var.mongo_port
    ssh_port        = 22
    protocol        = "tcp"
    any_port        = 0
    any_protocol    = "-1"
}

module "backend_server_db" {
    source = "../../../../modules/backend-servers"

    ami             = local.ami
    key_pair        = local.key_pair
    server_name     = "${local.server_name}-${local.environment}"
    security_groups = [aws_security_group.security_group.id]
    subnet_id       = lookup(data.terraform_remote_state.app_network.outputs.subnets, "app_private_subnet_a").id
}

resource "aws_security_group" "security_group" {
    name        = "${local.server_name}_security_group"
    description = "The SG for mongo db access & SSH from a Bastian Host (Management Server)"
    vpc_id      = data.terraform_remote_state.app_network.outputs.vpc_id
}

resource "aws_security_group_rule" "allow_ssh_from_bastian" {
    type                = "ingress"
    description         = "allow_ssh_from_bastian"
    from_port           = local.ssh_port
    to_port             = local.ssh_port
    protocol            = local.protocol
    cidr_blocks         = ["10.0.2.0/24"]
    security_group_id   = aws_security_group.security_group.id
}

resource "aws_security_group_rule" "default_outbound" {
    type                = "egress"
    description         = "default_outbound"
    from_port           = local.any_port
    to_port             = local.any_port
    protocol            = local.any_protocol
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.security_group.id
}