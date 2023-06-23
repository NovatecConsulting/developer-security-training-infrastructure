data "azurerm_client_config" "current" {
  # lookup for azure resource manager's config
}

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
  # will be provided as HARDCODED environment variable based upon Playground created RSG Name

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