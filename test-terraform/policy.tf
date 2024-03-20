# ==================================================
# => AWS IAM Policy Document
#   * policy_document
#   * policy
# ==================================================

data "aws_iam_policy_document" "HttpPolicyDocument" {
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

resource "aws_iam_policy" "HttpPolicy" {
  name   = "example_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.HttpPolicyDocument.json
}

data "aws_iam_policy_document" "multiple_condition_keys_and_values" {
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
