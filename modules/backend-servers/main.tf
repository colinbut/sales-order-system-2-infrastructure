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
    associate_public_ip_address = true
    iam_instance_profile        = data.terraform_remote_state.roles.outputs.ec2_ecr_instance_profile_name
    
    user_data                   = <<EOF
                                    #!/bin/bash
                                    amazon-linux-extras install docker -y
                                    service docker start
                                    EOF

    tags = {
        Name = var.server_name
    }
}