# Dockerized Protoc

This repository holds receipts for production of Dockerized `protoc` plugin for Elixir.
We use these Docker images in the development process accross our Elixir projects
in order to make sure that every team member uses the same `protoc` version.

## Usage

Docker run should be executed with the following options set:
- assign local directories to the following Docker container volumes `/home/protoc/code` and `/home/protoc/source`
  - `/home/protoc/code` - working directory (`$PWD` in the following example)
  - `/home/protoc/source` - directory that contains already generated protos (`$TMP_PROTO_DIR`)
- specify the protos output path within your local environment (`$PROTO_OUTPUT_DIR`)
- specify Docker container path of the target `proto` file (ie. file that needs to be compiled with `protoc` and is present in `$TMP_PROTO_DIR` locally; eg. `/home/protoc/source/user.proto`)
- specify Docker protoc image tag (`$PROTOC_IMG_VSN`); when not specified `latest` will be used

``` bash
docker run --rm -v $PWD:/home/protoc/code -v $TMP_PROTO_DIR:/home/protoc/source \
  renderedtext/protoc:$PROTOC_IMG_VSN protoc -I /home/protoc/source -I /home/protoc/source/include \
  --elixir_out=plugins=grpc:$PROTO_OUTPUT_DIR \
  --plugin=/root/.mix/escripts/protoc-gen-elixir /home/protoc/source/user.proto
```

## Deployment

New Docker image deployment is managed with the following promotions
within [`docker-protoc`] Semaphore project:
- parametrized promotion
- legacy promotion

Resulting Docker images are tagged (as described below) and pushed to Dockerhub repository ([`renderedtext/protoc`]).

### Parametrized promotion

Available parameters:

- Elixir version (required, default `v1.11.4`)
- `protoc` version (required, default `3.17.3`)
- Protobuf version (optional)

This promotion constructs a tag in the following form:

`<elixir_version>-<protoc_version>-<protobuf_version>`

### Legacy promotion

This promotion relies on `make build` and `make push` target sequences.
Produced image is pushed to repository with `latest` and `git commit sha` tags.
It is based on `Elixir v1.8.2`, `Protobuf v0.5.4` and `protoc v3.3.0`.
This image is used by some of projects in the production (eg. UI project [`front`]).

[`docker-protoc`]: https://semaphore.semaphoreci.com/projects/docker-protoc
[`renderedtext/protoc`]: https://hub.docker.com/repository/docker/renderedtext/protoc
[`front`]: https://semaphore.semaphoreci.com/projects/front
