resource "aws_dynamodb_table" "todo_db" {
    name           = var.todo_db_table_name
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "partitionKey"
    range_key      = "sortKey"

    attribute {
        name = "partitionKey"
        type = "S"
    }

    attribute {
        name = "sortKey"
        type = "S"
    }

    tags = var.aws_tags
}
