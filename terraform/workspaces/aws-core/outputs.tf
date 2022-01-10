// URL of the ECR Registry
output "akse_repository_url" {
    value = aws_ecr_repository.akse_repository_todo_service.repository_url
}
