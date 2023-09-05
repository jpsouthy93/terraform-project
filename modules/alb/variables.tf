variable "vpc_id" {
  description = "ID of the VPC to associate the ALB Target Group with"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "allow_http" {
  description = "Security group ID to allow HTTP traffic"
  type        = string
}

variable "allow_https" {
  description = "Security group ID to allow HTTPS traffic"
  type        = string
}

variable "instance_ids" {
  description = "List of EC2 instance IDs to be used as targets for the target group"
  type        = list(string)
}
