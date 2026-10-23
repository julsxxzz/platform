# Build and test

## When to use this
Building a service, running its tests, and running it locally so its telemetry shows up in Grafana.
Commands run from the service's folder in cmd.

## Steps

### Build and test
| To | Run |
|---|---|
| Build and run all tests | `gradlew.bat build` |
| Run the tests only | `gradlew.bat test` |
| Build the runnable jar | `gradlew.bat bootJar` (the jar ends up in `build\libs`) |

Integration tests that use Testcontainers need Docker Desktop running.

### Run a service with telemetry
Services are started with the OpenTelemetry Java agent (in the workspace's `tools` folder). It sends traces, logs and metrics to the lgtm container with no telemetry code in the service.

1. Stop any copy that's still running (Ctrl+C in its window). On Windows the jar is locked while it runs, so a rebuild fails otherwise.
2. Build the jar:

   ```bat
   gradlew.bat bootJar
   ```

3. In the same cmd window, tell the agent where to send telemetry. The last line is optional: it sends metrics every 10 seconds instead of 60, handy while testing.

   ```bat
   set OTEL_SERVICE_NAME=<service-name>
   set OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
   set OTEL_METRIC_EXPORT_INTERVAL=10000
   ```

4. Start it:

   ```bat
   java -javaagent:..\tools\opentelemetry-javaagent.jar -jar build\libs\<jar-name>.jar
   ```

From IntelliJ instead: put the `-javaagent:` part under the run configuration's **VM options**, and the `OTEL_` settings under **Environment variables**.

## Check it worked

- The start-up output begins with the agent's banner (`opentelemetry-javaagent - version: ...`).
- After a few requests, in Grafana's **Explore**:
  - **Tempo → Search**, Service Name = the service's name: one trace per request.
  - From a trace, the span's **logs icon** opens the log lines written during that request.
  - **Prometheus**: this query counts requests:

    ```promql
    http_server_request_duration_seconds_count{job="<service-name>"}
    ```

- Grafana's **Dashboards** includes a ready-made JVM dashboard.

## If it didn't

- **Nothing in Grafana:** check the agent banner appeared, and that `OTEL_EXPORTER_OTLP_ENDPOINT` was set in the same window that started the service. Traces can take 10–20 seconds to become searchable.
- **An endpoint returns 404:** the controller method is missing its mapping annotation (for example `@GetMapping`), or the controller isn't in the application's package or below it.
- **The build fails with a locked-file error:** the service is still running. Stop it and build again.
