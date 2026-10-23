# 0002 Pre-push checks

- Date: 2026-10-22
- Status: Accepted

## Context
The project uses manual operations, with no CI server. Something still has to make sure that broken builds, failing tests and secrets don't get pushed. The options were a written checklist, or a local Git hook that runs checks automatically before every push.

## Decision
Use the written [pre-push checklist](../runbook/pre-push-checklist.md) in every repository, and no Git hook for now.

## Consequences
- Pushing stays fast, and nothing runs that you didn't ask for.
- The checks depend on discipline: a step can be forgotten.
- Revisit this if a broken build or a secret is ever pushed. A hook that only runs the fast checks (compiling, unit tests, a scan for `.env`) would then be the next step.

## Alternatives considered
- **A Git hook running the full build and all tests:** catches mistakes automatically, but makes every push slow, especially once integration tests start containers. Hooks are also per clone, so they have to be installed by hand in every repository.
- **A CI server** (Jenkins, GitHub Actions): ruled out by the decision to use manual operations.
