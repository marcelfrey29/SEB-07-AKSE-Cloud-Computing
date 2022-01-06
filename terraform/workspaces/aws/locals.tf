locals {
    mime_types = {
        ".html" : "text/html",
        ".css" : "text/css",
        ".js" : "text/javascript",
        ".ico" : "image/vnd.microsoft.icon",
        ".jpg" : "image/jpeg",
        ".jpeg" : "image/jpeg",
        ".json" : "application/json"
        "DEFAULT_VALUE" : "text/plain"
    }

    cluster_name = "akse-todo-cluster"

    cloudfront_s3_origin_id = "todo-frontend-s3-origin"
}
