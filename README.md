# plugin-arch-grpc-dependencies

Services required to run Plugin Arch gRPC Server and Client locally.

- nginx
- envoy
- grafana
- tempo
- loki
- prometeus
- opentelemetry-collector
- fluentd-loki

## Prerequisites

- docker compose

## Setup

1. Create a docker compose `.env` file based on `.env.template` file. 
2. Fill in the required environment variables in `.env` file.
3. Put `server_cert.key` and `client_cert.key` file in `compose-config/certs` folder.

## Usage

To start the services, run the following command.

```
docker-compose up
```
