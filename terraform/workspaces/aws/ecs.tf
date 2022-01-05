resource "aws_ecs_cluster" "todo_app_cluster" {
    name = local.cluster_name
    tags = var.aws_tags
}

resource "aws_ecs_service" "todo_app_services" {
    name                               = "TodoAppServices"
    cluster                            = aws_ecs_cluster.todo_app_cluster.id
    task_definition                    = aws_ecs_task_definition.todo_app_services.arn
    desired_count                      = 1
    launch_type                        = "EC2"
    deployment_minimum_healthy_percent = 0
    deployment_maximum_percent         = 100
    tags                               = var.aws_tags
    depends_on                         = [
        aws_ecs_task_definition.todo_app_services
    ]
    force_new_deployment               = true
}

resource "aws_ecs_task_definition" "todo_app_services" {
    family                = "TodoAppServices"
    container_definitions = templatefile("${path.module}/ecs-tasks/todo-app-services-container.tftpl", {
        // Keycloak
        keycloak_port             = var.keycloak_port,
        keycloak_user             = var.keycloak_user,
        keycloak_password         = aws_secretsmanager_secret.keycloak_admin_password.arn
        keycloak_db_vendor        = var.keycloak_db_vendor,
        keycloak_db_url           = aws_db_instance.keycloak_db.address,
        keycloak_db_port          = var.keycloak_db_port
        keycloak_db_user          = var.keycloak_db_username,
        keycloak_db_password      = aws_secretsmanager_secret.keycloak_rds_db_user_password.arn
        keycloak_db_database_name = var.keycloak_db_database_name
    })
    execution_role_arn    = aws_iam_role.todo_app_services_task_execution_role.arn
    //    task_role_arn         = ""
    tags                  = var.aws_tags
}

// The Role for Executing ECS Tasks
// See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data-secrets.html
resource "aws_iam_role" "todo_app_services_task_execution_role" {
    name               = "Todo-App-Services-Task-Execution-Role"
    description        = "The role for launching the keycloak task"
    // Set Trust Relation: Allow ECS to "assume role"
    assume_role_policy = file("${path.module}/policies/allow-ecs-to-assume-role.json")
    tags               = var.aws_tags
}

// Attach the AWS Managed ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {
    role       = aws_iam_role.todo_app_services_task_execution_role.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// Allow Secrets Manager Access via Inline Policy
resource "aws_iam_role_policy" "todo_app_services_task_execution_role" {
    role   = aws_iam_role.todo_app_services_task_execution_role.id
    policy = templatefile("${path.module}/policies/keycloak-task-execution-role.tftpl", {
        keycloak_rds_secret  = aws_secretsmanager_secret.keycloak_rds_db_user_password.arn
        keycloak_user_secret = aws_secretsmanager_secret.keycloak_admin_password.arn
    })
}
