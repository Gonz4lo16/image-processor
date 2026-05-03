data "archive_file" "upload" {
  type        = "zip"
  source_file = "${path.module}/lambda/upload/index.js"
  output_path = "${path.module}/lambda/upload.zip"
}

data "archive_file" "crop" {
  type        = "zip"
  source_file = "${path.module}/lambda/crop/index.js"
  output_path = "${path.module}/lambda/crop.zip"
}

resource "aws_lambda_function" "upload" {
  filename      = data.archive_file.upload.output_path
  function_name = "upload-lambda"
  role          = aws_iam_role.upload_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  memory_size = 256
  timeout     = 30

  environment {
    variables = {
      S3_BUCKET     = aws_s3_bucket.images.bucket
      UPLOAD_PREFIX = "uploads/"
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

resource "aws_lambda_function" "crop" {
  filename      = data.archive_file.crop.output_path
  function_name = "crop-lambda"
  role          = aws_iam_role.crop_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  memory_size = 512
  timeout     = 60

  environment {
    variables = {
      S3_BUCKET        = aws_s3_bucket.images.bucket
      PROCESSED_PREFIX = "processed/"
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = aws_sqs_queue.main.arn
  function_name    = aws_lambda_function.crop.arn

  batch_size = 5
  function_response_types = ["ReportBatchItemFailures"]
}