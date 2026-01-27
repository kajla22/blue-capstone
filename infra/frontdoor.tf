resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "fd-capstone-profile"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "fd-capstone-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = "app-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  health_probe {
    interval_in_seconds = 30
    path                = "/"
    protocol            = "Https"
    request_type        = "GET"
  }

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 2
  }
}

resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  name                          = "app-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  host_name          = azurerm_linux_web_app.webapp.default_hostname
  origin_host_header = azurerm_linux_web_app.webapp.default_hostname
  http_port          = 80
  https_port         = 443

  certificate_name_check_enabled = true
  enabled                        = true

  priority = 1
  weight   = 1000
}

resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.fd_origin.id
  ]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  link_to_default_domain = true

  depends_on = [
    azurerm_cdn_frontdoor_origin.fd_origin
  ]
}

