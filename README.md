# README

## Fork of https://gitlab.com/aztek-io/oss/containers/pgbouncer-container

## GENERAL DOCUMENTATION

All options defined in `/etc/pgbouncer/pgbouncer.ini` can be overridden using environment variables by using the syntax `<SectionName>_<KeyName>`. For example:

```
docker run -d \
    -p 5439:5439 \
    --name=pgbouncer \
    -e "DATABASES_HOST=redshift.server.name" \
    -e "DATABASES_PORT=5439" \
    -e "DATABASES_USER=awsuser" \
    -e "DATABASES_PASSWORD=secret" \
    -e "DATABASES_DBNAME=mydatabase" \
    -e "PGBOUNCER_LISTEN_PORT=5439" \
    pgbouncer/pgbouncer
```

This will output an ini file of:

```
#pgbouncer.ini

[databases]
* = host = redshift.server.name port=5439 user=awsuser password=secret dbname=mydatabase

[pgbouncer]
listen_addr = 0.0.0.0
listen_port = 5439
auth_type = any
ignore_startup_parameters = extra_float_digits

# Log settings
admin_users = postgres

# Connection sanity checks, timeouts

# TLS settings

# Dangerous timeouts
```

Please note:

As of right now only one DB Connection string per container is accepted.

## ADD IN FORK

### Section `[databases]` of pgbouncer.ini in raw format and symbol `|` is seporator of lines:

```
docker run -d \
    -p 5439:5439 \
    --name=pgbouncer \
    -e "DATABASES_RAW='mydatabase = host=redshift.server.name port=5439 user=awsuser password=secret dbname=mydatabase|mydatabase2 = host=redshift2.server.name port=5439 user=awsuser2 password=secret2 dbname=mydatabase2'"
    -e "PGBOUNCER_LISTEN_PORT=5439" \
    pgbouncer/pgbouncer
```
This will output an ini file of:

```
#pgbouncer.ini

[databases]
mydatabase = host = redshift.server.name port=5439 user=awsuser password=secret dbname=mydatabase
mydatabase2 = host=redshift2.server.name port=5439 user=awsuser2 password=secret2 dbname=mydatabase2

[pgbouncer]
listen_addr = 0.0.0.0
listen_port = 5439
auth_type = any
ignore_startup_parameters = extra_float_digits

# Log settings
admin_users = postgres

# Connection sanity checks, timeouts

# TLS settings

# Dangerous timeouts
```

## BUILD INFO

This is an automated weekly build that will kick off at midnight on Sunday (CDT).

This was created since pgbouncer does not have an official docker image.

## HUB REPO

Here is the hub.docker.com repo:

https://hub.docker.com/r/sportsru/pgbouncer

