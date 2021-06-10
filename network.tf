resource "azurerm_resource_group" "eastus_rg_demo" {
  name     = "eastus_resource_group_demo"
  location = "East US"
}

resource "azurerm_network_security_group" "remote_access" {
  name                = "remote-access-sg"
  location            = azurerm_resource_group.eastus_rg_demo.location
  resource_group_name = azurerm_resource_group.eastus_rg_demo.name

  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "71.230.68.100"
    destination_address_prefix = "*"
  }
}

# resource "azurerm_network_ddos_protection_plan" "example" {
#   name                = "ddospplan1"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
# }

resource "azurerm_virtual_network" "eastus" {
  name                = "eastus_vnet"
  location            = azurerm_resource_group.eastus_rg_demo.location
  resource_group_name = azurerm_resource_group.eastus_rg_demo.name
  address_space       = ["10.200.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.200.2.0/28"
    security_group = azurerm_network_security_group.remote_access.id
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.200.3.0/28"
    security_group = azurerm_network_security_group.remote_access.id
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.200.4.0/28"
    security_group = azurerm_network_security_group.remote_access.id
  }

  tags = {
    environment = var.environment
  }
}