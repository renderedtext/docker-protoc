.PHONY: build push setup

REPO=us.gcr.io/semaphore2-prod/protoc
IMAGE_LATEST=$(REPO):latest
DOCKER_IMAGE_TAG=$(shell git rev-parse --short HEAD)

ELIXIR_VERSION=1.6.6
PROTOC_VERSION=3.3.0
PROTOBUF_VERSION=0.5.4

DOCKER_IMAGE_VERSIONS_TAG=$(ELIXIR_VERSION)-$(PROTOC_VERSION)-$(PROTOBUF_VERSION)

image.build.versions: setup
		docker buildx build \
			--platform linux/amd64,linux/arm64 \
			-t $(REPO) -t $(IMAGE_LATEST) . \
			--build-arg ELIXIR_VERSION=$(ELIXIR_VERSION) \
			--build-arg PROTOC_VERSION=$(PROTOC_VERSION) \
			--build-arg PROTOBUF_VERSION=$(PROTOBUF_VERSION) 

build: 
		$(MAKE) image.build.versions PROTOBUF_VERSION="0.5.4" ELIXIR_VERSION="1.8.2" PROTOC_VERSION=3.3.0

push:
		docker tag $(IMAGE_LATEST) $(REPO):$(DOCKER_IMAGE_TAG)
		docker push $(REPO):$(DOCKER_IMAGE_TAG)
		docker push $(IMAGE_LATEST)

pull: 
	docker pull $(IMAGE_LATEST)
	docker pull $(REPO):$(DOCKER_IMAGE_TAG)

push.tagged.versions:
		docker tag $(IMAGE_LATEST) $(REPO):$(DOCKER_IMAGE_VERSIONS_TAG)
		docker push $(REPO):$(DOCKER_IMAGE_VERSIONS_TAG)

setup:
	docker run --privileged --rm tonistiigi/binfmt --install all
	docker buildx create --name mybuilder
	docker buildx use mybuilder

configure.gcloud:
	gcloud auth activate-service-account $(GCP_REGISTRY_WRITER_EMAIL) --key-file ~/gce-registry-writer-key.json
	gcloud --quiet auth configure-docker