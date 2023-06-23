# configure terraform to use an Azure Storage for sync all platform's state
terraform {
  backend "azurerm" {
    # storage_account_name = "willBeConfiguredByInitPhaseAndEnvironmentVar"
    container_name = "terraformstate"
    # key                  = "willBeConfiguredByInitPhaseAndEnvironmentVar"
    # access_key           = "willBeConfiguredByInitPhaseAndEnvironmentVar"
  }
}

module "components" {
  source                = "./components"
  labname               = var.labname
  SAACCOUNTNAME         = var.SAACCOUNTNAME
  location              = var.location
  labNumberParticipants = var.labNumberParticipants
  vmUserName            = var.vmUserName
  vmPassword            = var.vmPassword
  vmSize                = var.vmSize
  vmSizeAks             = var.vmSizeAks
  vmSizeGuac            = var.vmSizeGuac
  vmDisktype            = var.vmDisktype
  vmLang                = var.vmLang
  clientid              = var.clientid
  clientsecret          = var.clientsecret
  vmSku                 = var.vmSku
  vmPublisher           = var.vmPublisher
  vmOffer               = var.vmOffer
  vmVersion             = var.vmVersion
  nodecount             = var.nodecount
  rsgcommon             = var.rsgcommon
}

# -------------------------
# as env-variables are use to pass information to the module,
# they are needed to be defined here as well
# inside the module, environmentVsariables.tf is taking care of variables

variable "clientid" {

}

variable "clientsecret" {

}

variable "SAACCOUNTNAME" {

}

variable "location" {
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

variable "rsgcommon" {
  # will be provided as environment variable.

}

provider "azurerm" {
  # will receive configration by environment variables
  version                    = "2.32.0"
  skip_provider_registration = "true" #do not register all ressources of this provider - because we work in a restricted env
  features {}
}
