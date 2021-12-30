resource "aws_ecs_cluster" "todo_app_cluster" {
    name = local.cluster_name
    tags = var.aws_tags
}
