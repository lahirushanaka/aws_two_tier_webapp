region = "ap-southeast-1"
environment = "dev"
network_cidr = "10.10.0.0/24"
private_subnet_cidrs = ["10.10.0.0/26", "10.10.0.64/26"]
public_subnet_cidrs = ["10.10.0.128/26", "10.10.0.192/26"]

#### ASG ####
instance_type = "t3.small"
