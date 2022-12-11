REPO := fopina/smtp_to_telegram
PLATFORMS := linux/amd64,linux/arm/v7,linux/arm64
ACTION := push
VERSION := $(shell git describe --tags --always)
GOLANG_CROSS_VERSION  ?= v1.18.1

build:
	make push ACTION=load PLATFORMS=linux/amd64

push:
	docker buildx build \
				--platform $(PLATFORMS) \
				-t $(REPO):$(VERSION) \
				-t $(REPO):latest \
				--build-arg ST_VERSION=$(VERSION) \
				--$(ACTION) .

test-release:
	@docker run \
		--rm \
		--privileged \
		-v ${PWD}:/smtp_to_telegram \
		-w /smtp_to_telegram \
		-e GITHUB_TOKEN \
		-e DOCKER_USERNAME \
		-e DOCKER_PASSWORD \
		-e DOCKER_REGISTRY \
		-v /var/run/docker.sock:/var/run/docker.sock \
		goreleaser/goreleaser-cross:${GOLANG_CROSS_VERSION} \
		--rm-dist --skip-validate --timeout=1h --snapshot
