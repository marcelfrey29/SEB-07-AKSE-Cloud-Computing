// Database Subnet based on our VPC
resource "aws_db_subnet_group" "keycloak_db_subnet" {
    name       = "keycloak-db-subnet"
    subnet_ids = [aws_subnet.todo_app_public_subnet.id]
    tags       = var.aws_tags
}

// Database
resource "aws_db_instance" "keycloak_db" {
    identifier             = "akse-todo-app-keycloak-db"
    instance_class         = "db.t2.micro" # db.t3.micro
    allocated_storage      = 10
    engine                 = "postgres"
    engine_version         = "12" # 13.1
    username               = var.keycloak_db_username
    password               = var.keycloak_db_password
    name                   = var.keycloak_db_database_name # Create a database after the DB-Instance is created
    publicly_accessible    = true
    port                   = var.keycloak_db_port
    //    parameter_group_name = aws_db_parameter_group.keycloak_db_parameters.name
    db_subnet_group_name   = aws_db_subnet_group.keycloak_db_subnet.name
    vpc_security_group_ids = [aws_security_group.keycloak_db_sg.id]
    skip_final_snapshot    = true # Don't keep a snapshot on deletion
    tags                   = var.aws_tags
}

// Parameters to configure the DB Engine
// See https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.Parameters
// Not required, but good to know ;)
//resource "aws_db_parameter_group" "keycloak_db_parameters" {
//    name   = "Keycloak DB"
//    family = "postgres12" # postgres13
//
//    parameter {
//        name  = ""
//        value = ""
//    }
//
//    tags = var.aws_tags
//}

// Security Group (Firewall) for the RDS Host (the underlying EC2 instance)
resource "aws_security_group" "keycloak_db_sg" {
    vpc_id = aws_vpc.todo_app_vpc.id

    // Allow incoming traffic only on the db port
    ingress {
        protocol  = "tcp"
        from_port = var.keycloak_db_port
        to_port   = var.keycloak_db_port
    }

    // Allow all outgoing traffic
    egress {
        protocol  = "tcp"
        from_port = 0
        to_port   = 65535
    }

    tags = var.aws_tags
}
