variable "internet_gateway_id" {
  description = "The ID of the Internet Gateway associated to the Route Tables"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}
