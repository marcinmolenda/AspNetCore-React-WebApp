data "terraform_remote_state" "infrastructure" {
  backend = "azurerm"
  config = {
    resource_group_name = "TerraformState"
    storage_account_name = "terraformstatex01"
    container_name = "state"
    key = "infrastructure.tfstate"
    subscription_id    = var.subscription_id
    client_id          = var.client_id
    tenant_id          = var.tenant_id
    use_oidc = true
   }
}