
# data "aws_iam_policy_document" "key_policy" {
#   policy_id = "key-default-1"

#   statement {
#     sid    = "Enable IAM User Permissions"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#     }

#     actions = [
#       "kms:*",
#     ]

#     resources = ["*"]
#   }
# }

data "aws_caller_identity" "current" {}

# Create kms key
resource "aws_kms_key" "kms" {
  description = "KMS key "
  policy = jsonencode({
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"},
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
  })

}
resource "aws_kms_alias" "alias" {
  name          = "alias/kms"
  target_key_id = aws_kms_key.kms.key_id
}