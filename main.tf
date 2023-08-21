provider "azurerm" {
subscription_id = "${var.subscription_id}"
client_id = "${var.client_id}"
client_secret = "${var.client_secret}"
tenant_id = "${var.tenant_id}"
features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "802terraform"
    container_name       = "tfstate"
    key                  = "devpipeline.terraform.tfstate"
  }
}



# Create a resource group
resource "azurerm_resource_group" "primary" {
  name     = "tf_rg_storageaccount"
  location = "eastus"
}

# Create Azure Storage Account required for Function App
resource azurerm_storage_account "primary" {
  name                     = "tfsastorageaccount802"
  resource_group_name      = azurerm_resource_group.primary.name
  location                 = azurerm_resource_group.primary.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource azurerm_storage_container "tfcontainer1" {
  name                  = "tfcontainer1"
  storage_account_name  = azurerm_storage_account.primary.name
  container_access_type = "private"
}