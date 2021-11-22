# Intermediate Presentations

## Architecture

TODO

## Technologies

Service                | Technologies         | Notes
---------------------- | -------------------- | -----------------------------
Common / Shared        | [Docker](https://www.docker.com/) <br> [Docker Compose](https://docs.docker.com/compose/) <br> [Shell Scrips]() for the setup guide | ---
&MediumSpace;          | &MediumSpace;        | &MediumSpace;
Keycloak Database      | [PostgreSQL](https://www.postgresql.org/) for persistence (users) | ---
Keycloak               | [Keycloak](https://www.keycloak.org/) <br>[Terraform](https://www.terraform.io/) to configure Keycloak <br> [Terraform Keycloak Provider](https://registry.terraform.io/providers/mrparkers/keycloak/latest) | ---
Frontend Application   | [Nuxt.js](https://nuxtjs.org/) as application framework for [Vue.js](https://vuejs.org/) <br> [Nuxt Auth](https://dev.auth.nuxtjs.org/) for authentication with Keycloak (with a few lines of configuration) <br> [Nuxt Axios](https://axios.nuxtjs.org/) integrates with Nuxt Auth (automatic headers) <br> [Vue Class Components](https://class-component.vuejs.org/) <br> [Vue Property Decorator](https://www.npmjs.com/package/vue-property-decorator?activeTab=versions) <br> [Bootstrap](https://getbootstrap.com/) <br> [Bootstrap Vue](https://bootstrap-vue.org/) for UI components <br> [Node.js](https://nodejs.org/en/) as runtime <br> [TypeScript](https://www.typescriptlang.org/) for types  | ---
Todo-Service Database  | [Amazon DynamoDB (NoSQL Database)](https://aws.amazon.com/dynamodb/) for persistence (lists and todos) <br> [DynamoDB Local](https://hub.docker.com/r/amazon/dynamodb-local) for local development | [DynamoDB Table Design](../03.DynamoDB-Modelling/README.md)
Todo-Service           | [Nest.js](https://nestjs.com/) as server-side application framework <br> [Nest Config](https://docs.nestjs.com/techniques/configuration) for configuration (uses `.env` files, `ConfigService` can be injected) <br> [Nest Keycloak Connect](https://www.npmjs.com/package/nest-keycloak-connect) for easy Keycloak integration <br> [AWS SDK (DynamoDB Client)](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-dynamodb/index.html) to communicate with DynamoDB <br> [AWS SDK (DynamoDB Utils)](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/modules/_aws_sdk_util_dynamodb.html) for marshalling and unmarshalling of data <br> [Node.js](https://nodejs.org/en/) as runtime <br> [TypeScript](https://www.typescriptlang.org/) for types | ---

## Known Issues

- The Backend Service doesn't work inside the docker network
    - Details: See Issue
    - Workaround: Start the service outside of docker (DynamoDB needs to be reachable outside the network, required port mapping)
    - [GitLab Issue #5](https://git.it.hs-heilbronn.de/it/courses/seb/cc1/ws21/paris/-/issues/5)
- Lists can't be edited or deleted
    - Details: Not yet implemented / Not the focus of this course
    - Workaround: None
    - [GitLab Issue #6](https://git.it.hs-heilbronn.de/it/courses/seb/cc1/ws21/paris/-/issues/6), [GitLab Issue #7](https://git.it.hs-heilbronn.de/it/courses/seb/cc1/ws21/paris/-/issues/7)
- Editing a closed todo marks the todo as not done
    - Details: If a
    - Workaround: Close the todo again
    - [GitLab Issue #8](https://git.it.hs-heilbronn.de/it/courses/seb/cc1/ws21/paris/-/issues/8)

## Next Steps

- Properly set up a CI/CD Pipeline
    - Use GitLab Runners
- Use AWS Services and Deploy to AWS
    - Declare infrastructure with Terraform
    - Use Managed Services (RDS, DynamoDB, S3, EC2 with ECS and ECR)
