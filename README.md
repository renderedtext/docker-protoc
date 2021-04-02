# Dockerized Protoc

Run protoc for `/tmp/internal_api/user.proto` file and put out into `/Users/radwo/workspace/semaphore/front/protos/internal_api`:

``` bash
docker run --rm -v /Users/radwo/workspace/semaphore/front:/home/protoc/code -v /tmp/internal_api:/home/protoc/source \
  renderedtext/protoc protoc -I /home/protoc/source -I /home/protoc/source/include \
  --elixir_out=plugins=grpc:/home/protoc/code/protos/internal_api \
  --plugin=/root/.mix/escripts/protoc-gen-elixir /home/protoc/source/user.proto
```
