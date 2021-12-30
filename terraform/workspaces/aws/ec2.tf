resource "aws_instance" "container_host" {
    ami                    = "ami-05d34d340fb1d89e5" # Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.todo_app_public_subnet_a.id
    availability_zone      = "eu-central-1a"
    vpc_security_group_ids = [aws_security_group.container_host.id]
    iam_instance_profile   = aws_iam_instance_profile.container_host.name
    # Install the ECS Agent
    user_data              = templatefile("${path.module}/ec2-user-data/container_host.tftpl", {
        cluster_name = local.cluster_name
    })

    root_block_device {
        volume_size           = 20
        delete_on_termination = true
        tags                  = var.aws_tags
    }

    depends_on = [
        aws_ecs_cluster.todo_app_cluster, # Make sure the ECS Agent registration works
        aws_iam_instance_profile.container_host
    ]
    tags       = var.aws_tags
}

// Security Group (Firewall) for the EC2 Container Hosts
resource "aws_security_group" "container_host" {
    name        = "ECS Container Host Security Group"
    description = "Container Networking"
    vpc_id      = aws_vpc.todo_app_vpc.id
    tags        = var.aws_tags
}

// Allow all outgoing traffic
resource "aws_security_group_rule" "container_host_egress_allow_all" {
    description       = "Allow all outgoing traffic"
    type              = "egress"
    security_group_id = aws_security_group.container_host.id
    protocol          = "tcp"
    from_port         = 0
    to_port           = 65535
    cidr_blocks       = [var.public_cidr_block]
}

// Keycloak Ingres Rule
resource "aws_security_group_rule" "container_host_ingres_keycloak" {
    description       = "Allow Connections to Keycloak"
    type              = "ingress"
    security_group_id = aws_security_group.container_host.id
    protocol          = "tcp"
    from_port         = var.keycloak_port
    to_port           = var.keycloak_port
    cidr_blocks       = [var.public_cidr_block]
}

// Backend Service Ingres Rule
resource "aws_security_group_rule" "container_host_ingres_backend_service" {
    description       = "Allow Connections to the Backend Service"
    type              = "ingress"
    security_group_id = aws_security_group.container_host.id
    protocol          = "tcp"
    from_port         = var.todo_service_port
    to_port           = var.todo_service_port
    cidr_blocks       = [var.public_cidr_block]
}

// IAM Role: A Role that Users and Services can Assume
// assume_role_policy contains the Policy-JSON
//
// Container Host Role
// Ensure that EC2 Instances can assume Roles and that
// ECS can interact with the container agent (done by the attached AWS-Managed Policy)
resource "aws_iam_role" "container_host" {
    name               = "Container-Host-Role"
    description        = "Permissions for the Container Host EC2 Instances"
    assume_role_policy = file("${path.module}/policies/allow-assume-role.json")
    tags               = var.aws_tags
}

// Attach an AWS-Managed Policy to an IAM Role
//
// Required to allow ECS to interact with the Container Agent on EC2
// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceForEC2Role" {
    role       = aws_iam_role.container_host.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

// Required to pass an IAM Role to an EC2 Instance
// See https://docs.aws.amazon.com/de_de/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
resource "aws_iam_instance_profile" "container_host" {
    name = "container-host-profile"
    role = aws_iam_role.container_host.name
    tags = var.aws_tags
}
