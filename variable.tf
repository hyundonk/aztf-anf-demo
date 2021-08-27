variable "resource_group_name" {}
variable "location" {}

variable "networking_object" {}

variable "pip" {}
variable "vm" {}

variable "num_disk" {}
variable "use_dedicated_host" {
  default = true
}

variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {}

