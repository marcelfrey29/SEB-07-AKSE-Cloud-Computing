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
                    "iam:ListRoles",
                    "iam:GetRole",
                    "iam:CreateRole",
                    "iam:UpdateRole",
                    "iam:DeleteRole",
                    "iam:PassRole",
                    "iam:ListRolePolicies",
                    "iam:GetRolePolicy",
                    "iam:DeleteRolePolicy",
                    "iam:AttachRolePolicy",
                    "iam:DetachRolePolicy",
                    "iam:PutRolePolicy",
                    "iam:UpdateRoleDescription",
                    "iam:UpdateAssumeRolePolicy",
                    "iam:ListAttachedRolePolicies",
                    "iam:ListInstanceProfiles",
                    "iam:GetInstanceProfile",
                    "iam:CreateInstanceProfile",
                    "iam:DeleteInstanceProfile",
                    "iam:ListInstanceProfilesForRole",
                    "iam:AddRoleToInstanceProfile",
                    "iam:RemoveRoleFromInstanceProfile"
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
