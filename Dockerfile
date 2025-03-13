FROM golang:alpine as builder

ENV DUMB_INIT_VERSION=1.2.2 \
    RUVCHAIN_VERSION=0.5.12-5

RUN set -ex \
 && apk --no-cache add \
      build-base \
      curl \
      git \
      
 && git clone "https://github.com/ruvcoindev/ruvchain" /src \
 && cd /src/ruvchain-go \
 && git reset --hard v${RUVCHAIN_VERSION} \
 && ./build \
 && curl -sSfLo /tmp/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64" \
 && chmod 0755 /tmp/dumb-init 

FROM alpine:3.10

LABEL maintainer "Ruvcoindev <admin@ruvcha.in>" \

RUN set -ex \
 && apk --no-cache add bash \

COPY --from=builder /src/ruvchain/ruvchain    /usr/bin/ \
COPY --from=builder /src/ruvchain/ruvchainctl /usr/bin/ \
COPY --from=builder /tmp/dumb-init    /usr/bin/ \
COPY --from=builder   start.sh          /usr/bin/ \

VOLUME /config \

ENTRYPOINT /usr/bin/start.sh
