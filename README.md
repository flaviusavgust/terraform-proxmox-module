# Terraform custom module (Proxmox)

This custom module automating creation of Virtual Machnine in Proxmox.

## Prerequisits

 - terraform  >= 1.0.4
 - proxmox >= 2.7.4
 
## How to use module

 - Install terragrunt
 - Source this module in terragrunt.hcl
 - Run terragrunt

### Example of default project structure

```
project-name/
  |__dev/
       |__terragrunt.hcl
       |__mongodb/
            |__terragrunt.hcl
  |__stage/
       |__terragrunt.hcl
       |__mongodb/
            |__terragrunt.hcl
  |__prod/
       |__terragrunt.hcl
       |__mongodb/
            |__terragrunt.hcl
```


### Example of terragrunt.hcl for create single VM

```
terraform {
  source = "git::https://git.tengemarket.uz/devops/terraform/terraform-proxmox-module.git?ref=main"
}

remote_state {
  backend = "http"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    address        = "${get_env("TF_ADDRESS")}"
    lock_address   = "${get_env("TF_ADDRESS")}/lock"
    unlock_address = "${get_env("TF_ADDRESS")}/lock"
    username       = "gitlab-ci-token"
    password       = "${get_env("CI_JOB_TOKEN")}"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}

inputs = {

  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFIsq9qC+MRo3GJfrXTy9F9+b8HFR3WM8EaZqmEROoY08rsVOi2Owu9jRAnJOWxQFDc8va+KgdIPLMi6s/zVK31Pli1fgkQb1+k1T/U0Wr7Qp9/1DqPPaq8xDmnkj8asqGEcAhabHvDD4KWcHikGyWEj278FjIT+XsjxoxE8rTMvg7kzfaDXd+QAK6deYIshG3O8EMkRI5SjZj0JKDTz1mBCOs2dpEGAMqHWY4LJT2M773MEf7Qk7GqSRLMsIYEfywJ3QXfrPA1xoExyzFC+AndawBg/TsKaqBpaEjd3AspNghkfQSwcUV9azAAW0/xSMxpmNWAaFl27/PoGHPD9Ol noname
    EOF

  clone_template_name = "Ubuntu2204-Template"

  virtual_machines = {
    test-mongo-01 = {
      target_node            = "tas650pve05"
      pool                   = "client_5_1"
      vmid                   = 9011
      memory                 = 2048
      sockets                = 1
      cores                  = 2
      main_disk_storage_size = "50G"
      main_disk_storage      = "HDD_Pool"
      data_disk_storage_size = "70G"
      data_disk_storage      = "SSD_Pool"
      vlan_tag               = 621
      ip                     = "10.10.2.11/24"
      gateway                = "10.10.2.1"
      dns1                   = "8.8.8.8"
      dns2                   = "8.8.4.4"
      search_domain          = "tengemarket.uz"
    },
  }
}
```


### Example of terragrunt.hcl for create multiple VM

> Note: then you provision multiple VMs, you must add "-parallelism=1" option, because Proxmox cannot clone multiple VM from one template at the same time

Provision example:
```
terragrunt apply -parallelism=1
```

```
terraform {
  source = "git::https://git.tengemarket.uz/devops/terraform/terraform-proxmox-module.git?ref=main"
}

remote_state {
  backend = "http"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    address        = "${get_env("TF_ADDRESS")}"
    lock_address   = "${get_env("TF_ADDRESS")}/lock"
    unlock_address = "${get_env("TF_ADDRESS")}/lock"
    username       = "gitlab-ci-token"
    password       = "${get_env("CI_JOB_TOKEN")}"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}

inputs = {

  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFIsq9qC+MRo3GJfrXTy9F9+b8HFR3WM8EaZqmEROoY08rsVOi2Owu9jRAnJOWxQFDc8va+KgdIPLMi6s/zVK31Pli1fgkQb1+k1T/U0Wr7Qp9/1DqPPaq8xDmnkj8asqGEcAhabHvDD4KWcHikGyWEj278FjIT+XsjxoxE8rTMvg7kzfaDXd+QAK6deYIshG3O8EMkRI5SjZj0JKDTz1mBCOs2dpEGAMqHWY4LJT2M773MEf7Qk7GqSRLMsIYEfywJ3QXfrPA1xoExyzFC+AndawBg/TsKaqBpaEjd3AspNghkfQSwcUV9azAAW0/xSMxpmNWAaFl27/PoGHPD9Ol noname
    EOF

  clone_template_name = "Ubuntu2204-Template"

  virtual_machines = {
    test-mongo-01 = {
      target_node            = "tas650pve05"
      pool                   = "client_5_1"
      vmid                   = 9011
      memory                 = 2048
      sockets                = 1
      cores                  = 2
      main_disk_storage_size = "50G"
      main_disk_storage      = "HDD_Pool"
      data_disk_storage_size = "70G"
      data_disk_storage      = "SSD_Pool"
      vlan_tag               = 621
      ip                     = "10.10.2.11/24"
      gateway                = "10.10.2.1"
      dns1                   = "8.8.8.8"
      dns2                   = "8.8.4.4"
      search_domain          = "tengemarket.uz"
    },
    test-mongo-02 = {
      target_node            = "tas650pve05"
      pool                   = "client_5_1"
      vmid                   = 9012
      memory                 = 2048
      sockets                = 1
      cores                  = 2
      main_disk_storage_size = "50G"
      main_disk_storage      = "HDD_Pool"
      data_disk_storage_size = "70G"
      data_disk_storage      = "SSD_Pool"
      vlan_tag               = 621
      ip                     = "10.10.2.12/24"
      gateway                = "10.10.2.1"
      dns1                   = "8.8.8.8"
      dns2                   = "8.8.4.4"
      search_domain          = "tengemarket.uz"
    },
    test-mongo-03 = {
      target_node            = "tas650pve05"
      pool                   = "client_5_1"
      vmid                   = 9013
      memory                 = 2048
      sockets                = 1
      cores                  = 2
      main_disk_storage_size = "50G"
      main_disk_storage      = "HDD_Pool"
      data_disk_storage_size = "70G"
      data_disk_storage      = "SSD_Pool"
      vlan_tag               = 621
      ip                     = "10.10.2.12/24"
      gateway                = "10.10.2.1"
      dns1                   = "8.8.8.8"
      dns2                   = "8.8.4.4"
      search_domain          = "tengemarket.uz"
    },
  }
}
```


### Example of terragrunt.hcl for create multiple VM with independent external disk

In this example we have new variable ***data_disk***. For each VM will be created second external data disk.

```
terraform {
  source = "git::https://git.tengemarket.uz/devops/terraform/terraform-proxmox-module.git?ref=main"
}

remote_state {
  backend = "http"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    address        = "${get_env("TF_ADDRESS")}"
    lock_address   = "${get_env("TF_ADDRESS")}/lock"
    unlock_address = "${get_env("TF_ADDRESS")}/lock"
    username       = "gitlab-ci-token"
    password       = "${get_env("CI_JOB_TOKEN")}"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}

inputs = {

  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFIsq9qC+MRo3GJfrXTy9F9+b8HFR3WM8EaZqmEROoY08rsVOi2Owu9jRAnJOWxQFDc8va+KgdIPLMi6s/zVK31Pli1fgkQb1+k1T/U0Wr7Qp9/1DqPPaq8xDmnkj8asqGEcAhabHvDD4KWcHikGyWEj278FjIT+XsjxoxE8rTMvg7kzfaDXd+QAK6deYIshG3O8EMkRI5SjZj0JKDTz1mBCOs2dpEGAMqHWY4LJT2M773MEf7Qk7GqSRLMsIYEfywJ3QXfrPA1xoExyzFC+AndawBg/TsKaqBpaEjd3AspNghkfQSwcUV9azAAW0/xSMxpmNWAaFl27/PoGHPD9Ol noname
    EOF

  clone_template_name = "Ubuntu2204-Template"

  data_disk = {
    data = {
      storage         = "HDD_Pool"
      storage_size    = "50G"
      storage_type    = "virtio"
    }
  }

  virtual_machines = {
    test-mongo-01 = {
      target_node            = "tas650pve05"
      pool                   = "client_5_1"
      vmid                   = 9011
      memory                 = 2048
      sockets                = 1
      cores                  = 2
      main_disk_storage_size = "50G"
      main_disk_storage      = "HDD_Pool"
      data_disk_storage_size = "70G"
      data_disk_storage      = "SSD_Pool"
      vlan_tag               = 621
      ip                     = "10.10.2.11/24"
      gateway                = "10.10.2.1"
      dns1                   = "8.8.8.8"
      dns2                   = "8.8.4.4"
      search_domain          = "tengemarket.uz"
    },
    test-mongo-02 = {
      target_node            = "tas650pve05"
      pool                   = "client_5_1"
      vmid                   = 9012
      memory                 = 2048
      sockets                = 1
      cores                  = 2
      main_disk_storage_size = "50G"
      main_disk_storage      = "HDD_Pool"
      data_disk_storage_size = "70G"
      data_disk_storage      = "SSD_Pool"
      vlan_tag               = 621
      ip                     = "10.10.2.12/24"
      gateway                = "10.10.2.1"
      dns1                   = "8.8.8.8"
      dns2                   = "8.8.4.4"
      search_domain          = "tengemarket.uz"
    },
    test-mongo-03 = {
      target_node            = "tas650pve05"
      pool                   = "client_5_1"
      vmid                   = 9013
      memory                 = 2048
      sockets                = 1
      cores                  = 2
      main_disk_storage_size = "50G"
      main_disk_storage      = "HDD_Pool"
      data_disk_storage_size = "70G"
      data_disk_storage      = "SSD_Pool"
      vlan_tag               = 621
      ip                     = "10.10.2.12/24"
      gateway                = "10.10.2.1"
      dns1                   = "8.8.8.8"
      dns2                   = "8.8.4.4"
      search_domain          = "tengemarket.uz"
    },
  }
}
```


### Example of terragrunt.hcl for create VM with additional network interface

```
terraform {
  source = "git::https://git.tengemarket.uz/devops/terraform/terraform-proxmox-module.git?ref=main"
}

remote_state {
  backend = "http"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    address        = "${get_env("TF_ADDRESS")}"
    lock_address   = "${get_env("TF_ADDRESS")}/lock"
    unlock_address = "${get_env("TF_ADDRESS")}/lock"
    username       = "gitlab-ci-token"
    password       = "${get_env("CI_JOB_TOKEN")}"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}

inputs = {

  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFIsq9qC+MRo3GJfrXTy9F9+b8HFR3WM8EaZqmEROoY08rsVOi2Owu9jRAnJOWxQFDc8va+KgdIPLMi6s/zVK31Pli1fgkQb1+k1T/U0Wr7Qp9/1DqPPaq8xDmnkj8asqGEcAhabHvDD4KWcHikGyWEj278FjIT+XsjxoxE8rTMvg7kzfaDXd+QAK6deYIshG3O8EMkRI5SjZj0JKDTz1mBCOs2dpEGAMqHWY4LJT2M773MEf7Qk7GqSRLMsIYEfywJ3QXfrPA1xoExyzFC+AndawBg/TsKaqBpaEjd3AspNghkfQSwcUV9azAAW0/xSMxpmNWAaFl27/PoGHPD9Ol noname
    EOF

  clone_template_name = "Ubuntu2204-Template"

  virtual_machines = {
    test-mongo-01 = {
      target_node            = "tas650pve05"
      pool                   = "client_5_1"
      vmid                   = 9011
      memory                 = 2048
      sockets                = 1
      cores                  = 2
      main_disk_storage_size = "50G"
      main_disk_storage      = "HDD_Pool"
      data_disk_storage_size = "70G"
      data_disk_storage      = "SSD_Pool"
      vlan_tag               = 621
      ip                     = "10.10.2.11/24"
      gateway                = "10.10.2.1"
      dns1                   = "8.8.8.8"
      dns2                   = "8.8.4.4"
      search_domain          = "tengemarket.uz"
      additional_networks = {
        second_nic = {
          network_model  = "virtio"
          network_bridge = "vmbr1"
    },
  }
}
```
