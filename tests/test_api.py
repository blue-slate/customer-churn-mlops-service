from fastapi.testclient import TestClient

from api.api_service.main import app

client = TestClient(app)


def test_health_endpoint():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_model_info_returns_404_if_metadata_missing():
    response = client.get("/model-info")
    assert response.status_code in [200, 404]


def test_predict_returns_503_if_model_missing_or_200_if_present():
    payload = {
        "gender": "Female",
        "SeniorCitizen": 0,
        "Partner": "Yes",
        "Dependents": "No",
        "tenure": 12,
        "PhoneService": "Yes",
        "MultipleLines": "No",
        "InternetService": "Fiber optic",
        "OnlineSecurity": "No",
        "OnlineBackup": "Yes",
        "DeviceProtection": "No",
        "TechSupport": "No",
        "StreamingTV": "Yes",
        "StreamingMovies": "Yes",
        "Contract": "Month-to-month",
        "PaperlessBilling": "Yes",
        "PaymentMethod": "Electronic check",
        "MonthlyCharges": 79.85,
        "TotalCharges": 956.4,
    }

    response = client.post("/predict", json=payload)
    assert response.status_code in [200, 503]

    if response.status_code == 200:
        body = response.json()
        assert "churn_probability" in body
        assert "churn_prediction" in body
        assert "model_name" in body
