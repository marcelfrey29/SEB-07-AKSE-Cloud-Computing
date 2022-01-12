resource "aws_iam_group" "bots" {
    name = "Automation-Bots"
}

resource "aws_iam_group_policy" "bots" {
    name   = "Bot-Deployment-Permissions"
    group  = aws_iam_group.bots.name
    policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Sid      = "IAMAllowedPermissions"
                Action   = [
                    "iam:CreateRole",
                    "iam:GetRole",
                    "iam:DeleteRole",
                    "iam:GetRolePolicy",
                    "iam:AttachRolePolicy",
                    "iam:DetachRolePolicy",
                    "iam:DeleteRolePolicy",
                    "iam:ListRolePolicies",
                ]
                Effect   = "Allow"
                Resource = "*"
            },
            {
                Sid      = "AWSServicesAllowedPermissions"
                Action   = [
                    "cloudfront:*",
                    "dynamodb:*",
                    "ec2:*",
                    "ecr:*",
                    "ecs:*",
                    "s3:*",
                    "rds:*",
                    "secretsmanager:*"
                ]
                Effect   = "Allow"
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_group_membership" "bots" {
    name  = "Bot Group Membership"
    group = aws_iam_group.bots.name
    users = [
        aws_iam_user.gitlab_runner.name
    ]
}
