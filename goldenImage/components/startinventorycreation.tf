data "template_file" "ansiblefilegold" {
  template = file("${path.module}/inventory.tpl")

  vars = {
    vmip_name = azurerm_public_ip.pubgold.ip_address
    user      = var.vmUserName
    pass      = var.vmPassword
  }

}

resource "local_file" "inventory_file" {
  content  = data.template_file.ansiblefilegold.rendered
  filename = "ansibleinventorygold"
}

data "azurerm_storage_container" "inventoryContainer" {
  name                 = "vminventoryfiles"
  storage_account_name = var.SAACCOUNTNAME
}

resource "azurerm_storage_blob" "blobobject" {
  depends_on             = [local_file.inventory_file]
  name                   = "ansibleinventorygold"
  storage_account_name   = var.SAACCOUNTNAME
  storage_container_name = data.azurerm_storage_container.inventoryContainer.name
  type                   = "Block"
  source                 = "ansibleinventorygold"
} 