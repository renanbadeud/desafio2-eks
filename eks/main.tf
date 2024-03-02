provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "desafio-eks"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  #latest eks
  version = "3.19.0"

  name = "desafio-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

resource "aws_iam_user" "desafio_aquarela" {
  name = "desafio_aquarela"

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  
  
  manage_aws_auth_configmap = true 
  aws_auth_users = [
    {
      userarn  = aws_iam_user.desafio_aquarela.arn
      username = "desafio_aquarela"
      groups   = ["system:masters"]
    }
  ]
  
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }

  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

#aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

#verifique que o usuario foi adicionado ao configmap aws-auth

#kubectl get configmaps aws-auth -n kube-system -o yaml

#wget https://raw.githubusercontent.com/microservices-demo/microservices-demo/master/deploy/kubernetes/complete-demo.yaml

#AWS_PROFILE=desafio_aquarela aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

 #aws eks create-access-entry --cluster-name desafio-eks-lK1VhSAE --principal-arn "arn:aws:iam::176924220418:user/desafio_aquarela"

 #aws eks associate-access-policy --cluster-name desafio-eks-lK1VhSAE --principal-arn "arn:aws:iam::176924220418:user/desafio_aquarela" --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy --access-scope type=cluster

 #kubectl cluster-info