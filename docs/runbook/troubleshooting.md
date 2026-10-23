# Troubleshooting

## When to use this
Something doesn't behave as expected. Each problem below was actually hit while building this environment.

## Steps
Find the symptom and follow its fix. Add new problems here as they happen.

### Environment

| Symptom | Cause | Fix |
|---|---|---|
| A container won't start: "port is already allocated" | Another program uses the port | Find it with `netstat -ano \| findstr "LISTENING" \| findstr ":<port> "`, then stop it or change the port in compose.yml |
| Docker commands fail with "error during connect" | Docker Desktop isn't running | Start Docker Desktop and wait for "Engine running" |
| Laravel Herd and this environment at the same time | Herd uses ports 80 and 443 | No conflict: this environment doesn't use 80 or 443 |

### PostgreSQL

| Symptom | Cause | Fix |
|---|---|---|
| Users, databases or schemas are missing | The init script only runs when the data volume is empty | Wipe and start fresh |
| The init script fails with strange errors | Windows line endings (CRLF) | Save `01-init.sql` with LF endings; `.gitattributes` keeps it that way |
| A service user can't create tables in another service's schema | Each schema belongs to its own user | Expected: services only use their own schema |

### Kafka

| Symptom | Cause | Fix |
|---|---|---|
| A message typed into the console producer never arrives | Ctrl+C was pressed before the producer sent it | Pipe the text in instead: `echo <text> \| docker compose exec -T kafka /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic <topic>`, or wait a second before Ctrl+C |
| The console consumer ends with `TimeoutException` and "Processed a total of 0 messages" | That's how `--timeout-ms` stops | Normal. Use `--max-messages <n>` to stop cleanly |
| Messages come back in a different order | Order is only kept within one partition | Expected. Messages that must stay in order need the same key |
| Writing to a topic fails because it doesn't exist | Automatic topic creation is off | Create the topic first with `kafka-topics.sh --create` |

### Keycloak

| Symptom | Cause | Fix |
|---|---|---|
| Changes to the realm file have no effect | The realm is only imported if it doesn't exist yet | Make the change in the admin console too, or wipe and start fresh |
| A token request fails with `invalid_grant` | Wrong password, or the user still has a required action (such as a temporary password) | Set a non-temporary password and check the user's required actions |

### Apicurio and the Pact Broker

| Symptom | Cause | Fix |
|---|---|---|
| A schema can't be deleted: "Artifact deletion operation is not enabled" | Apicurio blocks deletion by default | compose.yml switches it on with `APICURIO_REST_DELETION_ARTIFACT_ENABLED` |
| A schema change is rejected as incompatible | The FULL rule ([decision 0004](../decisions/0004-schema-compatibility-full.md)): no removing fields, no type changes, new fields need defaults | Make the change compatible, or publish a new version of the event beside the old one |
| The Apicurio UI shows errors loading data | The API doesn't allow the UI's address (CORS) | `QUARKUS_HTTP_CORS_ORIGINS` must include `http://localhost:8086` |
| The Pact Broker lists "Example App" and "Example API" | Example data added to an empty database | `curl.exe -u pact:<PACT_BROKER_PASSWORD> -X DELETE "http://localhost:9292/pacticipants/Example%20App"`, then the same for `Example%20API` |

### Grafana and telemetry

| Symptom | Cause | Fix |
|---|---|---|
| Changing `GRAFANA_ADMIN_PASSWORD` in .env has no effect | Grafana only reads it on its first start | Change the password in Grafana itself, or wipe and start fresh |
| A service's traces don't appear | The agent isn't attached, or the endpoint setting is missing | See [Build and test](build-and-test.md) |

### Windows and tools

| Symptom | Cause | Fix |
|---|---|---|
| `docker login` or another command rejects a correct password piped in from PowerShell | PowerShell adds an invisible line ending | Type the password at the prompt, or pass it from a file with no line ending |
| curl inside a container can't reach `something.localhost` | curl treats every `*.localhost` name as the container itself | Use the container's name, or test with another tool |
| An endpoint returns 404 although the controller exists | The method has no mapping annotation | Add `@GetMapping` (or similar) and rebuild |

## Check it worked
The symptom is gone, and `docker compose ps` shows everything healthy.

## If it didn't
Read the container's full log with `docker compose logs <name>`, and add the problem and its fix to this page once solved.
