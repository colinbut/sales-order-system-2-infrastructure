output "route_tables" {
    value = {for route_table in aws_route_table.route_table : route_table.tags.Name => route_table}
}