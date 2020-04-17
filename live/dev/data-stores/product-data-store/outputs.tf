output "cache_nodes" {
    value = aws_elasticache_cluster.product_redis_elasticache_cluster.cache_nodes
}

output "product_service_data_store_security_group_id" {
    value = aws_security_group.redis_elasticache_security_group.id
}