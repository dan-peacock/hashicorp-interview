variable role_id {
  type= string
}
variable secret_id {
  type = string
}

variable VAULT_NAMESPACE {
  type = string
}

provider vault {
  address = "https://vault-cluster.vault.5b9819f8-78c7-4299-bd66-bed672713bca.aws.hashicorp.cloud:8200"
  auth_login {
    path = "auth/approle/login"
    namespace = "admin"
    parameters = {
      role_id = var.role_id
      secret_id = var.secret_id
    }
  }
}

data "vault_azure_access_credentials" "creds" {
  backend        = "azure"
  role           = "ns-msdn-contributor"
  validate_creds = true
}

provider "azurerm" {
  disable_terraform_partner_id = true
  version                      = "=2.65"
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

#Create Storage account
resource "azurerm_storage_account" "storage_account" {
  name                = "acmestoragedanp"
  resource_group_name = azurerm_resource_group.acme.name
  location                 = "ukwest"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
  }
}

#Add index.html to blob storage
resource "azurerm_storage_blob" "example" {
  for_each=fileset("${path.module}/website", "*")

  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/${each.value.source_path}"
}

