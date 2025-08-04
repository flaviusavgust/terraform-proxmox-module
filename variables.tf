variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL for connect"
  default     = "https://10.226.96.1:8006/api2/json"
}

variable "proxmox_user" {
  type        = string
  description = "Proxmox username for connect"
}

variable "proxmox_password" {
  type        = string
  description = "Proxmox password for connect"
}

variable "proxmox_tls_insecure" {
  description = "Verify SSL certificate or not"
  default     = true
}

variable "sshkeys" {
  type        = string
  description = "SSH public key"
}

variable "data_disk_storage" {
  type        = string
  description = "Data disk storage"
  default     = null
}

variable "virtual_machines" {
  description = "Map of Virtual Machines"
  type = map(object({
    target_node            = string
    pool                   = string
    clone_template_name    = string
    vmid                   = number
    memory                 = number
    sockets                = number
    cores                  = number
    main_disk_storage      = string
    main_disk_storage_size = string
    data_disk_storage      = optional(string)
    data_disk_storage_size = optional(string)
    vlan_tag               = number
    ip                     = string
    gateway                = string
    dns                    = string
    search_domain          = string


    disk = optional(map(object({
      size    = string
      storage = string
      type    = string
    })))
    additional_networks = optional(map(object({
      network_model  = string
      network_bridge = string
    })))
  }))
}

variable "data_disk" {
  description = "Additional data disk to VM (Data disk - /dev/sdb)"
  type = map(object({
    storage      = string
    storage_size = string
    storage_type = string
    })
  )
  default = null
}