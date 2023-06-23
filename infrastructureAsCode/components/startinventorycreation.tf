#${element(azurerm_public_ip.pub.*.ip_address, count.index)}
data "template_file" "ansiblefile" {
  template = file("${path.module}/inventory.tpl")

  vars = {
    vmip_name = join("\n", azurerm_public_ip.pub.*.ip_address)
    user      = var.vmUserName
    pass      = var.vmPassword
    vmguac    = azurerm_public_ip.pubguac.ip_address
    fqdnguac  = azurerm_public_ip.pubguac.fqdn
  }
}


resource "local_file" "inventory_file" {
  content  = data.template_file.ansiblefile.rendered
  filename = "${var.labname}inventory"
}


resource "azurerm_storage_account" "inventory" {
  account_replication_type  = "RAGRS"
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  location                  = var.location
  name                      = "${var.labname}inventory"
  resource_group_name       = azurerm_resource_group.resourceGroup.name
  enable_https_traffic_only = true
}


resource "azurerm_storage_container" "inventoryContainer" {
  name                  = "vminventoryfiles"
  storage_account_name  = azurerm_storage_account.inventory.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "blobobject" {
  depends_on             = [local_file.inventory_file]
  name                   = "${var.labname}inventory"
  storage_account_name   = azurerm_storage_account.inventory.name
  storage_container_name = azurerm_storage_container.inventoryContainer.name
  type                   = "Block"
  source                 = "${var.labname}inventory"
}