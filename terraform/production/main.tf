terraform {
  backend "azurerm" {
    resource_group_name  = "storage-account-resource-group"
    storage_account_name = "rejdeboertfstate"
    container_name       = "tfstate"
    key                  = "production.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.96.0"
    }
    github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }
    flux = {
      source = "fluxcd/flux"
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
  location = "westeurope"
}

locals {
  project_name = "multiplayer-server"
}
