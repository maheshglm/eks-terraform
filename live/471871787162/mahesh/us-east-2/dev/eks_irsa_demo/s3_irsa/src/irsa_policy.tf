
#Create the IAM role with the trust relationship and attach the policy to get access to S3.
data "aws_iam_policy_document" "irsa" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_issuer_url,"https://","")}:sub"
      values   = [
        "system:serviceaccount:${var.sa_namespace}:${var.sa_name}"
      ]
    }
  }
}
