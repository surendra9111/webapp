# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.23.0"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id   = "b85b9f92-2303-4d3f-b13b-09cee95b4fab"
  tenant_id         = "896c7046-33cf-4af1-a97e-9d1d58c5107a"
  client_id         = "ce3eb8de-088a-4fe6-b8ff-cbe47e580f99"
  client_secret     = "3TP8Q~gBNG2RpWhR1e9-C.jgRZ6STcBK4c3USa~k"
}

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999 
}
# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "webapp-rg-${random_integer.ri.result}"
  location = "west us 3"
}
# Create the Linux App Service Plan
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "webapp-asp-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}
# Create the web app, pass in the App Service Plan ID, and deploy code from a public GitHub repo
resource "azurerm_app_service" "pizzahut-dummy2" {
  name                = "pizzahut-dummy2-${random_integer.ri.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  source_control {
    repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }
}