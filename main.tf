data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_flow_log" "vpc" {
  log_destination = aws_cloudwatch_log_group.default.arn
  iam_role_arn    = aws_iam_role.log.arn
  vpc_id          = var.vpc_id
  traffic_type    = var.traffic_type
}

resource "aws_cloudwatch_log_group" "default" {
  name              = var.name
  retention_in_days = var.retention_in_days
  kms_key_id        = aws_kms_key.log.arn
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
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      aws_cloudwatch_log_group.default.arn,
      "${aws_cloudwatch_log_group.default.arn}:*"
    ]

    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:ResourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
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

resource "aws_kms_key" "log" {
  description             = "An KMS key for encrypting cloudwatch logs"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        },
        Action = [
          "kms:ReplicateKey",
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}
