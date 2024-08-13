# grpc-plugin-dependencies

```mermaid
flowchart LR
    CL[gRPC Client]
    SV[gRPC Server]
	EN[Envoy]
	OT[Open Telemetry Collector]
    TM[(Tempo)]
    LK[(Loki)]
    PM[(Prometheus)]
    GF[Grafana]	
    FL[Fluentd-Loki]
	subgraph Dependency Services

        EN -.->|traces\n9411| OT
        OT -.->|traces\n4317| TM
        OT -.->|metrics\n9090| PM
        FL -.->|logs\n3100| LK
        TM -.->|traces\n3200| GF
        PM -.->|metrics\n9090| GF
        LK -.->|logs\n3100| GF
    end
    CL ---|grpc/grpc mtls\n10000| EN
    CL -.->|traces\n9411| OT
    CL -.->|logs\n3100| LK
    EN ---|grpc\n6565| SV
    SV -.->|metrics\n8080| OT
    SV -.->|traces\n9411| OT
    SV -.->|logs\n24225| FL
```

The `gRPC server` and the `gRPC client` can actually communicate directly. However, additional services are necessary to provide **security**, **reliability**, **scalability**, and **observability**. In this architecture, we call those services as `dependency services`.

This repository contains the docker compose of the `dependency services`. It consists of the following services.

- envoy
- grafana
- tempo
- loki
- prometeus
- opentelemetry-collector
- fluentd-loki

> :warning: **It is important to note:** the dependency services docker compose is provided as an example for local development environment only.

## Prerequisites

- docker v23.x
- docker compose v2.x

## Setup

Create a docker compose `.env` file based on `.env.template` file. Modify any environment variables in the `.env` file if necessary.

## Running

To run the services, run the following command.

```
docker-compose up
```

## Administration and Observability

1. `Grafana` can be accessed at http://localhost:3000 to view the metrics, traces, and logs emitted. Some sample dashboards are included.

2. `Envoy` admin interface can be accessed at http://localhost:9901.
