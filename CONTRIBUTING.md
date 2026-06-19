# Contributing to Let's HAB Backend

Internal contribution guide for the HAB engineering team. This repository is
proprietary; access is limited to authorized contributors.

## Branching

- `main` — production. Protected. Only merges via reviewed PRs.
- `develop` — integration branch for the next release.
- `feature/<short-name>` — new work, branched from `develop`.
- `fix/<short-name>` — bug fixes.
- `hotfix/<short-name>` — urgent production fixes, branched from `main`.

## Commit messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(agent): add spam-filter node to qualification graph
fix(integrations): handle HubSpot 429 with backoff
chore(deps): bump deepgram-sdk to 3.x
docs(readme): clarify realtime service setup
```

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `ci`.

## Local checks before opening a PR

```bash
ruff check .                 # lint
ruff format --check .        # formatting
mypy apps agent realtime     # type checks
pytest --cov=apps --cov=agent --cov=realtime
```

All four must pass. CI runs the same checks.

## Pull requests

1. Branch from `develop` (or `main` for hotfixes).
2. Keep PRs focused and reasonably small.
3. Include tests for new behavior and a clear description.
4. Link the related issue/ticket.
5. Request at least one review. Do not self-merge to `main`.

## Code conventions

- Python 3.12, type hints required on public functions.
- Business logic and persistence live in `apps/`; the realtime path in `realtime/`; agent logic in `agent/`.
- Add new CRM/calendar providers as adapters in `apps/integrations/` implementing the shared adapter interface — do not branch the agent core per provider.
- Never log secrets, full transcripts with PII, or raw recordings. Redact before logging.
- All tenant-scoped queries must filter by tenant; never rely on the agent to enforce isolation.

## Migrations

- Generate with `python manage.py makemigrations` and commit them with the code change.
- Keep migrations backward-compatible where possible (expand/contract pattern).

## Reporting issues

Use the issue tracker with: environment, steps to reproduce, expected vs actual,
and logs with secrets/PII redacted.
