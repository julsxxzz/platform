# Runbook

How to set up, run and operate the payments-ledger environment by hand.
Every entry has the same shape: when to use it, the steps, how to check it worked, and what to do if it didn't.

| Entry | Use it when |
|---|---|
| [First-time setup](first-time-setup.md) | Setting up on a new PC, or after Docker Desktop was reset |
| [Start, stop and status](start-stop-status.md) | Day to day: starting work, stopping, checking what's running |
| [Wipe and start fresh](wipe-and-start-fresh.md) | Data is broken, or the .env passwords were lost |
| [Build and test](build-and-test.md) | Building a service, running its tests, running it with telemetry |
| [Pre-push checklist](pre-push-checklist.md) | Before every git push |
| [Troubleshooting](troubleshooting.md) | Something doesn't work as expected |

Decisions behind this setup are recorded in [../decisions](../decisions).
