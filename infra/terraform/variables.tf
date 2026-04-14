variable "project_name" {
  description = "Project name used for naming and tagging"
  type        = string
  default     = "customer-churn-mlops-service"
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "us-west-2a"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into the instance"
  type        = string
  default     = "0.0.0.0/32"
}

variable "key_name" {
  description = "Optional EC2 key pair name"
  type        = string
  default     = null
}

variable "docker_image" {
  description = "Docker image to run on the EC2 instance"
  type        = string
  default = "doyonm/customer-churn-mlops-service:latest"
}

variable "app_port" {
  description = "Port exposed by the API container"
  type        = number
  default     = 8000
}
