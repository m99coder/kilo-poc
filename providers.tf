provider "aws" {
  alias  = "aws-eu-central-1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "aws-eu-west-1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "aws-us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "aws-us-west-2"
  region = "us-west-2"
}

provider "azurerm" {
  features {}
}

provider "google" {
  alias   = "gcp-eu-central1"
  project = var.project
  region  = "eu-central1"
  zone    = "eu-central1-a"
}

provider "google" {
  alias   = "gcp-us-central1"
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-a"
}
