# virtual network with public IP address
provider "azurerm" {
features {}
  
}
# resource group 
resource "azurerm_resource_group" "ak" {
  name     = "akresorcegroup"
  location = "East Us"
}

# azure vritual network
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
