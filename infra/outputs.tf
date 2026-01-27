output "frontdoor_url" {
  value = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}
