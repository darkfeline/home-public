---
name: agent-workspaces
description: Use this skill when creating, configuring, organizing, or managing agent workspaces under ~/src/aitelier, setting up AGENTS.md or workspace skills under .agents/skills, symlinking shared skills from ~/src/dalian, choosing a VCS or submodule layout, or setting up personal or work repository remotes for a workspace.
---

# Agent Workspaces Management Guide

Use this guide to create, organize, and maintain agent workspaces under `~/src/aitelier` according to the user's conventions.

## 1. Directory Structure & VCS Patterns

Agent workspaces live under `~/src/aitelier/<workspace-name>` (prefer short, lowercase kebab-case names). Scratch workspaces matching `tmp*` are ignored by `~/src/aitelier/.gitignore`.

A typical workspace has the following layout:

```text
~/src/aitelier/<workspace-name>/
├── AGENTS.md                       # Persistent context and instructions for agents
└── .agents/
    └── skills/
        ├── <shared-skill> -> ../../../../dalian/<shared-skill>
        └── <local-skill>/
            └── SKILL.md
```

Workspaces follow one of two version control patterns based on size and lifecycle:

1. **Small workspaces (no standalone repository)**:
   - Do not initialize a separate Git or Jujutsu repository inside the workspace.
   - Either commit the workspace directly into the home directory repository (`~`) or leave it uncommitted in `~/src/aitelier/<workspace-name>` if the user is not ready to commit it yet.
2. **Larger workspaces (standalone repository)**:
   - Initialize the workspace as its own repository (Git, or colocated Jujutsu + Git; see the `jujutsu` skill in `~/src/dalian/jujutsu/SKILL.md` when using `jj`).
   - **Local-only**: Keep the repository local without configuring a remote.
   - **Remote-backed**: Associate the repository with a remote following the conventions in `references/remotes-*.md`.
   - **Home-repository submodule (optional)**: Once a workspace repository has a remote, it may optionally be added as a Git submodule in the home directory repository (`~`). Do not register a local-only repository as a submodule.

## 2. Workspace Conventions

### `AGENTS.md`

Most workspaces include an `AGENTS.md` file at the workspace root that provides domain context, scope, references, and operational notes for agents working in that workspace.

### Skills (`.agents/skills/`)

Workspaces store active skills under `.agents/skills/`:

- **Shared skills (`~/src/dalian/`)**: Store reusable skills in `~/src/dalian/<skill-name>` and symlink them into a workspace's `.agents/skills/` directory using **relative paths**:

  ```bash
  mkdir -p ~/src/aitelier/<workspace-name>/.agents/skills
  ln -s ../../../../dalian/<skill-name> ~/src/aitelier/<workspace-name>/.agents/skills/<skill-name>
  ```

  From `~/src/aitelier/<workspace-name>/.agents/skills/<skill-name>`, four parent segments (`../../../../`) traverse up to `~/src/`, then into `dalian/<skill-name>`.
- **Workspace-local skills**: Store non-shared skills directly as directories under `.agents/skills/<skill-name>/SKILL.md`. To promote a local skill into a shared skill later, move its directory to `~/src/dalian/<skill-name>` and replace it with the relative symlink above.
- **Tool-specific skill configs**: Some workspaces also include `.agents/skills.json` to reference external skill depots when supported by the agent runtime.

## 3. Repository Remote Conventions

Some existing workspace repositories have remotes that predate or differ from these conventions (such as legacy names or direct checkouts of upstream repositories). Always inspect existing remotes (`git remote -v`) before making changes, and apply these conventions when creating new remotes unless explicitly directed otherwise.

Environment-specific remote conventions live in `references/remotes-*.md` inside this skill directory. Before creating or configuring a remote:

1. List and read the `references/remotes-*.md` files present in this skill directory.
2. Select the file matching the workspace's context (for example, personal vs. work); ask the user if the context is ambiguous.
3. Follow the naming, creation, authentication, and submodule instructions in that reference file.

## 4. Plan-Validate-Execute Workflows

### A. Create a New Workspace

1. **Clarify requirements**: Confirm `<workspace-name>`, VCS tier (small non-repo, local standalone repo, or remote-backed standalone repo), whether to commit or register as a submodule in `~`, and which skills to link.
2. **Create directory**: Run `mkdir -p ~/src/aitelier/<workspace-name>`.
3. **Initialize VCS (standalone workspaces only)**:
   - For Git: `git -C ~/src/aitelier/<workspace-name> init`
   - For colocated Jujutsu + Git: `jj git init --colocate ~/src/aitelier/<workspace-name>`
4. **Create `AGENTS.md`**: Write an initial `~/src/aitelier/<workspace-name>/AGENTS.md` describing the workspace's purpose and instructions.
5. **Link shared skills**: For each shared skill requested, verify `~/src/dalian/<skill-name>/SKILL.md` exists, create the relative symlink `../../../../dalian/<skill-name>` under `.agents/skills/`, and verify the link resolves:

   ```bash
   test -f ~/src/aitelier/<workspace-name>/.agents/skills/<skill-name>/SKILL.md
   ```

6. **Set up remote and home-repo integration (if requested)**:
   - For remote-backed repos, read the matching `references/remotes-*.md` file and confirm visibility/target before creating the remote.
   - Only commit files into `~` or register a submodule in `~` when requested or confirmed by the user.

### B. Add a Shared Skill to an Existing Workspace

1. Verify the source skill exists at `~/src/dalian/<skill-name>/SKILL.md`.
2. Ensure `.agents/skills` exists: `mkdir -p ~/src/aitelier/<workspace-name>/.agents/skills`.
3. Create the relative symlink and confirm it resolves:

   ```bash
   ln -s ../../../../dalian/<skill-name> ~/src/aitelier/<workspace-name>/.agents/skills/<skill-name>
   test -f ~/src/aitelier/<workspace-name>/.agents/skills/<skill-name>/SKILL.md
   ```

### C. Promote a Small Workspace to a Standalone Repository

1. **Check home-repo tracking**: Run `git -C ~ status -- src/aitelier/<workspace-name>` and `git -C ~ ls-files -- src/aitelier/<workspace-name>`.
2. **Untrack from `~` if already committed**: Confirm with the user before running `git -C ~ rm -r --cached src/aitelier/<workspace-name>` so `~` does not conflict with the nested repository or future submodule.
3. **Initialize the workspace repository**: Run `git init` or `jj git init --colocate` inside `~/src/aitelier/<workspace-name>` and verify `git -C ~/src/aitelier/<workspace-name> rev-parse --show-toplevel` returns the workspace path (not `~`).
4. **Create an initial commit** and, if a remote is desired, follow the matching `references/remotes-*.md` guide.

### D. Configure a Remote for an Existing Workspace Repository

1. Verify the workspace is a standalone repository:

   ```bash
   git -C ~/src/aitelier/<workspace-name> rev-parse --show-toplevel
   ```

   Stop if the output is `$HOME` (`~`) rather than the workspace directory.
2. Check existing remotes with `git -C ~/src/aitelier/<workspace-name> remote -v`.
3. Read the matching `references/remotes-*.md` file and follow its remote creation, push, and optional submodule steps.

## 5. Key Gotchas (CRITICAL)

- **Parent `~` is a Git repository**: Running `git` commands inside a small workspace (which has no `.git` directory of its own) silently targets the home directory repository (`~`). Always run `git rev-parse --show-toplevel` before executing mutating Git commands (`git add`, `git commit`, `git remote add`, `git init`, etc.).
- **Relative symlinks only**: Always symlink shared skills using `../../../../dalian/<skill-name>`, never absolute paths like `/home/<user>/src/dalian/...`. Absolute symlinks break across machines with different home paths.
- **Directory name is `.agents/skills` (plural)**: Place skill directories and symlinks under `.agents/skills/`, not `.agents/skill/`.
- **Explicit target directory when cloning**: Remote workspace repositories typically use a prefixed name (such as `aitelier-<workspace-name>`). When cloning a workspace repository into `~/src/aitelier`, always specify the destination path `~/src/aitelier/<workspace-name>` so Git does not create `~/src/aitelier/aitelier-<workspace-name>`.
- **Confirm durable repository actions**: Ask the user before creating external remote repositories, selecting public vs. private visibility, committing into `~`, or adding submodules to `~`.
