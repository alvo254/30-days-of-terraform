terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "westus2"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_cdn_profile" "example" {
  name                = "example-cdn"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard_Verizon"
}

resource "azurerm_cdn_endpoint" "example" {
  name                = "example"
  profile_name        = azurerm_cdn_profile.example.name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  origin {
    name      = "example"
    host_name = "www.contoso.com"
  }
}


resource "azurerm_cognitive_account" "example" {
  name                = "example-account"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Face"

  sku_name = "S0"

  tags = {
    Acceptance = "Test"
  }
}


data "azurerm_client_config" "current" {}
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West US"
}

resource "azurerm_user_assigned_identity" "example" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  name                = "example-identity"
}

resource "azurerm_cognitive_account" "example" {
  name                  = "example-account"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  kind                  = "Face"
  sku_name              = "E0"
  custom_subdomain_name = "example-account"
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }
}

resource "azurerm_key_vault" "example" {
  name                     = "example-vault"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true

  access_policy {
    tenant_id = azurerm_cognitive_account.example.identity.0.tenant_id
    object_id = azurerm_cognitive_account.example.identity.0.principal_id
    key_permissions = [
      "Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"
    ]
    secret_permissions = [
      "Get",
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"
    ]
    secret_permissions = [
      "Get",
    ]
  }

  access_policy {
    tenant_id = azurerm_user_assigned_identity.example.tenant_id
    object_id = azurerm_user_assigned_identity.example.principal_id
    key_permissions = [
      "Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"
    ]
    secret_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_key" "example" {
  name         = "example-key"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

resource "azurerm_cognitive_account_customer_managed_key" "example" {
  cognitive_account_id = azurerm_cognitive_account.example.id
  key_vault_key_id     = azurerm_key_vault_key.example.id
  identity_client_id   = azurerm_user_assigned_identity.example.client_id
}



resource "azurerm_availability_set" "example" {
  name                = "example-aset"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = "Production"
  }
}
