# Repository Guidelines

## Project Structure & Module Organization

This repository is organized around reusable agent skills.

- `README.md`: project overview and usage summary.
- `skills/kegg-api/SKILL.md`: primary skill definition and workflow.
- `skills/kegg-api/scripts/kegg_fetch.sh`: Bash helper for KEGG REST API calls.
- `skills/kegg-api/references/api-reference.md`: detailed KEGG API reference.
- `.github/renovate.json`: dependency update automation settings.

When adding a new skill, follow the same layout: `skills/<skill-name>/` with `SKILL.md`, and optional `scripts/` and `references/`.

## Build, Test, and Development Commands

There is no build step; development is file-based and command-line driven.

- `bash skills/kegg-api/scripts/kegg_fetch.sh info pathway`: quick smoke test against KEGG.
- `bash skills/kegg-api/scripts/kegg_fetch.sh find compound aspirin`: example functional query.
- `bash -n skills/kegg-api/scripts/kegg_fetch.sh`: shell syntax check.
- `rg --files skills`: list tracked skill files and verify paths referenced in docs.

Run commands from the repository root.

## Coding Style & Naming Conventions

- Use Markdown with clear ATX headings (`#`, `##`) and fenced code blocks for commands.
- Keep instructions direct and task-oriented; prefer concise bullet lists over long prose.
- Bash scripts should keep strict mode (`set -euo pipefail`), quote variables, and use `${var}` syntax.
- Use 2-space indentation in shell control blocks.
- Skill directories use lowercase kebab-case (for example, `kegg-api`).
- Script files use lowercase snake_case with `.sh` suffix (for example, `kegg_fetch.sh`).

## Testing Guidelines

No formal test framework is configured yet. For changes, use lightweight validation:

- Run `bash -n` for script syntax.
- Execute at least one successful API call and one invalid-input path to confirm error handling.
- For documentation updates, verify that all referenced files and commands exist and run.

Include manual verification steps in your pull request description.

## Commit & Pull Request Guidelines

- Keep commits small and single-purpose.
- Write commit subjects in imperative mood; optional Conventional Commit prefixes (for example, `chore: ...`) are consistent with history.
- PRs should include what changed and why.
- PRs should include key files touched.
- PRs should include example command/output for behavior changes.
- PRs should include a linked issue when applicable.

## Security & API Usage Notes

- KEGG REST API use is for academic contexts and is rate-limited (max 3 requests/second).
- Avoid adding bulk query loops that can exceed rate limits.
