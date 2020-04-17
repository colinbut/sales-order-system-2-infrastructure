data "terraform_remote_state" "frontend_app" {
    backend = "s3"
    config = {
        bucket  = "sales-order-system-terraform-state-s3-bucket"
        key     = "live/dev/frontend-app/client/terraform.tfstate"
        region  = "eu-west-2"
    }
}

data "aws_route53_zone" "hosted_zone" {
    name = var.domain_name
}