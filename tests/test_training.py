import json

import joblib
import pandas as pd

from api.training.train import build_pipeline, load_data, save_json


def test_load_data_loads_csv_and_maps_target(temp_csv_path):
    df = load_data(temp_csv_path)

    assert isinstance(df, pd.DataFrame)
    assert "Churn" in df.columns
    assert set(df["Churn"].unique()) <= {0, 1}


def test_load_data_raises_if_target_missing(tmp_path):
    csv_path = tmp_path / "missing_target.csv"
    df = pd.DataFrame(
        [
            {"gender": "Female", "tenure": 12, "MonthlyCharges": 50.0},
            {"gender": "Male", "tenure": 24, "MonthlyCharges": 80.0},
        ]
    )
    df.to_csv(csv_path, index=False)

    try:
        load_data(csv_path)
        assert False, "Expected ValueError when target column is missing"
    except ValueError as exc:
        assert "Churn" in str(exc)


def test_build_pipeline_returns_fittable_pipeline(sample_training_dataframe):
    X = sample_training_dataframe.drop(columns=["Churn"])
    y = sample_training_dataframe["Churn"]

    pipeline = build_pipeline(X)
    pipeline.fit(X, y)

    predictions = pipeline.predict(X)
    probabilities = pipeline.predict_proba(X)

    assert len(predictions) == len(X)
    assert probabilities.shape[0] == len(X)
    assert probabilities.shape[1] == 2


def test_save_json_writes_expected_content(tmp_path):
    output_path = tmp_path / "metrics.json"
    payload = {"accuracy": 0.85, "f1": 0.77}

    save_json(output_path, payload)

    assert output_path.exists()
    with output_path.open("r", encoding="utf-8") as file:
        saved = json.load(file)

    assert saved == payload


def test_trained_pipeline_can_be_serialized(sample_training_dataframe, tmp_path):
    X = sample_training_dataframe.drop(columns=["Churn"])
    y = sample_training_dataframe["Churn"]

    pipeline = build_pipeline(X)
    pipeline.fit(X, y)

    model_path = tmp_path / "model.pkl"
    joblib.dump(pipeline, model_path)

    loaded_model = joblib.load(model_path)
    predictions = loaded_model.predict(X)

    assert len(predictions) == len(X)
