#!/bin/bash

# Print regular text with indent
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

# Check if a tool is installed
# $1 The name of the Tool
# $2 The command to verify if is exists
printRequiredInstallState() {
    state="(UNKNOWN)"

    if ! command -v $2 &> /dev/null
    then
        state="(NOT INSTALLED: 'command -v $2' returned an empty string)"
    else
        state="(INSTALLED [Detected by the Script])"
    fi

    printCheck "$1 $state"
}

# Hello
printTask "Hello!"
print "Welcome to the interactive setup of Project Paris - A Todo-Application."
printWait

# README
printTask "In addition to this scrips, you should read the README.md file in '/documentation/03.Local-Setup/README.md'."
print "If you have problems or need help, please contact me!"
printWait

# Command execution
printTask "This script will run some commands automatically."
print "Feel free to check the code of the script first."
printWait

# 1. Required tools
printTask "[1] To set up and run the application, following tools are required:"
printRequiredInstallState "Docker" "docker"
printRequiredInstallState "Docker Compose" "docker-compose"
printRequiredInstallState "Terraform" "terraform"
printRequiredInstallState "AWS CLI" "aws"
print "If one of these tools is not installed, please install it."
printWait

# 2. Ports
printTask "[2] The application requires following ports to be available on the host:"
printCheck "8080 (Keycloak)"
printCheck "4000 (Todo-Service, PostgreSQL)"
printCheck "3000 (Frontend)"
printCheck "8000 (Todo-Database, DynamoDB)"
print "Make sure there are no other applications running on these ports."
printWait

# 3. Docker-Compose: Environment Variables
printTask "[3] Let's prepare our Docker / Docker-Compose environment:"
printCheck "Create a copy of the '.env.TEMPLATE' file in the project root"
printCheck "Make sure the name of copied file is '.env'"
printWait

#
printTask "Add values for following keys in the '.env' file:"
print "You have to choose usernames and passwords."
printCheck "KEYCLOAK_DB_USER_NAME"
printCheck "KEYCLOAK_DB_USER_PASSWORD"
printCheck "KEYCLOAK_USER"
printCheck "KEYCLOAK_PASSWORD"
printWait

# 4. Frontend: Environment Variables
print "[4] A note on the Frontend environment:"
printTask "The Frontend uses its own ENV files that are already configured for you."
print "You don't need to do anything here!"
print "If you need additional infos, check out the '/documentation/03.Local-Setup/README.md' file"
printWait

# 5 Initial Docker Compose up
printTask "[5] Now it's time start the Docker-Compose Stack for the first time."
printCheck "Open a new terminal window and navigate to the project root."
printCheck "Run 'docker compose up --build -d'"
print "IMPORTANT: Starting and building all services can take a few minutes! Time to get some coffee ☕️ 😀"
printWait

# Wait until all services are up and running
printTask "Wait until all services are up and running."
printCheck "http://localhost:3000 (you should see the 'Marketing Page' of the Todo-Application)"
printCheck "http://localhost:4000 (404 error is ok, because there is no controller for the root path)"
printCheck "http://localhost:8080 (you should be able to open the 'Administration Console' with the credentials you set earlier: Values of 'KEYCLOAK_USER' and 'KEYCLOAK_PASSWORD')"
print "Continue if all services are available!"
printWait

# 6. Configure Keycloak with Terraform
printTask "[6] Lets configure Keycloak with Terraform:"
printCheck "In your other terminal window, navigate to the 'terraform/workspaces/config' directory"
printCheck "Run 'terraform init'."
printCheck "Run 'terraform plan -var-file=\"local.tfvars\"', for the variables use your Keycloak username and password (Values of KEYCLOAK_USER and KEYCLOAK_PASSWORD from the '.env' file)."
printCheck "Run 'terraform apply -var-file=\"local.tfvars\"', for the variables use your Keycloak username and password (Values of KEYCLOAK_USER and KEYCLOAK_PASSWORD from the '.env' file). Review the changes and confirm them with 'yes'."
print "Wait until Terraform has configured Keycloak."
printWait

# 7. Get Keycloak Values
printTask "[7] Now, we need to add some values from Keycloak to our '.env' file."
printCheck "Open http://localhost:8080/auth/admin/master/console/#/realms/todoapp and sign in with values of 'KEYCLOAK_USER' and 'KEYCLOAK_PASSWORD' if required"
printCheck "Copy the value from the 'Name' field and paste it for 'KEYCLOAK_REALM' in the '.env' file"
printCheck "In the left navigation bar, choose 'Clients'"
printCheck "You should now see a list of all clients. Click on the 'todoservice' client."
printCheck "Copy the value from the 'Client ID' field and paste it for 'KEYCLOAK_CLIENT_ID' in the '.env' file"
printCheck "On the top, select the 'Credentials' Tab."
printCheck "Click the 'Regenerate Secret' button and copy the generated secret. Then, paste the secret for 'KEYCLOAK_CLIENT_SECRET' in the '.env' file"
printCheck "In the left navigation bar, choose 'Realm Settings'"
printCheck "On the top, select the 'Keys' tab. You should see a table now."
printCheck "Identify the row where the 'Provider' is 'rsa-generated'."
printCheck "In this row, click the 'Public Key' button. A Popup should show up."
printCheck "Copy the value from the popup and paste it for 'KEYCLOAK_REALM_PUBLIC_KEY' in the '.env' file"
print "Continue if you added all values to the '.env' file"
printWait

#
printTask "If something doesn't work later, check out the notes for Step 7 in '/documentation/03.Local-Setup/README.md'"
printWait

# 8. AWS CLI
printTask "[8] Now, configure the AWS CLI so that we can work with DynamoDB-Local"
print "IMPORTANT: If you have already configured the AWS CLI, skip this step."
print "For DynamoDB-Local, must of the values can be mocked."
printCheck "Run 'aws configure'"
printCheck "Set 'AWS Key ID' to 'DEMO'"
printCheck "Set 'AWS Secret Access Key' to 'DEMO'"
printCheck "Set 'region' to 'eu-central-1'"
printWait

# 9. DynamoDB
printTask "[9] Create the 'Todos' Table in DynamoDB-Local"
print "In the next steps, this script will run some AWS commands, feel free to check the script code first."
printCheck

printTask "Currently, there are following tables:"
echo "----- ----- -----"
aws dynamodb list-tables --endpoint-url http://localhost:8000
echo "----- ----- -----"
printWait

printTask "Creating the 'Todos' table..."
echo "----- ----- -----"
aws dynamodb create-table --table-name Todos \
      --attribute-definitions \
          AttributeName=partitionKey,AttributeType=S \
          AttributeName=sortKey,AttributeType=S \
      --key-schema \
          AttributeName=partitionKey,KeyType=HASH \
          AttributeName=sortKey,KeyType=RANGE \
      --provisioned-throughput \
              ReadCapacityUnits=10,WriteCapacityUnits=5 \
      --endpoint-url http://localhost:8000
echo "----- ----- -----"
print "Created."
printWait

printTask "Now, there are following tables:"
echo "----- ----- -----"
aws dynamodb list-tables --endpoint-url http://localhost:8000
echo "----- ----- -----"
print "As you can see, the required table has been created."
printCheck "DynamoDB is ready! 🎉"
printWait

# 10.
printTask "[10] Now all environment variables are defined and DynamoDB is ready. Let's restart our application"
printCheck "Run 'docker compose up --build -d' in your other terminal window"
print "The restart should be much faster than the initial launch, but can still take a while..."
printWait

# Wait until all services are up and running again
printTask "Wait until all services are up and running again."
printCheck "http://localhost:3000"
printCheck "http://localhost:4000"
printCheck "http://localhost:8080"
print "Continue if all services are up!"
print "Keep going! Just some more steps! "
printWait

# 11
printTask "[11] Let's enable User Registration in Keycloak"
printCheck "Open http://localhost:8080/auth/admin/master/console/#/realms/todoapp and sign in with the values of 'KEYCLOAK_USER' and 'KEYCLOAK_PASSWORD'"
printCheck "On the top, select the 'Login' tab"
printCheck "Make sure the Switch 'User registration' is enabled ('On')"
printCheck "Click the 'Save' button at the bottom"
printWait

# 12
printTask "[12] Congratulations! You are ready to use the Todo Application! 🥳"
printCheck "Open http://localhost:3000 to get started"
printCheck "Click on 'Sign in'"
printCheck "IMPORTANT: If you are using the app for the first time, you have to register for an account first. Your admin account WILL NOT work."
printCheck "After registration or sign in, you should be redirected to the App."
printWait

# End
printTask "Setup Complete ✅ "
print "No it's time to get things done!"
