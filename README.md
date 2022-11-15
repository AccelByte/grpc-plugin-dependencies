# plugin-arch-grpc-dependencies

> :warning: **If you are new to AccelByte Cloud Service Customization gRPC Plugin Architecture**: Start reading from [OVERVIEW.md](OVERVIEW.md) to get the full context.

Dependency services required by `gRPC server` and `gRPC client` for **reliability**, **scalability**, and **observability**. This repository contains docker compose to facilitate local development and testing.

- nginx
- envoy
- grafana
- tempo
- loki
- prometeus
- opentelemetry-collector
- fluentd-loki

## Prerequisites

- docker
- docker compose

## Setup

1. Create a docker compose `.env` file based on `.env.template` file. 
2. Fill in the required environment variables in `.env` file.
3. Put `server_cert.key` and `client_cert.key` file in `compose-config/certs` folder.

## Running

To start the services, run the following command.

```
docker-compose up
```
