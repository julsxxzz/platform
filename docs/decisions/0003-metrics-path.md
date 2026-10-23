# 0003 How telemetry reaches Grafana

- Date: 2026-10-22
- Status: Accepted

## Context
Every service must send metrics, logs and traces to Grafana, so one transfer can be followed across all services. The observability stack is Grafana's all-in-one container (lgtm: Grafana, Prometheus, Loki, Tempo and an OpenTelemetry collector). Metrics can reach Prometheus in two ways:
- **Push:** each service sends its metrics to the collector over OTLP.
- **Pull:** Prometheus fetches each service's metrics endpoint on a schedule, from a list of service addresses.

## Decision
Services **push** everything (metrics, logs and traces) over OTLP to the lgtm container, using the OpenTelemetry Java agent. Services need no telemetry code: they're started with the agent and three settings (service name, endpoint, export interval). See [Build and test](../runbook/build-and-test.md).

Proven while setting up the environment, with a placeholder service: its requests appeared in Tempo as traces, its log lines in Loki with matching trace ids, and its request counts and JVM metrics in Prometheus.

## Consequences
- New services appear in Grafana automatically. There's no list of service addresses to maintain.
- Logs and traces are linked by trace id with no extra setup.
- Alerts are built with Grafana's own alerting, because the all-in-one container has no Alertmanager.
- The agent adds a little start-up time and memory to each service.

## Alternatives considered
- **A separate Prometheus pulling from each service's actuator endpoint:** the classic Prometheus setup, good to know, but it means one more container and a list of every service's address to keep up to date.
- **Micrometer's OTLP exporter inside each service instead of the agent:** works too, but needs dependencies and settings in every service, and doesn't record traces and logs as completely without extra work.
