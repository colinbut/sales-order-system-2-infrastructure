provider "aws" {
    region = "eu-west-2"
}

resource "aws_ecr_repository" "ecr_repos" {
    for_each = toset(var.ecr-repos-to-create)
    name = each.value
}