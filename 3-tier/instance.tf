#web launch template#

resource "aws_launch_template" "web-launch-template" {
  name          = var.launch-template-web-name
  image_id      = var.image-id
  instance_type = var.instance-type
  key_name      = var.key-name
  user_data     = filebase64("${path.module}/userdata.sh")

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.web-asg-security-group.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.nino-ec2-admin.name
  }


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.launch-template-web-name
    }
  }
}

#app launch template#

resource "aws_launch_template" "app-launch-template" {
  name          = var.launch-template-app-name
  image_id      = var.image-id
  instance_type = var.instance-type
  key_name      = var.key-name

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.web-asg-security-group.id]
  }

  iam_instance_profile {
  name = aws_iam_instance_profile.nino-ec2-admin.name
  }

  tag_specifications {

    resource_type = "instance"
    tags = {
      Name = var.launch-template-app-name
    }
  }

} 

#database instance#

resource "aws_db_instance" "database" {
  allocated_storage    = 10
  db_name              = var.db-name
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.instance-type-db
  username             = var.db-username
  password             = var.db-password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  multi_az = true
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  db_subnet_group_name = aws_db_subnet_group.database-subnet-group.name
}
