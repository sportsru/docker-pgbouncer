FROM alpine:3.9

FROM alpine:3.9 AS build_stage

LABEL maintainer "robert@aztek.io"

RUN apk --update --no-cache add \
        autoconf=2.69-r2 \
        autoconf-doc=2.69-r2 \
        automake=1.16.1-r0 \
        c-ares=1.15.0-r0 \
        c-ares-dev=1.15.0-r0 \
        curl=7.64.0-r1 \
        gcc=8.2.0-r2 \
        libc-dev=0.7.1-r0 \
        libevent=2.1.8-r6 \
        libevent-dev=2.1.8-r6 \
        libtool=2.4.6-r5 \
        make=4.2.1-r2 \
        libressl-dev=2.7.5-r0 \
        pkgconf=1.6.0-r0

ARG PGBOUNCER_VERSION

RUN curl -Lo  "/tmp/pgbouncer.tar.gz" "https://pgbouncer.github.io/downloads/files/${PGBOUNCER_VERSION}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz"

WORKDIR /tmp

RUN mkdir /tmp/pgbouncer && \
        tar -zxvf pgbouncer.tar.gz -C /tmp/pgbouncer --strip-components 1

WORKDIR /tmp/pgbouncer

RUN ./configure --prefix=/usr && \
        make

FROM alpine:3.9

RUN apk --update --no-cache add \
        libevent=2.1.8-r6 \
        libressl=2.7.5-r0 \
        c-ares=1.15.0-r0

WORKDIR /etc/pgbouncer
WORKDIR /var/log/pgbouncer

RUN chown -R postgres:root \
        /etc/pgbouncer \
        /var/log/pgbouncer

USER postgres

COPY --from=build_stage --chown=postgres ["/tmp/pgbouncer", "/opt/pgbouncer"]
COPY --chown=postgres ["entrypoint.sh", "/opt/pgbouncer"]

WORKDIR /opt/pgbouncer
ENTRYPOINT ["/opt/pgbouncer/entrypoint.sh"]

