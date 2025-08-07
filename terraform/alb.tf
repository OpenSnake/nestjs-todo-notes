resource "aws_lb" "alb" {
  name = "alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg-alb.id]
  subnets = [
    aws_subnet.subnet-public-1.id,
    aws_subnet.subnet-public-2.id,
  ]
  tags = {
    Name = "tf-alb"
  }
}

resource "aws_lb_target_group" "alb-tg" {
  name = "tg"
  port = var.app_port
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id
  target_type = "ip"
  health_check {
    path = "/api"
    matcher = "200-399"
    port = var.app_port
    protocol = "HTTP"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "tf-tg"
  }
}

resource "aws_lb_listener" "alb-listener-http" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb-listener-https" {
  load_balancer_arn = aws_lb.alb.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = data.aws_acm_certificate.app_cert.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}