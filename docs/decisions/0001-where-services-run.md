# 0001 Where services run

- Date: 2026-10-22
- Status: Accepted

## Context
Everything runs on one PC with Docker Compose. The infrastructure (PostgreSQL, Kafka, Keycloak, Apicurio, the Pact Broker and Grafana) is always needed. The services can run either as containers in the same Compose setup, or directly on the PC from the IDE or Gradle.

## Decision
- The infrastructure always runs in Compose, and always starts (it has no profile).
- Services run from the IDE or Gradle while they're being developed, with the OpenTelemetry agent attached.
- Services are added to Compose under a `services` profile once several need to run together, for example when Transfer and Ledger first exchange messages. A service started from the IDE can still run alongside the others in Compose.

## Consequences
- Faster changes: rebuild and restart a service in seconds, with the debugger attached, and no Docker image per change.
- Services reach the infrastructure through localhost ports (for example Kafka at `localhost:9092`). Services in Compose use the container names instead (`kafka:19092`), so each service must take these addresses from configuration, not hard-code them.
- Port 8080 is kept free on the PC for the service being worked on.
- Running the whole system together still needs the `services` profile, which doesn't exist yet.

## Alternatives considered
- **Every service always in Compose:** closer to how the system runs as a whole, but every change means rebuilding an image and restarting a container, and debugging is harder.
- **Every service always from the IDE:** simplest at first, but with nine services there would be nine run configurations to start by hand.
