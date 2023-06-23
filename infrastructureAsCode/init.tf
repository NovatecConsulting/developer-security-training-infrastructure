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
  aksVersion            = var.aksVersion
  location              = var.location
  labNumberParticipants = var.labNumberParticipants
  vmUserName            = var.vmUserName
  vmPassword            = var.vmPassword
  vmSize                = var.vmSize
  vmSizeGuac            = var.vmSizeGuac
  vmSizeAks             = var.vmSizeAks
  nodecount             = var.nodecount
  vmDisktype            = var.vmDisktype
  vmLang                = var.vmLang
  clientid              = var.clientid
  clientsecret          = var.clientsecret
  vmSku                 = var.vmSku
  vmPublisher           = var.vmPublisher
  vmOffer               = var.vmOffer
  vmVersion             = var.vmVersion
  gal                   = var.gal
  vmGoldenImageName     = var.vmGoldenImageName
  vmGoldenImageVersion  = var.vmGoldenImageVersion
  rsgcommon             = var.rsgcommon
  dnsZone               = var.dnsZone
  nginxVersion          = var.nginxVersion

}

# -------------------------
# as env-variables are use to pass information to the module,
# they are needed to be defined here as well
# inside the module, environmentVariables.tf is taking care of variables

variable "clientid" {

}

variable "clientsecret" {

}

variable "dnsZone" {
  # will be provided as environment variable.
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

variable "vmSizeAks" {
  # will be provided as environment variable.
}
variable "nodecount" {
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

provider "azurerm" {
  # will receive configration by environment variables
  features {}
}
