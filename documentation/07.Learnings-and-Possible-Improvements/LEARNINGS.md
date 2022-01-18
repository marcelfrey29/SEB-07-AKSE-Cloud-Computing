# Learnings

This document describes some of my learnings.

## S3 Static Website Hosting - MIME Types and Terraform

At the beginning, I used the S3 Static Website Feature to host the Frontend-Application. The static assets have been uploaded to the S3 Bucket via Terraform.

When accessing the site, I expected the browser to render the website. Instead, the browser offered to download the `index.html` file. The reason for this behaviour was, that the `index.html` file had the wrong MIME-Type. A `.html` file should have the MIME-Type `text/html`, but the MIME-Type was `binary/ocet-stream`.

To solve this problem, I explicitly had to tell Terraform the MIME-Type for each file. I had to set the `content_type` to the correct MIME-Type for each `aws_s3_bucket_object`. The MIME-Type is set based on the file extension.

```terraform
resource "aws_s3_bucket_object" "files" {
    for_each     = fileset("${path.module}/../../../todo-frontend/dist/", "**")
    bucket       = aws_s3_bucket.todo-frontend.bucket
    key          = each.value
    source       = "${path.module}/../../../todo-frontend/dist/${each.value}"
    etag         = filemd5("${path.module}/../../../todo-frontend/dist/${each.value}")
    content_type = lookup(local.mime_types, try(regex("\\.[^.]+$", each.value), "DEFAULT_VALUE"), "text/plain")
}

locals {
    mime_types = {
        ".html" : "text/html",
        ".css" : "text/css",
        ".js" : "text/javascript",
        ".ico" : "image/vnd.microsoft.icon",
        ".jpg" : "image/jpeg",
        ".jpeg" : "image/jpeg",
        ".json" : "application/json"
        "DEFAULT_VALUE" : "text/plain"
    }
}
```

-----

## Nuxt Auth requires HTTPS

Clicking the "Sign in" button on the website hosted via S3 caused a `window.crypto` error and there was no redirect to Keycloak. In the beginning this error makes absolutely no sense for me. I mean, I told Nuxt to do a redirect, and then it throws a `crypto` error?!

Well, it turns out that the Nuxt Auth Module ensures the website is running on HTTPS before redirecting the user to Keycloak. Nuxt uses the `crypto` API which is `undefined` on http according to this [Stackoverflow Answer](https://stackoverflow.com/a/46468377).

To fix this issue, the website needs to be served via HTTPS. To add HTTPS support, I decided to distribute the website via CloudFront (which comes with a default HTTPS certificate).

-----

## CloudFront and Single Page Applications

After adding CloudFront, the redirect to Keycloak worked fine, but the redirect from Keycloak back to the Frontend-Application does not work.

Keycloak redirects users to the `/login` route, where the Frontend then handles the login. The problem is that there is no folder or file called `login` in S3, so CloudFront returned an 404 error.

When searching for a solution, I leaned that Single Page Applications need a special CloudFront configuration in order to work. Single Page Apps only have one page called `index.html`. The actual "Pages" are realized by manipulation the DOM with JavaScript. So because there are no actual files or folders, CloudFront can't find them. This means that deep links and redirects don't work by default with CloudFront.

The solution is to do all the error handling entirely in the Single Page Application. CloudFront is configured in a way, that it always returns the `index.html` file. This can be done by defining "custom error handlers". If CloudFront has a 404 error, we tell CloudFront to return the `index.html` file with the HTTP Status Code `200`. The actual URL (with deep link and/or redirects) stays unchanged and can be processed by the Single Page Application.

```
custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
}
```

CloudFront (or S3) returned a 403 error too. I have no idea why, but I fixed it by adding a second custom error handler.

```
custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
}
```

-----

## DB Subnet Requirements

While trying to create the RDS Database and the Database Subnet with Terraform, it turned out that the Database Subnet needs to be places in at least two different subnets which are located in at least two different Availability Zones. Before I was able to create the RDS Database, I had to create a second subnet.

-----

## AWS Networking: VPCs, Subnets, Internet Gateways and Routing

Configuring the AWS Networking was challenging. For a successful configuration it's mandatory to understand how networking on AWS works.

A VPC is tied to a Region, but spans over different Availability Zones. A Subnet belongs to exactly one Availability Zone.

I tried connecting to my RDS Database from my local machine, but it didn't work - although I was able to connect to my EC2 Instance in the same network (Spoiler: Not in the same subnet 😅).

After analyzing the network configuration (for hours) I found the problem:
The EC2 Instance was placed in Availability Zone `eu-central-1a`. The Subnet in this Availability Zone (`eu-central-1a`) was connected to an Internet Gateway which allowed internet access. In the [DB Subnet Requirement Section](#db-subnet-requirements) we learned that the DB Subnet requires two subnets in two different Availability Zones. So, I created a second Subnet in the `eu-central-1b` Availability Zone. The RDS Database Instance then launched in the `eu-central-1b` Availability Zone (AWS automatically selected an Availability Zone for the DB Instance). By that, the Instance launched into the `eu-central-1b` subnet. When analyzing the Subnets and Route Table, I recognized that only the `eu-central-1a` subnet is attached to an Internet Gateway, while `eu-central-1b` is not. It turned out that I forgot to add the `aws_route_table_association` for the second subnet.

Following Terraform Code fixed the connectivity issue:

```
resource "aws_route_table_association" "todo_app_public_routing_b_association" {
    subnet_id      = aws_subnet.todo_app_public_subnet_b.id
    route_table_id = aws_route_table.todo_app_public_routes.id
}
```

Next time if I have an identical issue, I will immediately check in which subnet the instance is launched and whether or not this subnet is a public subnet.

-----

## CloudInit and ECS Cluster Registration

After setting up a new EC2 Instance with CloudInit, it does not automatically register at the ECS Cluster. A restart of the EC2 instance fixed this problem.

-----

## ECS Port Mappings: Deployments and Scaling

Containers of the ECS Cluster are mapping their ports to the EC2 Instance.

If we want to connect to a container, we need to define the port. Because a service is tied to the EC2-DNS-Name and port, we can't easily scale up.

In addition, this causes problems when deploying a new version of the container. ECS by default tries to do a zero-downtime-deployment. This means that ECS tries to launch a new container before stopping the running one. Because the new container is deployed with the same configuration, it uses the same port. But, that port is already in use - it belongs to the already running container instance.

Here, ECS got stuck. The deployment of the new container failed.

Fo fix this issue, I had to adjust the deployment-health-configuration. This is done by setting the two values `deployment_minimum_healthy_percent` and `deployment_maximum_percent`. With `deployment_minimum_healthy_percent = 0` (0% of the `desired_count` which is `1`) we tell ECS that it's ok if there is no container running while deploying a new version. But, the second parameter is required too. `deployment_maximum_percent` defines the maximum amount of containers that are running while a deployment. Setting `deployment_maximum_percent` to `100` (100% of the `desired_count` which is `1`) tells ECS that there is only one running container allowed while the deployment. This forces ECS to first stop the running container and then launching the new one. By that, the port is getting free for the new container and the deployment succeeds.

```
resource "aws_ecs_service" "backend_service" {
    desired_count                      = 1
    deployment_minimum_healthy_percent = 0
    deployment_maximum_percent         = 100
}
```

A better solution is to use a [Load Balancer](IMPROVEMENTS.md#load-balancing-for-ecs-containers).

-----

## Secrets on AWS and GitLab

What can go wrong when storing secrets? Quite a bit.

On AWS, I store secrets in the AWS Secrets Manager so that they are not stored in plain text. To store the secrets, I used Terraform of course. It turns out that just passing the secret-string to Terraform can cause problems. Especially some characters like `\ ` and other special symbols. I'm not 100% sure what exactly happens, but the secret I passed to Terraform didn't work anymore. A secret with only alphanumeric characters worked fine. So it looks like there is something wrong with special characters - or I used Terraform incorrectly for this use case.

Another problem is the CI/CD Pipeline. The pipeline needs to know the secret values. Now, the GitLab CI has environment variables for this use case - so there are no sensitive values stored in the code. But, secrets can be exposed in the Runner-Log which is a security problem. This problem has been addressed by GitLab too. There is the option to mask secrets in the runner log. Instead of the secret value, the log says `[MASKED]`. This options has to be enabled per variable.

It turns out that not all secrets can be masked by GitLab. These secrets can be exposed in the Runner Log! When working with secrets, we should ensure that the secrets are "compatible" with the CI System to increase the security.

-----

## Terraform State, GitLab CI/CD and Multiple Branches

The Terraform State is stored in GitLab. There is only one environment at the moment - so there's only one Terraform State.

The CI/CD Pipeline is currently running for every change in every branch. Note: The actual deployment has to be triggered manually.

Here is the Problem: If Infrastructure is changed in a branch "A", Terraform plans (and applies) these changes. Now, if another branch is "behind" "A", the infrastructure changes are not included. The Pipeline will still run on a push. This will destroy parts of the Infrastructure because the "some Terraform code is not there anymore".

As a solution we could limit the Terraform Steps to the `main` branch. Typically, there are multiple different environments, so this can't be the final solution.

This is a problem that should be kept in mind when designing a CI/CD Pipeline!

-----

## Loose Coupling and Infrastructure as Code: ECR, ECS and Keycloak

Loosely Coupling Infrastructure is not easy.

Examples:

- The Elastic Container Registry can't be part of the main project, because we have to push an image before we can deploy the ECS Services and Tasks.
- The Keycloak configuration is currently places in a separate project, which depends on values from the main project.

Note: I haven't tried to apply the whole configuration at once. So there might be some conflicts/dependencies that are currently unknown. While development, I applied the infrastructure in incremental steps.

-----

## Localhost

Localhost is special.

For local development, localhost makes a lot of exceptions. This is great for local development, but it violates against the Dev/Prod Parity Principle in DevOps. While it makes local development easier, faster and less complex, it hides a lot of problems that will definitely occur at a later point in time making all saved time obsolete, e.g. when deploying to production.

Examples:

- [Nuxt Auth requires HTTPS](#nuxt-auth-requires-https) - not on localhost
- [HTTP and HTTPS](#http--https---mixed-content) - localhost is always fine - even on HTTP

In addition, localhost is super challenging with Docker, because localhost is not always localhost. Localhost on the machine is different from localhost in a container (obviously). This causes problems that are specific tied to local development, like the [Keycloak ISS mismatch](#keycloak-iss-mismatch). When working with Domain-Names (like the EC2-DNS-Name) this problem is not present.

-----

## HTTP & HTTPS - Mixed Content

Browsers don't like Mixed-Content. Mixed-Content is the combination of HTTP and HTTPS requests on the same site.

Our site is served with HTTPS (via CloudFront) but accesses Keycloak and the Backend-Service via HTTP. By default, all HTTP Requests are blocked for Security Reasons.

Firefox and Chrome (both on Desktop) allow us to temporarily disable this protection (See [How to disable Mixed-Content](../04.AWS-Setup#13-disable-mixed-content)). Safari does not allow to disable that option. So Safari on macOS, iOS and iPadOS don't work and can't use our Todo-Application.

**It's good that Mixed-Content is blocked by default** - but I'm happy that I still have an option to demonstrate by Application which is hosted on AWS. **For a real Application, HTTPS is a must-have!**

-----

## Keycloak ISS mismatch

At the [Intermediate Presentation](../05.Intermediate-Presentation/README.md) I had an issue, where the Backend-Service can't run inside the Docker Network. The reason was that the Backend-Service can't validate the Authentication Header of the Request.

```
[Nest] 67  - 11/11/2021, 8:00:27 PM    WARN [Keycloak] Cannot validate access token: Error: Grant validation failed. Reason: invalid token (wrong ISS)
```

The ISS field contains the URL where the token has been issued. The problem is that the Frontend-Application and the Backend-Service use different URLs to connect to Keycloak. The Frontend-Application (on `http://localhost:3000`) redirects the user to Keycloak at `http://localhost:8080`. Because the user signs in at Keycloak, the ISS field contains the value `http://localhost:8080`. Back at the Frontend-Application, the users makes an API call to the Backend at `http://localhost:4000`. Now, the Backend has to validate the Token and wants to talk to Keycloak. The only way to connect to Keycloak in this setup is to use the container DNS name. So the Backend-Service talks to Keycloak via `http://keycloak:8080`.

And that's the cause for the mismatch: `http://keycloak:8080` is not equal to `http://localhost:8080`.

I found out that there are different token validation strategies. By default, the `ONLINE` strategy is used which loads the Realm Public Key from Keycloak. There is also an `OFFLINE` strategy which requires no communication with Keycloak. Instead, we have to pass the Public Key as an environment variable to the Backend-Service. Then, the entire validation is done by the Backend-Service. Because we don't connect to Keycloak, we don't have to pass "the real" Keycloak URL. Instead, we pass in the value where we "expect" Keycloak to be available - in our case `http://localhost:8080`. This makes everything work and the Backend-Service can be run inside the Docker Network too - like all other services.

_I think that there is no other way to make everything work locally._

There's one important Thing to note:<br>
If there is a value present for the public key, Keycloak validates the token against that that value - so it uses the `OFFLINE` strategy even if we want the `ONLINE` strategy!

Here is that snipped from the Keycloak-Connect-Library Code that causes this behavior:

```
// if public key has been supplied use it to validate token
if (this.publicKey) {
    try {
        // ...
    } catch (err) {
        // ...
    }
} 
```

My first implementation ensured that environment variables are never `undefined`. I archived this by using the `??` operator and assigned a default value if no value has been passed. Here is my first implementation:

```
realmPublicKey: configService.get<string>('KEYCLOAK_REALM_PUBLIC_KEY') ?? 'NO_REALM_PUBLIC_KEY_PROVIDED',
```

Because of the default value, the Backend-Service always used the `OFFLINE` strategy which causes a failure on AWS. For AWS, we want to have the `ONLINE` strategy - we don't pass a public key!
So to make everything work, the implementation has to be changed so that the public key is `undefined` if no value is passed.

```
realmPublicKey: configService.get<string>('KEYCLOAK_REALM_PUBLIC_KEY',),
```

Only with the `undefined` public key, the `if (this.publicKey)` condition from the Keycloak-Connect-Library evaluates to `false`. Then, the `ONLINE` strategy is used.
