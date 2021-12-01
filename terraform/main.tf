
# create lambda IAM role 

resource "aws_iam_role" "lambda_function_s3_role" {
  name = "MiasLambdaRole"

 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda_function" {
  filename      = "lambda_function_payload.zip"
  function_name = "mia_lambda_s3"
  role          = aws_iam_role.lambda_function_s3_role.arn
  handler       = "lambda.lambda_handler"
  runtime = "python3.8"
  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access_attachment" {
  role       = aws_iam_role.lambda_function_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}



#Create policy for cloudwatch logs

resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "lambda_cloudwatch_policy"
  path        = "/"
  description = "lambda cloudwatch policy"


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

