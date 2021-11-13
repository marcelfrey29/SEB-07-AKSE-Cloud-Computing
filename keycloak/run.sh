#!/usr/bin/env sh

# Wait for the database
./wait.sh keycloak-db 5432

# Start Keycloak (required because the entrypoint has been overridden by the Dockerfile)
#
# Exec is not required, but using it is recommended:
# With `exec`, the current process is replaces by the new process, otherwise a child-process would be created.
# The new child-process won't have the PID 1 and might not receive interrupts (SIGTERM, ...).
# In this case, keycloak doesn't receive the commands and can't init a graceful shutdown.
# With exec, the keycloak process receives PID 1 (it replaces the process of this script which has PID 1).
# By that, keycloak is able to receive interrupts.
exec /opt/jboss/tools/docker-entrypoint.sh
