resource_group_name="deleteme-anftest"
location="koreacentral"

networking_object                 = {
  vnet = {
      name                = "-vnet"
      address_space       = ["10.10.0.0/16"]
      dns                 = []
  }
  specialsubnets = {
  }

  subnets = {
    frontend   = {
      name                = "frontend"
      cidr                = "10.10.0.0/24"
      service_endpoints   = []
      nsg_name            = "frontend"
    }
  }
}

pip = {
  0               = {
    name          = "deleteme-bastion"
  }
}

# use_dedicated_host = false # default is true. unblock this if you don't want to use dedicated host

vm = {
  name          = "deleteme-bastion"

  vm_num        = 1
  vm_size       = "Standard_E64s_v3"
    
  subnet_ip_offset  = 4
 
  vm_publisher      = "Canonical"
  vm_offer          = "UbuntuServer"
  vm_sku            = "18.04-LTS"
  vm_version        = "latest" 
}

num_disk = 3 

# admin_username="{Enter VM admin username here}"
# admin_password="{Enter VM admin password here}"
