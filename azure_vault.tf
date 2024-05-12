provider "azurerm" {
features {}
  
}
# resource group 
resource "azurerm_resource_group" "ak" {
  name     = "akresorcegroup"
  location = "East Us"
}

resource "azurerm_key_vault" "ak_vault" {
  name                        = "myKeyVault"
  location                    = azurerm_resource_group.ak.location
  resource_group_name         = azurerm_resource_group.ak.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
 key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

data "azurerm_client_config" "current" {}

output "key_vault_uri" {
  value = azurerm_key_vault.ak_vault.vault_uri
}
