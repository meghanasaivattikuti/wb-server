provider "aws" {
  region = "us-east-1"
}
terraform {
  # required_providers {
  #     aws = {
  #       source  = "hashicorp/aws"
  #       version = "~> 4.0"
  #     }
  #     kubernetes = {
  #       source  = "hashicorp/kubernetes"
  #       version = "~> 2.23"
  #     }
  #     helm = {
  #       source  = "hashicorp/helm"
  #       version = "2.5.1"
  #     }
  # }
  required_version = "~> 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

  }
  cloud {

    organization = "meghanasaiv"

    workspaces {
      name = "wb-serverupdated"
    }
  }


}

