data "terraform_remote_state" "roles" {
    backend = "s3"
    config = {
        bucket  = "sales-order-system-terraform-state-s3-bucket"
        key     = "mgmt/roles/terraform.tfstate"
        region  = "eu-west-2"
    }
}

resource "aws_instance" "server" {
    ami                         = var.ami
    instance_type               = var.instance_type
    key_name                    = var.key_pair
    associate_public_ip_address = var.enable_public_facing
    iam_instance_profile        = data.terraform_remote_state.roles.outputs.ec2_ecr_instance_profile_name
    security_groups             = var.security_groups
    subnet_id                   = var.subnet_id

    user_data                   = <<EOF
                                    #!/bin/bash
                                    amazon-linux-extras install docker -y
                                    service docker start
                                    EOF

    tags = {
        Name = var.server_name
    }
}