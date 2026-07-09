---
name: jujutsu
description: Use this skill when the user wants to use Jujutsu (jj) for version control, source control, repository management, viewing diffs or commit logs, creating or editing commits, managing bookmarks or branches, rebasing, or squashing changes, even if they mention Git commands in a Jujutsu repository.
---

## Jujutsu (jj) Version Control Guide for Agents

Jujutsu (`jj`) is a Git-compatible version control system with an anonymous, auto-committed working copy, powerful operation logging, and first-class conflict handling.

### Key Gotchas for AI Agents (CRITICAL)

1. **Never Run Interactive Commands**:
   - Never invoke commands that launch interactive editors or prompts.
   - Always provide commit messages inline: `jj describe -m "<message>"` or `jj new -m "<message>"`.
   - Never run `jj describe`, `jj commit`, `jj split`, or `jj squash -i` without arguments/flags that suppress interactivity.
2. **Always Suppress Pagination**:
   - `jj log`, `jj diff`, and `jj show` can invoke a pager and hang or clutter output.
   - Always use `--no-pager`: `jj --no-pager log -n 5`, `jj --no-pager diff`, `jj --no-pager status`.
3. **Working Copy is Auto-Committed (`@`)**:
   - There is no staging area (`git add`) and no need to stash (`git stash`).
   - Any modifications in the working directory immediately belong to the working copy revision, denoted by `@`.
   - Its parent revision is `@-`.
4. **Do Not Mix Git Commands in Co-Located Repos**:
   - If a repository uses `jj` (or is Git co-located), avoid mutating Git commands (`git commit`, `git checkout`, `git rebase`, `git reset`, `git merge`).
   - Use only `jj` commands to mutate repository state.
5. **Conflicts Do Not Abort Operations**:
   - If a rebase, merge, or squash causes conflicts, `jj` completes the operation and records conflict markers in the working copy.
   - Always run `jj --no-pager status` after structural operations (rebase/squash/new) to verify no files report `(conflicted)`.
6. **Change IDs vs. Commit IDs**:
   - Use Change IDs (alphabetic strings like `kkmv...`) or Revsets (`@`, `@-`) rather than Commit IDs (hexadecimal strings), because Change IDs remain stable across rebases and rewrites.

---

### Plan-Validate-Execute Checklist

Before mutating repository state or restructuring commits:
1. **Validate Current State**:
   - Run `jj --no-pager status` to inspect modified files and current change details.
   - Run `jj --no-pager log -n 5` to understand surrounding revision topology.
2. **Plan the Mutation**:
   - Determine if you are modifying the current commit (`@`) or starting a new child commit (`jj new`).
   - If rebasing or squashing, identify exact target Revision or Change IDs.
3. **Execute and Verify**:
   - Perform the command (with `-m` and `--no-pager`).
   - Re-check `jj --no-pager status` to confirm the expected topology and verify zero conflicts.

---

### Core Workflow & Command Reference

#### 1. Inspecting Repository State
- **Check status**:
  ```bash
  jj --no-pager status
  ```
- **View recent commit graph**:
  ```bash
  jj --no-pager log -n 5
  ```
- **View diff of current working copy (`@`)**:
  ```bash
  jj --no-pager diff
  ```
- **View diff of parent revision (`@-`)**:
  ```bash
  jj --no-pager diff -r @-
  ```
- **Show details and diff of a specific revision**:
  ```bash
  jj --no-pager show <rev>
  ```

#### 2. Creating and Editing Changes
- **Update commit message of current working copy (`@`)**:
  ```bash
  jj describe -m "feat: descriptive commit message"
  ```
- **Start a new change on top of current working copy**:
  ```bash
  jj new -m "feat: start new feature"
  ```
- **Start a new change from a specific parent revision** (e.g., `main` or `master`):
  ```bash
  jj new main -m "feat: feature branched from main"
  ```
- **Discard changes in specific files (restore from parent `@-`)**:
  ```bash
  jj restore <filepath>
  ```
- **Abandon (delete) a change**:
  ```bash
  jj abandon <rev>
  ```

#### 3. Squashing and Moving Changes
- **Squash all changes in working copy (`@`) into its parent (`@-`)**:
  ```bash
  jj squash
  ```
- **Squash specific file modifications into parent**:
  ```bash
  jj squash <filepath>
  ```
- **Move changes from one revision into another**:
  ```bash
  jj squash --from <source_rev> --into <dest_rev>
  ```

#### 4. Rebasing and Restructuring
- **Rebase current change and its descendants onto a new destination**:
  ```bash
  jj rebase -s @ -d <destination_rev>
  ```
- **Rebase only a single revision (re-parenting its descendants)**:
  ```bash
  jj rebase -r <rev> -d <destination_rev>
  ```

#### 5. Bookmarks (Branches) & Remote Interaction
*Note: In newer Jujutsu versions, bookmarks replace traditional branch naming.*
- **List bookmarks**:
  ```bash
  jj --no-pager bookmark list
  ```
- **Create or point a bookmark to current working copy (`@`)**:
  ```bash
  jj bookmark set <bookmark_name> -r @
  ```
- **Fetch from remote Git repository**:
  ```bash
  jj git fetch
  ```
- **Push a bookmark to remote Git repository**:
  ```bash
  jj git push --bookmark <bookmark_name>
  ```

#### 6. Undoing Mistakes
- **View operation history**:
  ```bash
  jj --no-pager op log -n 5
  ```
- **Undo the last Jujutsu operation** (reverts repo state, preserves file backups if needed):
  ```bash
  jj undo
  ```

---

### Git to Jujutsu Mental Mapping

| Git Command / Concept | Jujutsu (`jj`) Equivalent | Notes |
| :--- | :--- | :--- |
| `git status` | `jj --no-pager status` | Shows working copy (`@`) state and conflicts. |
| `git log -n 5` | `jj --no-pager log -n 5` | Displays topological revision graph. |
| `git diff` | `jj --no-pager diff` | Diffs working copy against its parent (`@-`). |
| `git diff --cached` | `jj --no-pager diff` | No staging area exists in jj. |
| `git add <file>` | *Automatic* | Files in working copy are automatically tracked/committed. |
| `git commit -m "msg"`| `jj describe -m "msg"` followed by `jj new` | `describe` names current change; `new` starts next child. |
| `git commit --amend` | `jj describe -m "new msg"` | Directly updates `@`'s description. |
| `git checkout -b <branch>` | `jj new <target> -m "msg"` + `jj bookmark set <name> -r @` | Creates anonymous revision, then assigns bookmark. |
| `git checkout <branch>` | `jj new <branch>` (to work on top) or `jj edit <branch>` | Use `jj new` to add child commits without mutating existing branch. |
| `git rebase <dest>` | `jj rebase -s @ -d <dest>` | Rebases working copy and descendants onto destination. |
| `git reset --hard / git restore` | `jj restore <file>` or `jj abandon @` | Restores files from `@-` or abandons current revision. |
| `git reflog` / `git reset` | `jj op log` + `jj undo` / `jj op restore` | First-class operation log enables undoing any jj command. |
