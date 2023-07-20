provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

#data "aws_eks_cluster" "cluster" {
#    name = module.eks.cluster_name
#}

#data "aws_eks_cluster_auth" "cluster" {
#    name = module.eks.cluster_name
#}

locals {
  cluster_name = "pankaj2DemoCluster"
}

#provider "kubernetes" {
#  host                   = data.aws_eks_cluster.cluster.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#  token                  = data.aws_eks_cluster_auth.cluster.token
#}
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}


module "eks-kubeconfig" {
  source  = "hyperbadger/eks-kubeconfig/aws"
  version = "2.0.0"

  depends_on = [module.eks]
  #cluster_id =  module.eks.cluster_id
  cluster_name = "pankaj2DemoCluster"
  }

resource "local_file" "kubeconfig" {
  content  = module.eks-kubeconfig.kubeconfig
  filename = "kubeconfig_${local.cluster_name}"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"
  
  name                 = "vpc-0e1c1e914c61d284c"
  cidr                 = "172.31.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["172.31.1.0/24", "172.31.2.0/24", "172.31.3.0/24"]
  public_subnets       = ["172.31.16.0/20", "172.31.32.0/20", "172.31.64.0/20"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.2"

  cluster_name    = "${local.cluster_name}"
  cluster_version = "1.27"
  subnet_ids      = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  eks_managed_node_groups = {
    first = {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 1
      instance_type = "t2.micro"

    }
  }
}
