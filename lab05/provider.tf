provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "front" {
  name = var.DOMAIN-NAME
  force_destroy = true
}