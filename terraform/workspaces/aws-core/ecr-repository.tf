resource "aws_ecr_repository" "akse_repository_todo_service" {
    name = "akse-todo-service"
    tags = var.aws_tags
}

resource "aws_ecr_lifecycle_policy" "akse_policy" {
    repository = aws_ecr_repository.akse_repository_todo_service.name
    policy     = jsonencode({
        "rules" : [
            {
                "rulePriority" : 1,
                "description" : "Keep only the latest images.",
                "selection" : {
                    "tagStatus" : "any",
                    "countType" : "imageCountMoreThan",
                    "countNumber" : 1
                },
                "action" : {
                    "type" : "expire"
                }
            }
        ]
    })
}

