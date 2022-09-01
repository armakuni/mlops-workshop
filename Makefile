unit-tests:
	@poetry run pytest

black:
	black -l 86 $$(find * -name '*.py')

mypy:
	mypy .

tf-init-bootstrap:
	@terragrunt init --terragrunt-working-dir terraform/bootstrap

tf-plan-bootstrap:
	@terragrunt plan --terragrunt-working-dir terraform/bootstrap

tf-apply-bootstrap:
	@terragrunt apply --terragrunt-working-dir terraform/bootstrap

tf-init-app:
	@terragrunt init --terragrunt-working-dir terraform/app

tf-plan-app:
	@terragrunt plan --terragrunt-working-dir terraform/app

tf-apply-app:
	@terragrunt apply --terragrunt-working-dir terraform/app --terragrunt-non-interactive --auto-approve

tf-destroy-app:
	@terragrunt destroy --terragrunt-working-dir terraform/app

docker-build:
	@docker build -t mlops-intro .

dvc-pull:
	@dvc pull