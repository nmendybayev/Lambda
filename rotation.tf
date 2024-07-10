# Configure secret rotation:

resource "aws_secretsmanager_secret_rotation" "example_rotation" {
  secret_id           = aws_secretsmanager_secret.credentials.id
  rotation_lambda_arn = aws_lambda_function.rotation_lambda.arn
  rotation_rules {
    automatically_after_days = 30
  }
}

# Permit Secret Manager invoke Lambda:

resource "aws_lambda_permission" "allow_secretsmanager" {
  statement_id  = "AllowSecretsManagerInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rotation_lambda.function_name
  principal     = "secretsmanager.amazonaws.com"
  source_arn    = aws_secretsmanager_secret.credentials.arn
}