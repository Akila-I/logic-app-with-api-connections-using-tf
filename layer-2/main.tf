# Configure remote state of layer 1 to reach its outputs
data "terraform_remote_state" "layer_1" {
  backend = "azurerm"
  config = {
    storage_account_name = var.backend_storage_account_name
    container_name       = var.layer_1_container_name
    key                  = var.layer_1_key
    access_key           = var.backend_access_key
  }
}

# create logic app
resource "azapi_resource" "logic_app_workflow" {
  type      = "Microsoft.Logic/workflows@2019-05-01"
  name      = var.logic_app_workflow_name
  location  = var.location
  parent_id = data.terraform_remote_state.layer_1.outputs.resource_group_id

  body = <<EOF
  {
      "properties": {
          "state": "Enabled",
          "definition": {
              "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                  "$connections": {
                      "defaultValue": {},
                      "type": "Object"
                  }
              },
              "triggers": {
                  "When_a_feed_item_is_published": {
                      "recurrence": {
                          "frequency": "Hour",
                          "interval": 1
                      },
                      "evaluatedRecurrence": {
                          "frequency": "Hour",
                          "interval": 1
                      },
                      "splitOn": "@triggerBody()?['value']",
                      "type": "ApiConnection",
                      "inputs": {
                          "host": {
                              "connection": {
                                  "name": "@parameters('$connections')['rss']['connectionId']"
                              }
                          },
                          "method": "get",
                          "path": "/OnNewFeed",
                          "queries": {
                              "feedUrl": "${var.rss_feed_url}",
                              "sinceProperty": "PublishDate"
                          }
                      }
                  }
              },
              "actions": {
                  "Send_email_(V2)_2": {
                      "runAfter": {},
                      "type": "ApiConnection",
                      "inputs": {
                          "body": {
                              "Body": "<p>New RSS feed is published! Here is the summary:<br>\n<br>\nTitle: @{triggerBody()?['title']}<br>\nPublished on : @{triggerBody()?['publishDate']}<br>\nLink : @{triggerBody()?['primaryLink']}</p>",
                              "Subject": "NEW FEED : @{triggerBody()?['title']}",
                              "To": "${var.recipient_email}"
                          },
                          "host": {
                              "connection": {
                                  "name": "@parameters('$connections')['gmail']['connectionId']"
                              }
                          },
                          "method": "post",
                          "path": "/v2/Mail"
                      }
                  }
              },
              "outputs": {}
          },
          "parameters": {
              "$connections": {
                  "value": {
                      "gmail": {
                          "connectionId": "${data.terraform_remote_state.layer_1.outputs.gmail_connection_id}",
                          "connectionName": "gmail",
                          "id": "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${var.location}/managedApis/gmail"
                      },
                      "rss": {
                          "connectionId": "${data.terraform_remote_state.layer_1.outputs.rss_connection_id}",
                          "connectionName": "rss",
                          "id": "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${var.location}/managedApis/rss"
                      }
                  }
              }
          }
      }
  }
  EOF
}
