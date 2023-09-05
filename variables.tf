variable "vpc_cidr_block" {
  description = "The CIDR block of the whole VPC"
  type        = string
}

variable "ManagedBy" {
  description = "Specifies the entity responsible for this resource"
  type        = string
}

variable "public_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "azs" {
  description = "List of Availability Zones available"
  type        = list(string)
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The .pem file to SSH into the server"
  type        = string
}

variable "use_auto_scaling_group" {
  description = "True or False as to whether we use ASG"
  type        = bool
}