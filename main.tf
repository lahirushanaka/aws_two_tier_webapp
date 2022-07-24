terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "${var.region}"
}

#VPC Creation
module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"
  name = "${var.environment}-vpc"
  cidr = var.network_cidr
  azs   = ["${var.region}a","${var.region}b"]
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs
  enable_nat_gateway = true
}



# ASG and Launch Template Creation
module "asg" {
    source = "git::https://github.com/terraform-aws-modules/terraform-aws-autoscaling.git"
    # Autoscaling group
  name = "${var.environment}-asg"

  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets

  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "${var.environment}-asg"
  launch_template_description = "Launch templatefor ${var.environment}"
  update_default_version      = true

  image_id          = data.aws_ami.ami.image_id
  instance_type     = var.instance_type
  ebs_optimized     = true
  enable_monitoring = true

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "${var.environment}-asg-role"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for ${var.environment}"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }
  ]

#   capacity_reservation_specification = {
#     capacity_reservation_preference = "open"
#   }

#   cpu_options = {
#     core_count       = 1
#     threads_per_core = 1
#   }

#   credit_specification = {
#     cpu_credits = "standard"
#   }

#   instance_market_options = {
#     market_type = "on-demand"
#     spot_options = {
#       block_duration_minutes = 60
#     }
#   }

#   metadata_options = {
#     http_endpoint               = "enabled"
#     http_tokens                 = "required"
#     http_put_response_hop_limit = 32
#   }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = ["${module.sg-ec2.security_group_id}"]
    }
    
  ]

#   placement = {
#     availability_zone = module.vpc.azs
#   }

#   tag_specifications = [
#     {
#       resource_type = "instance"
#       tags          = { WhatAmI = "Instance" }
#     },
#     {
#       resource_type = "volume"
#       tags          = { WhatAmI = "Volume" }
#     },
#     {
#       resource_type = "spot-instances-request"
#       tags          = { WhatAmI = "SpotInstanceRequest" }
#     }
#   ]

  tags = {
    Environment = "var.environment"
    
  }
}




