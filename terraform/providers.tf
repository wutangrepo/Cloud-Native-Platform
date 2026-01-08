# Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
  }

  required_version = ">= 1.14"
}

# Configuration options for providers
provider "aws" {
  region = var.aws_region
}

provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data) # certificate_authority attribute is a list of object usually containing only one object
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.main.name]
    }
  }
}