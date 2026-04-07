# Customer churn MLOps service

[![CI](https://github.com/blue-slate/customer-churn-mlops-service/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/blue-slate/customer-churn-mlops-service/actions/workflows/ci.yml)

End-to-end MLOps portfolio project for training, packaging, testing, deploying and monitoring a customer churn prediction API.

This project demonstrates a production-like ML service built with FastAPI, scikit-learn, Docker, GitHub Actions, Terraform, AWS EC2, Prometheus and Grafana.

\

## Project goal
This project's goal is to showcase how a tabular machine learning model can be taken from training to deployment in a production-like setup.

The focus is not on building the most advanced churn model, but on building a clean, reproducible, testable and deployable ML service.


## Contents
- [Scope](#Scope)
	- [Limitations](#Limitations)
- [Architecture](#Architecture)
	- [Future improvements](#Future-improvements)
- [Local setup](#Local-setup)
- [Api](#API)
- [ML Service](#ML Service)
- [Infrastructure](#Infrastructure)

***

## Scope
This MVP includes
- Training and evaluation of a tabular classification model
- Model artifact serialization and metadata persistence
- Prediction API with FastAPI
- Input validation with Pydantic
- Containerization with Docker
- CI/CD with GitHub Actions
- Infrastructure provisioning with Terraform
- Deployment to an AWS EC2 virtual machine
- Basic technical monitoring with Prometheus and Grafana

### Limitations
However, this project does not aim to provide:
- high availability and auto-scaling
- advanced security hardening
- automated model retraining
- drift detection
- feature store integration
- Kubernetes-based orchestration


## Architecture
The project is split into four parts:

1. A training pipeline that prepares the dataset, trains the model, evaluates it and saves the model artifact and metadata.
2. A FastAPI prediction service that loads the trained model and serves inference requests.
3. A CI/CD pipeline with GitHub Actions that runs checks, builds the Docker image and deploys the service.
4. A simple AWS deployment target provisioned with Terraform, with Prometheus and Grafana for basic monitoring.


### Future improvements


***

## Local setup


## API

### Endpoints

- `GET /health` - service health status
- `GET /model-info` - model metadata and version information
- `POST /predict` - predict churn probability for a customer
- `GET /metrics` - Prometheus metrics endpoint

### Example prediction request

**Input**
-

**Resonse**
-

## ML Service

## Infrastructure