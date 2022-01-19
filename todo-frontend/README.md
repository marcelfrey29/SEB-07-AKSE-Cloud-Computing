# Todo Application - Frontend

The Frontend-Application is a Single Page Application (SPA) that provides the User Interface of the Todo-Application.<br>
All data have to be queried and send to the [Backend-Service](../todo-service/README.md).<br>
Every request needs to contain the `Authorization` Header.<br>
The frontend is responsible for redirecting the user to [Keycloak](../keycloak/README.md) and handle the redirect.<br>

## Core Technologies

- Node.js **16** (newer versions are not supported, e.g. Node 17 is not working)
- [Nuxt.js](https://nuxtjs.org/) based on Vue.js
- Nuxt Auth
- BootstrapVue and Bootstrap

## Environment Variables

- Because the application is deployed by uploading static files to S3, the environment variables have to be injected on build-time
- Environment variables need to start with `NUXT_ENV_` that they are recognized by Nuxt
- See the `dev.env`, `production.env` and `TEMPLATE.env` files

| Key                              | Description                                                                                              | Supported Values | Default |
|----------------------------------|----------------------------------------------------------------------------------------------------------|------------------|---------|
| `NUXT_ENV_KEYCLOAK_HOST`         | The URL of the Keycloak-Server                                                                           | ` `              | ` `     |
| `NUXT_ENV_KEYCLOAK_REALM`        | The Realm for the application                                                                            | ` `              | ` `     |
| `NUXT_ENV_KEYCLOAK_REDIRECT_URI` | The URL of the Frontend (e.g. of this application)<br>Keycloak will redirect to this address after login | ` `              | ` `     |
| `NUXT_ENV_KEYCLOAK_CLIENT_ID`    | The Client ID of the application                                                                         | ` `              | ` `     |
| `NUXT_ENV_TODO_SERVICE_URL`      | The URL of the Backend-Service                                                                           | ` `              | ` `     |

## Local Development

- **Running the main `docker-compose.yml` file is enough to run and develop the frontend** (_Recommended_)
    - No local Node.js installation is required
    - All dependencies are installed inside the container
    - All relevant files are automatically mounted into the container
    - The correct script runs automatically
    
> The `node_modules` directory is NOT mounted into the container! It is excluded from the mount.<br>
> Mounting this folder can cause problems if it does not exist or if it is empty!<br>
> The reason is that we first install all dependencies in the container, and then override them with our (potential empty) local folder!
>
> If you add new dependencies, you have to rebuild the container image!<br>
> Run `docker compose up --build -d` from the project root to do so.

- If you want to work outside of Docker, you can use following commands:

```bash
# Install dependencies
$ npm install

# Start Development Server
$ npm run start:dev
```

## Build for Production (AWS)

- The Frontend-Application is hosted as a Static Website on S3
- **Building for production currently happens outside of Docker**
    - Node.js needs to be installed
- **In this step only the static assets are generated - The deployment (upload to S3) is done with Terraform**

```bash
# Install dependencies
$ npm install

# Generate Static Files
$ npm run generate:prod
```
