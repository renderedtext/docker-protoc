.PHONY: build push

DOCKER_IMAGE_TAG=$(shell git rev-parse --short HEAD)

build:
		docker build -t renderedtext/protoc .

push:
		docker tag renderedtext/protoc:latest renderedtext/protoc:$(DOCKER_IMAGE_TAG)
		docker push renderedtext/protoc:$(DOCKER_IMAGE_TAG)
		docker push renderedtext/protoc:latest
