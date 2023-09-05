variable "newest_ami" {
  description = "The AMI to be used for AutoScaling"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "availability_zones" {
  description = "The AZs to be used for AutoScaling"
  type        = list(string)
}

variable "tg_arn" {
  description = "The ARN of the Target Group"
  type        = string
}

variable "allow_http" {
  description = "Security Group ID for allowing HTTP traffic"
  type        = string
}

variable "allow_https" {
  description = "Security Group ID for allowing HTTPS traffic"
  type        = string
}

variable "allow_ssh" {
  description = "Security Group ID for allowing SSH traffic"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for the instance"
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of the Public Subnet IDs"
  type        = list(string)
}

variable "use_auto_scaling_group" {
  description = "True or False as to whether we use ASG"
  type        = bool
}