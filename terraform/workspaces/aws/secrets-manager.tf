resource "aws_secretsmanager_secret" "keycloak_rds_db_user_password" {
    name                    = "RDS-Postgres-Password"
    description             = "The password to access the RDS Postgres Instance (Required for Keycloak)"
    recovery_window_in_days = 0 # Enable force deletion
    tags                    = var.aws_tags
}

resource "aws_secretsmanager_secret_version" "keycloak_rds_db_user_password" {
    secret_id     = aws_secretsmanager_secret.keycloak_rds_db_user_password.id
    secret_string = var.keycloak_db_password
}

resource "aws_secretsmanager_secret_policy" "keycloak_rds_db_user_password" {
    secret_arn = aws_secretsmanager_secret.keycloak_rds_db_user_password.arn
    policy     = file("${path.module}/policies/secrets-manager-secret-access.json")
}

resource "aws_secretsmanager_secret" "keycloak_admin_password" {
    name                    = "Keycloak-Admin-Password"
    description             = "The password of the Keycloak Admin Account"
    recovery_window_in_days = 0 # Enable force deletion
    tags                    = var.aws_tags
}

resource "aws_secretsmanager_secret_version" "keycloak_admin_password" {
    secret_id     = aws_secretsmanager_secret.keycloak_admin_password.id
    secret_string = var.keycloak_password
}

resource "aws_secretsmanager_secret_policy" "keycloak_admin_password" {
    policy     = file("${path.module}/policies/secrets-manager-secret-access.json")
    secret_arn = aws_secretsmanager_secret.keycloak_admin_password.arn
}

// Fix to Connect to the Database with IntelliJ
resource "aws_secretsmanager_secret" "keycloak_rds" {
    name                    = "RDS-Postgres-IntelliJ"
    description             = "RDS Compatible Secret for the Keycloak RDS DB to use with IntelliJ DB Tools"
    recovery_window_in_days = 0 # Enable force deletion
    tags                    = var.aws_tags
}

resource "aws_secretsmanager_secret_version" "keycloak_rds" {
    secret_id     = aws_secretsmanager_secret.keycloak_rds.id
    secret_string = jsonencode(
    {
        "username" : var.keycloak_db_username,
        "password" : var.keycloak_db_password,
        "engine" : "postgres",
        "host" : aws_db_instance.keycloak_db.address,
        "port" : aws_db_instance.keycloak_db.port,
    })
}

resource "aws_secretsmanager_secret_policy" "keycloak_rds" {
    policy     = file("${path.module}/policies/secrets-manager-secret-access.json")
    secret_arn = aws_secretsmanager_secret.keycloak_rds.arn
}
