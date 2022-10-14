# S3 policy
data "aws_iam_policy_document" "dynamo" {
  statement {
    sid       = "AllowDynamoDBAllActions"
    effect    = "Allow"
    actions   = [
      "dynamodb:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "dynamo" {
  name   = "dynamo_all_actions"
  path   = "/"
  policy = data.aws_iam_policy_document.dynamo.json
}

resource "aws_iam_role" "dynamo_irsa_role" {
  name               = "dynamo_irsa_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.irsa.json
}

resource "aws_iam_role_policy_attachment" "dynamo" {
  role       = aws_iam_role.dynamo_irsa_role.name
  policy_arn = aws_iam_policy.dynamo.arn
}