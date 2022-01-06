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


    // Redirects (e.g. from Keycloak) and deep links of a Single Page Application (SPA) are not working by default with CloudFront.
    // The reason is that the routes to not existing on a file system level.
    // As a workaround, we have to define a custom error handler that redirects 404 errors to the index.html.
    // Then, the SPA is responsible to handle 404 errors.
    // https://stackoverflow.com/questions/38475329/single-page-application-in-aws-cloudfront
    custom_error_response {
        error_code         = 404
        response_code      = 200
        response_page_path = "/index.html"
    }

    // S3 returns a 403 instead of a 404... Not sure why :O
    // Where I am sure is that this rule fixes the redirect issue :D
    custom_error_response {
        error_code         = 403
        response_code      = 200
        response_page_path = "/index.html"
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
