# Public Subnet - NAT
resource "aws_subnet" "nat-subnet-1" {
    vpc_id = aws_vpc.nino-vpc.id
    cidr_block = var.nat-subnet1-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.az_1

    tags = {
        Name = var.nat-subnet1-name
    }
}

resource "aws_subnet" "nat-subnet-2" {
    vpc_id = aws_vpc.nino-vpc.id
    cidr_block = var.nat-subnet2-cidr
    map_public_ip_on_launch = "true"
    availability_zone = var.az_2

    tags = {
        Name = var.nat-subnet2-name
    }
}


#web subnets#

resource "aws_subnet" "web-subnet-1" {
  vpc_id     = aws_vpc.nino-vpc.id
  cidr_block = var.web-subnet1-cidr
  availability_zone = var.az_1

  tags = {
    Name = var.web-subnet1-name
  }
}

resource "aws_subnet" "web-subnet-2" {
  vpc_id     = aws_vpc.nino-vpc.id
  cidr_block = var.web-subnet2-cidr
  availability_zone = var.az_2

  tags = {
    Name = var.web-subnet2-name
  }
}

#app subnets#

resource "aws_subnet" "app-subnet-1" {
  vpc_id     = aws_vpc.nino-vpc.id
  cidr_block = var.app-subnet1-cidr
  availability_zone = var.az_1

  tags = {
    Name = var.app-subnet1-name
  }
}

resource "aws_subnet" "app-subnet-2" {
  vpc_id     = aws_vpc.nino-vpc.id
  cidr_block = var.app-subnet2-cidr
  availability_zone = var.az_2

  tags = {
    Name = var.app-subnet2-name
  }
}

#database subnets#

resource "aws_subnet" "db-subnet-1" {
  vpc_id     = aws_vpc.nino-vpc.id
  cidr_block = var.db-subnet1-cidr
  availability_zone = var.az_1

  tags = {
    Name = var.db-subnet1-name
  }
}

resource "aws_subnet" "db-subnet-2" {
  vpc_id     = aws_vpc.nino-vpc.id
  cidr_block = var.db-subnet2-cidr
  availability_zone = var.az_2

  tags = {
    Name = var.db-subnet2-name
  }
}