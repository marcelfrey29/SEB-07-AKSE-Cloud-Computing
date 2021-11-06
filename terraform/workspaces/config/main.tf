terraform {
    required_providers {
        keycloak = {
            source  = "mrparkers/keycloak"
            version = "3.5.1"
        }
    }
}

// IMPORTANT NOTE
// The variables values (username & password) have to match the values passed to the container image!
provider "keycloak" {
    url       = var.keycloak_url
    client_id = var.keycloak_client_id
    username  = var.keycloak_username
    password  = var.keycloak_password
}
