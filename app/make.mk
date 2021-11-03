# Use some sensible default shell settings
SHELL := /bin/bash
.ONESHELL:
.SILENT:

export RUNNING_IN_CONTAINER=True

RUN_PYTHON = @docker-compose run --rm python

.PHONY: all
all: unit_test package

.PHONY: docker_build
docker_build:
	echo -e --- $(CYAN)build container ...$(NC)
	docker-compose build

.PHONY: unit_test
unit_test:
	$(RUN_PYTHON) /app/src/scripts/unit-test.sh

.PHONY: package
package:
	$(RUN_PYTHON) /app/src/scripts/package.sh
