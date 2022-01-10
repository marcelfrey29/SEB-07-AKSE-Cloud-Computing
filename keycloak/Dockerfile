FROM jboss/keycloak:15.0.2

# Switch to root to install packages
USER root

# Install netcat which is required for the wait-for-script
RUN microdnf install -y nmap
RUN microdnf clean all

# Switch back to default user (see https://github.com/keycloak/keycloak-containers/blob/master/server/Dockerfile)
USER 1000

WORKDIR /home

# Copy Scripts
COPY wait.sh .
COPY run.sh .

# Override Entrypoint from keycloak. The run script has to launch keycloak!
# See https://github.com/keycloak/keycloak-containers/blob/master/server/Dockerfile
ENTRYPOINT ./run.sh
