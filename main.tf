terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }
}

provider "azurerm" {
 features {}
}

resource "azurerm_resource_group" "MyRG" {
  name     = "MyRG"
  location = "East US"
}

resource "azurerm_service_plan" "myweapplan" {
  name                = "webapp-plan4320"
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "mywebapp" {
  name                = "wepapp-linux01"
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location
  service_plan_id     = azurerm_service_plan.myweapplan.id

  site_config {
    application_stack {
      php_version = "8.0"
    }
  }
}

resource "azurerm_app_service_source_control" "source_control" {
  app_id   = azurerm_linux_web_app.mywebapp.id
  repo_url = "https://github.com/gvndverma787/simple-php-website.git"
  branch   = "master"
}

  output "app_url" {
    value = azurerm_linux_web_app.mywebapp.default_hostname
    description = "show the url"
  }