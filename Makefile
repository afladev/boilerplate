.PHONY: up
up: .env
	docker-compose up --build -d

.env:
	cp .env.example .env

vendor: composer.lock composer.json
	docker-compose exec app composer install

node_modules: package.json package-lock.json
	docker-compose exec app npm ci

.PHONY: run-prod
run-prod: node_modules
	docker-compose exec app npm run build

.PHONY: run-dev
run-dev: node_modules
	docker-compose exec app npm run dev

.PHONY: migrate
migrate: vendor
	docker-compose exec app php artisan migrate:refresh --seed

.PHONY: install
install: vendor run-prod migrate

.PHONY: test
test: vendor
	docker-compose exec app php artisan test
