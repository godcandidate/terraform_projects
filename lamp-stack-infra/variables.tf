//Global variables
variable "aws_region" {  
  description = "The ID of the VPC"
  type        = string
  default       = "eu-west-2"
}


variable "vpc_cidr" {
  description = "CIDR block for the LampStack VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for the LampStack public subnets"
  type        = list(string)
  default     = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR blocks for the LampStack private subnets"
  type        = list(string)
  default     = ["172.16.3.0/24", "172.16.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

//Security group variables
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default = null # Will be set to aws_vpc.main.id
}


//RDS Database variables
variable "dbuser" {
  description = "The name of the RDS database user"
  type        = string
  default     = "admin"
}

variable "dbpassword" {
  description = "The password of the RDS database user"
  type        = string
  default     = "Testing123#"
}

variable "dbinstance_class" {
  description = "The instance class of the RDS database"
  type        = string
  default     = "db.t3.medium"
}

variable "db_name" {
  description = "The name of the RDS database"
  type        = string
  default     = "todoDB"
}

variable "ecr_frontend_uri" {
  description = "The URI of the ECR frontend"
  type        = string
  default     = "585008053249.dkr.ecr.eu-west-1.amazonaws.com/lamp-stack-frontend:latest"
  
}

variable "ecr_backend_uri" {
  description = "The URI of the ECR backend"
  type        = string
  default     = "585008053249.dkr.ecr.eu-west-1.amazonaws.com/lamp-stack-backend:latest"
  
}