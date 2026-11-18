# Personal Workspace Remote Conventions (GitHub)

Personal workspace repositories are hosted on GitHub and managed with the `gh` CLI. Refer to the `github-cli` skill (`~/src/dalian/github-cli/SKILL.md`) for full CLI usage, non-interactive flags, and troubleshooting.

## Naming Convention

- **Repository name**: `aitelier-<workspace-name>` (where `<workspace-name>` matches the directory name under `~/src/aitelier/<workspace-name>`).
- **Remote URL**: `https://github.com/<owner>/aitelier-<workspace-name>.git` (or SSH if configured for the repository).
- **Existing repositories**: Some existing repositories use names that do not follow this convention. Check `git remote -v` first, and apply `aitelier-<workspace-name>` when creating new remotes unless explicitly directed otherwise.

## Prerequisites & Safety Checks

1. **Verify workspace repository root**: Confirm the workspace is its own Git repository (not `~`) before configuring remotes:

   ```bash
   git -C ~/src/aitelier/<workspace-name> rev-parse --show-toplevel
   ```

2. **Check `gh` authentication**: Run `gh auth status` to verify the active account and protocol. Do **not** run interactive `gh auth login`; if unauthenticated, ask the user to log in from their terminal.
3. **Confirm visibility**: Always confirm with the user whether the repository should be `--private` or `--public` before running `gh repo create`. Recommend `--private` by default unless the user explicitly asks for a public repository.

## Creating and Connecting a Remote

### From an Existing Local Repository

1. **Pure Git repository** (with at least one local commit):

   ```bash
   gh repo create aitelier-<workspace-name> --private \
     --source=~/src/aitelier/<workspace-name> --remote=origin --push
   ```

   If the repository has no commits yet, omit `--push` and push after the first commit (`git -C ~/src/aitelier/<workspace-name> push -u origin HEAD`).

2. **Colocated Jujutsu (`jj`) + Git repository**:
   Create the remote repository without mutating Git branches directly, then register and push via `jj`:

   ```bash
   gh repo create aitelier-<workspace-name> --private
   jj -R ~/src/aitelier/<workspace-name> git remote add origin https://github.com/<owner>/aitelier-<workspace-name>.git
   jj -R ~/src/aitelier/<workspace-name> bookmark set main -r @-
   jj -R ~/src/aitelier/<workspace-name> git push --bookmark main
   ```

### Cloning an Existing or Newly Created Remote

Create the remote first, then clone explicitly into `~/src/aitelier/<workspace-name>` so the local directory omits the `aitelier-` prefix:

```bash
gh repo create aitelier-<workspace-name> --private
gh repo clone <owner>/aitelier-<workspace-name> ~/src/aitelier/<workspace-name>
```

Avoid running `gh repo create aitelier-<workspace-name> --clone` directly inside `~/src/aitelier`, because it creates `~/src/aitelier/aitelier-<workspace-name>` instead of `~/src/aitelier/<workspace-name>`.

## Optional: Register as a Submodule in `~`

Only after the remote exists, has at least one pushed commit, and the user asks to track the workspace as a submodule in the home directory repository (if `src/aitelier/<workspace-name>` is already a local Git repository, Git registers it in place without re-cloning):

```bash
git -C ~ submodule add https://github.com/<owner>/aitelier-<workspace-name>.git src/aitelier/<workspace-name>
```

Confirm with the user which home-repository branch (e.g., personal vs. public) should receive the `.gitmodules` change before committing; do not add private repository URLs to a public branch unless requested.
