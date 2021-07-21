REGISTRY:=${CUSTOMER_REGISTRY}
PROJECT:=${CUSTOMER_PROJECT}
IMAGE:=$(REGISTRY)/$(PROJECT)/traefik
GUCCI_VERSION=1.2.4

.PHONY: all
all: build push

.PHONY: build
build: guard-TRAEFIK_DOMAIN guard-CUSTOMER_EMAIL guard-CUSTOMER_REGISTRY guard-CUSTOMER_PROJECT
	docker build \
		--build-arg="ARG_GUCCI_VERSION=$(GUCCI_VERSION)" \
		--build-arg="ARG_CUSTOMER_EMAIL=${CUSTOMER_EMAIL}" \
		--build-arg="ARG_TRAEFIK_DOMAIN=${TRAEFIK_DOMAIN}" \
		-t $(IMAGE):latest .

.PHONY: push
push: guard-CUSTOMER_EMAIL guard-CUSTOMER_REGISTRY guard-CUSTOMER_PROJECT
	docker push $(IMAGE):latest

.PHONY: deploy
deploy: guard-QUANTUM_USER guard-QUANTUM_PASSWORD guard-QUANTUM_ENDPOINT
	docker run \
		-e QUANTUM_USER \
		-e QUANTUM_PASSWORD \
		-e QUANTUM_ENDPOINT \
		-v $(CURDIR):/work -w /work \
		--rm r.planetary-quantum.com/quantum-public/cli:2 \
		quantum-cli stacks update \
			--create --wait \
			--stack ${QUANTUM_ENDPOINT}-traefik

guard-%:
	@ if [ "${${*}}" = "" ]; then \
        echo "Environment variable $* not set"; \
        exit 1; \
    fi
