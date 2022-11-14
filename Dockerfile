ARG ELIXIR_VERSION

FROM elixir:${ELIXIR_VERSION}-alpine
MAINTAINER Rendered Text <devs@renderedtext.com>

WORKDIR /tmp

ARG PROTOC_VERSION
ARG PROTOBUF_VERSION

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-2.33-r0.apk
RUN apk add --force-overwrite glibc-2.33-r0.apk

RUN wget -O /tmp/protoc https://github.com/google/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip
RUN unzip protoc
RUN mv bin/protoc /usr/local/bin/protoc

RUN mix local.hex --force
RUN mix escript.install hex protobuf ${PROTOBUF_VERSION} --force

RUN mkdir -p /home/protoc
VOLUME /home/protoc/source
VOLUME /home/protoc/code
WORKDIR /home/protoc/code

CMD ["protoc", "--version"]
