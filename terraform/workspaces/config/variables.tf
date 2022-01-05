variable "keycloak_url" {
    description = "The URL of the Keycloak server."
    type        = string
}

variable "keycloak_client_id" {
    description = "The Keycloak client id ('admin-cli' if Keycloak is accessed via username and password)."
    type        = string
    default     = "admin-cli"
}

variable "keycloak_username" {
    description = "The Keycloak user name of the admin account."
    type        = string
}

variable "keycloak_password" {
    description = "The Keycloak password of the admin account."
    type        = string
}

variable "keycloak_redirect_frontend" {
    description = "The URIs keycloak is allowed to redirect for the frontend application"
    type        = list(string)
}

variable "keycloak_root_url_frontend" {
    description = "The root url is applied to all relative urls."
    type        = string
}
