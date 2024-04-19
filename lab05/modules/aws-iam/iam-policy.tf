resource "aws_iam_role_policy" "iam-policy" {
  name   = var.iam-policy
  role   = var.iam-role
  policy = file("${path.module}/iam-policy.json")
}