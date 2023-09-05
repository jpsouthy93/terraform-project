data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "newest_ami" {
  description = "The AMI ID of the newest Ubuntu AMI pulled from data"
  value = data.aws_ami.ubuntu.id
}

resource "aws_instance" "ec2_instance" {
  # count = length(var.public_subnet_ids)
  # use a turnary here, if use_auto_scaling_group in /root/main.tf is true this = 0, else this = 3 
  count                       = var.use_auto_scaling_group == true ? 0 : length(var.public_subnet_ids)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  availability_zone           = element(sort(data.aws_availability_zones.available.names), count.index)
  subnet_id                   = var.public_subnet_ids[count.index]
  vpc_security_group_ids      = [var.allow_http, var.allow_https, var.allow_ssh]
  key_name                    = var.key_name
  associate_public_ip_address = true
  # user_data                   = file("user-data.tpl")

  tags = {
    Name = "EC2 Instance-${count.index + 1}"
  }
}