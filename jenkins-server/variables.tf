variable "aws_region"{
    description = "AWS Region where the infrastructure will be deployed"
    type = string
    default = "eu-west-1" 
}

variable "instance_type" {
  description = "EC2 instance type for the Jenkins server"
  type        = string
  default     = "t3.medium"
}


variable "ami_id" {
  description = "AMI id for the Jenkins server"
  type        = string
  default     = "ami-03fd334507439f4d1"  //Ubuntu latest image
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_access_cidr" {
  description = "CIDR block allowing SSH access to the instance"
  type        = string
  default     = "0.0.0.0/0"
}

variable "jenkins_port" {
  description = "Port number for Jenkins"
  type        = number
  default     = 8080
}

variable "key_name" {
  description = "key value for Jenkins server"
  type        = string
  default     = "todoLab2"
}