resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.domain_name}"
  acl = "public-read"

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

  website {
    redirect_all_requests_to = "https://www.${var.domain_name}"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.www_bucket.arn}/*", "${aws_s3_bucket.root_bucket.arn}/*"]

    principals {
      type = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.primary.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "www_bucket_policy" {
  bucket = aws_s3_bucket.www_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id = "www-bucket-cloudfront-access"

    Statement = [{
      Sid = "AllowCloudFrontOAI"
      Effect = "Allow"
      Principal = { "AWS": aws_cloudfront_origin_access_identity.primary.iam_arn }
      Action = "s3:*"
      Resource = [
        aws_s3_bucket.www_bucket.arn,
        "${aws_s3_bucket.www_bucket.arn}/*",
      ]
    }]
  })
}

resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket = aws_s3_bucket.root_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id = "root-bucket-cloudfront-access"

    Statement = [{
      Sid = "AllowCloudFrontOAI"
      Effect = "Allow"
      Principal = { "AWS": aws_cloudfront_origin_access_identity.primary.iam_arn }
      Action = "s3:*"
      Resource = [
        aws_s3_bucket.root_bucket.arn,
        "${aws_s3_bucket.root_bucket.arn}/*",
      ]
    }]
  })
}
