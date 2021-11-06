resource "keycloak_realm" "todo-realm" {
    // Realm settings
    realm             = "todoapp"
    enabled           = true
    display_name      = "Todo App"
    display_name_html = "<b>Todo App</b>"

    // Login settings
    registration_allowed     = true
    remember_me              = false
    login_with_email_allowed = true
    ssl_required             = "none"

    access_code_lifespan = "1h"
    password_policy      = "upperCase(1) and length(8) and notUsername"
}
