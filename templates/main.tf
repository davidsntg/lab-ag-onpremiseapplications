provider "azurerm" {
  features {}
  
}

##################
# Resource Group #
##################

resource "azurerm_resource_group" "onprem-site1-rg" {
  name     = "onprem-site1-rg"
  location = var.azure_location

}

resource "azurerm_resource_group" "onprem-site2-rg" {
  name     = "onprem-site2-rg"
  location = var.azure_location

}

resource "azurerm_resource_group" "azure-hub-rg" {
  name     = "azure-hub-rg"
  location = var.azure_location

}