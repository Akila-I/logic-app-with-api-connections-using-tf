terraform {
  required_providers {
    azapi = {
      version = "1.4.0"
      source  = "Azure/azapi"
    }
  }
  backend "azurerm" {
    storage_account_name = ""
    container_name       = "layer-1"
    key                  = "layer-1.terraform.tfstate"
    access_key           = ""
  }
}

# Configure the Azure Resource Manager Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}
