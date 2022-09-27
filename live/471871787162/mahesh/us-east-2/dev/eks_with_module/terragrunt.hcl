locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  customer_vars    = read_terragrunt_config(find_in_parent_folders("customer.hcl"))

  customer_name    = local.customer_vars.locals.customer_name
  environment_name = local.environment_vars.locals.environment
  eks_cluster_name = format("%s-%s", local.customer_name, local.environment_name)
}

terraform {
  source = "git@github.com:maheshglm/aws-infra.git//modules/eks/v18.28.0?ref=feature/build-ecr-eks-modules"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "unique_id" {
  config_path = "../unique_id"
}

inputs = {
  customer            = local.customer_name
  environment         = local.environment_name
  unique_id           = dependency.unique_id.outputs.id
  eks_cluster_version = "1.22"

  eks_vpc_id              = dependency.vpc.outputs.vpc_id
  eks_private_subnets_ids = dependency.vpc.outputs.private_subnets

  cluster_addons = {
    coredns    = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni    = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_group_defaults = {
    disk_size      = 20
    instance_types = ["t3.small"]
  }

  eks_managed_node_groups = {
    //blue  = {}
    green = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      ami_id         = "ami-0478aafd76a8aea10" #EKS 1.22
      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
      labels         = {
        Environment = local.environment_name
      }

      enable_bootstrap_user_data = true
      bootstrap_extra_args       = "--container-runtime containerd --kubelet-extra-args '--max-pods=50'"

      pre_bootstrap_user_data = <<-EOT
      export CONTAINER_RUNTIME="containerd"
      export USE_MAX_PODS=true
      EOT

      post_bootstrap_user_data = <<-EOT
      cd /tmp
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo systemctl enable amazon-ssm-agent
      sudo systemctl start amazon-ssm-agent
      EOT

      description = "EKS managed node group launch template"

      tags = {
        ExtraTag = "example"
      }
    }
  }


}