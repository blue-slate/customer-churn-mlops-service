import json
from pathlib import Path

import joblib
import pandas as pd
from fastapi import FastAPI, HTTPException
from prometheus_fastapi_instrumentator import Instrumentator

from api.schemas import PredictionRequest, PredictionResponse

PROJECT_ROOT = Path(__file__).resolve().parent.parent
MODEL_PATH = PROJECT_ROOT / "models" / "model.pkl"
METADATA_PATH = PROJECT_ROOT / "models" / "metadata.json"
METRICS_PATH = PROJECT_ROOT / "models" / "metrics.json"

app = FastAPI(title="Customer Churn MLOps Service", version="0.1.0")

Instrumentator(
    should_group_status_codes=False,
    should_instrument_requests_inprogress=True,
    excluded_handlers=["/metrics"],
).instrument(app).expose(app)


def load_json(path: Path) -> dict:
    if not path.exists():
        return {}
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def load_model():
    if not MODEL_PATH.exists():
        return None
    return joblib.load(MODEL_PATH)


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.get("/model-info")
def model_info() -> dict:
    metadata = load_json(METADATA_PATH)
    metrics = load_json(METRICS_PATH)

    if not metadata:
        raise HTTPException(status_code=404, detail="Model metadata not found.")

    return {
        "metadata": metadata,
        "metrics": metrics,
    }


@app.post("/predict", response_model=PredictionResponse)
def predict(payload: PredictionRequest) -> PredictionResponse:
    model = load_model()
    if model is None:
        raise HTTPException(
            status_code=503, detail="Model artifact not found. Train the model first."
        )

    input_df = pd.DataFrame([payload.model_dump()])

    probability = float(model.predict_proba(input_df)[0][1])
    prediction = int(model.predict(input_df)[0])

    metadata = load_json(METADATA_PATH)
    model_name = metadata.get("model_name", "unknown-model")

    return PredictionResponse(
        churn_probability=round(probability, 4),
        churn_prediction=prediction,
        model_name=model_name,
    )
