# Sales Order System 2.0 : Infrastructure



## Table of Contents

  - [Tech](#tech)
  - [Application Platform](#application-platform)
  - [Network Architecture](#network-architecture)
  - [Environments](#environments)
  - [Folder Structure](#folder-structure)
  - [Provisioning Guide](#provisioning-guide)
    - [Provision App-Network](#provision-app-network)
    - [Provision the Data Stores](#provision-the-data-stores)
    - [Provision the Backend Servers](#provision-the-backend-servers)
    - [Provision the Frontend App](#provision-the-frontend-app)
  - [Deploying Worldwide](#deploying-worldwide)


## Tech

- Terraform

## Application Platform 

![System Architecture](https://images-for-github-colinbut.s3.eu-west-2.amazonaws.com/sales-order-system-2/sales-order-system-2-system-arch.png)

## Network Architecture

![Network Diagram](https://images-for-github-colinbut.s3.eu-west-2.amazonaws.com/sales-order-system-2/sales-order-system-2-network-diagram.png)



## Environments

A list of the environments:

| Environment | Location | Region | Comment |
| :---------- | :------- | :----- | :------ |
| Mgmt | London | (eu-west-2) | Used for the project management resources such as Jenkins, IAM roles etc. |
| Dev  | Ireland | (eu-west-1) | |
| Staging | Sydney | (ap-southwest-2) | |
| Prod | Ohio | (us-east-2) | |


## Folder Structure

The following table explains in more detail what each directory entails:

| Folder | Description |
| :----- | :---------- |
| global | global configuration such as the state management for these Terraform configurations, IAM users |
| modules | reusable/composable modules for common infrastructure resources (vpc, ec2_instances) |
| mgmt | infrastructure configurations for management tooling (DevOps tools) such as Jenkins, ECR repo creation |
| live | terraform configurations for infrastructure resources used for the sales-order-system application (vpc, backend servers, data-stores, frontend-app) |

## Provisioning Guide

navigate to the correct folder for provision depending on which environment:

- `dev`
- `staging`
- `prod`

### Provision App-Network

First need to provision the network that the app (sales-order-system) lives on.

```bash
cd live/[environment]/app-network/
terraform init
terraform plan
terraform apply --auto-approve
```

### Provision the Data Stores

Certain backend services (Customer Service, Order Service, and Product Service) requires a backing data-store. So provision them first.

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

### Provision the Middleware Component(s)

```bash
cd live/[environment]/middleware/*
terraform init
terraform plan
terraform apply --auto-approve
```

### Provision the Frontend App

For this particular demo project, the front end app (built with React) statically compiles the source at build-time so cannot dynamically inject dependencies (the middleware component URL) into it.

Therefore, must provision the middleware components (if not already done so) prior to provision this. Get the public exposed endpoint URL of the middleware component and put it in the frontend app config then rebuuld the Docker image & upload it to the Docker Registry (in this example it is AWS ECR). 

See [Sales Order System 2.0](https://github.com/colinbut/sales-order-system-2.git) for more details.

Once done, follow steps below:

```bash
cd live/[environment]/frontend-app/
terraform init
terraform plan
terraform apply --auto-approve
```

## Deploying Worldwide

This project uses different AWS's geographic regions to segregrate different environments. Normally, should ideally use a different AWS account per each environment (you can take advantage of AWS Organization feature).

But for the purpose of a demo, I've used different disparate AWS regions to represent different environment you would typically have.

So to do "promotion" from one environment to the next (i.e. `dev` > `staging` > `prod`) you would require to deploy worldwide. 

Make sure each region is function correctly before moving on to the next. That is, make sure it works on `dev` first before testing on `staging` prior to releasing live to `prod`. 
