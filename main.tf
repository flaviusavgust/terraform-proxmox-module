# Create the VM
resource "proxmox_vm_qemu" "virtualMachine" {
  for_each = var.virtual_machines

  name         = each.key
  target_node  = each.value.target_node
  pool         = each.value.pool
  vmid         = each.value.vmid
  clone        = each.value.clone_template_name
  os_type      = "cloud-init"
  sshkeys      = var.sshkeys
  memory       = each.value.memory
  sockets      = each.value.sockets
  cores        = each.value.cores
  cpu          = "host"
  numa         = true
  agent        = 1
  onboot       = true
  hotplug      = "network,disk,usb"
  bootdisk     = "virtio0"
  scsihw       = "virtio-scsi-pci"
  ciuser       = "tb_market"
  cipassword   = "f67@J@bF"
  ipconfig0    = join(",", ["ip=${each.value.ip}", "gw=${each.value.gateway}"])
  nameserver   = each.value.dns
  searchdomain = each.value.search_domain

## main disk
  disk {
    storage = each.value.main_disk_storage
    size    = each.value.main_disk_storage_size
    type    = "virtio"
  }

## data disk
  dynamic "disk" {

    for_each = each.value.data_disk_storage != null ? [1] : []
    
    content {
      storage = each.value.data_disk_storage
      size    = each.value.data_disk_storage_size
      type    = "virtio"
    }
  }

## external disk
  dynamic "disk" {

    for_each = var.data_disk != null ? var.data_disk : {}

    content {
      storage = values(var.data_disk)[0]["storage"]
      size    = values(var.data_disk)[0]["storage_size"]
      type    = values(var.data_disk)[0]["storage_type"]
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = each.value.vlan_tag
  }

  dynamic "network" {
    for_each = each.value.additional_networks != null ? each.value.additional_networks : {}

    content {
      model  = network.value.network_model
      bridge = network.value.network_bridge
    }
  }

  lifecycle {
    ignore_changes = [
      network
    ]
  }
}
