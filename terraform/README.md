# Terraform

There are three different Terraform projects within this project.

- [AWS Core](#aws-core) (`/aws-core`) - for infrastructure that not directly belongs to the project
- [AWS](#aws) (`/aws`) - the actual project infrastructure
- [Config](#config) (`/config`) - for configuring services

**You have to run all projects in order to set up the application**<br>
**The projects should run in order (AWS Core - AWS - Config)**

## AWS Core

AWS Core contains all infrastructure resources that - in a real project - would be placed on organization level.<br>
This includes things like `user groups`, `users` and the `container registry` (ECR).

The Terraform State of this project is placed locally in the source folder.

```shell
$ cd terrafrom/workspaces/aws-core

$ terrafrom plan
$ terrafrom apply
$ terrafrom destroy
```

## AWS

The AWS folder contains the infrastructure of the project.<br>
So everything from `CloudFront`, over `EC2` to `RDS` is managed here.

The Terraform State is stored remotely on GitLab.<br>
To learn more about the GitLab managed Terraform, see the [GitLab Documentation](https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html).

This projects has some variables that require values.<br>
**Please write down or remember these values!**<br>
If these values change, some parts of the infrastructure might have to be recreated. This can cause additional work!

| Variable                 | Description                                                     |
|--------------------------|-----------------------------------------------------------------|
| `keycloak_db_username`   | The username to authenticate at the Postgres Database           |
| `keycloak_db_password`   | The password to authenticate at the Postgres Database           |
| `keycloak_user`          | The username of the Keycloak admin account                      |
| `keycloak_password`      | The password of the Keycloak admin account                      |
| `keycloak_client_secret` | The client secret of the Keycloak Realm for the Backend-Service |

```shell
$ cd terrafrom/workspaces/aws

$ terrafrom plan
$ terrafrom apply
$ terrafrom destroy
```

## Config

The configuration-project is used to configure the launched services of the applications.

Before running terraform, choose the environment you want to configure.<br>
There are two already prepared environments:

- Local: `local.tfvars`
- AWS: `aws.tfvars` (**You need to update the file with your AWS DNS-Names before running terraform!**)

```terraform
keycloak_url               = "http://localhost:8080" // The URL where the Keycloak Server is running
keycloak_redirect_frontend = [
    "http://localhost:3000/*" // The URL where the Frontend Application is hosted. The URL has to end with "/*"
]
keycloak_root_url_frontend = "http://localhost:3000" // The URL where the Frontend Application is hosted
```

The Terraform State of this project is placed locally in the source folder.

```shell
$ cd terrafrom/workspaces/config

$ terrafrom plan -var-file="" # local.tfvars OR aws.tfvars
$ terrafrom apply -var-file="" # local.tfvars OR aws.tfvars
$ terrafrom destroy -var-file="" # local.tfvars OR aws.tfvars
```
