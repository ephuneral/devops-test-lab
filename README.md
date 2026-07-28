# Yandex Cloud K3s Infrastructure

Этот модуль автоматизирует создание инфраструктуры для K8s кластера (K3s) в Yandex Cloud с использовнием подхода IaC.

## Назначение 

Модуль создает готовую инфраструктуру для развёртывания K3s кластера:
- 3 виртуальные машины (1 master + 2 worker nodes)
- Автогенерация inventory.ini (Ansible)
- Интеграция с CI/CD

## Архитектура

IP адреса на схеме приведены для примера

```mermaid
flowchart LR
    User([Internet])

    subgraph YC[Yandex Cloud · ru-central1-a]
        subgraph Subnet[Subnet · 192.168.10.0/24]
            VM1["k3s-node-1<br/>192.168.10.5"]
            VM2["k3s-node-2<br/>192.168.10.6"]
            VM3["k3s-node-3<br/>192.168.10.7"]
        end

        NAT1(("NAT<br/>84.201.x.1"))
        NAT2(("NAT<br/>84.201.x.2"))
        NAT3(("NAT<br/>84.201.x.3"))
    end

    User -->NAT1
    User -->NAT2
    User -->NAT3

    NAT1 -->|DNAT| VM1
    NAT2 -->|DNAT| VM2
    NAT3 -->|DNAT| VM3

    style User fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    style YC fill:#f1f8e9,stroke:#558b2f,stroke-width:2px
    style Subnet fill:#fff8e1,stroke:#f9a825,stroke-width:2px
    style VM1 fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px
    style VM2 fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px
    style VM3 fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px
    style NAT1 fill:#ffccbc,stroke:#d84315,stroke-width:2px
    style NAT2 fill:#ffccbc,stroke:#d84315,stroke-width:2px
    style NAT3 fill:#ffccbc,stroke:#d84315,stroke-width:2px
```

## Структура проекта
```
devops-test-lab/
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   ├── terraform.tf # заполняется вручную
│   └── variables.tf
├── ansible/
│   ├── inventory.ini # генерируется при запуске terraform apply
│   └── inventory.tpl
├── .gitignore
└── README.md
```

## Особенности

- Terraform генерирует файл ```inventory.ini``` в директории ```ansible/```, а также удаляет его при выполнении команды ```terraform destroy```.

## Быстрый старт
### Установка зависимостей

Инструкции по установке необходимых инструментов:
- Terraform: https://developer.hashicorp.com/terraform/install
- YC CLI: https://yandex.cloud/en/docs/cli/operations/install-cli

### Клонирование репозитория
```bash
git clone https://github.com/ephuneral/devops-test-lab.git
cd devops-test-lab/
```

### Конфигурация
```bash
# Скопировать шаблон
cp terraform.tfvars.example terraform.tfvars

# Подставить реальные значения
nano terraform.tfvars
```

### Развёртывание
```bash
# Инициализация Terraform
terraform init

# Просмотр плана
terraform plan

# Применение конфигурации
terraform apply
```

### Прсмотр результатов
```bash
# Получение IP-адреса master-ноды
terraform output master_ip

# Получение IP-адресов worker-нод
terraform output worker_ip

# Получение информации о кластере
terraform output cluster_info
```

### Удаление
```bash
terraform destroy
```