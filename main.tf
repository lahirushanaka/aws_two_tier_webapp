module "vpc" {
  source = "https://github.com/terraform-aws-modules/terraform-aws-vpc"
  name = "${var.environment}-vpc"
  cidr = lookup(var.network_cidr,var.environment, null)
  azs   = ["${var.region}a","${var.region}b"]
  private_subnets = lookup(var.private_subnet_cidrs,var.environment, null)
  public_subnets  = lookup(var.public_subnet_cidrs,var.environment, null)
  enable_nat_gateway = true
}