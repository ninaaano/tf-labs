#web load balancer#

resource "aws_lb" "web-alb" {
  name               = var.alb-web-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-web-sg.id]
  subnets            = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]
}

#app load balancer#

resource "aws_lb" "app-alb" {
  name               = var.alb-app-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-app-sg.id]
  subnets            = [aws_subnet.app-subnet-1.id, aws_subnet.app-subnet-2.id]

}



#web target group#

resource "aws_lb_target_group" "web-target-group" {
  name     = "tg-web-name"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.nino-vpc.id
  health_check {
    path = "/"
    matcher = 200
  }

}

resource "aws_lb_listener" "my_web_alb_listener" {
 load_balancer_arn = aws_lb.web-alb.arn 
 port              = "80"
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.web-target-group.arn
 }
}

#app target group#

resource "aws_lb_target_group" "app-target-group" {
  name     = "tg-app-name"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.nino-vpc.id
  health_check {
    path = "/"
    matcher = 200
  }
}

resource "aws_lb_listener" "my_app_alb_listener" {
 load_balancer_arn = aws_lb.app-alb.arn
 port              = "80"
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.app-target-group.arn
 }
}

