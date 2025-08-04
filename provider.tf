terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
  required_version = ">= 1.0.3"
}

provider "proxmox" {
  pm_tls_insecure = var.proxmox_tls_insecure
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
}
