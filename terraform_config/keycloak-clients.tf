resource "keycloak_openid_client" "todo-service" {
    realm_id    = keycloak_realm.todo-realm.id
    client_id   = "todoservice"
    name        = "Todo Service"
    enabled     = true
    description = "The client for the Nest.js Backend."
    
    access_type = "CONFIDENTIAL"
}

resource "keycloak_openid_client" "todo-frontend" {
    realm_id    = keycloak_realm.todo-realm.id
    client_id   = "todofrontend"
    name        = "Todo Frontend"
    enabled     = true
    description = "The client for the Nuxt.js / Vue.js Single Page Application."

    access_type           = "PUBLIC"
    standard_flow_enabled = true
    valid_redirect_uris   = var.keycloak_redirect_frontend
    root_url              = var.keycloak_root_url_frontend
    admin_url             = var.keycloak_root_url_frontend
    // CORS: "+" allows all redirect URIs
    web_origins           = [
        "+"
    ]
}
