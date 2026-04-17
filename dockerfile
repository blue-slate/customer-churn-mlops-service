FROM python:3.13-slim AS builder
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.13-slim
RUN useradd app


COPY --from=builder /install /usr/local

WORKDIR /app
COPY api/api_service/ ./api/api_service
COPY api/artifacts/models/ ./models

# Entrypoint

USER app
EXPOSE 8000
CMD ["uvicorn", "api.api_service.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
