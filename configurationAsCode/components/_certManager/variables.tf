data "azurerm_client_config" "current" {
  # lookup for azure resource manager's config
}

data "azurerm_resource_group" "main" {
  name = var.labname
  # access information about the existing Resource Group
}

data "azurerm_kubernetes_cluster" "main" {
  name                = "${var.labname}aks"
  resource_group_name = data.azurerm_resource_group.main.name
  # access the existing cluster
}

data "azurerm_dns_zone" "trainingsDnsZone" {
  name                = var.dnsZone
  resource_group_name = "securitytraining-common"
}

data "azurerm_subscription" "current" {
  subscription_id = var.subscriptionId
}

variable "clientid" {

}

variable "clientsecret" {

}

variable "location" {
  # will be provided as environment variable.
}

variable "labname" {
  # will be provided as environment variable.
}

variable "dnsZone" {
  # will be provided as environment variable.
}

variable "subscriptionId" {
  # will be provided as environment variable.
}
variable "certManagerVersion" {
  # will be provided as environment variable.
}
