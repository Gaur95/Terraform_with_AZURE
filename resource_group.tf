provider "azurerm" {
features {}
  
}
resource "azurerm_resource_group" "ak" {
  name     = "akresorcegroup"
  location = "East Us"
}