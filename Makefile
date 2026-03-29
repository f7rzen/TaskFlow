include .env
export

env-up:
	echo "Starting PostgreSQL..."
	@docker compose up -d taskflow-postgres

env-down:
	echo "Stopping PostgreSQL..."
	@docker compose down taskflow-postgres

env-cleanup:
	@docker compose down taskflow-postgres && \
	rm -rf out/pgdata && \
	echo "Файлы окружения очищены"

migrate-create:
	@docker compose run --rm taskflow-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"
//make migrate-create seq=init

migrate-action:
	@docker compose run --rm taskflow-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@taskflow-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		$(action)
//make migrate-action action="down 1"

# "postgres://test-user-123:test-postgres-password-456@taskflow-postgres:5432/test-db?sslmode=disable"