# Repository Guidelines

Use this guide to keep contributions consistent and easy to review. The repository is currently minimal; set up the layout and tooling below as you add code.

## Project Structure & Module Organization
- Place primary source under `src/`, grouped by feature or domain; avoid monolithic util folders.
- Mirror source structure in `tests/` for fast lookup between code and coverage.
- Keep reusable scripts in `scripts/` (POSIX shell or Python), and doc notes in `docs/`.
- Store shared configs (formatter, lint, test) at the repo root to avoid duplication.

## Build, Test, and Development Commands
- Prefer a `Makefile` (or `justfile`) with thin wrappers:
  - `make install` installs dependencies (e.g., `npm ci`, `pip install -r requirements.txt`).
  - `make test` runs the default unit suite.
  - `make lint` runs formatters/linters.
  - `make dev` starts the local dev server or watch mode if applicable.
- Keep any language-specific commands documented in `README` and implemented as scripts in `scripts/`.

## Coding Style & Naming Conventions
- Use an auto-formatter for the chosen stack (examples: `prettier`, `black`, `gofmt`) and run it before commits.
- Name directories in `kebab-case`; scripts/util files in `snake_case`; types/components in `PascalCase`.
- Keep functions small and single-purpose; prefer explicit returns over implicit side effects.
- Comment only where intent or constraints are non-obvious; avoid restating the code.

## Testing Guidelines
- Put tests in `tests/`, mirroring source modules (`tests/foo/test_bar.py`, `tests/foo/bar.test.ts`).
- Favor deterministic, isolated tests with representative edge cases and regressions.
- Add coverage flags (`pytest --cov`, `vitest --coverage`, `go test -cover`) and aim for at least 80% where practical.
- Document any required services or fixtures in test module docstrings or `README`.

## Commit & Pull Request Guidelines
- Write imperative commit subjects scoped to one concern (e.g., `add api client`, `fix date parsing`); include a short body with reasoning when non-trivial.
- Reference issues in commit bodies or PR descriptions when relevant.
- PRs should summarize the change set, list verification steps (`make test`, manual checks), and attach screenshots for UI changes.
- Keep diffs focused; open drafts early for feedback rather than batching large changes.

## Git Credentials Handling
- Use the repo-local credential helper already configured: `git config credential.helper 'store --file=.git-credentials'`.
- The token comes from `.env` (`GITHUB_TOKEN`) and is written to `.git-credentials`. That file is ignored; never add credentials to the repo.
- Do not create or use `.git/credentials`; keep tokens only in `.git-credentials` (local) or a user-approved global store when available.
- If home-directory writes are blocked, keep using `.git-credentials` in the repo root; rotate the token if compromised.
