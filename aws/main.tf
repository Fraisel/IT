provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_role" "iam_for_list_lambda" {
  name = "list_tables_role"

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

resource "aws_iam_role" "iam_for_add_row_lambda" {
  name = "add_row_role"

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

resource "aws_iam_role" "iam_for_add_table_lambda" {
  name = "add_table_role"

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

resource "aws_iam_role" "iam_for_edit_row_lambda" {
  name = "edit_row_role"

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

resource "aws_iam_role" "iam_for_show_table_lambda" {
  name = "show_table_role"

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

resource "aws_iam_role" "iam_for_delete_row_lambda" {
  name = "delete_row_role"

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

resource "aws_iam_role" "iam_for_delete_table_lambda" {
  name = "delete_table_role"

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

resource "aws_cloudwatch_log_group" "list_lambda_log_group" {
  name = "/aws/lambda/list_tables_role"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "add_row_lambda_log_group" {
  name = "/aws/lambda/add_row_role"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "add_table_lambda_log_group" {
  name = "/aws/lambda/add_table_role"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "edit_row_lambda_log_group" {
  name = "/aws/lambda/edit_row_role"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "show_table_lambda_log_group" {
  name = "/aws/lambda/show_table_role"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "delete_row_lambda_log_group" {
  name = "/aws/lambda/delete_row_role"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "delete_table_lambda_log_group" {
  name = "/aws/lambda/delete_table_role"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_log_policy" {
  name = "lambda_logging_policy"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "dynamodb_lambda_permissions" {
  name = "dynamodb_lambda_permissions"
  path = "/"
  description = "IAM policy for DynamoDB"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_list_logs" {
  role = aws_iam_role.iam_for_list_lambda.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_list_dynamodb" {
  role = aws_iam_role.iam_for_list_lambda.name
  policy_arn = aws_iam_policy.dynamodb_lambda_permissions.arn
}

resource "aws_iam_role_policy_attachment" "lambda_add_row_logs" {
  role = aws_iam_role.iam_for_add_row_lambda.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_add_row_dynamodb" {
  role = aws_iam_role.iam_for_add_row_lambda.name
  policy_arn = aws_iam_policy.dynamodb_lambda_permissions.arn
}

resource "aws_iam_role_policy_attachment" "lambda_add_table_logs" {
  role = aws_iam_role.iam_for_add_table_lambda.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_add_table_dynamodb" {
  role = aws_iam_role.iam_for_add_table_lambda.name
  policy_arn = aws_iam_policy.dynamodb_lambda_permissions.arn
}

resource "aws_iam_role_policy_attachment" "lambda_edit_row_logs" {
  role = aws_iam_role.iam_for_edit_row_lambda.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_edit_row_dynamodb" {
  role = aws_iam_role.iam_for_edit_row_lambda.name
  policy_arn = aws_iam_policy.dynamodb_lambda_permissions.arn
}

resource "aws_iam_role_policy_attachment" "lambda_show_table_logs" {
  role = aws_iam_role.iam_for_show_table_lambda.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_show_table_dynamodb" {
  role = aws_iam_role.iam_for_show_table_lambda.name
  policy_arn = aws_iam_policy.dynamodb_lambda_permissions.arn
}

resource "aws_iam_role_policy_attachment" "lambda_delete_row_logs" {
  role = aws_iam_role.iam_for_delete_row_lambda.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_delete_row_dynamodb" {
  role = aws_iam_role.iam_for_delete_row_lambda.name
  policy_arn = aws_iam_policy.dynamodb_lambda_permissions.arn
}

resource "aws_iam_role_policy_attachment" "lambda_delete_table_logs" {
  role = aws_iam_role.iam_for_delete_table_lambda.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_delete_table_dynamodb" {
  role = aws_iam_role.iam_for_delete_table_lambda.name
  policy_arn = aws_iam_policy.dynamodb_lambda_permissions.arn
}

locals {
  add_row_file = "${path.module}/add_row.py"
  add_table_file = "${path.module}/add_table.py"
  edit_row_file = "${path.module}/edit_row.py"
  list_tables_file = "${path.module}/list_tables.py"
  show_table_file = "${path.module}/show_table.py"
  delete_row_file = "${path.module}/delete_row.py"
  delete_table_file = "${path.module}/delete_table.py"
}

data "archive_file" "add_row_zip" {
  type = "zip"
  output_path = "bin/add_row_file.zip"
  source_file = local.add_row_file
}

data "archive_file" "add_table_zip" {
  type = "zip"
  output_path = "bin/add_table_file.zip"
  source_file = local.add_table_file
}

data "archive_file" "edit_row_zip" {
  type = "zip"
  output_path = "bin/edit_row_file.zip"
  source_file = local.edit_row_file
}

data "archive_file" "list_tables_zip" {
  type = "zip"
  output_path = "bin/list_tables_file.zip"
  source_file = local.list_tables_file
}

data "archive_file" "show_table_zip" {
  type = "zip"
  output_path = "bin/show_table_file.zip"
  source_file = local.show_table_file
}

data "archive_file" "delete_row_zip" {
  type = "zip"
  output_path = "bin/delete_row_file.zip"
  source_file = local.delete_row_file
}

data "archive_file" "delete_table_zip" {
  type = "zip"
  output_path = "bin/delete_table_file.zip"
  source_file = local.delete_table_file
}

resource "aws_lambda_function" "list_lambda" {
  function_name = "list_lambda"
  role = aws_iam_role.iam_for_list_lambda.arn
  handler = "list_tables.lambda_handler"
  filename = data.archive_file.list_tables_zip.output_path
  runtime = "python3.8"
}

resource "aws_lambda_function" "add_row_lambda" {
  function_name = "add_row_lambda"
  role = aws_iam_role.iam_for_add_row_lambda.arn
  handler = "add_row.lambda_handler"
  filename = data.archive_file.add_row_zip.output_path
  runtime = "python3.8"
}

resource "aws_lambda_function" "add_table_lambda" {
  function_name = "add_table_lambda"
  role = aws_iam_role.iam_for_add_table_lambda.arn
  handler = "add_table.lambda_handler"
  filename = data.archive_file.add_table_zip.output_path
  runtime = "python3.8"
}

resource "aws_lambda_function" "edit_row_lambda" {
  function_name = "edit_row_lambda"
  role = aws_iam_role.iam_for_edit_row_lambda.arn
  handler = "edit_row.lambda_handler"
  filename = data.archive_file.edit_row_zip.output_path
  runtime = "python3.8"
}

resource "aws_lambda_function" "show_table_lambda" {
  function_name = "show_table_lambda"
  role = aws_iam_role.iam_for_show_table_lambda.arn
  handler = "show_table.lambda_handler"
  filename = data.archive_file.show_table_zip.output_path
  runtime = "python3.8"
}

resource "aws_lambda_function" "delete_row_lambda" {
  function_name = "delete_row_lambda"
  role = aws_iam_role.iam_for_delete_row_lambda.arn
  handler = "delete_row.lambda_handler"
  filename = data.archive_file.delete_row_zip.output_path
  runtime = "python3.8"
}

resource "aws_lambda_function" "delete_table_lambda" {
  function_name = "delete_table_lambda"
  role = aws_iam_role.iam_for_delete_table_lambda.arn
  handler = "delete_table.lambda_handler"
  filename = data.archive_file.delete_table_zip.output_path
  runtime = "python3.8"
}

resource "aws_api_gateway_rest_api" "api" {
  name = "database_api"
}

resource "aws_api_gateway_resource" "list_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "list_tables"
}

resource "aws_api_gateway_method" "list_method" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.list_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_list" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "list_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.list_resource.id
  http_method = aws_api_gateway_method.list_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.list_lambda.invoke_arn
}

resource "aws_api_gateway_resource" "add_row_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "add_row"
}

resource "aws_api_gateway_method" "add_row_method" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.add_row_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_add_row" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_row_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "add_row_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.add_row_resource.id
  http_method = aws_api_gateway_method.add_row_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.add_row_lambda.invoke_arn
}

resource "aws_api_gateway_resource" "add_table_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "add_table"
}

resource "aws_api_gateway_method" "add_table_method" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.add_table_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_add_table" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_table_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "add_table_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.add_table_resource.id
  http_method = aws_api_gateway_method.add_table_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.add_table_lambda.invoke_arn
}

resource "aws_api_gateway_resource" "edit_row_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "edit_row"
}

resource "aws_api_gateway_method" "edit_row_method" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.edit_row_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_edit_row" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.edit_row_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "edit_row_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.edit_row_resource.id
  http_method = aws_api_gateway_method.edit_row_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.edit_row_lambda.invoke_arn
}

resource "aws_api_gateway_resource" "show_table_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "show_table"
}

resource "aws_api_gateway_method" "show_table_method" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.show_table_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_show_table" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.show_table_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "show_table_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.show_table_resource.id
  http_method = aws_api_gateway_method.show_table_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.show_table_lambda.invoke_arn
}

resource "aws_api_gateway_resource" "delete_row_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "delete_row"
}

resource "aws_api_gateway_method" "delete_row_method" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.delete_row_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_delete_row" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_row_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "delete_row_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.delete_row_resource.id
  http_method = aws_api_gateway_method.delete_row_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.delete_row_lambda.invoke_arn
}

resource "aws_api_gateway_resource" "delete_table_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "delete_table"
}

resource "aws_api_gateway_method" "delete_table_method" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.delete_table_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_delete_table" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_table_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "delete_table_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.delete_table_resource.id
  http_method = aws_api_gateway_method.delete_table_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.delete_table_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = "test"

  depends_on = [
    aws_api_gateway_integration.show_table_integration,
    aws_api_gateway_integration.edit_row_integration,
    aws_api_gateway_integration.add_row_integration,
    aws_api_gateway_integration.add_table_integration,
    aws_api_gateway_integration.list_integration,
    aws_api_gateway_integration.delete_row_integration,
    aws_api_gateway_integration.delete_table_integration
  ]
}