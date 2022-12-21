# AccelByte Cloud Service Customization gRPC Plugin Architecture

## Overview

```mermaid\
flowchart LR
   subgraph AB Cloud Service
   CL[gRPC Client]
   end
   subgraph External Hosting
   SV[gRPC Server]
   DS[Dependency Services]
   CL --- DS
   end
   DS --- SV
```

AccelByte Cloud Service Customization gRPC Plugin Architecture consists of three (3) components.

- `gRPC server`
- `gRPC client`
- `dependency services`

### gRPC Server

A **stateless** gRPC server containing custom logic implemented by customer according to the provided *.proto file by AccelByte. The *.proto file used depends on the AccelByte Cloud service feature being customized. 

Sample projects for this in C#, Go, Java, and Python are available. Customers can pick one or more language to implement this.

See the following repositories.

- For matchmaking custom function:

   - `matchmaking-function-grpc-plugin-server-csharp`
   - `matchmaking-function-grpc-plugin-server-go`
   - `matchmaking-function-grpc-plugin-server-java`
   - `matchmaking-function-grpc-plugin-server-python`

- For chat filter custom function:

   - `chat-filter-grpc-plugin-server-go`

### gRPC Client

The corresponding gRPC client to call gRPC server created by customers. It is implemented in AccelByte Cloud service for each feature which can be customized. This sample gRPC client app project is provided to customers to help with local development and testing purposes only. 

Sample projects for this in Go and Java are available. It is possible for a gRPC client in one language to communicate with gRPC server in a different language.

See the following repositories.

- For matchmaking custom function:

   - `matchmaking-function-grpc-plugin-client-go`
   - `matchmaking-function-grpc-plugin-client-java`

- For chat filter custom function:

   - `chat-filter-grpc-plugin-client-go`

### Dependency Services

While the `gRPC server` and the `gRPC client` are able communicate directly, additional services are necessary to provide **security**, **reliability**, **scalability**, and **observability**. These dependency services are packaged as a docker compose file.

See `grpc-plugin-dependencies` repository.

> :warning: **It is important to note:** the dependency services docker compose is provided as an example for local development environment only.

## How to Run The Sample Projects

### For Matchmaking Custom Function

#### Instruction

1. Run `dependency services` for local development and testing.

   a. Clone `grpc-plugin-dependencies` repository. 

   b. Follow the `README.md` inside to setup and run it. 

   c. Keep it running.

2. Run a `gRPC server`, for example `matchmaking-function-grpc-plugin-server-java`.

   a. Clone `matchmaking-function-grpc-plugin-server-java` repository. 

   b. Follow the `README.md` inside to setup, build, and run it. 
   
   c. Keep it running.

3. Run `gRPC client`, for example `matchmaking-function-grpc-plugin-client-java`.

   a. Clone `matchmaking-function-grpc-plugin-client-java` repository. 

   b. Follow the `README.md` inside to setup, build, and run it.

   c. Try it out! See the instruction in `README.md`.

#### Demonstration

[![asciicast](https://asciinema.org/a/546011.svg)](https://asciinema.org/a/546011)

### For Chat Filter Custom Function

#### Instruction

1. Run `dependency services` for local development and testing.

   a. Clone `grpc-plugin-dependencies` repository. 

   b. Follow the `README.md` inside to setup and run it. 

   c. Keep it running.

2. Run a `gRPC server`, for example `chat-filter-grpc-plugin-server-go`.

   a. Clone `chat-filter-grpc-plugin-server-go` repository. 

   b. Follow the `README.md` inside to setup, build, and run it. 
   
   c. Keep it running.

3. Run `gRPC client`, for example `chat-filter-grpc-plugin-client-go`.

   a. Clone `chat-filter-grpc-plugin-client-go` repository. 

   b. Follow the `README.md` inside to setup, build, and run it.

   c. Try it out! See the instruction in `README.md`.

#### Demonstration

[![asciicast](https://asciinema.org/a/546010.svg)](https://asciinema.org/a/546010)