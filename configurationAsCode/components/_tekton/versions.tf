terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
# Adding this to every module that uses third-party providers solved the problem described below
# https://discuss.hashicorp.com/t/using-a-non-hashicorp-provider-in-a-module/21841/2
