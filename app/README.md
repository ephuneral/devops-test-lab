# Python Test Application

Приложение на Python (FastAPI), предназначенное для тестирования в k8s.

## Описание

Простое REST API с двумя эндпоинтами:
- **POST /** - возвращет "Hello, World!" при наличии заголовка "Test: Hello".
- **GET /health** - пингует Yandex DNS, при успехе возвращает "ОК".

## Быстрый старт (локально)

### Требования
- Python >=3.11
- pip
- ping

### Установка и запуск

```bash
cd app
pyhton3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

### API Документация

FastAPI автоматически генерирует документацию. Доступна по следующим эндпоинтам:
- ```.../docs```
- ```.../redoc```


## Примеры использования

### Эндпоинт POST /

```bash
curl -X POST http://localhost:8000/ \
  -H "Test: Hello"
```

Ожидаемый результат:

```bash
"Hello, World!"
```

### Эндпоинт GET /health
```bash
curl -v http://localhost:8000/health
```

Ожидаемый результат:
```bash
OK
```