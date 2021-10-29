#!/usr/bin/env sh

# Wait for the database
./wait.sh keycloak-db 5432

# Start Keycloak (required because the entrypoint has been overridden by the Dockerfile)
/opt/jboss/tools/docker-entrypoint.sh
