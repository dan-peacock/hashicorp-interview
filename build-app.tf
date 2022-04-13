variable role_id {
  type= string
}
variable secret_id {
  type = string
}

provider "vault" {
  address = "https://vault-SP.vault.5b9819f8-78c7-4299-bd66-bed672713bca.aws.hashicorp.cloud:8200"
  auth_login {
    path = "auth/approle/login"
     parameters = {
      role_id   = var.role_id
      secret_id = var.secret_id
    }
    #namespace = "admin"
  }
}

data "vault_azure_access_credentials" "creds" {
  backend        = "azure"
  role           = "ns-msdn-contributor"
  validate_creds = true
}

provider "azurerm" {
  disable_terraform_partner_id = true
  version                      = "=2.0"
  tenant_id                    = var.tenant_id
  subscription_id              = var.subscription_id
  client_id                    = data.vault_azure_access_credentials.creds.client_id
  client_secret                = data.vault_azure_access_credentials.creds.client_secret
  features {}
}

# Create the resource group
resource "azurerm_resource_group" "acme" {
  name     = "acme"
  location = "westeurope"
}

# # Create the Linux App Service Plan
# resource "azurerm_app_service_plan" "sp-webapp-acme-1" {
#   name                = "sp-webapp-acme-1"
#   location            = azurerm_resource_group.acme.location
#   resource_group_name = azurerm_resource_group.acme.name
#   sku {
#     tier = "Free"
#     size = "F1"
#   }
# }

# # Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo
# resource "azurerm_app_service" "sa-webapp-acme-1" {
#   name                = "sa-webapp-acme-1"
#   location            = azurerm_resource_group.acme.location
#   resource_group_name = azurerm_resource_group.acme.name
#   app_service_plan_id = azurerm_app_service_plan.sp-webapp-acme-1.id
#   source_control {
#     repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
#     branch             = "master"
#     manual_integration = true
#     use_mercurial      = false
#   }
# }




