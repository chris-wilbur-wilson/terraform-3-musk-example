export AWS_DEFAULT_REGION = eu-west-2

CONFIG ?= config1
TF_ARTIFACT = config/$(CONFIG).plan
TF_ARTIFACT_JSON = $(TF_ARTIFACT).json

TF_VARS := -var-file=config/$(CONFIG).tfvars

RUN_TF				= @docker-compose run --rm terraform
RUN_TF_BASH			= @docker-compose run --rm --entrypoint bash terraform
RUN_AWSCLI			= @docker-compose run --rm --entrypoint aws terraform

include make-tests.mk

.PHONY: all
all: plan deploy

.PHONY: validate
#: Validate Terraform
validate:
	echo -e --- $(CYAN)Validating Terraform ...$(NC)
	$(RUN_TF) init -input=false -backend=false
	$(RUN_TF) validate

.PHONY: init
init:
	echo -e --- $(CYAN)Initialising Terraform ...$(NC)
	${RUN_TF} init

.PHONY: plan
plan: init
	echo -e --- $(CYAN)Building Terraform ...$(NC)
	$(RUN_TF) plan $(TF_VARS) -out $(TF_ARTIFACT)

.PHONY: plan_json
plan_json:
	echo -e --- $(CYAN)Generating JSON Terraform deployment plan ...$(NC)
	$(RUN_TF_BASH) -c "terraform show -json $(TF_ARTIFACT) | jq '.' > $(TF_ARTIFACT_JSON)"

.PHONY: deploy
deploy:
	echo -e --- $(CYAN)Deploying Terraform ...$(NC)
	$(RUN_TF) apply $(TF_ARTIFACT)

.PHONY: destroy
destroy: init
	echo -e --- $(CYAN)Running Destroy ...$(NC)
	$(RUN_TF) destroy -auto-approve $(TF_VARS) 

.PHONY: terraform_format
terraform_format:
	echo -e --- $(CYAN)Formatting Terraform Files ...$(NC)
	$(RUN_TF) fmt -recursive

.PHONY: docker_build
docker_build:
	echo -e --- $(CYAN)build container ...$(NC)
	docker-compose build
