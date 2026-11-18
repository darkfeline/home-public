---
name: github-cli
description: Use this skill when interacting with GitHub via the gh CLI to create, clone, inspect, or manage repositories, pull requests, issues, releases, GitHub Actions workflows and runs, or raw GitHub REST and GraphQL APIs, even when default gh commands hit interactive prompts, pager hangs, OAuth scope limits, or GraphQL deprecation errors.
---

# GitHub CLI (`gh`) Guide for Agents

Use this guide to interact with GitHub reliably and non-interactively via the `gh` CLI.

## 1. Key Gotchas for AI Agents (CRITICAL)

1. **Never Run Interactive Commands**:
   - Never invoke `gh auth login`, bare `gh repo create`, `gh pr create`, `gh issue create`, or confirmation prompts without non-interactive flags.
   - If `gh auth status` fails or reports missing auth, ask the user to run `gh auth login` in their terminal instead of launching it yourself.
   - Always supply explicit flags such as `--private`/`--public`, `--title`, `--body` / `--body-file`, and `--yes` (where applicable after user confirmation).

2. **Suppress Pagers and Prefer Structured JSON Output**:
   - Set `GH_PAGER=cat` when running commands that print long human-readable output (`gh pr view`, `gh pr diff`, `gh issue list`).
   - Prefer `--json <fields>` (optionally paired with `--jq '<expr>'`) for machine-readable, pagination-free output.

3. **Classic Projects Deprecation GraphQL Error (Older `gh` Builds)**:
   - On older `gh` versions (for example, Debian `gh 2.46.0`), default commands such as `gh pr edit` and `gh issue view <num>` query the deprecated `projectCards` GraphQL field and fail with `GraphQL: Projects (classic) is being deprecated ... (projectCards)`.
   - Workarounds:
     - Pass explicit `--json` fields that omit classic project cards when viewing:
       `gh issue view <num> --json number,title,state,body,comments`
       `gh pr view <num> --json number,title,state,body,comments,reviews,headRefName,baseRefName`
     - Use the REST API via `gh api` for PR edits and issue creation when GraphQL fails:
       `gh api -X PATCH repos/{owner}/{repo}/pulls/<num> -f title="..." -F body=@body.md`
       `gh api -X POST repos/{owner}/{repo}/issues -f title="..." -F body=@body.md`

4. **OAuth `workflow` Scope Restriction**:
   - Inspect granted token scopes in `gh auth status`. If the OAuth token lacks the `workflow` scope (for example, it only has `gist, read:org, repo`), pushing commits that modify `.github/workflows/*` or running `gh repo sync` across upstream workflow changes fails with:
     `refusing to allow an OAuth App to create or update workflow ... without workflow scope`
   - Ask the user to refresh scopes (`gh auth refresh -s workflow`) if workflow edits are required, or base branches on a commit range that does not include `.github/workflows/*` modifications when syncing forks.

5. **Confirm Visibility and Destructive / External Mutations**:
   - Confirm repository visibility (`--private` vs. `--public`) with the user before running `gh repo create`; never default silently to `--public`.
   - Confirm destructive or irreversible commands (`gh repo delete`, `gh repo archive`, `gh pr merge`, `gh release delete`) before executing.

6. **Explicitly Target Repositories Outside a Checkout**:
   - Pass `-R OWNER/REPO` (or `--repo OWNER/REPO`) when running `gh pr`, `gh issue`, `gh run`, or `gh workflow` commands outside a Git checkout or against a repo other than the default remote.

## 2. Plan-Validate-Execute Checklist

Before creating or mutating GitHub state:

1. **Validate Auth & Target**:
   - Check authentication and scopes: `gh auth status`
   - Verify the target repository (`git remote -v` inside a checkout, or confirm `OWNER/REPO` for `-R`).
2. **Plan Non-Interactive Flags**:
   - Choose explicit flags (`--private`/`--public`, `--title`, `--body-file`, `--base`, `--head`) so `gh` never opens an editor or prompt.
   - Check whether the operation hits known GraphQL/scope gotchas above and switch to `gh api` or `--json` if needed.
3. **Execute & Verify**:
   - Run the command (with `GH_PAGER=cat` or `--json` as needed).
   - Verify the resulting URL, state, or remote configuration.

## 3. Core Command Reference

### Authentication & Diagnostics

```bash
gh --version
gh auth status
```

### Repositories (`gh repo`)

- **Create a new remote repository (without cloning)**:

  ```bash
  gh repo create <name> --private --description "<description>"
  ```

- **Create a remote from an existing local Git repository and wire `origin`**:

  ```bash
  # Omit --push if the local repo has no commits yet or uses Jujutsu (jj)
  gh repo create <name> --private --source=. --remote=origin --push
  ```

- **Clone a repository (optionally into a custom directory name)**:

  ```bash
  gh repo clone <owner>/<repo> [<target-dir>]
  ```

- **Inspect or list repositories**:

  ```bash
  gh repo view <owner>/<repo> --json nameWithOwner,visibility,defaultBranchRef,url,description
  gh repo list --limit 30 --json nameWithOwner,visibility,updatedAt
  ```

- **Fork, sync, or configure default repo**:

  ```bash
  gh repo fork <owner>/<repo> --clone=false
  gh repo sync <owner>/<fork-repo>
  gh repo set-default <owner>/<repo>
  ```

### Pull Requests (`gh pr`)

- **List and inspect PRs**:

  ```bash
  gh pr list -R <owner>/<repo> --state open --json number,title,author,headRefName,updatedAt
  gh pr view <num> -R <owner>/<repo> --json number,title,state,body,comments,reviews,headRefName,baseRefName
  GH_PAGER=cat gh pr diff <num> -R <owner>/<repo>
  gh pr checks <num> -R <owner>/<repo>
  ```

- **Create a PR non-interactively**:

  ```bash
  gh pr create --title "<title>" --body-file <path-to-body.md> --base <base-branch> --head <head-branch>
  ```

- **Comment, review, or update a PR**:

  ```bash
  gh pr comment <num> -R <owner>/<repo> --body "<comment>"
  gh pr review <num> -R <owner>/<repo> --comment --body "<review>"
  # REST fallback if `gh pr edit` fails with classic projects GraphQL error:
  gh api -X PATCH repos/<owner>/<repo>/pulls/<num> -f title="<title>" -F body=@<path-to-body.md>
  ```

### Issues (`gh issue`)

- **List and inspect issues**:

  ```bash
  gh issue list -R <owner>/<repo> --state open --json number,title,labels,assignees,updatedAt
  gh issue view <num> -R <owner>/<repo> --json number,title,state,body,comments,labels
  ```

- **Create or comment on an issue**:

  ```bash
  gh issue create -R <owner>/<repo> --title "<title>" --body-file <path-to-body.md>
  # REST fallback if `gh issue create` hits classic projects GraphQL errors:
  gh api -X POST repos/<owner>/<repo>/issues -f title="<title>" -F body=@<path-to-body.md>
  gh issue comment <num> -R <owner>/<repo> --body "<comment>"
  ```

### GitHub Actions (`gh workflow` / `gh run`)

```bash
gh workflow list -R <owner>/<repo>
gh run list -R <owner>/<repo> --limit 10 --json databaseId,displayTitle,status,conclusion,headBranch
gh run view <run-id> -R <owner>/<repo> --log-failed
gh run rerun <run-id> -R <owner>/<repo> --failed
```

### Raw REST & GraphQL API (`gh api`)

Use `gh api` when subcommands lack needed fields or hit GraphQL compatibility issues:

- `{owner}`, `{repo}`, and `{branch}` expand automatically inside a Git checkout (or use explicit values).
- Use `-f key=value` for raw strings, `-F key=value` for typed JSON values (`true`, `false`, integers) or `@file` file reads, `-X <METHOD>` to override the HTTP method, `--paginate` for multi-page endpoints, and `--jq '<expr>'` to filter output.

```bash
# GET with jq filtering
gh api repos/<owner>/<repo> --jq '{full_name, private, default_branch, clone_url}'

# Paginated listing
gh api --paginate repos/<owner>/<repo>/pulls?state=closed --jq '.[].number'

# PATCH with body read from file
gh api -X PATCH repos/<owner>/<repo>/pulls/<num> -F body=@/tmp/pr_body.md
```
