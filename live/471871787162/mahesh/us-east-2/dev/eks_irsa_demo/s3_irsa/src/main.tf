# S3 policy
data "aws_iam_policy_document" "s3" {
  statement {
    sid       = "AllowS3BucketRead"
    effect    = "Allow"
    actions   = [
      "s3:*"
    ]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*",
    ]
  }
}

resource "aws_iam_policy" "s3" {
  name   = "s3_read"
  path   = "/"
  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_role" "s3" {
  name               = "s3"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.irsa.json
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.s3.name
  policy_arn = aws_iam_policy.s3.arn
}