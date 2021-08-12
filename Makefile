.PHONY: build push

REPO=renderedtext/protoc
IMAGE_LATEST=$(REPO):latest
DOCKER_IMAGE_TAG=$(shell git rev-parse --short HEAD)

ELIXIR_VERSION=1.11.4
PROTOC_VERSION=3.17.3
PROTOBUF_VERSION=

DOCKER_IMAGE_VERSIONS_TAG=$(ELIXIR_VERSION)-$(PROTOC_VERSION)-$(PROTOBUF_VERSION)

image.build.versions:
		docker build \
			-t $(REPO) -t $(IMAGE_LATEST) . \
			--build-arg ELIXIR_VERSION=$(ELIXIR_VERSION) \
			--build-arg PROTOC_VERSION=$(PROTOC_VERSION) \
			--build-arg PROTOBUF_VERSION=$(PROTOBUF_VERSION) \

build:
		$(MAKE) image.build.versions PROTOBUF_VERSION="0.5.4" ELIXIR_VERSION="1.8.2" PROTOC_VERSION=3.3.0

push:
		docker tag $(IMAGE_LATEST) $(REPO):$(DOCKER_IMAGE_TAG)
		docker push $(REPO):$(DOCKER_IMAGE_TAG)
		docker push $(IMAGE_LATEST)

push.tagged.versions:
		docker tag $(IMAGE_LATEST) $(REPO):$(DOCKER_IMAGE_VERSIONS_TAG)
		docker push $(REPO):$(DOCKER_IMAGE_VERSIONS_TAG)
