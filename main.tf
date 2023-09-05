module "aws_vpc" {
  source         = "./modules/vpc"
  ManagedBy      = var.ManagedBy
  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
}

module "subnets" {
  source        = "./modules/subnets"
  public_cidrs  = var.public_cidrs
  private_cidrs = var.private_cidrs
  vpc_id        = module.aws_vpc.vpc_id
  ManagedBy     = var.ManagedBy
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.aws_vpc.vpc_id
}

module "rt" {
  source              = "./modules/route-tables"
  internet_gateway_id = module.igw.gateway_id
  vpc_id              = module.aws_vpc.vpc_id
  public_subnet_ids   = module.subnets.public_subnet_ids
}

module "sg" {
  source         = "./modules/sg"
  vpc_id         = module.aws_vpc.vpc_id
  vpc_cidr_block = module.aws_vpc.vpc_cidr_block
}

module "ec2_instances" {
  source                 = "./modules/ec2"
  allow_http             = module.sg.allow_http
  allow_https            = module.sg.allow_https
  allow_ssh              = module.sg.allow_ssh
  instance_type          = var.instance_type
  public_subnet_ids      = module.subnets.public_subnet_ids
  key_name               = var.key_name
  use_auto_scaling_group = var.use_auto_scaling_group

}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.aws_vpc.vpc_id
  public_subnet_ids = module.subnets.public_subnet_ids
  allow_http        = module.sg.allow_http
  allow_https       = module.sg.allow_https
  instance_ids      = module.ec2_instances.instance_ids
}

module "asg" {
  source                 = "./modules/asg"
  instance_type          = var.instance_type
  newest_ami             = module.ec2_instances.newest_ami
  tg_arn                 = module.alb.tg_arn
  availability_zones     = module.ec2_instances.availability_zones
  allow_http             = module.sg.allow_http
  allow_https            = module.sg.allow_https
  allow_ssh              = module.sg.allow_ssh
  key_name               = var.key_name
  public_subnet_ids      = module.subnets.public_subnet_ids
  use_auto_scaling_group = var.use_auto_scaling_group

}

