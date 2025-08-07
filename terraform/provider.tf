terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # pin a provider version you have tested with; change as needed
      version = "~> 3.80"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
}
