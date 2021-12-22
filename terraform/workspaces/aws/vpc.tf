// VPC for the App (Isolated network)
// /24 = 2^8 = 256 Addresses
resource "aws_vpc" "todo_app_vpc" {
    cidr_block           = var.vpc_cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags                 = var.aws_tags
}

// Allow communication between VPC and the public internet
resource "aws_internet_gateway" "todo_app_internet_gateway" {
    vpc_id = aws_vpc.todo_app_vpc.id
    tags   = var.aws_tags
}

// Public Subnet A
// /25 = 2^7 = 128 Addresses (10.0.0.0 to 10.0.0.127)
// The next would be 10.0.0.128/25 (10.0.0.128 to 10.0.0.255)
resource "aws_subnet" "todo_app_public_subnet_a" {
    vpc_id            = aws_vpc.todo_app_vpc.id
    cidr_block        = "10.0.0.0/25"
    availability_zone = "eu-central-1a"
    tags              = var.aws_tags
}

// Public Subnet B
// /25 = 2^7 = 128 Addresses
// Start at 10.0.0.128/25 (10.0.0.128 to 10.0.0.255)
resource "aws_subnet" "todo_app_public_subnet_b" {
    vpc_id            = aws_vpc.todo_app_vpc.id
    cidr_block        = "10.0.0.128/25"
    availability_zone = "eu-central-1b"
    tags              = var.aws_tags
}

// Routing table for the public subnet
resource "aws_route_table" "todo_app_public_routes" {
    vpc_id = aws_vpc.todo_app_vpc.id

    // Allow all outgoing traffic
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.todo_app_internet_gateway.id
    }

    tags = var.aws_tags
}

// Associate the route table with a subnet
resource "aws_route_table_association" "todo_app_public_routing_association" {
    subnet_id      = aws_subnet.todo_app_public_subnet_a.id
    route_table_id = aws_route_table.todo_app_public_routes.id
}
