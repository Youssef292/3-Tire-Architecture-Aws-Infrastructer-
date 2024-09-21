variable "aws_region" {
  description = "The AWS region to deploy the infrastructure in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The EC2 instance type to use for all instances"
  type        = string
  default     = "t2.micro"
}

variable "jenkins_instances" {
  description = "The number of Jenkins instances to create"
  type        = number
  default     = 3
}

variable "backend_instances" {
  description = "The number of backend instances to create"
  type        = number
  default     = 2
}

variable "database_instances" {
  description = "The number of database instances to create"
  type        = number
  default     = 2
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "jenkins_allowed_cidr_blocks" {
  description = "The CIDR blocks allowed to access Jenkins (SSH and HTTP)"
  type        = list(string)
  default     = ["0.0.0.0/0"] 
}