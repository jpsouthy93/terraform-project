variable "public_subnet_ids" {
  description = "List of public subnet IDs where EC2 instances will be launched"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for the instance"
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

variable "use_auto_scaling_group" {
  description = "True or False as to whether we use ASG"
  type        = bool
}