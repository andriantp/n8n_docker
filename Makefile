# ============= SHARED =============

network:
	@if ! docker network inspect infra_networks > /dev/null 2>&1; then \
		echo "🔌 Network infra_networks not found, creating..."; \
		docker network create --driver=bridge infra_networks; \
	else \
		echo "✅ Network infra_networks already exists."; \
	fi


# ============= VPS MODE =============

n8n-up-vps: network
	@echo "🚀 Deploying n8n (VPS)"
	docker compose -f docker/docker-compose.yml -p n8n up --force-recreate -d --build

n8n-down-vps:
	docker compose -f docker/docker-compose.yml -p n8n down -v


# ============= LOCAL MODE =============

## Step 1: Start ngrok
ngrok-up: network
	@echo "🚀 Starting ngrok tunnel..."
	docker compose -f docker/docker-compose.ngrok.yml -p dev up --force-recreate -d --build


## Step 2: Get public URL from ngrok and save to .env
ngrok-set-url:
	@echo "🔍 Fetching ngrok public URL from host..."
	@attempts=0; \
	while [ $$attempts -lt 3 ]; do \
		url=$$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'); \
		if [ -n "$$url" ] && [ "$$url" != "null" ]; then \
			echo "NGROK_DOMAIN=$$url" > .env; \
			echo "$$url" > .env.tmp; \
			echo "✅ .env updated with NGROK_DOMAIN=$$url"; \
			exit 0; \
		else \
			echo "⏳ Waiting for ngrok to be ready... (attempt $$((attempts+1)))"; \
			sleep 2; \
			attempts=$$((attempts+1)); \
		fi; \
	done; \
	echo "❌ Failed to get ngrok URL after 3 attempts."; \
	exit 1



## Step 3: Deploy n8n with ngrok URL loaded from .env
n8n-up-local: network
	@echo "🚀 Deploying n8n (Local)"
	docker compose -f docker/docker-compose.n8n.yml --env-file .env -p dev up --force-recreate -d --build
	
## Stop local services
ngrok-down:
	docker compose -f docker/docker-compose.ngrok.yml -p ngrok down -v

n8n-down-local:
	docker compose -f docker/docker-compose.n8n.yml -p n8n down -v


# ============= SHORTCUTS =============
#local
local-ngrok: ngrok-up ngrok-set-url
	@echo "✅ All local services are up and running!"
	@echo "🌐 Access your n8n via ngrok domain:"
	@cat .env

local-url:ngrok-set-url

local-n8n:n8n-up-local

# vps
vps: n8n-up-vps
