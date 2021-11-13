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
rootEnvFilePath="../.env"
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

# Initial Docker Compose up
printTask "Now it's time start the docker compose stack for the first time."
#cd ..
#docker-compose up --build -d
printCheck "Open a new terminal window and navigate to the project root."
printCheck "Run 'docker compose up --build -d'"
print "IMPORTANT: Starting and building all services can take a few minutes! Time to get some coffee ☕️ 😀"
printWait

# Wait until all services are up and running
printTask "Wait until all services are up and running."
printCheck "http://localhost:3000 (you should be redirected to the /about page)"
printCheck "http://localhost:4000 (404 error is ok, because there is no controller for the root path)"
printCheck "http://localhost:8080 (you should be able to open the 'Administration Console' with the credentials you set earlier)"
print "IMPORTANT: Only continue, if all services are available!"
printWait

# Configure Keycloak with Terraform
printTask "Currently Keycloak only has its 'default' realm with the Admin-User you setup earlier."
print "Now it's time to add a new realm for our Todo Application and add clients for the Frontend and the Todo-Service."
print "To configure Keycloak, we are using Terraform - the configuration is already defined."
printCheck "In your other terminal window, navigate to the 'terraform/workspaces/config' ('cd terraform/workspaces/config') directory."
# terraform plan
# terraform apply
printCheck "Run 'terraform init'."
printCheck "Run 'terraform plan', for the variables use your Keycloak username and password (KEYCLOAK_USER and KEYCLOAK_PASSWORD from the '.env' file)."
printCheck "Run 'terraform apply', for the variables use your Keycloak username and password (KEYCLOAK_USER and KEYCLOAK_PASSWORD from the '.env' file). Review the changes and confirm them with 'yes'."
print "Wait until Terraform has configured Keycloak."
printWait

# Regenerate Secret and configure backend
printTask "For Security Reasons, you need to generate a new Client-Secret for the Todo-Service."
print "This is enforced by Keycloak."
printCheck "Open http://localhost:8080/auth/admin/master/console/#/realms/todoapp and sign in with your Keycloak username and password if required."
printCheck "In the left navigation bar, click on 'Clients'"
printCheck "Now you should see a list of all clients. Open the 'todoservice' client, by clicking on the Client ID 'todoservice'."
printCheck "On the top, select the tab 'credentials'."
printCheck "Click 'Regenerate Secret', copy the secret and paste it here."
todoServiceKeycloakSecret=$(askForValue "Secret")
printWait

# Configure TodoService
printTask "The Todo-Service requires this secret to validate Tokens."
print "Created a '.env' file in '<project-root>/todo-service/.env'"
print "Here it is:"
todoServiceEnvFile="../todo-service/.env"
echo "# Server" > $todoServiceEnvFile
echo "SERVER_PORT=4000" >> $todoServiceEnvFile
echo "" >> $todoServiceEnvFile
echo "# Keycloak" >> $todoServiceEnvFile
echo "KEYCLOAK_URL=http://localhost:8080" >> $todoServiceEnvFile
echo "KEYCLOAK_REALM=todoapp" >> $todoServiceEnvFile
echo "KEYCLOAK_CLIENT_ID=todoservice" >> $todoServiceEnvFile
echo "KEYCLOAK_CLIENT_SECRET=$todoServiceKeycloakSecret" >> $todoServiceEnvFile
printFileContent "$todoServiceEnvFile"
printWait

# Docker Compose up
printTask "Perfect! Everything is now configured."
print "Now, we have to restart all services so that they can use the newly created '.env' files."
#cd ..
#docker-compose up --build -d
printCheck "In your other terminal window, navigate to the project root."
printCheck "Run 'docker compose up --build -d'"
print "IMPORTANT: Starting and building all services can take a few minutes! Time to get another coffee 😁"
printWait

# Wait until all services are up and running
printTask "Wait until all services are up and running again."
printCheck "http://localhost:3000 (you should be redirected to the /about page)"
printCheck "http://localhost:4000 (404 error is ok, because there is no controller for the root path)"
printCheck "http://localhost:8080 (you should be able to open the 'Administration Console' with the credentials you set earlier)"
print "IMPORTANT: Only continue, if all services are available!"
printWait

#
printTask "Congratulations! You are ready to use the Todo Application! 🥳"
printCheck "Open http://localhost:3000"
printCheck "Click on 'Sign in'"
printCheck "On the Keycloak Login page you have to create an account first, so click on 'Register' at the bottom of the card."
printCheck "Fill in all fields and click on 'Register'"
printCheck "Now you are redirected to the application and can start using it."
print "IMPORTANT: Currently there is a bug and you are redirected to the /about page again. If that happens, just open http://localhost:3000"
printWait

#
printTask "Setup Complete ✅ "
print " "
