provider "aws" {
  region = var.aws_region 
}

# Data source for Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Modules
module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = var.vpc_cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
  jenkins_allowed_cidr_blocks = var.jenkins_allowed_cidr_blocks
}

module "instances" {
  source             = "./modules/instances"
  ami                = data.aws_ami.ubuntu.id
  public_subnets     = module.vpc.public_subnets
  private_subnets    = module.vpc.private_subnets
  security_group_ids = module.security_groups.security_group_ids
  instance_type     = var.instance_type
  jenkins_instances = var.jenkins_instances
  backend_instances = var.backend_instances
  database_instances= var.database_instances
}


module "load_balancer" {
  source      = "./modules/load_balancer"
  vpc_id      = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  jenkins_instances = module.instances.jenkins_instances
  jenkins_security_group_id = module.security_groups.security_group_ids.jenkins
}

# Outputs
output "jenkins_public_ips" {
  value = module.instances.jenkins.*.public_ip # You might want to remove this output if you're primarily using the load balancer
}

output "load_balancer_dns_name" {
  value = module.load_balancer.alb_dns_name
}


output "jenkins_public_ips" {
  value = module.instances.jenkins_public_ips
}
