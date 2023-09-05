variable "vpc_id" {
  description = "The ID of the VPC in which to create the subnets"
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

variable "ManagedBy" {
  description = "Specifies the entity responsible for this resource"
  type        = string
}
