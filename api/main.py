from fastapi import FastAPI

app = FastAPI(title="Customer Churn MLOps Service")

@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}