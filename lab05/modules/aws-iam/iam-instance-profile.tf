resource "aws_iam_instance_profile" "test_profile" {
  name = var.instance-profile-name
  role = var.iam-role
}