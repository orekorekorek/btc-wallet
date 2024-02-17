run:
	docker compose up -d

stop:
	docker compose down -v

help:
	docker compose exec app ruby wallet.rb --help

generate:
	docker compose exec app ruby wallet.rb --generate

balance:
	docker compose exec app ruby wallet.rb --balance

send:
	docker compose exec app ruby wallet.rb --amount=$(amount) --recipient=$(recipient)
