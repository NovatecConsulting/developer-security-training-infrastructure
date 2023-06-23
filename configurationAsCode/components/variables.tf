data "azurerm_resource_group" "main" {
  name = var.labname
  # access information about the existing Resource Group
}

data "azurerm_kubernetes_cluster" "main" {
  name                = "${var.labname}aks"
  resource_group_name = data.azurerm_resource_group.main.name
  # access the existing cluster
}

# -------------------------
# as env-variables are use to pass information to the module,
# they are needed to be defined here as well
# inside the module, environmentVariables.tf is taking care of variables

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

variable "jenkinsVersion" {
  # will be provided as environment variable.
}

variable "nexusVersion" {
  # will be provided as environment variable.
}

variable "certManagerVersion" {
  # will be provided as environment variable.
}

variable "nginxVersion" {
  # will be provided as environment variable.
}

variable "gitlabVersion" {
  # will be provided as environment variable.
}

variable "argocdVersion" {
  # will be provided as environment variable.
}

variable "tektonVersion" {
  # will be provided as environment variable.
}

variable "tektonDashboardVersion" {
  # will be provided as environment variable.
}
