# IAM Policy with assume role to EC2
data "aws_iam_policy_document" "ec2-assume-role" {
  statement {
     actions = ["sts:AssumeRole"]

     principals {
       type = "Service"
       identifiers = ["ec2.amazonaws.com"]
     }

     effect = "Allow"
     sid = ""
  }
}

# Configure IAM role
resource "aws_iam_role" "nino-ec2-admin" {
    name = "nino-ec2-admin"
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.ec2-assume-role.json
}

# Configure IAM instance profile
resource "aws_iam_instance_profile" "nino-ec2-admin" {
    name = "nino-ec2-admin"
    role = aws_iam_role.nino-ec2-admin.name
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.nino-ec2-admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}