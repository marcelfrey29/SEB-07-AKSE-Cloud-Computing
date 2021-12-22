variable "aws_tags" {
    description = "A list of default tags for AWS Resources."
    type        = object({})
    default     = {
        "terraform" = "yes",
        "project"   = "aws-core-akse"
    }
}

