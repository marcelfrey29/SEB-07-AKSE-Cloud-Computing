resource "aws_s3_bucket" "todo-frontend" {
    bucket = var.s3_webapp_bucket_name
    policy = templatefile("${path.module}/policies/s3-public-read.json", {
        bucket_name                = var.s3_webapp_bucket_name,
        cloudfront_access_identity = aws_cloudfront_origin_access_identity.webapp.id
    })
    tags   = var.aws_tags
}

resource "aws_s3_bucket_object" "files" {
    for_each = fileset("${path.module}/../../../todo-frontend/dist/", "**")
    bucket   = aws_s3_bucket.todo-frontend.bucket
    key      = each.value
    source   = "${path.module}/../../../todo-frontend/dist/${each.value}"
    etag     = filemd5("${path.module}/../../../todo-frontend/dist/${each.value}")

    # Fix MIME-Type
    # Otherwise static website hosting does not work
    content_type = lookup(local.mime_types, try(regex("\\.[^.]+$", each.value), "DEFAULT_VALUE"), "text/plain")

    tags = var.aws_tags
}
