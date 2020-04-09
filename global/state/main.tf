terraform {
    backend "s3" {
        bucket = "sales-order-system-terraform-state-s3-bucket"
        key     = "global/state/terraform.tfstate"
        region  = "eu-west-2"
    }
}

provider "aws" {
    region = "eu-west-2"
}

resource "aws_dynamodb_table" "s3-state-lock-table" {
    name = "sales-order-system-S3-state-lock"

    hash_key = "LockID"
    billing_mode = "PAY_PER_REQUEST"

    attribute {
        name = "LockID"
        type = "S"
    }
}

resource "aws_s3_bucket" "terraform-state-s3-bucket" {
    bucket = "sales-order-system-terraform-state-s3-bucket"

    lifecycle {
        prevent_destroy = true
    }

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}