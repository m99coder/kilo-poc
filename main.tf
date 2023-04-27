terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.39"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.48"
    }
  }
  required_version = ">= 1.3.0"
}

module "aws_eu_central_1" {
  source         = "./modules/aws-eu-central-1"
  public_ssh_key = var.public_ssh_key

  providers = {
    aws = aws.aws-eu-central-1
  }
}

module "aws_eu_west_1" {
  source         = "./modules/aws-eu-west-1"
  public_ssh_key = var.public_ssh_key

  k3s_leader_endpoint = module.aws_eu_central_1.public_ip

  providers = {
    aws = aws.aws-eu-west-1
  }

  depends_on = [
    module.aws_eu_central_1
  ]
}

module "aws_us_east_1" {
  source         = "./modules/aws-us-east-1"
  public_ssh_key = var.public_ssh_key

  k3s_leader_endpoint = module.aws_eu_central_1.public_ip

  providers = {
    aws = aws.aws-us-east-1
  }

  depends_on = [
    module.aws_eu_central_1
  ]
}

module "aws_us_west_2" {
  source         = "./modules/aws-us-west-2"
  public_ssh_key = var.public_ssh_key

  k3s_leader_endpoint = module.aws_eu_central_1.public_ip

  providers = {
    aws = aws.aws-us-west-2
  }

  depends_on = [
    module.aws_eu_central_1
  ]
}

module "az_japaneast" {
  source         = "./modules/az-japaneast"
  public_ssh_key = var.public_ssh_key

  k3s_leader_endpoint = module.aws_eu_central_1.public_ip

  depends_on = [
    module.aws_eu_central_1
  ]
}

module "gcp_eu_central1" {
  source         = "./modules/gcp-us-central1"
  public_ssh_key = var.public_ssh_key
  project        = var.project

  k3s_leader_endpoint = module.aws_eu_central_1.public_ip

  providers = {
    google = google.gcp-eu-central1
  }

  depends_on = [
    module.aws_eu_central_1
  ]
}

module "gcp_us_central1" {
  source         = "./modules/gcp-us-central1"
  public_ssh_key = var.public_ssh_key
  project        = var.project

  k3s_leader_endpoint = module.aws_eu_central_1.public_ip

  providers = {
    google = google.gcp-us-central1
  }

  depends_on = [
    module.aws_eu_central_1
  ]
}
