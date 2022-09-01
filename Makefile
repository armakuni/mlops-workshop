unit-tests:
	@poetry run pytest

black:
	black -l 86 $$(find * -name '*.py')

mypy:
	mypy .

tf-bootstrap-init:
	@terragrunt init --terragrunt-working-dir terraform/bootstrap

tf-bootstrap-plan:
	@terragrunt plan --terragrunt-working-dir terraform/bootstrap

tf-bootstrap-apply:
	@terragrunt apply --terragrunt-working-dir terraform/bootstrap

tf-bootstrap-destroy:
	@terragrunt destroy --terragrunt-working-dir terraform/bootstrap

tf-app-init:
	@terragrunt init --terragrunt-working-dir terraform/app

tf-app-plan:
	@terragrunt plan --terragrunt-working-dir terraform/app

tf-app-output-cname:
	@terragrunt output -raw cname --terragrunt-working-dir terraform/app

tf-app-apply:
	@terragrunt apply --terragrunt-working-dir terraform/app --terragrunt-non-interactive --auto-approve

tf-app-destroy:
	@terragrunt destroy --terragrunt-working-dir terraform/app

docker-build:
	@docker build -t mlops-intro .

dvc-pull:
	@dvc pull

train:
	@python mlops_api/train.py