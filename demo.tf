locals {
  resource_group_name   = var.resource_group_name
  location              = var.location
  admin_username        = var.admin_username
  admin_password        = var.admin_password
}

resource "azurerm_resource_group" "example" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_dedicated_host_group" "example" {
  count                       = var.use_dedicated_host ? 1 : 0
  name                        = "my-host-group"
  resource_group_name         = azurerm_resource_group.example.name
  location                    = azurerm_resource_group.example.location
  platform_fault_domain_count = 2
}

resource "azurerm_dedicated_host" "example" {
  count                       = var.use_dedicated_host ? 1 : 0

  name                    = "example-host"
  location                = azurerm_resource_group.example.location
  dedicated_host_group_id = azurerm_dedicated_host_group.example.0.id
  sku_name                = "ESv3-Type1"
  platform_fault_domain   = 1
}

module "virtual_network" {
  source  = "github.com/hyundonk/terraform-azurerm-caf-virtual-network"

  prefix              = "demo"

  virtual_network_rg  = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  networking_object   = var.networking_object

  tags            = {}
}

module "pip" {
  source                            = "git://github.com/hyundonk/aztf-module-pip.git"

  prefix                            = "demo"
  services                          = var.pip

  location                          = azurerm_resource_group.example.location
  rg                                = azurerm_resource_group.example.name

  tags                              = {}
}


resource "azurerm_network_interface" "example" {
  name                = "demo-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.virtual_network.subnet_ids_map["frontend"]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = module.pip.public_ip.0.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  								= var.vm.name
  resource_group_name 	                = local.resource_group_name
  location        	   	                = local.location
  size               	                  = var.vm.vm_size

  admin_username        = local.admin_username
  admin_password        = local.admin_password

  disable_password_authentication = false 
  
  os_disk {
    caching       		    = "ReadWrite"
    storage_account_type 	= "Premium_LRS"
  }


  source_image_reference {
    publisher             = var.vm.vm_publisher
    offer                 = var.vm.vm_offer
    sku                   = var.vm.vm_sku
    version               = var.vm.vm_version
  }

  network_interface_ids   = [azurerm_network_interface.example.id]

  dedicated_host_id = var.use_dedicated_host ? azurerm_dedicated_host.example.0.id : null

  tags = {}
}

resource "azurerm_managed_disk" "example" {
  count = var.num_disk

  name                 = "datadisk${count.index+1}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1024"
}

resource "azurerm_virtual_machine_data_disk_attachment" "lun0" {
  count = var.num_disk

  managed_disk_id    = element(azurerm_managed_disk.example.*.id, count.index)
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id

  lun                = count.index
  caching            = "None"
}

output "pip" {
  value = module.pip.public_ip
}


