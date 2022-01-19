# Local Setup

This Guide will explain how to set up a local version of the Todo-Application.

For an interactive setup process, you can run the interactive setup script (`/setup/setup.sh`).

```shell
# From the project root, navigate to the setup directory
$ cd setup/

# Run the setup script
$ ./setup.sh
```

-----

**If you have problems or need help, please contact me!**

-----

## 1. Required Tools

Following Tools are required to set up and run the application:

- Docker and Docker Compose (to run the containers)
- Terraform (to configure Keycloak)
- AWS CLI (to create the DynamoDB Table)

## 2. Required Ports

The application requires multiple ports to be available on the host. Make sure no other applications are running on these ports.

- `8080` Keycloak
- `4000` Todo-Service
- `3000` Frontend
- _`8000` DynamoDB (**For details see below**)_

**Details about Port `8000` and DynamoDB**:<br>
The application itself does not require a port-mapping of port `8000`. The Backend-Service accesses DynamoDB via the internal Docker Network by talking to `http://todo-db`. We need this port-mapping only for the setup process. By default, there is no Table created. Before we can run our application, we have to create a Table manually. Creating the Table is done via the AWS CLI from our local machine. In order to access DynamoDB we need this port-mapping. After creating the Table, you can disable this port-mapping.<br>
Note: Creating the Table is described in a later step in this guide.

## 3. Docker-Compose: Environment Variables

To run the application, we use the `docker-compose.yml` file in the project root. When you look at the file, you notice that there are a lot of environment variables.

When running `docker-compose up`, Docker automatically looks for a file called `.env` and injects the values defined in this file. In our project there is no `.env` file in the project root (yet). The reason is, that this file is excluded from Git because is contains sensitive values.

The first step is to create a `.env` file in the project root and define all required values. To make the setup easier, there is a template file where all environment variables and some values are already defined. This file is called `.env.TEMPLATE` and is located in the project root.

- Create a copy of the `.env.TEMPLATE` file
- Make sure the name of the copy is `.env`
- Open the newly created `.env` file
    - And add values for following keys - You have to choose usernames and passwords
        - `KEYCLOAK_DB_USER_NAME`
        - `KEYCLOAK_DB_USER_PASSWORD`
        - `KEYCLOAK_USER`
        - `KEYCLOAK_PASSWORD`
    - Leave following keys **empty** for now
        - `KEYCLOAK_REALM`
        - `KEYCLOAK_CLIENT_ID`
        - `KEYCLOAK_CLIENT_SECRET`
        - `KEYCLOAK_REALM_PUBLIC_KEY`

## 4. Frontend: Environment Variables

Because the Frontend-Application is deployed by uploading static files to S3, the environment variables have to be injected on build-time. For more details see the [Frontend Documentation](../../todo-frontend/README.md#environment-variables). To archive the highest dev/prod parity as possible, there are no variables injected via the `docker-compose.yml` file. The frontend application completely relies on its own environment variable file.

In the frontend project (`/todo-frontend`) there is a template file (`TEMPLATE.env`). For local development, the file `dev.env` is used. For AWS, the file `production.env` is used.

Choosing the correct file is done by the npm build scripts. Building for production is done with `npm run generate:prod`, while for local development we use `npm run start:dev`. **Note: You don't need to run any of these commands here.** When using `docker-compose` the correct script runs automatically.

**Because there are no sensitive values, all fields in the `dev.env` are defined. You don't have to change anything here.**

## 5. Initial `docker-compose up`

Now it's time to run `docker compose up --build -d` for the first time.

Open a new terminal window and run following command:

```shell
# In the project root, start the Docker-Compose stack
$ docker compose up --build -d
```

**Building and running all services for the first time can take a few minutes! Time to get some coffee ☕️ 😀**

- http://localhost:3000 : Frontend - You should see the "Marketing Page"
- http://localhost:4000 : Backend - You should see a 404 response from the Backend
- http://localhost:8080 : Keycloak - You should be able to open the "Administration Console". Login with the values you defined in [Step 3](#3-docker-compose-environment-variables)
    - `KEYCLOAK_USER` and `KEYCLOAK_PASSWORD`

Wait until all services are up and running.

## 6. Configure Keycloak with Terraform

Currently, Keycloak only has its "default" realm with the Admin-User you set up earlier. For our application we need a new realm. In this realm we have to define client applications.

The entire configuration has already been defined in Terraform Code. So we only have to apply the configuration.

For the local version, most of the required variables are defined in the `local.tfvars` file. In addition to passing this file, you need to set two additional variables:

- `keycloak_username`: Use the value of `KEYCLOAK_USER` from [Step 3](#3-docker-compose-environment-variables)
- `keycloak_password`: Use the value of `KEYCLOAK_PASSWORD` from [Step 3](#3-docker-compose-environment-variables)

The Terraform Keycloak Provider needs these credentials to authenticate at the Keycloak REST-API.

```shell
# From the project root, navigate to the Terraform Configuration directory
$ cd terraform/workspaces/config

# Initialize Terraform
$ terraform init

# Plan
$ terraform plan -var-file="local.tfvars" # then enter the KEYCLOAK_USER and KEYCLOAK_PASSWORD values

# Apply the configuration
$ terraform apply -var-file="local.tfvars" # then enter the KEYCLOAK_USER and KEYCLOAK_PASSWORD values
```

## 7. Get Keycloak Values and add them to the Environment Variable file

After Keycloak is configured, we can retrieve some values from and add them to the `.env` file.

- Open http://localhost:8080/auth/admin/master/console/#/realms/todoapp and sign in with `KEYCLOAK_USER` and `KEYCLOAK_PASSWORD` from [Step 3](#3-docker-compose-environment-variables) if required
- Copy the value from the `Name` field and paste it for `KEYCLOAK_REALM` in the `.env` file
- In the left navigation bar, choose "Clients"
- You should now see a list of all clients. Click on the "todoservice" client.
- Copy the value from the `Client ID` field and paste it for `KEYCLOAK_CLIENT_ID` in the `.env` file
- On the top, select the _Credentials_ Tab.
- Click the "Regenerate Secret" button and copy the generated secret. Then, paste the secret for `KEYCLOAK_CLIENT_SECRET` in the `.env` file
- In the left navigation bar, choose "Realm Settings"
- On the top, select the _Keys_ tab. You should see a table now.
- Identify the row where the "Provider" is `rsa-generated`.
- In this row, click the "Public Key" button. A Popup should show up.
- Copy the value from the popup and paste it for `KEYCLOAK_REALM_PUBLIC_KEY` in the `.env` file

Now, all environment variables in the `.env` file should have a value assigned.

**Important Notes**:<br>

- Make sure you don't add comments (`#`) to lines where values are defined! These comments will be passed alongside the value (which is not what we want)
    - There is a reason why I am adding this note... 😅
- Make sure there are no spaces between the `=` and the value.
    - Wrong: `KEYCLOAK_REALM_PUBLIC_KEY= MII...`, Right`KEYCLOAK_REALM_PUBLIC_KEY=MII...`
    - Again, there is a reason why I am adding this note... Identifying this problem wasted hours... 😭

## 8. Configure the AWS CLI

To configure DynamoDB-Local we need the AWS CLI.

**Skip this step if you have already configured the AWS CLI.**

**For DynamoDB-Local the credentials don't need to be real, but have to be set!**
The `AWS Key ID` and `AWS Secret Access Key` can be set to `DEMO`. For region use `eu-central-1`.

```shell
# To configure the AWS CLI run following command:
$ aws configure
```

## 9. Setup DynamoDB

In this step, we create the DynamoDB Table for the Backend-Service.

Run following commands to create the table and verify that is has been created:

**If your terminal get stuck after the next step, press `q`**

```shell
# List all tables (should return no tables)
$ aws dynamodb list-tables --endpoint-url http://localhost:8000

# Create the Table
$ aws dynamodb create-table --table-name Todos \
      --attribute-definitions \
          AttributeName=partitionKey,AttributeType=S \
          AttributeName=sortKey,AttributeType=S \
      --key-schema \
          AttributeName=partitionKey,KeyType=HASH \
          AttributeName=sortKey,KeyType=RANGE \
      --provisioned-throughput \
              ReadCapacityUnits=10,WriteCapacityUnits=5 \
      --endpoint-url http://localhost:8000

# List all tables (should return the Todos table)
$ aws dynamodb list-tables --endpoint-url http://localhost:8000
```

## 10. Restart the Application

Rebuild and restart all services: Run `docker compose up --build -d` from the **project root**.

In your other terminal window, run following command:

```shell
# In the project root, start the Docker-Compose stack
$ docker compose up --build -d
```

**Wait until all services are up and running again.**

- http://localhost:3000
- http://localhost:4000
- http://localhost:8080

## 11. Enable User Registration in Keycloak

By default, "User Registration" is disabled for the Todo-Realm in Keycloak. Before we can use the application, we have to enable it.

- Open http://localhost:8080/auth/admin/master/console/#/realms/todoapp and sign in with `KEYCLOAK_USER` and `KEYCLOAK_PASSWORD` from [Step 3](#3-docker-compose-environment-variables) if required
- On the top, select the _Login_ tab
- Make sure the Switch "User registration" is enabled (`On`)
- Click the "Save" button at the bottom

**Note**:<br>
It is also possible to enable user registration via Terraform. In the `/terraform/workspaces/config/keycloak-realms.tf` file, just set the value for `registration_allowed` to `true` and apply the configuration.

## 12. Use the Application

The application is now fully setup and ready to use.<br>
Congratulations! 🥳

- Open http://localhost:3000/ and click the "Sign in" Button in the upper right
- On the first time, you have to register for a new account (you can't use the admin account because it is not in the Todo-Realm)
    - Click on "Register" and follow the registration process
- Now, you can use the application!
