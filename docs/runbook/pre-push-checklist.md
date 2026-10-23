# Pre-push checklist

## When to use this
Before every `git push`, in any repository. There's no CI server, so this checklist does that job (see decision 0002).

## Steps

- [ ] **The build and all tests pass:** `gradlew.bat build` ends with BUILD SUCCESSFUL.
- [ ] **No secrets in the changes:** `git status` doesn't list `.env`, and the diff (`git diff --staged`) has no passwords, tokens or keys.
- [ ] **Only intended files are staged:** no build output, IDE files or local test files.
- [ ] **Schema changes pass the compatibility check** against Apicurio (for repositories that contain event schemas).
- [ ] **Contract tests pass**, and new contracts are published to the Pact Broker (for services that send or receive messages or API calls from other services).
- [ ] **The runbook is updated** if the change adds or changes an operation.
- [ ] **The commit message says what changed.**

## Check it worked

- After pushing, `git status` says the branch is up to date with `origin/main`.

## If it didn't

- **The push is rejected:** someone (or another machine) pushed first. Pull, check everything still builds, and push again:

  ```bat
  git pull
  ```
 Force pushes are blocked by the repository's protect-main ruleset.
- **A secret was committed:** don't just delete it in a new commit, because it stays in the history. Change the password, then remove it from the history before pushing.
