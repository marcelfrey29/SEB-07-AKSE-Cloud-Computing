# Todo-Service - Backend

The Todo-Service is the backend part of the Todo-Application.<br>
It is responsible for providing all business logic.<br>
The Backend provides REST-Endpoints for the [Frontend](../todo-frontend/README.md) Application.<br>
Requests need an `Authorization`-Header, because the JWT contains the user information.<br>
The identity of the user is then validated against [Keycloak](../keycloak/README.md).<br>
All Todo-Lists and Todos are stored in DynamoDB.

## Core Technologies

- Node.js **16** (never versions are not supported, e.g. Node 17 is not working)
- [Nest.js](https://github.com/nestjs/nest)
- Nest-Keycloak-Connect
- AWS SDK (DynamoDB, DynamoDB-Utils)

## Environment Variables

- Because the application is deployed as container, all environment variables have to passed to the container on startup

| Key                          | Description                                                                                                                                                                                                                          | Supported Values                                                                                 | Default |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|---------|
| `SERVER_ENVIRONMENT_SETTING` | The environment where the application is running.<br>Required to determine the correct user validation strategy.<br>See [Keycloak](../keycloak/README.md)                                                                            | `DEVELOPMENT`, `PRODUCTION` or ` `                                                               | ` `     |
| `SERVER_PORT`                | The port where Nest.js starts the server                                                                                                                                                                                             | `0` to `65535`                                                                                   | `4000`  |
| `KEYCLOAK_URL`               | The URL of the Keycloak-Server                                                                                                                                                                                                       | ` `                                                                                              | ` `     |
| `KEYCLOAK_REALM`             | The realm for the application                                                                                                                                                                                                        | ` `                                                                                              | ` `     |
| `KEYCLOAK_CLIENT_ID`         | The client ID of the application                                                                                                                                                                                                     | ` `                                                                                              | ` `     |
| `KEYCLOAK_CLIENT_SECRET`     | The client secret of the application                                                                                                                                                                                                 | ` `                                                                                              | ` `     |
| `KEYCLOAK_REALM_PUBLIC_KEY`  | The public key of the Keycloak realm<br>Required for local development<br>**Important: This value has to be empty on AWS (e.g. so that is interpreted as `undefined`)!** Otherwise the Online-Authentication-Strategy does not work! | ` `                                                                                              | ` `     |
| `DYNAMODB_REGION`            | The Region where the DynamoDB Table is located                                                                                                                                                                                       | An supported [AWS Region](https://aws.amazon.com/de/about-aws/global-infrastructure/regions_az/) | ` `     |
| `REGION`                     | The Region where the DynamoDB Table is located                                                                                                                                                                                       | An supported [AWS Region](https://aws.amazon.com/de/about-aws/global-infrastructure/regions_az/) | ` `     |
| `DYNAMODB_ENDPOINT`          | The DynamoDB Endpoint<br>Local: http://localhost:8000 <br>Local Docker: http://todo-db:8000 <br>AWS EU-Central-1: https://dynamodb.eu-central-1.amazonaws.com                                                                        | ` `                                                                                              | ` `     |
| `DYNAMODB_TABLE_NAME`        | The name of the DynamoDB table                                                                                                                                                                                                       | ` `                                                                                              | ` `     |
| `AWS_ACCESS_KEY_ID`          | The AWS Access Key ID<br> Only for local development, can be mocked                                                                                                                                                                  | ` `                                                                                              | ` `     |
| `AWS_SECRET_ACCESS_KEY`      | The AWS Access Key Secret<br> Only for local development, can be mocked                                                                                                                                                              | ` `                                                                                              | ` `     |

## REST Endpoints

| Endpoint                      | Public | Methods  | Description                                                                                |
|-------------------------------|--------|----------|--------------------------------------------------------------------------------------------|
| `/info`                       | ❌      | `GET`    | Get a status message<br>No app functionality                                               |
| `/lists`                      | ❌      | `GET`    | Get all Todo-Lists of the user                                                             |
| `/lists`                      | ❌      | `POST`   | Create a new Todo-List                                                                     |
| `/lists/:listid`              | ❌      | `DELETE` | Delete the Todo-List with the ID `listid`<br>This also deletes all Todos in that Todo-List |
| `/todos/:listid`              | ❌      | `GET`    | Get all Todos of the Todo-List with ID `listid`                                            |
| `/todos/:listid`              | ❌      | `POST`   | Create a new Todo in the Todo-List with ID `listid`                                        |
| `/todos/:listid/todo/:todoid` | ❌      | `PUT`    | Update the existing Todo with ID `todoid` in the Todo-List with ID `listid`                |
| `/todos/:listid/todo/:todoid` | ❌      | `DELETE` | Delete the existing Todo with ID `todoid` in the Todo-List with ID `listid`                |

## Local Development

- **Running the main `docker-compose.yml` file is enough to run and develop the backend** (_Recommended_)
    - No local Node.js installation is required
    - All dependencies are installed inside the container
    - All relevant files are automatically mounted into the container
    - The correct script runs automatically
- If you want to work outside of Docker, you can use following commands:
    - **If you run the app outside of Docker, you have to pass all required environment variables manually**
    - Also, make sure that all Ports are forwarded correctly

```bash
# Install dependencies
$ npm install

# Development
$ npm run start:dev
```

## Build for Production (AWS)

- The Backend-Service is deployed as container.
- **Building for production currently happens outside of Docker**
    - Node.js needs to be installed

```shell
# Install dependencies
$ npm install

# Build project
$ npm run build
```

- After building the backend, we need to build the Docker Image and push it to the Elastic Container Registry (ECR)
    - Replace `ACCOUNT_NUMBER` with the account number of your AWS Account

```shell
# Login to ECR with a temporary login
$ aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin ACCOUNT_NUMBER.dkr.ecr.eu-central-1.amazonaws.com

# Build Docker Image (Important: Use the Production Dockerfile!)
$ docker build -f Production.Dockerfile -t akse-todo-service .

# Tag Image
$ docker tag akse-todo-service:latest ACCOUNT_NUMBER.dkr.ecr.eu-central-1.amazonaws.com/akse-todo-service:latest

# Push the Image to ECR
$ docker push ACCOUNT_NUMBER.dkr.ecr.eu-central-1.amazonaws.com/akse-todo-service:latest
```
