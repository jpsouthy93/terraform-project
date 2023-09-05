output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.ec2_instance.*.id
}

output "instance_public_ips" {
  description = "Public IPs of the created EC2 instances"
  value       = aws_instance.ec2_instance.*.public_ip
}

output "ami" {
  description = "The AMI to be used for AutoScaling"
  value       = aws_instance.ec2_instance[*].ami
}

output "availability_zones" {
  description = "The AZs to be used for AutoScaling"
  value       = aws_instance.ec2_instance[*].availability_zone
}