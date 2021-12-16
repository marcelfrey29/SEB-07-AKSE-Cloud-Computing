output "todo_frontend_url" {
    value = aws_s3_bucket.todo-frontend.bucket_domain_name
}
