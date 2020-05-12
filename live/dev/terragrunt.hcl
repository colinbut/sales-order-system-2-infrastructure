remote_state {
    backend = "s3"
    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket = "sales-order-system-terraform-state-s3-bucket"

        key = "${path_relative_to_include()}/terraform.tfstate"
        region = "eu-west-2"
        dynamodb_table = "sales-order-system-S3-state-lock"
    }
}