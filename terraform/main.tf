terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = var.zone
}

resource "yandex_compute_instance" "k3s-node" {
  count = var.node_count

  name               = "k3s-node-${count.index + 1}"
  hostname           = "k3s-node-${count.index + 1}"
  folder_id          = var.folder_id
  zone               = var.zone
  service_account_id = var.service_account_id

  resources {
    memory        = var.memory
    cores         = var.cores
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      type           = "network-hdd"
      size           = var.disk_size
      image_id       = "fd85jo1jrjkh1qoemvna"
    }
    auto_delete = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }

  network_interface {
    subnet_id          = var.subnet_id
    security_group_ids = [var.security_group_id]
    nat                = true
  }

  scheduling_policy {
    preemptible = true
  }
}

output "master_ip" {
  value = yandex_compute_instance.k3s-node[0].network_interface.0.nat_ip_address
}

output "worker_ips" {
  value = [for i in range(1, var.node_count) : yandex_compute_instance.k3s-node[i].network_interface.0.nat_ip_address]
}

output "all_ips" {
  value = [for i in range(var.node_count) : yandex_compute_instance.k3s-node[i].network_interface.0.nat_ip_address]
}
