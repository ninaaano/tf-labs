# Configure related to IAM policies
resource "aws_iam_role_policy" "nino-ec2-admin" {
  name = "nino-ec2-admin"
  role = aws_iam_role.nino-ec2-admin.id

  policy = file("./json-policies/nino-ec2-admin.json")
}