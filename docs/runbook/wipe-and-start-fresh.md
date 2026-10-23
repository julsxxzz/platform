# Wipe and start fresh

## When to use this
Only when the data itself is the problem:
- The `.env` file was lost and the passwords are unknown. PostgreSQL keeps the passwords it was first started with, so new ones won't work until it starts from empty.
- The PostgreSQL init script failed or was changed. It only runs on an empty database.
- Test data has become a mess and a clean slate is easier.

**This permanently deletes everything stored by the environment:**
- PostgreSQL: all databases, including service schemas and data, Keycloak users and settings, Apicurio schemas and Pact contracts
- Kafka: all topics and messages
- Grafana (lgtm): all metrics, logs, traces and Grafana settings

Nothing in Git is affected.

## Steps

1. From the platform folder, stop everything and delete the data volumes:

   ```bat
   docker compose down -v
   ```

2. If the passwords were lost, create a new `.env` from `.env.example` (see [First-time setup](first-time-setup.md), step 3).
3. Start again:

   ```bat
   docker compose up -d
   ```

4. Redo what isn't stored in Git:
   - Keycloak test users (First-time setup, step 8)
   - DBeaver connection passwords, if the `.env` passwords changed
   - Delete the Pact Broker's example data (see [Troubleshooting](troubleshooting.md))
   - Kafka topics, once services use them

## Check it worked

- `docker compose ps` shows all 7 containers **(healthy)**.
- `docker compose logs postgres` shows `running /docker-entrypoint-initdb.d/01-init.sql` with no `ERROR` lines.
- DBeaver connects as the ledger user.

## If it didn't

- **Old data is still there:** the volumes weren't deleted. Before starting again, this should list none of `payments-ledger_postgres-data`, `payments-ledger_kafka-data` or `payments-ledger_grafana-data`:

  ```bat
  docker volume ls
  ```

- **The init script fails:** read the error in `docker compose logs postgres`, fix `config/postgres/01-init.sql`, and wipe again. The script must have LF line endings.
