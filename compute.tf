resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  location            = azurerm_resource_group.eastus_rg_demo.location
  resource_group_name = azurerm_resource_group.eastus_rg_demo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.demo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo.id
  }
}

resource "azurerm_public_ip" "demo" {
  name                = "public_ip_1"
  resource_group_name = azurerm_resource_group.eastus_rg_demo.name
  location            = azurerm_resource_group.eastus_rg_demo.location
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm_1_demo" {
  name                = "windowsvm"
  resource_group_name = azurerm_resource_group.eastus_rg_demo.name
  location            = azurerm_resource_group.eastus_rg_demo.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

output "public_ip" {
  value = azurerm_public_ip.demo.ip_address
}

data "azurerm_virtual_network" "eastus" {
  name                = "eastus_vnet"
  resource_group_name = azurerm_resource_group.eastus_rg_demo.name
}

data "azurerm_subnet" "demo" {
  name                 = data.azurerm_virtual_network.eastus.subnets[0]
  virtual_network_name = azurerm_virtual_network.eastus.name
  resource_group_name  = azurerm_resource_group.eastus_rg_demo.name
}

output "subnet_ids" {
  value = data.azurerm_subnet.demo.id
}