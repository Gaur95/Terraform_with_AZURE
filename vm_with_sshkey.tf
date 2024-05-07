# If we need to create a VM, the first step is to create a NIC (Network Interface Card) and PUBLIC_IP if we use existed virtual network .
# also get subnet id of azurerm subnet .
provider "azurerm" {
features {}
  
}
# resource group 
resource "azurerm_resource_group" "ak" {
  name     = "akresorcegroup"
  location = "East Us"
}
# PUBLIC IP
resource "azurerm_public_ip" "akpublic1" {
  name                = "akPublicIP1"
  resource_group_name   = azurerm_resource_group.ak.name
  location              = azurerm_resource_group.ak.location
  allocation_method   = "Dynamic"  # You can also use "Static"
}
# NIC
resource "azurerm_network_interface" "aknic1" {
  name                = "akNIC1"
 resource_group_name   = azurerm_resource_group.ak.name
  location              = azurerm_resource_group.ak.location

  ip_configuration {
    name                          = "akNICConfig1"
    subnet_id                     = "/subscriptions/d6149973-b7ed-4f45-a98d-b6f73494887f/resourceGroups/akresorcegroup/providers/Microsoft.Network/virtualNetworks/akVnet/subnets/akSubnet"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.akpublic1.id
  }
}
# NOW VM
resource "azurerm_linux_virtual_machine" "akvm1" {
  name                  = "myUbuntuVM"
  resource_group_name   = azurerm_resource_group.ak.name
  location              = azurerm_resource_group.ak.location
  size                  = "Standard_DS1_v2"
  admin_username        = "adminuser"
  disable_password_authentication = true  # Disable password-based authentication
  network_interface_ids = [azurerm_network_interface.aknic1.id]


    admin_ssh_key {
      username = "adminuser"
      public_key = file("/home/akash/.ssh/id_rsa.pub")  # SSH public key data
    }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
# to get public ip
output "public_ip_address" {
  value = azurerm_linux_virtual_machine.akvm1.public_ip_address
}
