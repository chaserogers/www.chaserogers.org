resource "aws_route53_record" "root_record" {
  zone_id = data.aws_route53_zone.default.zone_id
  name = var.domain_name
  type = "A"

  alias {
    name = aws_cloudfront_distribution.root_distro.domain_name
    zone_id = aws_cloudfront_distribution.root_distro.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_record" {
  zone_id = data.aws_route53_zone.default.zone_id
  name = "www.${var.domain_name}"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.www_distro.domain_name
    zone_id = aws_cloudfront_distribution.www_distro.hosted_zone_id
    evaluate_target_health = false
  }
}
