# VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "main"
    }
}

# igw
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "main"
    }
}

# Public Subnet
resource "aws_subnet" "main-public-1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"

    tags = {
        Name = "main-public-1"
    }
}

resource "aws_subnet" "main-public-2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1c"

    tags = {
        Name = "main-public-2"
    }
}


# private subnet
resource "aws_subnet" "main-private-1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"

    tags = {
        Name = "main-private-1"
    }
}

resource "aws_subnet" "main-private-2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1c"

    tags = {
        Name = "main-private-2"
    }
}


# Route Table 생성
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "public_igw" {
    route_table_id = aws_route_table.route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private_nat_1" {
  route_table_id = aws_route_table.route_table_private_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_route" "private_nat_2" {
  route_table_id = aws_route_table.route_table_private_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
}

resource "aws_route_table_association" "route_table_association_1" {
    subnet_id = aws_subnet.main-public-1.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_2" {
    subnet_id = aws_subnet.main-public-2.id
    route_table_id = aws_route_table.route_table.id
}

# NAT
resource "aws_eip" "nat_1" {
    domain = "vpc"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_eip" "nat_2" {
    domain = "vpc"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_nat_gateway" "nat_gateway_1" {
    allocation_id = aws_eip.nat_1.id
    subnet_id = aws_subnet.main-public-1.id
    
    tags = {
        Name = "NAT-GW-1"
    }
}

resource "aws_nat_gateway" "nat_gateway_2" {
    allocation_id = aws_eip.nat_2.id
    subnet_id = aws_subnet.main-public-2.id

    tags = {
        Name = "NAT-GW-2"
    }
}

# Private RT 생성 및 연결
resource "aws_route_table" "route_table_private_1" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "private-rt-1"
    }
}

resource "aws_route_table" "route_table_private_2" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "private-rt-2"
    }
}

resource "aws_route_table_association" "route_table_association_private_1" {
    subnet_id = aws_subnet.main-private-1.id
    route_table_id = aws_route_table.route_table_private_1.id
}

resource "aws_route_table_association" "route_table_association_private_2" {
    subnet_id = aws_subnet.main-private-2.id
    route_table_id = aws_route_table.route_table_private_2.id
}

resource "aws_route_table_association" "route_table_association_public_1" {
    subnet_id = aws_subnet.main-public-1.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_public_2" {
    subnet_id = aws_subnet.main-public-2.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
