# Kubernetes: деплоймент приложения

Данный модуль содержит манифест для развёртывания python-приложения в Kubernetes-кластере (K3s). Используется Ingress контроллер Traefik.

# Назначение 

Модуль описывает деплой приложения в кластер:
- Создание Namespace
- Развёртывание с 2 репликами
- Настройка Service для внутренней маршрутизации
- Конфигурация Ingress для доступности из внешней сети

# Архитектура

Ниже представлена схема кластера с развёрнутыми приложением и Ingress. В запросах необходимо использовать заголовок `Host: app.test.local`

```mermaid
flowchart LR
    User([Internet])
    
    subgraph NODE["K3s Node (Master/Worker)"]
        TRAEFIK["Traefik Ingress<br/>─────────────<br/>:80 / :443<br/>Host-based routing"]
    end
    
    subgraph K8S["Kubernetes Cluster"]
        subgraph NS["Namespace: python-app"]
            SVC["Service<br/>python-app-service<br/>─────────────<br/>Port 80 → 8000"]
            
            subgraph PODS["Deployment: 2 replicas"]
                POD1["Pod 1<br/>python-app<br/>:8000"]
                POD2["Pod 2<br/>python-app<br/>:8000"]
            end
        end
    end
    
    User -->|"HTTP<br/>Host: app.test.local"| TRAEFIK
    TRAEFIK -->|Ingress Rule| SVC
    SVC -->|Round-robin| POD1
    SVC -->|Round-robin| POD2
    
    POD1 -.->|Readiness Probe<br/>GET /health| SVC
    POD2 -.->|Readiness Probe<br/>GET /health| SVC
    
    style User fill:#e3f2fd,stroke:#1565c0,stroke-width:2px,color:#000
    style NODE fill:#fff3e0,stroke:#f57c00,stroke-width:2px,color:#000
    style K8S fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px,color:#000
    style NS fill:#e8f5e9,stroke:#388e3c,stroke-width:2px,color:#000
    style TRAEFIK fill:#ffccbc,stroke:#d84315,stroke-width:2px,color:#000
    style SVC fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px,color:#000
    style PODS fill:#fff9c4,stroke:#f9a825,stroke-width:2px,color:#000
    style POD1 fill:#fff59d,stroke:#f9a825,color:#000
    style POD2 fill:#fff59d,stroke:#f9a825,color:#000
```    