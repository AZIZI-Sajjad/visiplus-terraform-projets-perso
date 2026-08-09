# Output the access key ID (not sensitive)
output "access_key_id" {
  value       = aws_iam_access_key.developer.id
  description = "The access key ID for the service account"
}

# Output the secret key (sensitive)
output "secret_access_key" {
  value       = aws_iam_access_key.developer.secret
  description = "The secret access key for the service account"
  sensitive   = true
}