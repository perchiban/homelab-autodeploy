variable vm_configs {
    type = map(object({
        vm_id = number
        name = string
	cores = number
	memory = number
	vm_state = string
    }))
    default = {
	"K8s-01" = { vm_id = 301, name = "K8s-01", cores = 1, memory = 2048, vm_state = "stopped"}
	# "K8s-02" = { vm_id = 302, name = "K8s-02", cores = 2, memory = 1024, vm_state = "stopped"}
	# "K8s-03" = { vm_id = 303, name = "K8s-03", cores = 3, memory = 2048, vm_state = "stopped"}
	# "K8s-04" = { vm_id = 304, name = "K8s-04", cores = 4, memory = 1024, vm_state = "stopped"}
    }
}

resource "proxmox_vm_qemu" "pxe-test" {
    for_each = var.vm_configs

    target_node = "proxmoxtesting"
    clone = "Debian12.11v2"
    name = each.value.name
    vmid = each.value.vm_id
    vm_state = each.value.vm_state
    agent = 1
    full_clone = false
    scsihw = "virtio-scsi-single"
    bios = "seabios"
    boot = "order=scsi0"
    force_create = false
    hotplug = 0
    kvm = true
    os_type = "cloud-init"
    skip_ipv6 = true
    memory = each.value.memory
    balloon = 0
    cpu {
        cores    = each.value.cores
        sockets  = 1
        type     = "host"
    }
    disks {
        ide {
            ide3 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    backup             = false
                    cache              = "none"
                    discard            = true
                    emulatessd         = true
                    iothread           = true
                    size               = 8
                    storage            = "local-lvm"
                }
            }
        }
    }
    network {
        id        = 0
        bridge    = "vmbr0"
        model     = "virtio"
    }
    ipconfig0 = "ip=10.10.0.241/24,gw=10.10.0.1"
}
