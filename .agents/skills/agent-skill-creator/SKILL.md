---
name: agent-skill-creator
description: Create, format, and optimize Agent Skills. Use when the user wants to build, write, or refine a skill for an AI agent to use, or needs guidance on the Agent Skills specification and best practices.
metadata:
  source: "https://agentskills.io"
---

# Agent Skill Creation Guide

Agent Skills are a standardized, open format for extending AI agent capabilities. A skill packages domain expertise, repeatable workflows, and context into portable, version-controlled folders.

## Directory Structure
A skill is a directory containing a `SKILL.md` file and optional supporting folders.

```text
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code (Python, Bash, JS)
├── references/       # Optional: documentation (loaded on-demand)
└── assets/           # Optional: templates, resources
```

* **Progressive Disclosure:** Agents load skills progressively. 
  1. **Discovery:** Only `name` and `description` are loaded at startup (~100 tokens).
  2. **Activation:** The full `SKILL.md` is read into context when the task matches the description (< 5000 tokens recommended).
  3. **Execution:** Resources in `scripts/`, `references/`, and `assets/` are loaded only when explicitly needed. Keep the main `SKILL.md` under 500 lines and use relative paths (e.g., `references/API.md` or `scripts/run.py`).

## `SKILL.md` Frontmatter Specification
The `SKILL.md` file must start with YAML frontmatter.

| Field | Required | Constraints / Notes |
| --- | --- | --- |
| `name` | Yes | 1-64 characters. Lowercase alphanumeric and hyphens (`-`) only. No consecutive, leading, or trailing hyphens. Must match the parent directory name. |
| `description` | Yes | 1-1024 characters. Crucial for skill triggering (see Optimization below). |
| `license` | No | Short license name or file reference (e.g., `Apache-2.0`). |
| `compatibility` | No | Max 500 chars. Environment requirements (e.g., system packages, CLI tools). |
| `metadata` | No | Arbitrary string key-value map for extra properties. |

**Example Frontmatter:**
```yaml
---
name: csv-analyzer
description: Analyze CSV and tabular data files — compute summary stats, generate charts, and clean messy data. Use when the user wants to explore or visualize data, even if they don't explicitly mention "CSV".
---
```

## Optimizing Descriptions (Triggering)
Because agents only read the `description` to decide whether to activate a skill, writing a good description is critical:
* **Use imperative phrasing:** Tell the agent when to act (e.g., "Use this skill when...").
* **Focus on user intent:** Describe what the user is trying to achieve, not the internal implementation.
* **Err on the side of being pushy:** Explicitly list contexts where it applies, even if the user doesn't use the exact terminology.
* **Test and Iterate:** If a skill doesn't trigger, broaden the scope. If it false-triggers, add specificity about what the skill does *not* do.

## Best Practices for Body Instructions

When writing the Markdown body of `SKILL.md`, use these patterns to make the skill robust:

### 1. Spend Context Wisely
* **Add what the agent lacks, omit what it knows:** Do not explain basic concepts (like what a database is). Focus on project conventions, unfamiliar APIs, and specific procedures.
* **Provide defaults, not menus:** Instead of offering multiple equal options, pick one default approach and mention alternatives briefly.

### 2. Match Specificity to Fragility
* **Give freedom for flexible tasks:** Explain *why* something is done, rather than rigid steps (e.g., for a code review skill, list what to look for).
* **Be prescriptive for fragile operations:** Use exact sequences for strict procedures (e.g., "Run exactly this sequence: `python migrate.py --verify`").

### 3. High-Value Instruction Patterns
* **Gotchas Section:** Include a bulleted list of environment-specific facts or common mistakes the agent will likely make without being told (e.g., "The `users` table uses soft deletes; always include `WHERE deleted_at IS NULL`").
* **Templates for Output:** Provide Markdown templates for specific reporting formats. Agents pattern-match well against concrete structures.
* **Checklists for Workflows:** Use explicit markdown checklists `[ ]` for multi-step operations to help the agent track dependencies.
* **Validation Loops & Plan-Validate-Execute:** Instruct the agent to check its work. For destructive/batch tasks, tell it to generate a plan, run a validation script/check against a reference, and only execute once validation passes.

### 4. Synthesize from Real Expertise
* **Use real artifacts:** Base the skill on actual runbooks, schemas, code reviews, and failure cases rather than generic "best practices."
* **Extract from execution:** Have the agent perform the task first, note the corrections and steps that worked, and write the skill based on that successful trace.
