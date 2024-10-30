resource "aws_flow_log" "vpc" {
  log_destination = aws_cloudwatch_log_group.default.arn
  iam_role_arn    = aws_iam_role.log.arn
  vpc_id          = var.vpc_id
  traffic_type    = var.traffic_type
}

resource "aws_cloudwatch_log_group" "default" {
  name              = var.name
  retention_in_days = var.retention_in_days
}

data "aws_iam_policy_document" "log_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "log" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "log" {
  name   = var.name
  role   = aws_iam_role.log.id
  policy = data.aws_iam_policy_document.log.json
}

resource "aws_iam_role" "log" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.log_assume.json
}