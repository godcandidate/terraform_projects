# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id
  name = "ls-alb-security-group"

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow port 3000 traffic
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ls-alb-security-group"
  }
}

# Security Group for ECS
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id
  name = "ls-ecs-security-group"

  # Allow traffic only from ALB Security Group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow traffic only from ALB Security Group
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ls-ecs-security-group"
  }
}

# Security Group for RDS and RDS Proxy
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id
  name = "ls-rds-security-group"

  # Allow MySQL traffic from ECS tasks
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ls-rds-security-group"
  }
}

# Allow traffic from RDS to itself
resource "aws_security_group_rule" "rds_self_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.rds_sg.id
}

# Outputs
output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "ecs_security_group_id" {
  description = "The ID of the ECS security group"
  value       = aws_security_group.ecs_sg.id
}

output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}