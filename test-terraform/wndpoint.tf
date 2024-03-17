data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "",
        "home/",
        "home/&{aws:username}/",
      ]
    }
  }

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}",
      "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}/*",
    ]
  }
}

resource "aws_iam_policy" "example" {
  name   = "example_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "example_multiple_condition_keys_and_values" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = ["*"]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "kms:EncryptionContext:service"
      values   = ["pi"]
    }

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "kms:EncryptionContext:aws:pi:service"
      values   = ["rds"]
    }

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "kms:EncryptionContext:aws:rds:db-id"
      values   = ["db-AAAAABBBBBCCCCCDDDDDEEEEE", "db-EEEEEDDDDDCCCCCBBBBBAAAAA"]
    }

  }
}


data "aws_iam_policy_document" "event_stream_bucket_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = [var.trusted_role_arn]
    }

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.account_id}:saml-provider/${var.provider_name}", "cognito-identity.amazonaws.com"]
    }
  }
}

#Example Using A Source Document
data "aws_iam_policy_document" "source" {
  statement {
    actions   = ["ec2:*"]
    resources = ["*"]
  }

  statement {
    sid = "SidToOverride"

    actions   = ["s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "source_document_example" {
  source_policy_documents = [data.aws_iam_policy_document.source.json]

  statement {
    sid = "SidToOverride"

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::somebucket",
      "arn:aws:s3:::somebucket/*",
    ]
  }
}
#Example Using An Override Document
data "aws_iam_policy_document" "override" {
  statement {
    sid = "SidToOverride"

    actions   = ["s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "override_policy_document_example" {
  override_policy_documents = [data.aws_iam_policy_document.override.json]

  statement {
    actions   = ["ec2:*"]
    resources = ["*"]
  }

  statement {
    sid = "SidToOverride"

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::somebucket",
      "arn:aws:s3:::somebucket/*",
    ]
  }
}

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Sid": "SidToOverride",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}



data "aws_iam_policy_document" "source" {
  statement {
    sid       = "OverridePlaceholder"
    actions   = ["ec2:DescribeAccountAttributes"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "override" {
  statement {
    sid       = "OverridePlaceholder"
    actions   = ["s3:GetObject"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "politik" {
  source_policy_documents   = [data.aws_iam_policy_document.source.json]
  override_policy_documents = [data.aws_iam_policy_document.override.json]
}

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "OverridePlaceholder",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "*"
    }
  ]
}

data "aws_iam_policy_document" "source_one" {
  statement {
    actions   = ["ec2:*"]
    resources = ["*"]
  }

  statement {
    sid = "UniqueSidOne"

    actions   = ["s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "source_two" {
  statement {
    sid = "UniqueSidTwo"

    actions   = ["iam:*"]
    resources = ["*"]
  }

  statement {
    actions   = ["lambda:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.source_one.json,
    data.aws_iam_policy_document.source_two.json
  ]
}

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Sid": "UniqueSidOne",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    },
    {
      "Sid": "UniqueSidTwo",
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "lambda:*",
      "Resource": "*"
    }
  ]
}

data "aws_iam_policy_document" "policy_one" {
  statement {
    sid    = "OverridePlaceHolderOne"
    effect = "Allow"

    actions   = ["s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "policy_two" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }

  statement {
    sid    = "OverridePlaceHolderTwo"
    effect = "Allow"

    actions   = ["iam:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "policy_three" {
  statement {
    sid    = "OverridePlaceHolderOne"
    effect = "Deny"

    actions   = ["logs:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "combined" {
  override_policy_documents = [
    data.aws_iam_policy_document.policy_one.json,
    data.aws_iam_policy_document.policy_two.json,
    data.aws_iam_policy_document.policy_three.json
  ]

  statement {
    sid    = "OverridePlaceHolderTwo"
    effect = "Deny"

    actions   = ["*"]
    resources = ["*"]
  }
}
