# plugin-arch-grpc-dependencies

> :warning: **If you are new to AccelByte Cloud Service Customization gRPC Plugin Architecture**: Start reading from [OVERVIEW.md](OVERVIEW.md) to get the full context.

```mermaid
flowchart LR
    CL[gRPC Client]
    SV[gRPC Server]
	EN[Envoy]
    NX[Nginx]
	OT[Open Telemetry Collector]
    TM[(Tempo)]
    LK[(Loki)]
    PM[(Prometheus)]
    GF[Grafana]	
    FL[Fluentd-Loki]
	subgraph Dependency Services
        NX ---|secure grpc\n10000| EN
        EN -.->|traces\n9411| OT
        OT -.->|traces\n4317| TM
        OT -.->|metrics\n9090| PM
        FL -.->|logs\n3100| LK
        TM -.->|traces\n3200| GF
        PM -.->|metrics\n9090| GF
        LK -.->|logs\n3100| GF
    end
    CL ---|grpc\n10001| NX
    CL -.->|traces\n9411| OT
    CL -.->|logs\n3100| LK
    EN ---|grpc\n6565| SV
    SV -.->|metrics\n8080| OT
    SV -.->|traces\n9411| OT
    SV -.->|logs\n24225| FL
```

The `gRPC server` and the `gRPC client` can actually communicate directly. However, additional services are necessary to provide **security**, **reliability**, **scalability**, and **observability**. In this architecture, we call those services as `Dependency Services`.

This repository contains the docker compose of the `Dependency Services` for local development and testing purposes. It consists of the following services.

- nginx
- envoy
- grafana
- tempo
- loki
- prometeus
- opentelemetry-collector
- fluentd-loki

> :warning: **It is important to note:** the dependency services docker compose is provided as an example for local development setup only.

## Prerequisites

- docker
- docker compose

## Setup

1. Create a docker compose `.env` file based on `.env.template` file. 
2. Fill in the required environment variables in `.env` file.
3. Put `server.key` and `client.key` file in `compose-config/certs` folder.

## Running

To start the services, run the following command.

```
docker-compose up
```

## Usage

## Accessing Grafana Dashboard

The Grafana dashboard can be accessed at http://localhost:3000.

## Running with Ngrok

To allow `gRPC Client` in AccelByte Cloud to access `gRPC Server` in local development environment without requiring a public IP address, we can use [ngrok](https://ngrok.com/).

1. Sign-in/sign-up to [ngrok](https://ngrok.com/). Get your auth token in ngrok Dashboard.

2. Open `.env` file and  set `NGROK_AUTHTOKEN` with your ngrok auth token.

3. You can set `NGROK_TARGET_PORT` to 10000 to use Envoy mTLS.

4. Start the services with following command.
    ```
    docker-compose -f docker-compose-ngrok.yaml up
    ```

## Generate Certificates

For mTLS, CA-signed certificate is required. To generate those certificates, run the following command.

```
make certificate
```

By default, certificates will be generated inside `compose-config/certs` directory. To generate certificates to different directory, run the following command.

```
make certificate CERT_TARGET_DIR=<path-to-directory>
```
