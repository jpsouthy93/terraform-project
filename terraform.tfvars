ManagedBy = "Terraform"

public_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

private_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

azs = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

vpc_name = "<YOUR-VPC-NAME"

vpc_cidr_block = "10.0.0.0/16"

instance_type = "t2.micro"

key_name = "<YOUR-KEY>"

// While set to true, EC2 instances will spin up for each public subnet using the autoscaling group
// If you prefer to not autoscale, set this to false and EC2 instances will spin up according to how many public subnets exist
// The amount of subnets is determined by the amount of unique public CIDR ranges, specified above
use_auto_scaling_group = true 