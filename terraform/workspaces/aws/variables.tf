variable "aws_region" {
    description = "The AWS Region to create the services"
    type        = string
    default     = "eu-central-1"
}

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

variable "keypair_public_key" {
    description = "The public key to access the EC2 Instance"
    type        = string
    default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbPiHyfEuQ/QlGs5sarVyRGtrVUO3ol4uaQFCCsuDBaSjEoCTPce6oULSMA7X5ftXLJZVCaah3cQWm433ADM+rdxKXILz7iq/UOAMSos3b0ruFMts6BUJyVX3spDvI8xaWLZ4HzsHcobr3Qc21Ye5RZXmn6GL2B1Sz8lo2uRo+fKn2Uv1cjwEbBkO53Fv+d8380m/aIjLiY2ttgHtojJTFxbreHcZkczCx1GIX3XJtYdbjKVnp+eVEAa3FzcbO5tjAmicHHIrg+Rrj0KBFA6VDTSG0Wrksomm3+QFEjHiW4CrTTh9dSZH8Le6D74VPBCcQSemnGrL9mMvgLmOj8ngX9jASTwr6ttCtRwoanqLD9QNJxzlvmJAJJuP17Twf/h95SW3em+dHIK1qMSC80YA2LebeOI33LAGQWZLXUHIehbjkuQLG77gymjz58FOaCTtZbcdCXHnld+mIGIs0yRAPwReDbMtMK9DGlnIvGyFrjb20+jRbhHqW47aJcCY5ttk= noname"
}

variable "s3_webapp_bucket_name" {
    description = "The name of the S3 Bucket of the WebApp"
    type        = string
    default     = "todo-frontend.akse.hhn"
}

variable "keycloak_db_vendor" {
    description = "The vendor of the keycloak database (has the match the value keycloak expects)"
    type        = string
    default     = "postgres"
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

variable "keycloak_user" {
    description = "The username for the Keycloak Admin Account"
    type        = string
}

variable "keycloak_password" {
    description = "The password of the Keycloak Admin Account"
    type        = string
    sensitive   = true
}

variable "keycloak_realm" {
    description = "The Keycloak Realm of the Todo Application"
    type        = string
    default     = "todoapp"
}

variable "keycloak_client_id" {
    description = "The Keycloak Client ID for the Backend Service"
    type        = string
    default     = "todoservice"
}

variable "keycloak_client_secret" {
    description = "The Keycloak Client Secret for the Backend Service"
    type        = string
    sensitive   = true
}

variable "todo_service_port" {
    description = "The Port where the Todo-Service is listening"
    type        = number
    default     = 5903
}
