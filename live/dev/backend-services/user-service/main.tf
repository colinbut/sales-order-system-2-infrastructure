terraform {
    backend "s3" {
        bucket          = "sales-order-system-terraform-state-s3-bucket"
        key             = "live/dev/backend-services/user-service/terraform.tfstate"
        region          = "eu-west-2"
        dynamodb_table  = "sales-order-system-S3-state-lock"
    }
}

provider "aws" {
    region = "eu-west-1"
}

module "backend-server" {
    source      = "../../../../modules/backend-servers"

    ami         = "ami-06ce3edf0cff21f07"
    key_pair    = "MyIrelandKP"
    server_name = "user-service"
}