provider "azurerm" {
  features {}
}

provider "google" {
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-a"
}
