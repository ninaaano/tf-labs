#web security group#

resource "aws_security_group" "alb-web-sg" {
  name        = var.alb-sg-web-name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.nino-vpc.id

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb-sg-web-name
  }
}

#app security group#

resource "aws_security_group" "alb-app-sg" {
  name        = var.alb-sg-app-name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.nino-vpc.id

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.web-asg-security-group.id]
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb-sg-app-name
  }
}

#web auto scaling security group#

resource "aws_security_group" "web-asg-security-group" {
  name        = var.asg-sg-web-name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.nino-vpc.id

  ingress {
    description = "HTTP from alb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb-web-sg.id]
  }

    ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.asg-sg-web-name
  }
}

#app auto scaling security group#

resource "aws_security_group" "app-asg-security-group" {
  name        = var.asg-sg-app-name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.nino-vpc.id

  ingress {
    description = "HTTP from alb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb-app-sg.id]
  }

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.web-asg-security-group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.asg-sg-app-name
  }
}

#database security group#

resource "aws_security_group" "db-sg" {
  name        = var.db-sg-name
  description = "DataBase Security Group"
  vpc_id      = aws_vpc.nino-vpc.id
  ingress {

    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.app-asg-security-group.id]
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.db-sg-name
  }
}