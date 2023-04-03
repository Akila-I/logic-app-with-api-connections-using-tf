# crete resource group
resource "azurerm_resource_group" "rg-logic-app-rss-gmail" {
  name     = var.resource_group_name
  location = var.location
}

# create rss connection
resource "azapi_resource" "rss_connection" {
  type      = "Microsoft.Web/connections@2016-06-01"
  name      = "rss"
  location  = var.location
  parent_id = azurerm_resource_group.rg-logic-app-rss-gmail.id

  body = <<EOF
  {
      "properties": {
          "displayName": "RSS",
          "statuses": [
              {
                  "status": "Connected"
              }
          ],
          "parameterValues": {},
          "customParameterValues": {},
          "api": {
              "name": "rss",
              "displayName": "RSS",
              "description": "RSS is a popular web syndication format used to publish frequently updated content – like blog entries and news headlines.  Many content publishers provide an RSS feed to allow users to subscribe to it.  Use the RSS connector to retrieve feed information and trigger flows when new items are published in an RSS feed.",
              "iconUri": "https://connectoricons-prod.azureedge.net/u/laborbol/releases/ase-v3/1.0.1622.3202/rss/icon.png",
              "brandColor": "#ff9900",
              "id": "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${var.location}/managedApis/rss",
              "type": "Microsoft.Web/locations/managedApis"
          },
          "testLinks": []
      }
  }
  EOF
}

# create gmail connection
resource "azapi_resource" "gmail_connection" {
  type      = "Microsoft.Web/connections@2016-06-01"
  name      = "gmail"
  location  = var.location
  parent_id = azurerm_resource_group.rg-logic-app-rss-gmail.id

  body = <<EOF
  {
    "properties": {
        "displayName": "Gmail",
        "statuses": [
             {
                "status": "Connected"
            }
        ],
        "parameterValues": {},
        "nonSecretParameterValues": {},
        "customParameterValues": {
        },
        "api": {
            "name": "gmail",
            "displayName": "Gmail",
            "description": "Gmail is a web-based email service from Google. With the Gmail connector, you can perform actions such as send or receive e-mail messages, and trigger flows on new e-mails.",
            "iconUri": "https://connectoricons-prod.azureedge.net/u/laborbol/releases/ase-v3-99-la-only-no-gov/1.0.1622.3206/gmail/icon.png",
            "brandColor": "#20427f",
            "id": "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${var.location}/managedApis/gmail",
            "type": "Microsoft.Web/locations/managedApis"
        },
        "testLinks": [
            {
                "requestUri": "https://management.azure.com:443/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Web/connections/gmail/extensions/proxy/TestConnection?api-version=2018-07-01-preview",
                "method": "get"
            }
        ]
    }
  }
  EOF
}
