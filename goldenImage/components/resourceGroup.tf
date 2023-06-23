# We provide this only as data - because TF could not create the labname (RSG) 
# RSG'S are created through Azure Dev Test Labs Playground base. 
# Use automatic generated name of the RSG here.  
data "azurerm_resource_group" "resourceGroup" {
  name = var.rsgcommon
}