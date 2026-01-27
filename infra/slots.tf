resource "azurerm_linux_web_app_slot" "green" {
  name           = "green"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}

resource "azurerm_linux_web_app_slot" "canary" {
  name           = "canary"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}
