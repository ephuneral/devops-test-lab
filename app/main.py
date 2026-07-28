import subprocess
from fastapi import FastAPI, Request, Response, status

app = FastAPI(
    title="Test",
    version="1.0.0"
)

@app.post("/")
async def hello_endpoint(request: Request):
    """
    Возвращает 'Hello, World!' если заголовок 'Test' равен 'Hello'.
    Иначе возвращает 403 Forbidden.
    """
    test_header = request.headers.get("test")

    if test_header == "Hello":
        return "Hello, World!"

    return Response(status_code=status.HTTP_403_FORBIDDEN)


@app.get("/health")
async def health_check():
    """
    Пингует 77.88.8.8 (Yandex DNS).
    При успехе возвращает 200 OK, при неудаче - 503 Service Unavailable.
    """
    target_ip = "77.88.8.8"

    try:
        result = subprocess.run(
            ["ping", "-c", "1", "-W", "2", target_ip],
            capture_output=True,
            text=True,
            timeout=5
        )

        if result.returncode == 0:
            return Response(content="OK", status_code=status.HTTP_200_OK)
        else:
            return Response(
                content=f"Ping failed: {result.stderr.strip()}",
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE
            )

    except subprocess.TimeoutExpired:
        return Response(content="Ping timeout", status_code=status.HTTP_503_SERVICE_UNAVAILABLE)
    except Exception as e:
        return Response(content=str(e), status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)
