output "todo_frontend_url" {
    value = aws_s3_bucket.todo-frontend.bucket_domain_name
}

output "rds_keycloak_db_url" {
    value = "${aws_db_instance.keycloak_db.address}:${aws_db_instance.keycloak_db.port}"
}

output "ec2_container_host_url" {
    value = aws_instance.container_host.public_dns
}

output "cloudfront_frontend_url" {
    value = aws_cloudfront_distribution.webapp.domain_name
}
