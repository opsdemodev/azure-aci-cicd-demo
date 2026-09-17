terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ---------------------------------------------------------
# Resource Group
# ---------------------------------------------------------

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Project     = "Azure-ACI-CICD"
    Environment = "Lab"
  }
}

# ---------------------------------------------------------
# Azure Container Registry
# ---------------------------------------------------------

resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku           = "Basic"
  admin_enabled = true

  tags = {
    Project     = "Azure-ACI-CICD"
    Environment = "Lab"
  }
}
