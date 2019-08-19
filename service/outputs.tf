# Outputs
# required resources
# - server

# outputs
# password - The base64 encoded admin password
# private_ip - Private IP address for RDP access

output "password" {
  value = rsadecrypt(aws_instance.server.password_data, tls_private_key.priv_key.private_key_pem)
}

output "public_dns" {
  value = aws_instance.server.public_dns
}

output "public_ipv4" {
  value = aws_instance.server.public_ip
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

