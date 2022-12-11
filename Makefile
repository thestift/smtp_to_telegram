REPO := fopina/smtp_to_telegram
PLATFORMS := linux/amd64,linux/arm/v7,linux/arm64
ACTION := push
VERSION := $(shell git describe --tags --always)

build:
	make push ACTION=load PLATFORMS=linux/amd64

push:
	docker buildx build \
				--platform $(PLATFORMS) \
				-t $(REPO):$(VERSION) \
				-t $(REPO):latest \
				--build-arg ST_VERSION=$(VERSION) \
				--$(ACTION) .
