# Decision records

Short records of decisions that shape this project: what was decided, why, and what else was considered.
Numbered in the order they were made. A decision is changed by writing a new record that replaces the old one, not by editing history.

| # | Decision | Status |
|---|---|---|
| [0001](0001-where-services-run.md) | Infrastructure runs in Compose; services run from the IDE or Gradle while being developed | Accepted |
| [0002](0002-pre-push-checks.md) | A written pre-push checklist instead of a Git hook | Accepted |
| [0003](0003-metrics-path.md) | Services push metrics, logs and traces over OTLP through the OpenTelemetry agent | Accepted |
| [0004](0004-schema-compatibility-full.md) | Event schemas use the FULL compatibility rule, not BACKWARD | Accepted |
