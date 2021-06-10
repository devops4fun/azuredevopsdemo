terraform {
  backend "azurerm" {
    resource_group_name  = "mhjr-rg"
    storage_account_name = "mhjrstorage"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}