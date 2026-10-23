# 0004 Event schema compatibility: FULL

- Date: 2026-10-22
- Status: Accepted

## Context
Event schemas (Avro) are stored in the Apicurio Registry, which checks every new version against the previous one using a compatibility rule.

The project's rule for event changes is:
- **Allowed:** adding an optional field with a default value.
- **Not allowed:** removing a field, renaming a field, or changing a field's type.

The commonly used BACKWARD rule doesn't enforce this. It only checks that the **new** schema can read **old** messages, so testing showed it:
- rejects adding a field without a default,
- but **accepts removing a field**.

## Decision
Apicurio's global compatibility rule is **FULL**: new and old schemas must each be able to read the other's messages. Tested against this Apicurio:

| Change | FULL |
|---|---|
| Add a field with a default | Accepted |
| Add a field without a default | Rejected |
| Remove a field | Rejected |
| Change a field's type | Rejected |

## Consequences
- The registry enforces the project's rule: the only allowed change is adding an optional field with a default.
- Producers and consumers can be upgraded in either order.
- Anything else is a breaking change. It's handled by publishing a new version of the event (for example `TransferCompletedV2`) beside the old one, moving consumers over, then retiring the old one.

## Alternatives considered
- **BACKWARD:** allows removing fields, which breaks consumers that still read them.
- **FORWARD:** the mirror image of BACKWARD (old schemas must read new messages). Allows removing optional fields but not adding required ones; it doesn't match the rule either.
- **The TRANSITIVE variants** (checking against every earlier version, not just the last one): stricter. Worth considering once schemas have many versions.
