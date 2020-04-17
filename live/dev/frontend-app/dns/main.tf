terraform {
    backend "s3" {
        bucket          = "sales-order-system-terraform-state-s3-bucket"
        key             = "live/dev/frontend-app/dns/terraform.tfstate"
        region          = "eu-west-2"
        dynamodb_table  = "sales-order-system-S3-state-lock"
    }
}

provider "aws" {
    region = "eu-west-1"
}

resource "aws_route53_record" "www_domain_url" {
    zone_id = data.aws_route53_zone.hosted_zone.zone_id
    name    = var.domain_name
    type    = "A"
    ttl     = "300"
    records = [data.terraform_remote_state.frontend_app.outputs.public_ip_address]
}