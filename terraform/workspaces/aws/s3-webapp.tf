resource "aws_s3_bucket" "todo-frontend" {
    bucket = var.s3_webapp_bucket_name

    policy = templatefile("${path.module}/policies/s3-public-read.json", {
        bucket_name : var.s3_webapp_bucket_name
    })

    website {
        index_document = "index.html"
        error_document = "index.html"
    }

    tags = var.aws_tags
}
