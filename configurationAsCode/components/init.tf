# configure terraform to use an Azure Storage for sync all platform's state
terraform {
  backend "azurerm" {
    # storage_account_name = "willBeConfiguredByInitPhaseAndEnvironmentVar"
    container_name = "terraformstate"
    # key                  = "willBeConfiguredByInitPhaseAndEnvironmentVar"
    # access_key           = "willBeConfiguredByInitPhaseAndEnvironmentVar"
  }
}

module "certManager" {

  source = "../components/_certManager"

  labname            = var.labname
  location           = var.location
  dnsZone            = var.dnsZone
  subscriptionId     = var.subscriptionId
  clientid           = var.clientid
  clientsecret       = var.clientsecret
  certManagerVersion = var.certManagerVersion
}

module "jenkins" {

  source = "../components/_jenkins"

  labname        = var.labname
  location       = var.location
  dnsZone        = var.dnsZone
  subscriptionId = var.subscriptionId
  clientid       = var.clientid
  clientsecret   = var.clientsecret
  jenkinsVersion = var.jenkinsVersion
}

module "nexus" {

  source = "../components/_nexus"

  labname        = var.labname
  location       = var.location
  dnsZone        = var.dnsZone
  subscriptionId = var.subscriptionId
  clientid       = var.clientid
  clientsecret   = var.clientsecret
  nexusVersion   = var.nexusVersion
}

module "keycloak" {

  source = "../components/_keycloak"

  labname        = var.labname
  location       = var.location
  dnsZone        = var.dnsZone
  subscriptionId = var.subscriptionId
  clientid       = var.clientid
  clientsecret   = var.clientsecret
  nginxVersion   = var.nginxVersion
}

module "gitlab" {

  source = "../components/_gitlab"

  labname        = var.labname
  location       = var.location
  dnsZone        = var.dnsZone
  subscriptionId = var.subscriptionId
  clientid       = var.clientid
  clientsecret   = var.clientsecret
  gitlabVersion  = var.gitlabVersion
}

module "argocd" {

  source = "../components/_argocd"

  labname        = var.labname
  location       = var.location
  dnsZone        = var.dnsZone
  subscriptionId = var.subscriptionId
  clientid       = var.clientid
  clientsecret   = var.clientsecret
  argocdVersion  = var.argocdVersion
}

module "tekton" {

  source = "../components/_tekton"

  labname                = var.labname
  location               = var.location
  subscriptionId         = var.subscriptionId
  clientid               = var.clientid
  clientsecret           = var.clientsecret
  tektonVersion          = var.tektonVersion
  tektonDashboardVersion = var.tektonDashboardVersion
}

provider "azurerm" {
  # will receive configration by environment variables
  features {}
}