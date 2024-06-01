terraform {
  backend "azurerm" {
    resource_group_name  = "storage-account-resource-group"
    storage_account_name = "rejdeboertfstate"
    container_name       = "tfstate"
    key                  = "local.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.96.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.project_name
  location = "northeurope"
}

locals {
  organization = "rejdeboer"
  environment  = "dev"
  project_name = "multiplayer-server"
}
