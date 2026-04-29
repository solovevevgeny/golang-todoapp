include .env
export

export PROJECT_ROOT=$(shell pwd)

env-up:
	@docker compose up -d todoapp-postgres

env-down:
	@docker compose down todoapp-postgres

env-cleanup:
	@read -p "Clean all file from OUT folder? [y/N]: " ans; \
	if [ $$ans = "y" ] || [ $$ans = "Y" ]; then \
		make env-down && \
		rm -rf out/pgdata; \
		echo "OUT folder cleaned."; \
	else \
		echo "Cleanup cancelled."; \
	fi


migrate-create:
	@if [ -z "$(name)" ]; then \
		echo "Error: Migration name is required. Usage: make migrate-create name=<migration_name" \
		exit 1; \
	fi; \
    docker compose run --rm todoapp-postgres-migrate \
		create \
	    -ext sql \
		-dir ./migrations \
		-seq "${name}" \

migrate-up:
	migrate-action action=up

migrate-down:
	migrate-action action=down


migrate-action:
	@docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database "postgresql://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@todoapp-postgres:5432/$(POSTGRES_DB)?sslmode=disable" \
		$(action)