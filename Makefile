PYTHON=python3
VENV=.venv
VENV_STAMP=$(VENV)/.installed

TF_DIR=infra/terraform
TF_PLAN=tfplan

# ------------------------------------
# Python environment and app commands
# ------------------------------------

ifeq ($(OS),Windows_NT)
	VENV_PYTHON=$(VENV)/Scripts/python.exe
	VENV_UVICORN=$(VENV)/Scripts/uvicorn.exe
	VENV_PYTEST=$(VENV)/Scripts/pytest.exe
	VENV_RUFF=$(VENV)/Scripts/ruff.exe
	VENV_BLACK=$(VENV)/Scripts/black.exe
else
	VENV_PYTHON=$(VENV)/bin/python
	VENV_UVICORN=$(VENV)/bin/uvicorn
	VENV_PYTEST=$(VENV)/bin/pytest
	VENV_RUFF=$(VENV)/bin/ruff
	VENV_BLACK=$(VENV)/bin/black
endif

.PHONY: install train run test lint format format-check docker-build docker-run clean quality  tf-fmt tf-init-check tf-validate tf-check tf-init tf-plan tf-apply tf-destroy

install: $(VENV_STAMP)

$(VENV_STAMP): requirements.txt pyproject.toml
	$(PYTHON) -m venv $(VENV)
	$(VENV_PYTHON) -m pip install --upgrade pip
	$(VENV_PYTHON) -m pip install -r requirements.txt
	$(VENV_PYTHON) -m pip install -e .
	@touch $(VENV_STAMP)

train: $(VENV_STAMP)
	$(VENV_PYTHON) -m training.train

run: $(VENV_STAMP)
	$(VENV_UVICORN) api.main:app --host 0.0.0.0 --port 8000 --reload

test: $(VENV_STAMP)
	$(VENV_PYTEST) -q

lint: $(VENV_STAMP)
	$(VENV_RUFF) check .

format-check: $(VENV_STAMP)
	$(VENV_BLACK) --check .

format: $(VENV_STAMP)
	$(VENV_BLACK) .
	$(VENV_RUFF) check . --fix

quality: format-check lint format test

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -f $(VENV_STAMP)
	rm -rf .venv

# ------------------
# Docker commands
# ------------------

docker-build:
	docker build -t doyonm/customer-churn-mlops-service .

docker-run:
	docker run --name churn-api -p 8000:8000 -d doyonm/customer-churn-mlops-service

# -------------------
# Terraform commands
# -------------------

tf-fmt:
	cd $(TF_DIR) && terraform fmt -recursive

tf-init-check:
	cd $(TF_DIR) && terraform init -backend=false

tf-validate: tf-init-check
	cd $(TF_DIR) && terraform validate

tf-check: tf-fmt tf-validate

tf-init:
	cd $(TF_DIR) && terraform init -backend-config=tfbackend.config

tf-plan: tf-init
	cd $(TF_DIR) && terraform plan -out=$(TF_PLAN)

tf-apply: tf-plan
	cd $(TF_DIR) && terraform apply -auto-approve $(TF_PLAN)

tf-destroy:
	cd $(TF_DIR) && terraform destroy -auto-approve