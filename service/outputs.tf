# Outputs
# required resources
# - server

# outputs
# password - The base64 encoded admin password
# private_ip - Private IP address for RDP access

output "password" {
  value = aws_instance.server.password_data
}

output "server_id" {
  value = aws_instance.server.id
}

output "server_arn" {
  value = aws_instance.server.arn
}

output "server_private_ip" {
  value = aws_instance.server.private_ip
}
