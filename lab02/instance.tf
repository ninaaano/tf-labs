data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "aws_instance" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.main-public-1.id
  availability_zone = "us-east-1a"
  security_groups = [aws_security_group.allow_tls.id] # 보안 그룹을 EC2 인스턴스에 연결합니다.


  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }

  tags = {
    Name = "Web-Server-1"
  }

  user_data = filebase64("./user_data_script.sh")

}

