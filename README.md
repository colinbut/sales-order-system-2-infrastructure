# Sales Order System 2.0 : Infrastructure

## Tech

- Terraform

## Environments

Mgmt - London (eu-west-2)
Dev - Ireland (eu-west-1)
Staging - Sydney (ap-southwest-2)
Prod - Ohio (us-east-2)


## Folder Structure

global - global configuration such as the state management for these Terraform configurations, IAM users
modules - reusable/composable modules for common infrastructure resources (vpc, ec2_instances)
mgmt - infrastructure configurations for management tooling (DevOps tools) such as Jenkins, ECR repo creation
live - terraform configurations for infrastructure resources used for the sales-order-system application (vpc, backend servers, data-stores, frontend-app)

## Provisioning Guide

navigate to the correct folder for provision depending on which environment:

`dev`
`staging`
`prod`

### Provision App-Network

First need to provision the network that the app (sales-order-system) lives on.

```bash
cd live/[environment]/app-network/
terraform init
terraform plan
terraform apply --auto-approve
```

### Provision the Data Stores

```bash
cd live/[environment]/data-stores/
terraform init
terraform plan
terraform apply --auto-approve
```

### Provision the Backend Servers

```bash
cd live/[environment]/backend-servers/
terraform init
terraform plan
terraform apply --auto-approve
```

### Provision the Frontend App

```bash
cd live/[environment]/frontend-app/
terraform init
terraform plan
terraform apply --auto-approve
```

