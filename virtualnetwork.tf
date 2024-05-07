# virtual network with public IP address
provider "azurerm" {
features {}
  
}
# resource group 
resource "azurerm_resource_group" "ak" {
  name     = "akresorcegroup"
  location = "East Us"
}

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
# public IP
resource "azurerm_public_ip" "akpublic" {
  name                = "akPublicIP"
  location            = azurerm_resource_group.ak.location
  resource_group_name = azurerm_resource_group.ak.name
  allocation_method   = "Dynamic"  # You can also use "Static"
}
