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
###################################

//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Sid": "",
//      "Effect": "Allow",
//      "Action": [
//        "kms:GenerateDataKey",
//        "kms:Decrypt"
//      ],
//      "Resource": "*",
//      "Condition": {
//        "ForAnyValue:StringEquals": {
//          "kms:EncryptionContext:aws:pi:service": "rds",
//          "kms:EncryptionContext:aws:rds:db-id": [
//            "db-AAAAABBBBBCCCCCDDDDDEEEEE",
//            "db-EEEEEDDDDDCCCCCBBBBBAAAAA"
//          ],
//          "kms:EncryptionContext:service": "pi"
//        }
//      }
//    }
//  ]
//}

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
