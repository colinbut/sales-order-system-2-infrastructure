terraform {
    backend "s3" {
        bucket          = "sales-order-system-terraform-state-s3-bucket"
        key             = "global/users/terraform.tfstate"
        region          = "eu-west-2"
        dynamodb_table  = "sales-order-system-S3-state-lock"
    }
}

provider "aws" {
    region = "eu-west-2"
}

resource "aws_iam_user" "users" {
    for_each = var.user_names
    name = each.value
}