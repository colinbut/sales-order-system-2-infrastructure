# Container Repo

This directory contains Terraform configurations to create Docker Repositories on AWS ECR.

To add/remove a docker repository to create, edit the `repos.tfvars` file

```bash
terraform init
terraform plan -var-file=repos.tfvars
terraform apply -var-file=repos.tfvars
```


