FROM elixir:1.7-alpine
MAINTAINER Rendered Text <devs@renderedtext.com>

WORKDIR /tmp

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-2.33-r0.apk
RUN apk add glibc-2.33-r0.apk

RUN wget -O /tmp/protoc https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip
RUN unzip protoc
RUN mv bin/protoc /usr/local/bin/protoc

RUN mix local.hex --force
RUN mix escript.install hex protobuf 0.5.4 --force

RUN mkdir -p /home/protoc
VOLUME /home/protoc/source
VOLUME /home/protoc/code
WORKDIR /home/protoc/code

CMD ["protoc", "--version"]
