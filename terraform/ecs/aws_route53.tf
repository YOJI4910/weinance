data "aws_route53_zone" "weinance" {
  name = "weinance.xyz"
}

resource "aws_route53_record" "weinance" {
  zone_id = data.aws_route53_zone.weinance.zone_id
  name    = data.aws_route53_zone.weinance.name
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

# SSL証明の発行(ACM)
resource "aws_acm_certificate" "weinance" {
  domain_name               = data.aws_route53_zone.weinance.name
  subject_alternative_names = []
  validation_method         = "DNS"
}
# 所有権検証用DNSレコード
resource "aws_route53_record" "weinance_certificate" {
  zone_id = data.aws_route53_zone.weinance.id
  name    = aws_acm_certificate.weinance.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.weinance.domain_validation_options[0].resource_record_type
  records = [
    aws_acm_certificate.weinance.domain_validation_options[0].resource_record_value
  ]
  ttl = 60
}