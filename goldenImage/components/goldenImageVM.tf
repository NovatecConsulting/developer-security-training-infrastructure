resource "azurerm_virtual_network" "vnetgold" {
  name                = "gold-vnet-goldenimage"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resourceGroup.name
}

resource "azurerm_subnet" "subnetgold" {
  name                 = "gold-subnet-goldenimage"
  resource_group_name  = data.azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.vnetgold.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pubgold" {
  name                = "gold-pub-goldenimage"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsggold" {
  name                = "gold-nsg-goldenimage"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resourceGroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Create network interface
resource "azurerm_network_interface" "nicgold" {
  name                = "gold-nic-goldenimage"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "gold-nictoip-goldenimage"
    subnet_id                     = azurerm_subnet.subnetgold.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubgold.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsgtonicgold" {
  network_interface_id      = azurerm_network_interface.nicgold.id
  network_security_group_id = azurerm_network_security_group.nsggold.id
}

resource "azurerm_virtual_machine" "vmgold" {
  name                          = "gold-vm-goldenimage"
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.resourceGroup.name
  network_interface_ids         = [azurerm_network_interface.nicgold.id]
  vm_size                       = var.vmSize
  delete_os_disk_on_termination = true
  depends_on                    = [azurerm_network_interface_security_group_association.nsgtonicgold]

  storage_os_disk {
    name              = "gold-vmOsDisk-goldenimage"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.vmDisktype #"Standard_LRS" 
  }

  storage_image_reference {
    publisher = var.vmPublisher #Canonical
    offer     = var.vmOffer     #UbuntuServer
    sku       = var.vmSku       #"16.04-DAILY-LTS"
    version   = var.vmVersion   #latest
  }

  os_profile {
    computer_name  = "gold-vm-goldenimage"
    admin_username = var.vmUserName
    admin_password = var.vmPassword

  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}

