terraform {
    backend "s3" {
        bucket          = "sales-order-system-terraform-state-s3-bucket"
        key             = "live/dev/data-stores/customer-database/terraform.tfstate"
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

resource "aws_security_group" "mysql_rds_security_group" {
    name        = "mysql_rds_security_group"
    description = "mysql rds security group"
    vpc_id      = data.terraform_remote_state.app_network.outputs.vpc_id

    ingress {
        from_port   = 3306
        to_port     = 3306
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

resource "aws_db_subnet_group" "mysql_rds_subnet_group" {
    name        = "mysql_rds_subnet_group" 
    subnet_ids  = [
        lookup(data.terraform_remote_state.app_network.outputs.subnets, "app_private_subnet_a").id,
        lookup(data.terraform_remote_state.app_network.outputs.subnets, "app_private_subnet_b").id
    ]
}

resource "aws_db_instance" "mysql_on_rds" {
    identifier                  = "customer-mysql-rds"
    allocated_storage           = 20
    storage_type                = "gp2"
    engine                      = "mysql"
    engine_version              = "8.0"
    instance_class              = "db.t2.micro"
    username                    = "root"
    password                    = var.password
    apply_immediately           = true
    allow_major_version_upgrade = true
    availability_zone           = "eu-west-1a"
    port                        = 3306
    skip_final_snapshot         = true
    vpc_security_group_ids      = [aws_security_group.mysql_rds_security_group.id]
    publicly_accessible         = true
    db_subnet_group_name        = aws_db_subnet_group.mysql_rds_subnet_group.id
}