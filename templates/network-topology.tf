#########################################################
# Hub VNet
#########################################################
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "hub-vnet"
  location            = azurerm_resource_group.azure-hub-rg.location
  resource_group_name = azurerm_resource_group.azure-hub-rg.name
  address_space       = ["10.221.0.0/21"]
 
}

resource "azurerm_subnet" "hub-gateway-subnet" {
    name                    = "GatewaySubnet"
    resource_group_name     = azurerm_resource_group.azure-hub-rg.name
    virtual_network_name    = azurerm_virtual_network.hub-vnet.name
    address_prefixes        = ["10.221.0.0/26"]
}


resource "azurerm_subnet" "hub-workload-subnet" {
    name                    = "snet-workload"
    resource_group_name     = azurerm_resource_group.azure-hub-rg.name
    virtual_network_name    = azurerm_virtual_network.hub-vnet.name
    address_prefixes        = ["10.221.0.64/26"]
}

resource "azurerm_subnet" "hub-applicationgateway-subnet" {
    name                    = "snet-applicationgateway"
    resource_group_name     = azurerm_resource_group.azure-hub-rg.name
    virtual_network_name    = azurerm_virtual_network.hub-vnet.name
    address_prefixes        = ["10.221.1.128/25"]
}

#########################################################
# Onprem Site1
#########################################################

resource "azurerm_virtual_network" "onprem-site1-vnet" {
  name                = "onprem-site1-vnet"
  location            = azurerm_resource_group.onprem-site1-rg.location
  resource_group_name = azurerm_resource_group.onprem-site1-rg.name
  address_space       = ["10.1.0.0/16"]
  
}

resource "azurerm_subnet" "onprem-site1-gateway-subnet" {
    name                    = "GatewaySubnet"
    resource_group_name     = azurerm_resource_group.onprem-site1-rg.name
    virtual_network_name    = azurerm_virtual_network.onprem-site1-vnet.name
    address_prefixes        = ["10.1.0.0/26"]
}

resource "azurerm_subnet" "onprem-site1-workload-subnet" {
    name                    = "snet-workload"
    resource_group_name     = azurerm_resource_group.onprem-site1-rg.name
    virtual_network_name    = azurerm_virtual_network.onprem-site1-vnet.name
    address_prefixes        = ["10.1.0.64/26"]
}


#########################################################
# Onprem Site2
#########################################################

resource "azurerm_virtual_network" "onprem-site2-vnet" {
  name                = "onprem-site2-vnet"
  location            = azurerm_resource_group.onprem-site2-rg.location
  resource_group_name = azurerm_resource_group.onprem-site2-rg.name
  address_space       = ["10.2.0.0/16"]
  
}

resource "azurerm_subnet" "onprem-site2-gateway-subnet" {
    name                    = "GatewaySubnet"
    resource_group_name     = azurerm_resource_group.onprem-site2-rg.name
    virtual_network_name    = azurerm_virtual_network.onprem-site2-vnet.name
    address_prefixes        = ["10.2.0.0/26"]
}

resource "azurerm_subnet" "onprem-site2-workload-subnet" {
    name                    = "snet-workload"
    resource_group_name     = azurerm_resource_group.onprem-site2-rg.name
    virtual_network_name    = azurerm_virtual_network.onprem-site2-vnet.name
    address_prefixes        = ["10.2.0.64/26"]
}

