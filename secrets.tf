# Create secret in AWS Secret Manager:

resource "aws_secretsmanager_secret" "credentials" {
  name = "sensitive-credentials"
}

resource "aws_secretsmanager_secret_version" "example_version" {
  secret_id = aws_secretsmanager_secret.credentials.id
  secret_string = jsonencode({
    username = "example_user"
    password = "example_password"
  })
}