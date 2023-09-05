data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count             = length(var.public_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.public_cidrs[count.index]
  availability_zone = element(sort(data.aws_availability_zones.available.names), count.index)


  tags = {
    ManagedBy = var.ManagedBy
    Name      = "Public EC2 ${count.index + 1}"

  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = element(sort(data.aws_availability_zones.available.names), count.index)

  tags = {
    ManagedBy = var.ManagedBy
    Name      = "Private EC2 ${count.index + 1}"

  }
}


