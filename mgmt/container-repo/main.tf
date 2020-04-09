terraform {
    backend "s3" {
        bucket = "sales-order-system-terraform-state-s3-bucket"
        key     = "mgmt/container-repo/terraform.tfstate"
        region  = "eu-west-2"
    }
}

provider "aws" {
    region = "eu-west-2"
}

resource "aws_ecr_repository" "ecr_repos" {
    for_each = toset(var.ecr-repos-to-create)
    name = each.value
}