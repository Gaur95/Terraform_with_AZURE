#An Azure storage account is a container for data objects like files, blobs, tables, and queues. 
provider "azurerm" {
features {}
  
}
# resource group 
resource "azurerm_resource_group" "ak" {
  name     = "akresorcegroup"
  location = "East Us"
}

resource "azurerm_storage_account" "akstorage" {
  name                     = "akstorageaccount"
  resource_group_name      = azurerm_resource_group.ak.name
  location                 = azurerm_resource_group.ak.location
  account_tier             = "Standard"
  account_replication_type = "LRS"  # we can also use ZRS ,GRS ,GZRS
}
