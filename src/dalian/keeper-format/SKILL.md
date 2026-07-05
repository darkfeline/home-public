---
name: keeper-format
description: Use this skill when reading, writing, editing, generating, or validating double-entry bookkeeping files in the .kpr format supported by darkfeline/keeper-go. Trigger when the user mentions keeper files, .kpr files, or working with accounting/bookkeeping data in the keeper syntax.
---

# Keeper (.kpr) File Format Skill

This skill provides rules, syntax constraints, and best practices for creating and manipulating double-entry accounting ledger files (`.kpr`) supported by [`darkfeline/keeper-go`](https://github.com/darkfeline/keeper-go).

## 1. Syntax Overview & Core Rules

Keeper files use strict mathematical double-entry accounting backed by arbitrary-precision integers scaled by unit division factors.

### Required Keywords & Line Termination
- **Single-line statements** do **NOT** terminate with `end`:
  - `unit <SYMBOL> <SCALE>`
  - `disable <DATE> <ACCOUNT>`
  - Single-currency balance: `balance <DATE> <ACCOUNT> <AMOUNT> <SYMBOL>`
  - Single-currency tree balance: `treebal <DATE> <ACCOUNT> <AMOUNT> <SYMBOL>`
- **Multi-line statements** **MUST** terminate with `end` on its own line:
  - Transactions: `tx <DATE> "<DESCRIPTION>"` ... `end`
  - Account metadata: `account <ACCOUNT>` ... `end`
  - Multi-currency balance assertions: `balance <DATE> <ACCOUNT>` ... `end` or `treebal <DATE> <ACCOUNT>` ... `end`


## 2. Critical Gotchas & Common Pitfalls

1. **Unit Pre-Declaration Required**:
   Every unit (`USD`, `BTC`, `EUR`) must be declared via `unit <SYMBOL> <SCALE>` before any transaction or balance assertion uses it.
   - Scale must be an integer power of ten representing the smallest division (e.g., `100` for cents, `100000000` for satoshis).
   - Fractional amounts smaller than the scale (e.g., `0.001 USD` when scale is `100`) cause strict compiler errors (`scaled unit amount is fractional`).

2. **Account Name Restrictions**:
   Account names must start with an uppercase letter and contain alphanumeric characters, colons (`:`), or underscores (`_`).
   - **DO NOT** use all-uppercase account names (e.g., `CASH` or `ASSETS:CHECKING`). The lexer treats all-uppercase identifiers as unit symbols (`USYMBOL`). Always use mixed-case or PascalCase (e.g., `Assets:Checking`, `Cash_Account`).

3. **Number Formatting**:
   - Always use periods (`.`) for decimal separators.
   - Commas (`,`) are ignored visual grouping separators (`1,000.00` is parsed identical to `1000.00`).

4. **Transaction Balancing & Automatic Split Inference**:
   - In a `tx` block, the net sum of explicit split amounts for each unit must balance exactly to `0`.
   - At most **one** split line may omit its `<AMOUNT> <SYMBOL>`. When omitted, `keeper-go` automatically calculates and infers the exact amount required to balance the transaction to `0`.

## 3. Reference Files

- For a complete, valid `.kpr` template demonstrating all statement types, inspect [sample.kpr](examples/sample.kpr).
- For detailed lexical token definitions and AST semantics, read [GRAMMAR.md](references/GRAMMAR.md).

## 4. Plan-Validate-Execute Workflow for .kpr Files

When editing or generating `.kpr` files:
1. **Verify Unit Declarations**: Ensure every unit referenced in new transactions has a corresponding `unit` entry at the top of the file.
2. **Validate Account Case**: Check that all account names contain at least one lowercase letter, digit, or symbol so they are not mistaken for units.
3. **Check Transaction Balance**: Confirm that explicit splits sum to zero or that exactly one split is left blank for automatic balancing.
4. **Check Block Termination**: Verify that every `tx`, `account`, or multi-line `balance` block ends with `end`.
