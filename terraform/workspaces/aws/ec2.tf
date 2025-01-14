// TODO: After initial create and setup, an reboot is required to successfully register the instance as ECS Container Host.
//       The manual reboot is the only manual required step - everything else is fully automated!
//       The reboot can be performed via the AWS EC2 Management Console.
resource "aws_instance" "container_host" {
    ami                         = "ami-05d34d340fb1d89e5" // Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
    instance_type               = "t2.micro"
    subnet_id                   = aws_subnet.todo_app_public_subnet_a.id
    availability_zone           = "eu-central-1a"
    vpc_security_group_ids      = [aws_security_group.container_host.id]
    associate_public_ip_address = true
    iam_instance_profile        = aws_iam_instance_profile.container_host.name
    // Install the ECS Agent:
    // After creation, the user_data script is executed by cloud-init.
    // By that, the server is always setup and configured in the same way.
    user_data                   = templatefile("${path.module}/ec2-user-data/container_host.tftpl", {
        cluster_name = local.cluster_name
    })
    key_name                    = aws_key_pair.key.key_name

    root_block_device {
        volume_size           = 20
        delete_on_termination = true
        tags                  = var.aws_tags
    }

    depends_on = [
        aws_ecs_cluster.todo_app_cluster, // Required to make sure the ECS Agent registration works
        aws_iam_instance_profile.container_host
    ]

    // The name of the EC2 Instance can be set via Tag-Meta-Data
    tags = merge(var.aws_tags, {
        Name = "ECS-Container-Host"
    })
}

resource "aws_key_pair" "key" {
    key_name   = "EC2-Container-Host-Key-Pair"
    public_key = var.keypair_public_key
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

// SSH Ingress Rule
// INFO: This rule should only be enabled while working with SSH
resource "aws_security_group_rule" "ssh_ingress_rule" {
    description       = "Allow SSH access to the Instance"
    type              = "ingress"
    security_group_id = aws_security_group.container_host.id
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
    cidr_blocks       = [var.public_cidr_block]
}

// Keycloak Ingress Rule
resource "aws_security_group_rule" "container_host_ingres_keycloak" {
    description       = "Allow Connections to Keycloak"
    type              = "ingress"
    security_group_id = aws_security_group.container_host.id
    protocol          = "tcp"
    from_port         = var.keycloak_port
    to_port           = var.keycloak_port
    cidr_blocks       = [var.public_cidr_block]
}

// Backend Service Ingress Rule
resource "aws_security_group_rule" "container_host_ingres_backend_service" {
    description       = "Allow Connections to the Backend Service"
    type              = "ingress"
    security_group_id = aws_security_group.container_host.id
    protocol          = "tcp"
    from_port         = var.todo_service_port
    to_port           = var.todo_service_port
    cidr_blocks       = [var.public_cidr_block]
}

// IAM Role: A Role that Users and Services can assume.
// assume_role_policy contains the trust-relationship Policy-JSON.
//
// Container Host Role
// Ensure that EC2 Instances can assume Roles and that...
// ...ECS can interact with the container agent (done by the attached AWS-Managed Policy)
resource "aws_iam_role" "container_host" {
    name               = "Container-Host-Role"
    description        = "Permissions for the Container Host EC2 Instances"
    // Set Trust Relation: Allow EC2 to "assume role"
    assume_role_policy = file("${path.module}/policies/ec2-allow-assume-role.json")
    tags               = var.aws_tags
}

// Attach an AWS-Managed Policy to an IAM Role.
//
// Required to allow ECS to interact with the Container Agent on EC2.
// See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceForEC2Role" {
    role       = aws_iam_role.container_host.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

// Allow access to DynamoDB table
resource "aws_iam_role_policy" "container_host_dynamodb" {
    role   = aws_iam_role.container_host.id
    policy = templatefile("${path.module}/policies/ecs-task-backend-service-execution-role.tftpl", {
        dynamodb_table = aws_dynamodb_table.todo_db.arn
    })
}

// Required to pass an IAM Role to an EC2 Instance.
// See https://docs.aws.amazon.com/de_de/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
resource "aws_iam_instance_profile" "container_host" {
    name = "container-host-profile"
    role = aws_iam_role.container_host.name
    tags = var.aws_tags
}
