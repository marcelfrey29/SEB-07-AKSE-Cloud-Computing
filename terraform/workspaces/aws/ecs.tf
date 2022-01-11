resource "aws_ecs_cluster" "todo_app_cluster" {
    name = local.cluster_name
    tags = var.aws_tags
}

resource "aws_ecs_service" "keycloak_service" {
    name                               = local.ecs_service_keycloak_family_name
    cluster                            = aws_ecs_cluster.todo_app_cluster.id
    task_definition                    = aws_ecs_task_definition.keycloak_service.arn
    desired_count                      = 1
    launch_type                        = "EC2"
    // This deployment health configuration does NOT provide zero-downtime-deployments!
    // This configuration first stops the existing container and then launches a new one.
    // The reason for this configuration is that we use the ports of the EC2 instance.
    // New containers can't be launched because the running container is already using the desired port.
    deployment_minimum_healthy_percent = 0
    deployment_maximum_percent         = 100
    tags                               = var.aws_tags
    depends_on                         = [
        aws_ecs_task_definition.keycloak_service
    ]
    force_new_deployment               = true
}

resource "aws_ecs_task_definition" "keycloak_service" {
    family                = local.ecs_service_keycloak_family_name
    container_definitions = templatefile("${path.module}/ecs-tasks/keycloak-service-container.tftpl", {
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
    execution_role_arn    = aws_iam_role.keycloak_services_task_execution_role.arn
    tags                  = var.aws_tags
}

// The Role for Executing ECS Tasks.
// See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data-secrets.html
resource "aws_iam_role" "keycloak_services_task_execution_role" {
    name               = "Keycloak-Service-Task-Execution-Role"
    description        = "The role for launching the keycloak service container"
    // Set Trust Relation: Allow ECS to "assume role"
    assume_role_policy = file("${path.module}/policies/ecs-allow-assume-role.json")
    tags               = var.aws_tags
}

// Attach the AWS Managed ECS Task Execution Role.
// This policy provides ECS-Core-Permission.
resource "aws_iam_role_policy_attachment" "keycloak_service_AmazonECSTaskExecutionRolePolicy" {
    role       = aws_iam_role.keycloak_services_task_execution_role.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// Allow ECS to Access Secrets from the Secrets Manager via Inline Policy
resource "aws_iam_role_policy" "keycloak_services_task_execution_role" {
    role   = aws_iam_role.keycloak_services_task_execution_role.id
    policy = templatefile("${path.module}/policies/ecs-task-keycloak-service-execution-role.tftpl", {
        keycloak_rds_secret  = aws_secretsmanager_secret.keycloak_rds_db_user_password.arn
        keycloak_user_secret = aws_secretsmanager_secret.keycloak_admin_password.arn
    })
}

resource "aws_ecs_service" "backend_service" {
    name                               = local.ecs_service_backend_family_name
    cluster                            = aws_ecs_cluster.todo_app_cluster.id
    task_definition                    = aws_ecs_task_definition.backend_service.arn
    desired_count                      = 1
    launch_type                        = "EC2"
    // Info about the deployment configuration, see "keycloak_service"
    deployment_minimum_healthy_percent = 0
    deployment_maximum_percent         = 100
    tags                               = var.aws_tags
    depends_on                         = [
        aws_ecs_task_definition.backend_service
    ]
    force_new_deployment               = true
}

resource "aws_ecs_task_definition" "backend_service" {
    family                = local.ecs_service_backend_family_name
    container_definitions = templatefile("${path.module}/ecs-tasks/backend-service-container.tftpl", {
        server_port            = var.todo_service_port
        // IMPORTANT: If the "server_environment" is NOT "DEVELOPMENT", then the Environment Variable "KEYCLOAK_REALM_PUBLIC_KEY" has NOT to be set!
        server_environment     = "PRODUCTION"
        // Important: The Keycloak URL has to end with "/auth" (see Backend-Code)
        keycloak_url           = "http://${aws_instance.container_host.public_dns}:${var.keycloak_port}/auth",
        keycloak_realm         = var.keycloak_realm,
        keycloak_client_id     = var.keycloak_client_id,
        keycloak_client_secret = var.keycloak_client_secret,
        dynamodb_region        = var.aws_region,
        dynamodb_endpoint      = "https://dynamodb.${var.aws_region}.amazonaws.com",
        dynamodb_table         = aws_dynamodb_table.todo_db.name
    })
    execution_role_arn    = aws_iam_role.backend_service_task_execution_role.arn
    tags                  = var.aws_tags
}

// The Role for Executing ECS Tasks.
// See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data-secrets.html
resource "aws_iam_role" "backend_service_task_execution_role" {
    name               = "Backend-Service-Task-Execution-Role"
    description        = "The role for launching the backend service container"
    // Set Trust Relation: Allow ECS to "assume role"
    assume_role_policy = file("${path.module}/policies/ecs-allow-assume-role.json")
    tags               = var.aws_tags
}

// Attach the AWS Managed ECS Task Execution Role.
// This policy provides ECS-Core-Permission.
resource "aws_iam_role_policy_attachment" "backend_service_AmazonECSTaskExecutionRolePolicy" {
    role       = aws_iam_role.backend_service_task_execution_role.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
