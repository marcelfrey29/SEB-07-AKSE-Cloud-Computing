variable "aws_tags" {
    description = "AWS Tags for the AKSE Project"
    type        = map(string)
    default     = {
        "terraform" = "yes"
        "project"   = "aws-akse-todo-app"
    }
}

variable "vpc_cidr_block" {
    description = "The CIDR Block for the VPC"
    type        = string
    default     = "10.0.0.0/24"
}

variable "public_cidr_block" {
    description = "The CIDR Block 0.0.0.0/0"
    type        = string
    default     = "0.0.0.0/0"
}

variable "s3_webapp_bucket_name" {
    description = "The name of the S3 Bucket of the WebApp"
    type        = string
    default     = "todo-frontend.akse.hhn"
}

variable "keycloak_db_username" {
    description = "The username to access the database"
    type        = string
}

variable "keycloak_db_password" {
    description = "The password to access the database"
    type        = string
    sensitive   = true
}

variable "keycloak_db_database_name" {
    description = "The name of the database to create by default"
    type        = string
    default     = "keycloak"
}

variable "keycloak_db_port" {
    description = "The port where the keycloak db accepts connections"
    type        = number
    default     = 5901
}

variable "todo_db_table_name" {
    description = "The name of the DynamoDB Table"
    type        = string
    default     = "Todos"
}

variable "keycloak_port" {
    description = "The port where Keycloak is listening"
    type        = number
    default     = 5902
}

variable "todo_service_port" {
    description = "The Port where the Todo-Service is listening"
    type        = number
    default     = 5903
}
