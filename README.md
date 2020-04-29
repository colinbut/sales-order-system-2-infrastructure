# Sales Order System 2.0 : Infrastructure (Docker on EC2)

This project is a direct spin-off from the main [Sales Order System 2.0](https://github.com/colinbut/sales-order-system-2.git) project. Whereas that project showcases the theme of "Application Development" - this project demonstrates in particular the __Infrastructure as Code__ concept of __Infrastructure Provisioning__.


## Table of Contents

  - [Tech](#technology)
  - [Application Platform](#application-platform)
  - [Network Architecture](#network-architecture)
  - [Environments](#environments)
  - [Folder Structure](#folder-structure)
  - [Provisioning Guide](#provisioning-guide)
    - [Provision App-Network](#provision-app-network)
    - [Provision the Data Stores](#provision-the-data-stores)
    - [Provision the Backend Servers](#provision-the-backend-servers)
    - [Provision the Middleware Components](#provision-the-middleware-components)
    - [Provision the Frontend App](#provision-the-frontend-app)
  - [Deploying Worldwide](#deploying-worldwide)


## Technology

- Terraform
- AWS:
  - S3
  - DynamoDB
  - EC2
  - ECR
  - RDS
  - Elasticache

## Application Platform 

This section covers a brief overview of the Sales Order System 2.0 platform which is AWS Cloud Native.

Each backend microservice is a Java 8-Spring Boot web service packaged up in a Docker Image which then gets bundled to run inside an EC2 instance (by default `t2.micro`). UserService uses an embedded in-memory H2 database. Customer Service uses MySQL so we go native and uses AWS's managed database service (RDS) with MySQL as its engine. Since Product Service uses Redis as its backing NoSQL datastore, I choose to use AWS Elasticache (with obviously Redis as its engine). Rather than fiddling with the complexity of using AWS DocumentDB (MongoDB compatible) I choose to simply run MongoDB in a Docker Container running directly inside EC2 instances (just like the backend microservices). 

Frontend App is simply a SPA (Single Page Application) React application where its static files are served statically from a simple Http Web Server (Apache). A middleware component (NGINX) which acts as both an API Gateway & a Reverse Proxy sits in-between the frontend app & the backend microservices in order to hide the backend services from the public internet (backend services sit inside a private subnet - see section below) and to route content to different URLs served by different backend service.

Also setup DNS with Route53 to configure a simple A record to allow accessing the frontend app via a human-friendly domain name (a domain name which I bought & registered using Route53). 


![System Architecture](https://images-for-github-colinbut.s3.eu-west-2.amazonaws.com/sales-order-system-2/sales-order-system-2-system-arch.png)

## Network Architecture

A standard VPC with 4 subnets configured (2 x public, 2 x private) residing from 2 different Availability Zones (AZs). The backend microservices and its databases/datastores lives inside the private subnets. The frontend app lives in the public subnet. The middleware component (API Gateway/Reverse Proxy) also resides in the public subnet for reasons mentioned above. The frontend app talks directly to this middleware component in order to communicate with the backend services.

![Network Diagram](https://images-for-github-colinbut.s3.eu-west-2.amazonaws.com/sales-order-system-2/sales-order-system-2-network-diagram.png)

Having the middleware component living inside the public subnet also allows exposing the backend services's Swagger (API Doc) outside for testing only.

2 AZs with one acting as a primary and the other standby to facilitate a primary to standby failover/disaster recovery mechanism. For example, by default, I've provisioned everything into `eu-west-1a` and if need be can bring everything up again in the 2nd AZ (`eu-west-1b`) and then can easily switch traffic to that side by reconfigure DNS in Route53.
I've personally not done this and simply left it as a future exercise to do.

Finally, I've also provisioned a Bastian Host (Jump Host/Management Server) to allow me to ssh onto the EC2 instances running in the private subnets so that I can do my maintenance on them. Currently, I've isolated this management server to be in the same AZ as the standby AZ (for pure demo purposes).

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
