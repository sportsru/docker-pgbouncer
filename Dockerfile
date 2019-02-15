FROM alpine

FROM alpine:latest AS build_stage

MAINTAINER "robert@aztek.io"

RUN apk --update add \
        autoconf \
        autoconf-doc \
        automake \
        c-ares \
        c-ares-dev \
        curl \
        gcc \
        libc-dev \
        libevent \
        libevent-dev \
        libtool \
        make \
        man \
        libressl-dev \
        pkgconfig

ARG PGBOUNCER_VERSION

RUN curl -o  "/tmp/pgbouncer.tar.gz" -L "https://pgbouncer.github.io/downloads/files/${PGBOUNCER_VERSION}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz"

WORKDIR /tmp

RUN mkdir /tmp/pgbouncer && \
        tar -zxvf pgbouncer.tar.gz -C /tmp/pgbouncer --strip-components 1

WORKDIR /tmp/pgbouncer

RUN ./configure --prefix=/usr && \
        make

FROM alpine:latest
RUN apk --update add libevent openssl c-ares
WORKDIR /
COPY --from=build_stage /tmp/pgbouncer /pgbouncer

EXPOSE 5432
USER postgres

ADD ["entrypoint.sh", "/"]
ENTRYPOINT ["/entrypoint.sh"]

