resource "aws_lambda_function" "demo-lambda-vpcflow-logstoelasticsearch" {
    filename         = "../module_lambda/lambda_function/terraform-demo-lambda-vpcflow-logstoelasticsearch.zip"
    function_name    = "terraform-demo-lambda-vpcflow-logstoelasticsearch"
    description      = "VPC fLow Logs to Amazon ES streaming"
    role             = "${aws_iam_role.demo-iam-role-lambda-cwlpolicyforstreaming.arn}"
    handler          = "index.handler"
    source_code_hash = "${filebase64sha256("../module_lambda/lambda_function/terraform-demo-lambda-vpcflow-logstoelasticsearch.zip")}"
    runtime          = "nodejs8.10"
    timeout          = "60"
    memory_size      = "128"

    environment {
        variables = {
            es_endpoint = "${var.es_endpoint}"
        }
    }

    tags = "${var.common_tags}"
}


resource "aws_lambda_permission" "demo-lambda-permission-vpcflow-logstoelasticsearch" {
  statement_id = "terraform-demo-lambda-permission-vpcflow-logs-cloudwatch-allow"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.demo-lambda-vpcflow-logstoelasticsearch.arn}"
  principal = "logs.eu-central-1.amazonaws.com"
  source_arn = "${var.cloud_watch_logs_group_arn_vpcflow}"
}