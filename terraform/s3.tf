resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.domain_name}"
  acl = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.domain_name}" })

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

resource "aws_s3_bucket" "root_bucket" {
  bucket = var.domain_name
  acl = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = var.domain_name })

  website {
    redirect_all_requests_to = "https://www.${var.domain_name}"
  }
}
