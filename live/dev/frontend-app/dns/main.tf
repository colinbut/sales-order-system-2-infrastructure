resource "aws_route53_record" "www_domain_url" {
    zone_id = data.aws_route53_zone.hosted_zone.zone_id
    name    = var.domain_name
    type    = "A"
    ttl     = "300"
    records = [data.terraform_remote_state.frontend_app.outputs.public_ip_address]
}