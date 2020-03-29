provider "azurerm" {
  version = "=2.3.0"
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "${var.instance-name}-resources"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                     = var.acr-name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  sku                      = "Basic"
  admin_enabled            = true

  provisioner "local-exec" {
    command = <<EOF
    docker build -t ${var.acr-name}.azurecr.io/${var.image-name}:latest .
    docker login ${var.acr-name}.azurecr.io \
      --username ${var.acr-name} \
      --password ${azurerm_container_registry.acr.admin_password}
    docker push ${var.acr-name}.azurecr.io/${var.image-name}:latest
EOF
  }
}

resource "azurerm_application_insights" "insights" {
  name                = "${var.instance-name}-appinsights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "other"
}

resource "azurerm_container_group" "example" {
  name                = "${var.instance-name}-continst"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "public"
  os_type             = "Linux"

  image_registry_credential {
    server = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = var.image-name
    image  = "${var.acr-name}.azurecr.io/${var.image-name}:latest"
    cpu    = "0.5"
    memory = "1.5"

    secure_environment_variables = {
      "APPLICATION_INSIGHTS_KEY" = azurerm_application_insights.insights.instrumentation_key
    }

    # Not needed, but terraform fails without it
    ports {
      port = 443
      protocol = "TCP"
    }
  }
}
