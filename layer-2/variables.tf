variable "location" {
  default = ""
}

variable "subscription_id" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "backend_storage_account_name" {
  default = ""
}

variable "backend_access_key" {
  default = ""
}
  
variable "layer_1_container_name" {
  default = "layer-1"
}
  
variable "layer_1_key" {
  default = "layer-1.terraform.tfstate"
}

variable "logic_app_workflow_name" {
  default = ""
}

variable "recipient_email" {
  default = ""
}

variable "rss_feed_url" {
  default = "https://feeds.a.dj.com/rss/RSSMarketsMain.xml"
}