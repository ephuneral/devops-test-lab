# Ansible: K3s Cluster Configuration

Данный модуль автоматизирует развёртывание и настройку K3s кластер на виртуальных машинах, созданных Terraform.

## Назначение

Модуль выполняет следующие задачи:
- Отключает swap на машинах.
- Устанавливает K3s на мастер-ноду.
- Извлекает токен для подключения рабочих нод.
- Устанавливает K3s на воркер-ноды и подключает их к кластеру.

## Требования

- Ansible `>= 2.15`

## Быстрый старт

Для старта требуется файл `inventory.ini`. В данном случае файл генерируется Terraform.

### Запуск

```bash
cd ansible
ansible-playbook playbooks/k3s-install.yml
```

### Проверка результата

```bash
ssh ubuntu@{*IP мастер ноды*}
sudo k3s kubectl get nodes -o wide
```

Ожидаемый вывод:

```bash
NAME         STATUS   ROLES           AGE     VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION              CONTAINER-RUNTIME
k3s-node-1   Ready    control-plane   3m4s    v1.36.2+k3s1   10.128.0.10   <none>        Ubuntu 24.04.4 LTS   6.8.0-134-generic (amd64)   containerd://2.3.2-k3s2
k3s-node-2   Ready    <none>          2m13s   v1.36.2+k3s1   10.128.0.21   <none>        Ubuntu 24.04.4 LTS   6.8.0-134-generic (amd64)   containerd://2.3.2-k3s2
k3s-node-3   Ready    <none>          2m20s   v1.36.2+k3s1   10.128.0.5    <none>        Ubuntu 24.04.4 LTS   6.8.0-134-generic (amd64)   containerd://2.3.2-k3s2
```
