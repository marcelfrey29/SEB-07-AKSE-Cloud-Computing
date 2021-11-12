resource "null_resource" "example_say_hello" {
    provisioner "local-exec" {
        command = "echo Hello from Terraform!"
    }
}
