

resource "azurerm_subnet" "example" {
  name                 = "anf-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = module.virtual_network.vnet_obj.name
  address_prefixes     = ["10.10.2.0/24"]

  delegation {
    name = "netapp"

    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_netapp_account" "example" {
  name                = "example-netappaccount"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_netapp_pool" "example" {
  name                = "example-netapppool"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  account_name        = azurerm_netapp_account.example.name
  service_level       = "Premium"
  size_in_tb          = 4
}

resource "azurerm_netapp_volume" "example" {
  name                       = "example-netappvolume"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  account_name               = azurerm_netapp_account.example.name
  pool_name                  = azurerm_netapp_pool.example.name
  volume_path                = "mynfsvolume"
  service_level              = "Premium"
  subnet_id                  = azurerm_subnet.example.id
  protocols                  = ["NFSv4.1"]
  security_style             = "Unix"
  storage_quota_in_gb        = 3000

  export_policy_rule {
    rule_index      = 1
    allowed_clients = [module.virtual_network.subnet_prefix_map["frontend"]]
    protocols_enabled = ["NFSv4.1"]
    unix_read_write = true
    root_access_enabled = true
  }
}
