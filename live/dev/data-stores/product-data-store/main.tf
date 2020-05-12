provider "aws" {
    region = "eu-west-1"
}

data "terraform_remote_state" "app_network" {
    backend = "s3"
    config = {
        bucket  = "sales-order-system-terraform-state-s3-bucket"
        key     = "live/dev/app-network/terraform.tfstate"
        region  = "eu-west-2"
    }
}

resource "aws_security_group" "redis_elasticache_security_group" {
    name        = "redis_elasticache_security_group"
    description = "The security group for the redis elasticache"
    vpc_id      = data.terraform_remote_state.app_network.outputs.vpc_id
}

resource "aws_elasticache_subnet_group" "elasticache_redis_subnet_group" {
    name        = "redis-subnet-group"
    description = "Subnet Group for redis elasticache"
    subnet_ids  = [lookup(data.terraform_remote_state.app_network.outputs.subnets, "app_private_subnet_a").id]
}

resource "aws_elasticache_cluster" "product_redis_elasticache_cluster" {
    cluster_id              = "product-redis-data-store"
    engine                  = "redis"
    engine_version          = "5.0.6"
    num_cache_nodes         = 1
    node_type               = "cache.t2.micro"
    parameter_group_name    = "default.redis5.0"
    security_group_ids      = [aws_security_group.redis_elasticache_security_group.id]
    subnet_group_name       = aws_elasticache_subnet_group.elasticache_redis_subnet_group.name
    port                    = 6379
}