resource "aws_cloudfront_distribution" "webapp" {
    comment             = "CloudFront Distribution for the S3 Bucket where the static WebApp is hosted"
    enabled             = true
    default_root_object = "index.html"
    wait_for_deployment = false

    origin {
        domain_name = aws_s3_bucket.todo-frontend.bucket_regional_domain_name
        origin_id   = local.cloudfront_s3_origin_id

        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.webapp.cloudfront_access_identity_path
        }
    }

    default_cache_behavior {
        allowed_methods        = ["GET", "HEAD", "OPTIONS"]
        cached_methods         = ["GET", "HEAD"]
        target_origin_id       = local.cloudfront_s3_origin_id
        viewer_protocol_policy = "https-only"

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    tags = var.aws_tags
}

resource "aws_cloudfront_origin_access_identity" "webapp" {
    comment = "CloudFront-Identity"
}
