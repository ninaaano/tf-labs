terraform  {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#vpc creation#

resource "aws_vpc" "nino-vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.nino-vpc
  }
}

#create IGW#

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nino-vpc.id
  tags = {
    Name = var.igw-name
  }
}

###elastic IP address###

resource "aws_eip" "eip-address" {
    domain     = "vpc"
    
}

resource "aws_eip" "eip-address-2" {
    domain     = "vpc"
    
}

#create NGW#

resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.eip-address.id
  subnet_id     = aws_subnet.web-subnet-1.id

  tags = {
    Name = var.nat-gw-name-1
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id = aws_eip.eip-address-2.id
  subnet_id     = aws_subnet.web-subnet-2.id

  tags = {
    Name = var.nat-gw-name-2
  }

  depends_on = [aws_internet_gateway.igw]
}


#database subnet group#

resource "aws_db_subnet_group" "database-subnet-group" {
  name       = var.db-subnet-grp-name
  subnet_ids = [aws_subnet.db-subnet-1.id, aws_subnet.db-subnet-2.id]

}


#public route table#

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.nino-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt-name"
  }
}
resource "aws_route_table_association" "public-rt-association1" {
  subnet_id      = aws_subnet.nat-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table_association" "public-rt-association2" {
  subnet_id      = aws_subnet.nat-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}


#private route table# - web

resource "aws_route_table" "private-rt-az-a" {
  vpc_id = aws_vpc.nino-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-1.id
  }

   tags = {
    Name = var.private-rt-name-1
  }
}

resource "aws_route_table_association" "private-rt-association1-web" {
  subnet_id      = aws_subnet.web-subnet-1.id
  route_table_id = aws_route_table.private-rt-az-a.id
}

resource "aws_route_table_association" "private-rt-association2-web" {
  subnet_id      = aws_subnet.web-subnet-2.id
  route_table_id = aws_route_table.private-rt-az-b.id
}


#private route table# - app

resource "aws_route_table" "private-rt-az-b" {
  vpc_id = aws_vpc.nino-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-2.id
  }

   tags = {
    Name = var.private-rt-name-2
  }
}

resource "aws_route_table_association" "private-rt-association1" {
  subnet_id      = aws_subnet.app-subnet-1.id
  route_table_id = aws_route_table.private-rt-az-a.id
}

resource "aws_route_table_association" "private-rt-association2" {
  subnet_id      = aws_subnet.app-subnet-2.id
  route_table_id = aws_route_table.private-rt-az-b.id
}


resource "aws_route_table_association" "db-private-subnet-a" {
  subnet_id      = aws_subnet.db-subnet-1.id
  route_table_id = aws_route_table.private-rt-az-a.id
}

resource "aws_route_table_association" "db-private-subnet-b" {
  subnet_id      = aws_subnet.db-subnet-2.id
  route_table_id = aws_route_table.private-rt-az-b.id
}


#web auto scaling group#

resource "aws_autoscaling_group" "web-asg" {
  name =   var.asg-web-name
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  target_group_arns   = [aws_lb_target_group.web-target-group.arn]
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]

  launch_template {
    id      = aws_launch_template.web-launch-template.id
    version = "$Latest"
  }
}


#app auto scaling group#

resource "aws_autoscaling_group" "app-asg" {
  name =   var.asg-app-name
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  target_group_arns   = [aws_lb_target_group.app-target-group.arn]
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.app-subnet-1.id, aws_subnet.app-subnet-2.id]

  launch_template {
    id      = aws_launch_template.app-launch-template.id
    version = "$Latest"
  }
}
