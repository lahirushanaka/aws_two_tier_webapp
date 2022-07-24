#### Security Groups #########
module "sg-ec2" {
    source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git"
    name = "${var.environment}-ec2-sg"
    description = "Security group for ${var.environment} EC2"
    vpc_id = module.vpc.vpc_id
    ingress_with_cidr_blocks = [
        {
            rule    = "ssh-tcp"
            cidr_block = "0.0.0.0/0"
        },
        {
            rule    = "http-80-tcp"
            cidr_block = "0.0.0.0/0"
        },

    ]
    egress_rules       = ["all-all"]
  
}