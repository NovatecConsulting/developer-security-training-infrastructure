data "azurerm_shared_image" "image" {
  name                = var.vmGoldenImageName
  gallery_name        = var.gal
  resource_group_name = var.rsgcommon
}

data "azurerm_shared_image_version" "image_version" {
  name                = "latest" #var.vmGoldenImageVersion
  image_name          = data.azurerm_shared_image.image.name
  gallery_name        = var.gal
  resource_group_name = var.rsgcommon
}


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.labname}-vnet-${count.index}"
  count               = var.labNumberParticipants
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.labname}-subnet-${count.index}"
  count                = var.labNumberParticipants
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = element(azurerm_virtual_network.vnet.*.name, count.index)
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pub" {
  name                = "${var.labname}-pub-${count.index}"
  count               = var.labNumberParticipants
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.labname}-nsg-${count.index}"
  count               = var.labNumberParticipants
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

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

  security_rule {
    name                       = "todoui"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8090"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "todobackend"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.labname}-nic-${count.index}"
  count               = var.labNumberParticipants
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "${var.labname}-nictoip-${count.index}"
    subnet_id                     = element(azurerm_subnet.subnet.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.pub.*.id, count.index)
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsgtonic" {
  count                     = var.labNumberParticipants
  network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = element(azurerm_network_security_group.nsg.*.id, count.index)
}

resource "azurerm_virtual_machine" "vm" {
  name                          = "${var.labname}-vm-${count.index}"
  count                         = var.labNumberParticipants
  location                      = var.location
  resource_group_name           = azurerm_resource_group.resourceGroup.name
  network_interface_ids         = [element(azurerm_network_interface.nic.*.id, count.index)]
  vm_size                       = var.vmSize
  delete_os_disk_on_termination = true
  depends_on                    = [azurerm_network_interface_security_group_association.nsgtonic]

  storage_image_reference {
    id = data.azurerm_shared_image_version.image_version.id
  }

  storage_os_disk {
    name              = "${var.labname}-vmOsDisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.vmDisktype #"Standard_LRS" 
  }


  os_profile {
    computer_name  = "${var.labname}-vm-${count.index}"
    admin_username = var.vmUserName
    admin_password = var.vmPassword

  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}