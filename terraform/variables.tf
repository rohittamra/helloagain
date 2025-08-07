variable "prefix" {
  type    = string
  default = "myaks"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "ssh_key_data" {
  type    = string
  description = "Public SSH key data for node pool (e.g. file(\"~/.ssh/id_rsa.pub\"))"
  default = ""
}

variable "node_vm_size" {
  type    = string
  default = "Standard_D4s_v3"
}
