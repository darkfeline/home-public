---
name: create-agent-skill
description: Assist agents in designing, writing, organizing, and validating Agent Skills. Use this skill when asked to create a new agent skill, edit an existing one, optimize skill descriptions, or set up evaluation loops.
---

## Designing and Creating Agent Skills

Use this guide and helper scripts to create robust, well-triggered, and effective Agent Skills matching the [Agent Skills Specification](https://agentskills.io/specification).

### Directory Structure
An Agent Skill is a directory named using lowercase letters, numbers, and single hyphens. It must match the `name` field in the frontmatter.
```
my-skill-name/
├── SKILL.md          # Required: YAML metadata + markdown instructions
├── scripts/          # Optional: Self-contained validation/processing scripts
├── references/       # Optional: Domain documentation (e.g. REFERENCE.md)
└── assets/           # Optional: Static resources, schemas, and templates
```

---

### Step-by-Step Skill Creation Workflow

#### 1. Define the Scope and Name
- Name must be 1-64 characters, lowercase alphanumeric and hyphens only (`^[a-z0-9]+(-[a-z0-9]+)*$`).
- Must not start/end with a hyphen, nor have consecutive hyphens (`--`).
- Scope the skill like a coherent programming function: do one main thing well.

#### 2. Write the YAML Frontmatter
In `SKILL.md`, define the frontmatter:
```yaml
---
name: your-skill-name
description: Imperative sentences starting with "Use this skill when..." describing when to trigger. Limit to 1024 characters.
license: Apache-2.0 (Optional)
compatibility: Environment requirements (Optional, max 500 chars)
---
```

#### 3. Optimize the Trigger Description
- Use **imperative phrasing**: `"Use this skill when the user wants to..."`
- Focus on user intent, not the internal code implementation.
- Include synonyms or edge-case context: `"even if they don't explicitly mention 'X'."`

#### 4. Structure the body of `SKILL.md`
Keep `SKILL.md` under 500 lines. Focus on:
- **Gotchas / Common Pitfalls**: Specific edge cases (e.g., "Table X uses soft deletes").
- **Workflow Checklist**: Clear step-by-step instructions.
- **Plan-Validate-Execute**: Validate state before running destructive commands.
- **Reference links**: Use relative markdown links to files in `references/` or `scripts/`.

#### 5. Bundle Reusable Scripts
If you notice the agent writing similar code chunks or validating data manually:
- Move it to a script under `scripts/`.
- Make it self-contained. Use PEP 723 TOML block for Python scripts to declare dependencies.
- Ensure scripts are **non-interactive** (never prompt for user input or block).

---

### Validation Script

Run the built-in validator script on any skill you create to ensure it adheres to all specifications:
```bash
python3 scripts/validate_skill.py <path_to_skill_directory>
```

---

### Key Gotchas to Avoid
- **No interactive scripts**: Agents run in non-interactive terminals; interactive inputs hang.
- **Don't overcomplicate `SKILL.md`**: Keep it brief (under 500 lines). Put extra context in `references/`.
- **Match directory name**: The parent directory name MUST be identical to the frontmatter `name`.
