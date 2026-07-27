[k3s_master]
${master_ip} ansible_user=ubuntu

[k3s_workers]
%{ for ip in worker_ips ~}
${ip} ansible_user=ubuntu
%{ endfor ~}

[k3s_cluster:children]
k3s_master
k3s_workers
