# Application Load Balancer
resource "aws_lb" "lamp_alb" {
  name               = "lamp-stack-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets           = aws_subnet.public[*].id

  tags = {
    Name = "lamp-stack-alb"
  }
}

# Target Groups
resource "aws_lb_target_group" "frontend" {
  name        = "lamp-frontend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_target_group" "backend" {
  name        = "lamp-backend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

# Listeners
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.lamp_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.lamp_alb.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

# Outputs
output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.lamp_alb.dns_name
}

output "frontend_url" {
  description = "The URL for the frontend application"
  value       = "http://${aws_lb.lamp_alb.dns_name}"
}

output "backend_url" {
  description = "The URL for the backend API"
  value       = "http://${aws_lb.lamp_alb.dns_name}:3000"
}
