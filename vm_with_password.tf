# vm  with public IP and password authentication
# also create virtual network 
provider "azurerm" {
features {}
  
}
# resource group 
resource "azurerm_resource_group" "ak" {
  name     = "akresorcegroup"
  location = "East Us"
}
## start virtualNetwork
# VPC
resource "azurerm_virtual_network" "aknet" {
  name                = "akVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ak.location
  resource_group_name = azurerm_resource_group.ak.name
}
# subnet
resource "azurerm_subnet" "aksubnet" {
  name                 = "akSubnet"
  resource_group_name  = azurerm_resource_group.ak.name
  virtual_network_name = azurerm_virtual_network.aknet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Network interface
resource "azurerm_network_interface" "aknic" {
  name                = "akNIC"
  location            = azurerm_resource_group.ak.location
  resource_group_name = azurerm_resource_group.ak.name

  ip_configuration {
    name                          = "akNICConfig"
    subnet_id                     = azurerm_subnet.aksubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.akpublic.id
  }
}
resource "azurerm_public_ip" "akpublic" {
  name                = "akPublicIP"
  location            = azurerm_resource_group.ak.location
  resource_group_name = azurerm_resource_group.ak.name
  allocation_method   = "Dynamic"  # You can also use "Static"
}
## end virtualNetwork 


# Now create vm 
resource "azurerm_linux_virtual_machine" "akvm" {
  name                  = "akVM"
  resource_group_name   = azurerm_resource_group.ak.name
  location              = azurerm_resource_group.ak.location
  size                  = "Standard_DS1_v2"
  admin_username        = "adminuser"
  admin_password        = "akash123@"
  network_interface_ids = [azurerm_network_interface.aknic.id]
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
# to get this 
# use :-akash@sky:~az vm image list --publisher canonical

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
# ip,username,password
output "public_ip" {
    value = azurerm_linux_virtual_machine.akvm.public_ip_address
}
output "username" {
    value = azurerm_linux_virtual_machine.akvm.admin_username
}
