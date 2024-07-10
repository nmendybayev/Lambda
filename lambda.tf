# Create IAM Role for Lambda:

resource "aws_iam_role" "lambda_rotation_role" {
  name = "lambda_rotation_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for Lambda:

resource "aws_iam_policy" "lambda_rotation_policy" {
  name = "lambda_rotation_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [aws_secretsmanager_secret.credentials.arn]
      }
    ]
  })
}

# Attach the role to the policy:

resource "aws_iam_role_policy_attachment" "lambda_rotation_policy_attachment" {
  role       = aws_iam_role.lambda_rotation_role.name
  policy_arn = aws_iam_policy.lambda_rotation_policy.arn
}

# Create AWS Lambda:

resource "aws_lambda_function" "rotation_lambda" {
  filename         = "lambda_rotation.zip" # Path to your zip file
  function_name    = "SecretRotationFunction"
  role             = aws_iam_role.lambda_rotation_role.arn
  handler          = "rotation.lambda_handler"
  runtime          = "python3.8"
  depends_on = [ data.archive_file.lambda ]

  environment {
    variables = {
      SECRET_ARN = aws_secretsmanager_secret.credentials.arn
    }
  }
}

# Zip file 'rotation.py':

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "rotation.py"
  output_path = "lambda_rotation.zip"
}