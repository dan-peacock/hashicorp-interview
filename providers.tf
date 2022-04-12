terraform {

  required_version = ">=0.12"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
      disable_terraform_partner_id = true
      tenant_id                    = var.tenant_id
      subscription_id              = var.subscription_id
      client_id                    = data.vault_azure_access_credentials.creds.client_id
      client_secret                = data.vault_azure_access_credentials.creds.client_secret
    }

    vault {
      address = "https://vault-cluster.vault.5b9819f8-78c7-4299-bd66-bed672713bca.aws.hashicorp.cloud:8200"
        auth_login {
          path = var.vault_username
          parameters = {
            password = var.vault_password
            }
        }
    }
  }
  
}