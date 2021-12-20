output "todo_frontend_url" {
    value = aws_s3_bucket.todo-frontend.bucket_domain_name
}

output "rds_keycloak_db_url" {
    value = "${aws_db_instance.keycloak_db.address}:${aws_db_instance.keycloak_db.port}"
}
