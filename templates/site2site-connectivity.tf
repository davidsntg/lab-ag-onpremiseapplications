#########################################################
# Azure hub VPN Gateway
#########################################################

resource "azurerm_public_ip" "hub-vpngw-ip" {
  name                = "hub-vpngw-ip"
  location            = azurerm_resource_group.azure-hub-rg.location
  resource_group_name = azurerm_resource_group.azure-hub-rg.name

  allocation_method = "Dynamic"

}

resource "azurerm_virtual_network_gateway" "hub-vpngw" {
  name                              = "hub-vpngw"
  location                          = azurerm_resource_group.azure-hub-rg.location
  resource_group_name               = azurerm_resource_group.azure-hub-rg.name

  type                              = "Vpn"
  vpn_type                          = "RouteBased"

  active_active                     = false
  enable_bgp                        = true
  sku                               = "VpnGw1"

  bgp_settings {
      asn = var.azure_bgp_asn
  }

  ip_configuration {
    name                            = "vnetGatewayIpConfig"
    public_ip_address_id            = azurerm_public_ip.hub-vpngw-ip.id
    private_ip_address_allocation   = "Dynamic"
    subnet_id                       = azurerm_subnet.hub-gateway-subnet.id
  }

}

#########################################################
# On premise Site1 VPN Gateway
#########################################################

resource "azurerm_public_ip" "site1-vpngw-ip" {
  name                = "site1-vpngw-ip"
  location            = azurerm_resource_group.onprem-site1-rg.location
  resource_group_name = azurerm_resource_group.onprem-site1-rg.name

  allocation_method = "Dynamic"

}

resource "azurerm_virtual_network_gateway" "site1-vpngw" {
  name                              = "site1-vpngw"
  location                          = azurerm_resource_group.onprem-site1-rg.location
  resource_group_name               = azurerm_resource_group.onprem-site1-rg.name

  type                              = "Vpn"
  vpn_type                          = "RouteBased"

  active_active                     = false
  enable_bgp                        = true
  sku                               = "VpnGw1"

  bgp_settings {
      asn = var.site1_bgp_asn
  }

  ip_configuration {
    name                            = "vnetGatewayIpConfig"
    public_ip_address_id            = azurerm_public_ip.site1-vpngw-ip.id
    private_ip_address_allocation   = "Dynamic"
    subnet_id                       = azurerm_subnet.onprem-site1-gateway-subnet.id
  }

}

resource "azurerm_public_ip" "site2-vpngw-ip" {
  name                = "site2-vpngw-ip"
  location            = azurerm_resource_group.onprem-site2-rg.location
  resource_group_name = azurerm_resource_group.onprem-site2-rg.name

  allocation_method = "Dynamic"

}

resource "azurerm_virtual_network_gateway" "site2-vpngw" {
  name                              = "site2-vpngw"
  location                          = azurerm_resource_group.onprem-site2-rg.location
  resource_group_name               = azurerm_resource_group.onprem-site2-rg.name

  type                              = "Vpn"
  vpn_type                          = "RouteBased"

  active_active                     = false
  enable_bgp                        = true
  sku                               = "VpnGw1"

  bgp_settings {
      asn = var.site2_bgp_asn
  }

  ip_configuration {
    name                            = "vnetGatewayIpConfig"
    public_ip_address_id            = azurerm_public_ip.site2-vpngw-ip.id
    private_ip_address_allocation   = "Dynamic"
    subnet_id                       = azurerm_subnet.onprem-site2-gateway-subnet.id
  }

}


#########################################################
# Site1 Local Network Gateway to Azure Hub
#########################################################

resource "azurerm_local_network_gateway" "site1-lng" {
  name                  = "site1-lng-to-azure-hub"
  resource_group_name   = azurerm_resource_group.onprem-site1-rg.name
  location              = azurerm_resource_group.onprem-site1-rg.location
  gateway_address       = azurerm_public_ip.hub-vpngw-ip.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.hub-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.hub-vpngw.bgp_settings[0].peering_addresses[0].default_addresses[0]
      peer_weight         = azurerm_virtual_network_gateway.hub-vpngw.bgp_settings[0].peer_weight
  }

  depends_on = [azurerm_virtual_network_gateway.hub-vpngw]
}

#########################################################
# Site2 Local Network Gateway to Azure Hub
#########################################################

resource "azurerm_local_network_gateway" "site2-lng" {
  name                  = "site2-lng-to-azure-hub"
  resource_group_name   = azurerm_resource_group.onprem-site2-rg.name
  location              = azurerm_resource_group.onprem-site2-rg.location
  gateway_address       = azurerm_public_ip.hub-vpngw-ip.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.hub-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.hub-vpngw.bgp_settings[0].peering_addresses[0].default_addresses[0]
      peer_weight         = azurerm_virtual_network_gateway.hub-vpngw.bgp_settings[0].peer_weight
  }

  depends_on = [azurerm_virtual_network_gateway.hub-vpngw]
}

#########################################################
# Azure Hub Local Network Gateway to Site 1
#########################################################

resource "azurerm_local_network_gateway" "hub-lng-to-site1" {
  name                  = "hub-lng-to-site1"
  resource_group_name   = azurerm_resource_group.azure-hub-rg.name
  location              = azurerm_resource_group.azure-hub-rg.location
  gateway_address       = azurerm_public_ip.site1-vpngw-ip.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.site1-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.site1-vpngw.bgp_settings[0].peering_addresses[0].default_addresses[0]
  }

  depends_on = [azurerm_virtual_network_gateway.site1-vpngw]
}

#########################################################
# Azure Hub Local Network Gateway to Site 2
#########################################################

resource "azurerm_local_network_gateway" "hub-lng-to-site2" {
  name                  = "hub-lng-to-site2"
  resource_group_name   = azurerm_resource_group.azure-hub-rg.name
  location              = azurerm_resource_group.azure-hub-rg.location
  gateway_address       = azurerm_public_ip.site2-vpngw-ip.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.site2-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.site2-vpngw.bgp_settings[0].peering_addresses[0].default_addresses[0]
  }

  depends_on = [azurerm_virtual_network_gateway.site2-vpngw]
}



#########################################################
# Connection Azure hub => On premise Site1
#########################################################
resource "azurerm_virtual_network_gateway_connection" "hub-to-site1" {
  name                = "${azurerm_virtual_network_gateway.hub-vpngw.name}-To-${azurerm_virtual_network_gateway.site1-vpngw.name}"
  resource_group_name   = azurerm_resource_group.azure-hub-rg.name
  location              = azurerm_resource_group.azure-hub-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub-lng-to-site1.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.hub-vpngw, azurerm_local_network_gateway.hub-lng-to-site1]
}

#########################################################
# Connection On premise Site1 => Azure hub 
#########################################################
resource "azurerm_virtual_network_gateway_connection" "site1-to-hub" {
  name                = "${azurerm_virtual_network_gateway.site1-vpngw.name}-To-${azurerm_virtual_network_gateway.hub-vpngw.name}"
  resource_group_name   = azurerm_resource_group.onprem-site1-rg.name
  location              = azurerm_resource_group.onprem-site1-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.site1-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.site1-lng.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.site1-vpngw, azurerm_local_network_gateway.site1-lng]
}

#########################################################
# Connection Azure hub => On premise Site2
#########################################################
resource "azurerm_virtual_network_gateway_connection" "hub-to-site2" {
  name                = "${azurerm_virtual_network_gateway.hub-vpngw.name}-To-${azurerm_virtual_network_gateway.site2-vpngw.name}"
  resource_group_name   = azurerm_resource_group.azure-hub-rg.name
  location              = azurerm_resource_group.azure-hub-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub-lng-to-site2.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.hub-vpngw, azurerm_local_network_gateway.hub-lng-to-site2]
}

#########################################################
# Connection On premise Site2 => Azure hub 
#########################################################
resource "azurerm_virtual_network_gateway_connection" "site2-to-hub" {
  name                = "${azurerm_virtual_network_gateway.site2-vpngw.name}-To-${azurerm_virtual_network_gateway.hub-vpngw.name}"
  resource_group_name   = azurerm_resource_group.onprem-site2-rg.name
  location              = azurerm_resource_group.onprem-site2-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.site2-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.site2-lng.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.site2-vpngw, azurerm_local_network_gateway.site2-lng]
}

