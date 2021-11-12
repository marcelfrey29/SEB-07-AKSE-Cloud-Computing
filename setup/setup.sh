#!/bin/bash

# Print regular text
print() {
    echo "  $1"
}

# Print a task
printTask() {
    echo " "
    echo "⟶ $1"
}

# Print a checklist item
printCheck() {
    echo "    ✓ $1"
}

# Print wait info and wait for user input
printWait() {
    read -p "  Press Enter (⏎) to continue..."
}

# Ask for user input
askForValue() {
    read -p "    ? $1: " userInput
    echo $userInput
}

# Check if a tool is installed
# $1 The name of the Tool
# $2 The command to verify if is exists
printRequiredInstallState() {
    state="(UNKNOWN)"

    if ! command -v $2 &> /dev/null
    then
        state="(NOT INSTALLED: 'command -v $2' returned an empty string)"
    else
        state="(INSTALLED)"
    fi

    printCheck "$1 $state"
}

# Print the contents of a file
printFileContent() {
    echo "----- START of File -----"
    cat $1
    echo "----- END of File -----"
}

# Hello
printTask "Welcome to the Todo Application."
print "This script will guide you through the Setup process."
print "At the end you will have a running, local version of the todo app."
printWait

# Required tools
printTask "To setup and run the application, following tools are required:"
printRequiredInstallState "Docker" "docker"
printRequiredInstallState "Docker Compose" "docker-compose"
printRequiredInstallState "Terraform" "terraform"
printWait

# Ports
printTask "The application requires following ports to be available on the host:"
printCheck "8080 (Keycloak)"
printCheck "4000 (Todo-Service)"
printCheck "3000 (Frontend)"
print "Make sure there are no other applications running on these ports."
printWait

# Setup docker-compose / .env file in project root
rootEnvFilePath="../.env.TEST"
printTask "Fist, you need to define some credentials for Keycloak and the Keycloak database."
print "Keycloak Database:"
keycloakDbUserName=$(askForValue "Admin Username for the Keycloak Database")
keycloakDbPassword=$(askForValue "Admin Password for the Keycloak Database")
print "Keycloak:"
keycloakAdminUser=$(askForValue "Admin Username for Keycloak")
keycloakAdminPassword=$(askForValue "Admin Username for Keycloak")
echo "# PostgreSQL (Keycloak DB)" > $rootEnvFilePath
echo "KEYCLOAK_DB_USER_NAME=$keycloakDbUserName" >> $rootEnvFilePath
echo "KEYCLOAK_DB_USER_PASSWORD=$keycloakDbPassword" >> $rootEnvFilePath
echo "KEYCLOAK_DB_TABLE_NAME=keycloak" >> $rootEnvFilePath
echo "KEYCLOAK_DB_PORT=5432" >> $rootEnvFilePath
echo "" >> $rootEnvFilePath
echo "# Keycloak" >> $rootEnvFilePath
echo "KEYCLOAK_USER=$keycloakAdminUser" >> $rootEnvFilePath
echo "KEYCLOAK_PASSWORD=$keycloakAdminPassword" >> $rootEnvFilePath
echo "KEYCLOAK_VENDOR=postgres" >> $rootEnvFilePath
echo "KEYCLOAK_ADDR=keycloak-db" >> $rootEnvFilePath
print "Created a '.env' file in the project root."
print "Here it is:"
printFileContent "$rootEnvFilePath"
printWait
