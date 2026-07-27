output "cluster_info" {
  description = "K3s cluster information"
  value = {
    master_ip  = yandex_compute_instance.k3s-node[0].network_interface.0.nat_ip_address
    worker_ips = [for i in range(1, var.node_count) : yandex_compute_instance.k3s-node[i].network_interface.0.nat_ip_address]
    all_ips    = [for i in range(var.node_count) : yandex_compute_instance.k3s-node[i].network_interface.0.nat_ip_address]
  }
}
