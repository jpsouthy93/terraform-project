variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the whole VPC"
}

variable "ManagedBy" {
  description = "Specifies the entity responsible for this resource"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}