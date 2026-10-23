# First-time setup

## When to use this
Setting up the environment on a PC for the first time, or after Docker Desktop was reset.

## Steps

1. **Install** (once per PC):
   - Git
   - Docker Desktop with the WSL2 backend
   - Java 21 (JDK)
   - DBeaver (database client)

2. **Clone the platform repository** into the workspace folder:

   ```bat
   git clone https://github.com/julsxxzz/platform.git
   ```

3. **Create the environment file.** In the platform folder, copy `.env.example` to `.env` and give every variable a random password.
   Use letters and numbers only (symbols like `$` or `#` break `.env` files). One way to generate one:

   ```bat
   powershell -Command "-join ((48..57)+(65..90)+(97..122) | Get-Random -Count 24 | % {[char]$_})"
   ```

   The `.env` file is the only copy of these passwords and must never be committed.

4. **Check the ports are free.** This must print nothing:

   ```bat
   netstat -ano | findstr "LISTENING" | findstr ":5432 :9092 :8180 :8085 :8086 :9292 :3000 :4317 :4318"
   ```

   | Port | Used by |
   |---|---|
   | 5432 | PostgreSQL |
   | 9092 | Kafka |
   | 8180 | Keycloak |
   | 8085 | Apicurio Registry (API) |
   | 8086 | Apicurio Registry (web UI) |
   | 9292 | Pact Broker |
   | 3000 | Grafana |
   | 4317, 4318 | Telemetry from services (OTLP) |
   | 8080 | Kept free for running a service from the IDE |

5. **Start everything** from the platform folder:

   ```bat
   docker compose up -d
   ```

   The first start downloads the images and takes a few minutes.

6. **Download the OpenTelemetry Java agent** into the workspace's `tools` folder (shared by all services). From the workspace folder:

   ```bat
   mkdir tools
   curl.exe -L -o tools\opentelemetry-javaagent.jar https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.32.0/opentelemetry-javaagent.jar
   ```

7. **Set up DBeaver connections** (PostgreSQL, host `localhost`, port `5432`):

   | Connection | Database | User | Password from .env |
   |---|---|---|---|
   | Admin | postgres | postgres | POSTGRES_PASSWORD |
   | Ledger | payments | ledger | LEDGER_DB_PASSWORD |
   | Transfer | payments | transfer | TRANSFER_DB_PASSWORD |

8. **Optional: create a Keycloak test user** for trying out logins. In the Keycloak admin console, switch to the Payments Ledger realm, add a user (first name, last name and email are required), then set a password on its Credentials tab with Temporary turned off.

## Check it worked

- `docker compose ps` shows 7 containers, all **(healthy)**: postgres, kafka, keycloak, apicurio, apicurio-ui, pact-broker, lgtm.
- These pages open and accept the logins:

  | Page | Address | Login |
  |---|---|---|
  | Grafana | http://localhost:3000 | admin / GRAFANA_ADMIN_PASSWORD |
  | Keycloak admin | http://localhost:8180 | admin / KEYCLOAK_ADMIN_PASSWORD |
  | Apicurio Registry | http://localhost:8086 | none |
  | Pact Broker | http://localhost:9292 | pact / PACT_BROKER_PASSWORD |

- DBeaver connects as the ledger user and shows the ledger schema.
- Grafana's Connections → Data sources lists Prometheus, Loki, Tempo and Pyroscope.

## If it didn't

- **A container isn't healthy:** read its log:

  ```bat
  docker compose logs <name>
  ```

- **A port is in use:** see [Troubleshooting](troubleshooting.md). Laravel Herd uses 80 and 443, not these ports.
- **PostgreSQL's users or databases are missing:** the init script only runs on the very first start. See [Wipe and start fresh](wipe-and-start-fresh.md).
- **The Pact Broker shows "Example App" and "Example API":** that's example data it adds to an empty database. Delete it as described in [Troubleshooting](troubleshooting.md).
