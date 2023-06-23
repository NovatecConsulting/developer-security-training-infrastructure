resource "azurerm_public_ip" "loadBalancerIp" {
  name                = "${var.labname}-nginx-PublicIp"
  resource_group_name = "MC_${azurerm_resource_group.resourceGroup.name}_${azurerm_kubernetes_cluster.k8scluster.name}_${var.location}"
  location            = var.location
  allocation_method   = "Static"
  zones               = [1]
  sku                 = "Standard"
}

data "azurerm_client_config" "current" {
  # lookup for azure resource manager's config
}

data "azurerm_dns_zone" "trainingsDnsZone" {
  name                = var.dnsZone
  resource_group_name = "securitytraining-common"
}

variable "dnsZone" {
  # will be provided as environment variable.
}

variable "clientid" {

}

variable "clientsecret" {

}

variable "location" {
  # will be provided as environment variable.
}

variable "aksVersion" {
  # will be provided as environment variable.
}

variable "labname" {
  # will be provided as environment variable.
}

variable "labNumberParticipants" {
  # will be provided as environment variable.
}

variable "vmUserName" {
  # will be provided as environment variable.
}

variable "vmPassword" {
  # will be provided as environment variable.
}

variable "vmSize" {
  # will be provided as environment variable.
}

variable "vmSizeGuac" {
  # will be provided as environment variable.
}

variable "vmDisktype" {
  # will be provided as environment variable.
}

variable "vmSku" {
  # will be provided as environment variable.
}

variable "vmPublisher" {
  # will be provided as environment variable.
}

variable "vmOffer" {
  # will be provided as environment variable.
}
variable "vmVersion" {
  # will be provided as environment variable.
}
variable "vmLang" {
  # will be provided as environment variable.
}

variable "vmSizeAks" {
  # will be provided as environment variable.
}
variable "nodecount" {
  # will be provided as environment variable.
}

variable "gal" {
  # will be provided as environment variable.

}

variable "vmGoldenImageName" {
  # will be provided as environment variable.

}

variable "vmGoldenImageVersion" {
  # will be provided as environment variable.

}

variable "rsgcommon" {
  # will be provided as environment variable.

}

variable "nginxVersion" {
  # will be provided as environment variable.
}
