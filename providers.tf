terraform {

  required_version = ">=0.12"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }


provider "azurerm" {
  features {}
}

provider "vault" {
  address = "https://vault-cluster.vault.5b9819f8-78c7-4299-bd66-bed672713bca.aws.hashicorp.cloud:8200"

  auth_login {
    path = var.vault_username

    parameters = {
      password = var.vault_password
    }
  }
}

}