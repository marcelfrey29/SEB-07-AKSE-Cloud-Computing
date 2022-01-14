# Keycloak

Users can log in or register for an account with Keycloak.<br>
Keycloak is responsible for handling authentication and authorization.<br>
In this project, we use the Docker Image of Keycloak.<br>
Keycloak stores its data in a PostgreSQL Database (see below).

## Core Technologies

- [Keycloak](https://www.keycloak.org/)

## Environment Variables

- For all environment variables, see the [Keycloak Image on Docker Hub](https://hub.docker.com/r/jboss/keycloak/)

| Key                 | Description                                 | Supported Values | Default |
|---------------------|---------------------------------------------|------------------|---------|
| `KEYCLOAK_USER`     | The username of the Keycloak admin account  | ` `              | ` `     |
| `KEYCLOAK_PASSWORD` | The username of the Keycloak admin password | ` `              | ` `     |
| `DB_VENDOR`         | The vendor of the database that is used     | ` `              | ` `     |
| `DB_ADDR`           | The address where the database is listening | ` `              | ` `     |
| `DB_PORT`           | The port of the database                    | ` `              | ` `     |
| `DB_USER`           | The username to authorize at the database   | ` `              | ` `     |
| `DB_PASSWORD`       | The password to authorize at the database   | ` `              | ` `     |
| `DB_DATABASE`       | The name of the database to use             | ` `              | ` `     |

## Local Development

- For local development, we use a custom Docker Image that uses the _wait-for-script_ (see `/wait.sh`)
    - This script ensures that Keycloak only starts if the Database is ready and accepts connections
    - Without wait-for-script, Keycloak crashes if the Database does not accept connections yet

## Production Environment

- On AWS, we use the default Keycloak Image
- Keycloak is managed by the Elastic Container Service (ECS)
- ECS itself is managed by Terraform

# PostgreSQL - Keycloak Database

Keycloak stores its data in a relational Database, in our case PostgreSQL.

## Core Technologies

- [PostgreSQL](https://www.postgresql.org/)

## Environment Variables

- For all environment variables, see the [PostgreSQL on Docker Hub](https://hub.docker.com/_/postgres)

| Key                 | Description                                   | Supported Values | Default |
|---------------------|-----------------------------------------------|------------------|---------|
| `POSTGRES_USER`     | The admin username for Postgres               | ` `              | ` `     |
| `POSTGRES_PASSWORD` | The admin password for Postgres               | ` `              | ` `     |
| `POSTGRES_DB`       | The name of the database to create on startup | ` `              | ` `     |

## Local Development

- **Use the main `docker-compose.yml` file** (_Recommended_)

## Production Environment

- On AWS, the Relational Database Service (RDS) is used
- The RDS Instance is managed by Terraform
