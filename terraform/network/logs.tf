resource "aws_s3_bucket" "log_storage" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_cloudwatch_log_group" "service" {
  name = "awslogs-service-staging"

  tags = {
    Environment = "staging"
    Application = var.app_name
  }
}

resource "aws_s3_bucket_acl" "lb-logs-acl" {
  bucket = aws_s3_bucket.log_storage.id
  acl    = "private"
}

data "aws_iam_policy_document" "allow-lb" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elb.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/frontend-alb/AWSLogs/${var.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
  statement {
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/frontend-alb/AWSLogs/${var.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.elb_account_id}:root"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/frontend-alb/AWSLogs/${var.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "allow-lb" {
  bucket = aws_s3_bucket.log_storage.id
  policy = data.aws_iam_policy_document.allow-lb.json
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.log_storage.id

  rule {
    id      = "log_lifecycle"
    status  = "Enabled"

    expiration {
      days = 10
    }
  }
}
