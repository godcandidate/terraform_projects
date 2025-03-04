# Create Secrets Manager secret for RDS credentials
resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "ls-rds-credentials-2025-b"
  tags = {
    Name = "ls-rds-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = var.dbuser
    password = var.dbpassword
  })
}

# Create RDS DB Subnet Group
resource "aws_db_subnet_group" "rds" {
  name       = "ls-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "ls-rds-subnet-group"
  }
}

# Create RDS Instance
resource "aws_db_instance" "mysql" {
  identifier           = "ls-mysql"
  engine              = "mysql"
  engine_version      = "8.0.40"
  instance_class      = var.dbinstance_class
  allocated_storage   = 20
  storage_type        = "gp2"
  
  db_name             = var.db_name
  username            = jsondecode(aws_secretsmanager_secret_version.rds_credentials.secret_string)["username"]
  password            = jsondecode(aws_secretsmanager_secret_version.rds_credentials.secret_string)["password"]
  
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # RDS instance only accepts traffic from RDS Proxy
  
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az              = false

  tags = {
    Name = "ls-mysql"
  }
}

# Create IAM role for RDS Proxy
resource "aws_iam_role" "rds_proxy_role" {
  name = "ls-rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for RDS Proxy to access Secrets Manager
resource "aws_iam_role_policy" "rds_proxy_policy" {
  name = "ls-rds-proxy-policy"
  role = aws_iam_role.rds_proxy_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [aws_secretsmanager_secret.rds_credentials.arn]
      }
    ]
  })
}

# Create RDS Proxy
resource "aws_db_proxy" "mysql_proxy" {
  name                   = "ls-mysql-proxy"
  debug_logging         = false
  engine_family         = "MYSQL"
  idle_client_timeout   = 1800
  require_tls           = false
  role_arn             = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # Using same security group as RDS instance
  vpc_subnet_ids        = aws_subnet.private[*].id

  # Ensure proxy is in the same VPC as the RDS instance
  depends_on = [aws_db_instance.mysql]

  auth {
    auth_scheme = "SECRETS"
    description = "RDS Proxy authentication"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.rds_credentials.arn
  }

  tags = {
    Name = "ls-mysql-proxy"
  }
}

# Create RDS Proxy Target Group
resource "aws_db_proxy_default_target_group" "mysql_proxy_target" {
  db_proxy_name = aws_db_proxy.mysql_proxy.name

  connection_pool_config {
    max_connections_percent = 100
  }
}

# Create RDS Proxy Target
resource "aws_db_proxy_target" "mysql_proxy_target" {
  db_instance_identifier = "ls-mysql"
  db_proxy_name         = aws_db_proxy.mysql_proxy.name
  target_group_name     = aws_db_proxy_default_target_group.mysql_proxy_target.name

  depends_on = [
    aws_db_instance.mysql,
    aws_db_proxy.mysql_proxy,
    aws_db_proxy_default_target_group.mysql_proxy_target
  ]
}

# Outputs
output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_proxy_endpoint" {
  description = "The endpoint of the RDS proxy"
  value       = aws_db_proxy.mysql_proxy.endpoint
}
