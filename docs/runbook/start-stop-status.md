# Start, stop and status

## When to use this
Day to day: starting the environment before work, stopping it afterwards, and checking what's running.
All commands run from the platform folder.

## Steps

| To | Run |
|---|---|
| Start everything | `docker compose up -d` |
| See what's running and whether it's healthy | `docker compose ps` |
| Stop everything, **keeping all data** | `docker compose down` |
| Read one container's log | `docker compose logs <name>` (add `-f` to keep following it, Ctrl+C to stop) |
| Restart one container | `docker compose restart <name>` |
| Apply a change to compose.yml | `docker compose up -d` (only the changed containers are recreated) |
| See memory use | `docker stats --no-stream` |

Container names: `postgres`, `kafka`, `keycloak`, `apicurio`, `apicurio-ui`, `pact-broker`, `lgtm`.

Start-up order is handled by Compose: Keycloak, Apicurio and the Pact Broker wait until PostgreSQL is healthy, and the Apicurio UI waits for Apicurio.

Memory, idle: about 1.8 GB for all 7 containers (Keycloak about 550 MB, lgtm about 460 MB, Kafka about 340 MB, Apicurio about 240 MB, PostgreSQL about 80 MB, Pact Broker about 75 MB, Apicurio UI about 15 MB). lgtm grows as telemetry builds up.

## Check it worked

- After starting: `docker compose ps` shows all 7 containers **(healthy)**. Kafka and Keycloak take up to a minute.
- After stopping: `docker compose ps` shows nothing, and starting again brings back all data (database contents, Keycloak users, Kafka topics, schemas, contracts, Grafana data).

## If it didn't

- **A container stays "starting" or becomes "unhealthy":** read its log with `docker compose logs <name>`.
- **Docker commands fail with "cannot find the file specified" or "error during connect":** Docker Desktop isn't running. Start it and wait for "Engine running".
- **Never add `-v` to `docker compose down` by accident:** that deletes all data. See [Wipe and start fresh](wipe-and-start-fresh.md).
