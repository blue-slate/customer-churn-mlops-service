PYTHON=python
TF_DIR=infra/terraform

install:
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements.txt
	$(PYTHON) -m pip install -e .

train:
	$(PYTHON) -m training.train

run:
	uvicorn api.main:app --host 0.0.0.0 --port 8000 --reload

test:
	pytest -q

lint:
	black .
	ruff check . --fix

format:
	black .

format-check:
	black --check .

docker-build:
	docker build -t doyonm/customer-churn-mlops-service .

docker-run:
	docker run -p 8000:8000 doyonm/customer-churn-mlops-service

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

quality: format-check lint test

tf-fmt:
	cd $(TF_DIR) && terraform fmt -recursive

tf-init-check:
	cd $(TF_DIR) && terraform init -backend=false

tf-validate:
	cd $(TF_DIR) && terraform validate

tf-check: tf-fmt tf-init-check tf-validate

tf-init:
	cd $(TF_DIR) && terraform init -backend-config=tfbackend.config

tf-plan:
	cd $(TF_DIR) && terraform plan -out plan.tfplan

tf-apply:
	cd $(TF_DIR) && terraform apply -auto-approve plan.tfplan

tf-destroy:
	cd $(TF_DIR) && terraform apply -destroy -auto-approve