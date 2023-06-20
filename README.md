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

1. Create a docker compose `.env` file based on `.env.template` file. Modify any environment variables in the `.env` file if necessary.

2. To run the services with gRPC mTLS enabled, run the following command to generate self-signed certificates required for mTLS secured gRPC for local development environment only.

   ```
   make certificate
   ```

   You can find the generated root CA, key, and certificate files for both `gRPC server` and `gRPC client` in `certs` folder.

## Running

To run the services, run the following command.

With gRPC mTLS disabled:

```
docker-compose up
```

OR

With gRPC mTLS enabled:

```
docker-compose -f docker-compose-mtls.yaml up
```

> :warning: **The `gRPC client` mTLS configuration need to be set accordingly:** if gRPC mTLS is enabled here, then the mTLS configuration in `gRPC client` also need to be enabled and vice versa.

## Administration and Observability

1. `Grafana` can be accessed at http://localhost:3000 to view the metrics, traces, and logs emitted. Some sample dashboards are included.

2. `Envoy` admin interface can be accessed at http://localhost:9901.

## Exposing Local gRPC Server to AccelByte Gaming Services

To test `gRPC server` running in local development environment with AccelByte Gaming Services, it needs to be exposed to the internet.
In order to do this without requiring a public IP address, we can use something like [ngrok](https://ngrok.com/).

1. Sign-in/sign-up to [ngrok](https://ngrok.com/) and get your auth token in `ngrok` dashboard.

2. Run the following command to expose `gRPC server` Envoy proxy port in local development environment to the internet.

   ```
   make ngrok NGROK_AUTHTOKEN=xxxxxxxxxxx
   ```
   
3. Follow specific instruction of each AccelByte Gaming Services to register your `ngrok` endpoint.