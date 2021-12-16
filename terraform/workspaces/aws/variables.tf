variable "aws_tags" {
    description = "AWS Tags for the AKSE Project"
    type        = map(string)
    default     = {
        "terraform" = "yes"
        "project"   = "aws-akse-todo-app"
    }
}

variable "s3_webapp_bucket_name" {
    description = "The name of the S3 Bucket of the WebApp"
    type        = string
    default     = "todo-frontend.akse.hhn"
}
