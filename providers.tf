provider "azurerm" {
  features {}
}

provider "google" {
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "aws" {
  alias = "aws-euc1"
  region = "eu-central-1"
}

provider "aws" {
  alias = "aws-euw1"
  region = "eu-west-1"
}

provider "aws" {
  alias = "aws-use1"
  region = "us-east-1"
}

provider "aws" {
  alias = "aws-usw2"
  region = "us-west-2"
}