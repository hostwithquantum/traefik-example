REGISTRY:=${CUSTOMER_REGISTRY}
PROJECT:=${CUSTOMER_PROJECT}
IMAGE:=$(REGISTRY)/$(PROJECT)/traefik
GUCCI_VERSION=1.2.4

.PHONY: all
all: build push

.PHONY: build
build:
	docker build \
		--build-arg="ARG_GUCCI_VERSION=$(GUCCI_VERSION)" \
		--build-arg="ARG_CUSTOMER_EMAIL=${CUSTOMER_EMAIL}" \
		--build-arg="ARG_TRAEFIK_DOMAIN=${TRAEFIK_DOMAIN}" \
		-t $(IMAGE):latest .

.PHONY: push
push:
	docker push $(IMAGE):latest

.PHONY: clean
clean:
	rm docker-compose.yml

.PHONY: deploy
deploy:
	docker run \
		-e QUANTUM_USER \
		-e QUANTUM_PASSWORD \
		-e QUANTUM_ENDPOINT \
		-v $(CURDIR):/work -w /work \
		--rm r.planetary-quantum.com/quantum-public/cli:2 \
		quantum-cli stacks update \
			--create --wait \
			--stack ${QUANTUM_ENDPOINT}-traefik
