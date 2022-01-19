// GitLab Runner
resource "aws_iam_user" "gitlab_runner" {
    name          = "GitLab-Runner"
    force_destroy = true
    tags          = var.aws_tags
}

