# Customer churn MLOps service

[![CI](https://github.com/blue-slate/customer-churn-mlops-service/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/blue-slate/customer-churn-mlops-service/actions/workflows/ci.yml) [![CI](https://github.com/blue-slate/customer-churn-mlops-service/actions/workflows/delivery.yml/badge.svg?branch=main)](https://github.com/blue-slate/customer-churn-mlops-service/actions/workflows/deploy.yml)


## Overview

This project is a production-inspired MLOps service for customer churn prediction.

It exposes a machine learning model through a FastAPI API, packages the service with Docker, provisions infrastructure with Terraform, and uses GitHub Actions for CI/CD. The project also includes monitoring with Prometheus and Grafana to reflect real-world deployment and reliability practices.

Its goal is not to build the most complex model, but to demonstrate how an ML service can be structured, deployed, monitored, and maintained in a clean and professional way.

## Architecture

![Architecture-diagram](docs/architecture-diagram.svg)

The project is built as a simple end-to-end ML service with a deployment flow inspired by real-world production setups.

- A **FastAPI** application exposes the prediction API and operational endpoints
- A **scikit-learn pipeline** is loaded by the service to serve predictions
- The application is packaged and run in a **Docker** container
- **GitHub Actions** handles CI/CD tasks such as testing, linting, image build, and delivery
- **Terraform** provisions the AWS infrastructure
- The service is deployed on an **EC2 instance**
- **Prometheus** scrapes application metrics
- **Grafana** visualizes service health and performance through dashboards


At a high level, the system covers the full lifecycle of an ML service: packaging, deployment, delivery, monitoring, and basic production reliability practices.






