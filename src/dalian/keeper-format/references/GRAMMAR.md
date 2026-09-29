# Formal Grammar and Semantics Reference for keeper-go (.kpr)

This document specifies the exact lexical structure, grammar rules, and bookkeeping semantics for `.kpr` files as implemented in [`darkfeline/keeper-go`](https://github.com/darkfeline/keeper-go).

---

## 1. Lexical Tokens

- **Comments (`#`)**: Start with `#` and extend to the end of the line. Comments can appear on their own lines or at the end of statements.
- **Strings (`STRING`)**: Standard double-quoted strings (`"example"`). Support escape sequences such as `\"` and `\\`. Used for transaction descriptions and account metadata.
- **Unit Symbols (`USYMBOL`)**: Composed strictly of one or more uppercase ASCII letters (e.g., `USD`, `EUR`, `BTC`).
- **Account Names (`ACCTNAME`)**: Must start with an uppercase letter followed by alphanumeric characters, underscores (`_`), or colons (`:`). Colon separators denote hierarchical sub-accounts (e.g., `Assets:Current:Checking`).
  - **CRITICAL RESTRICTION**: An account name cannot consist *only* of uppercase letters, as the scanner would categorize it as a `USYMBOL`. For example, `CASH` is a `USYMBOL`, whereas `Assets:Cash` or `Cash_Account` is an `ACCTNAME`.
- **Decimal Numbers (`DECIMAL`)**: Arbitrary precision integer-backed numbers formatted with period (`.`) as the decimal separator.
  - Commas (`,`) may be used freely as visual grouping separators; they are ignored during parsing.
  - Numbers may begin with a minus sign (`-`) for credits/negative values.
- **Dates (`DATE`)**: Standard ISO 8601 calendar date format: `YYYY-MM-DD`.

---

## 2. Keywords and Statements

There are 8 reserved keywords: `unit`, `tx`, `balance`, `treebal`, `disable`, `account`, `meta`, and `end`.

### 2.1 Unit Declarations (`unit`)
Single-line statement declaring a unit and its fractional scaling factor.
```keeper
unit <USYMBOL> <SCALE_DECIMAL>
```
- `<SCALE_DECIMAL>` must be an integer power of ten representing the smallest fractional division (e.g., `100` for 2 decimal places / cents, `100000000` for satoshis).
- **Semantics**: Units must be declared before any transaction or balance assertion references them. Any scaled amount that results in a fractional smallest unit triggers a compile error (`scaled unit amount is fractional`).

### 2.2 Transactions (`tx` ... `end`)
Multi-line statement recording a double-entry transaction.
```keeper
tx <DATE> <STRING_DESCRIPTION>
<ACCTNAME> [<DECIMAL> <USYMBOL>]
<ACCTNAME> [<DECIMAL> <USYMBOL>]
end
```
- **Splits**: Each line inside a `tx` block specifies an account and an optional amount (`<DECIMAL> <USYMBOL>`).
- **Zero-Balancing**: For each declared unit involved in a transaction, the sum of all explicit split amounts must equal exactly `0`.
- **Inferred Amounts**: At most **one** split line per transaction may omit the `<DECIMAL> <USYMBOL>` amount. If omitted, the parser infers the exact amount required to balance the transaction to `0`. If multiple units are present across other splits, inference succeeds only if exactly one unit has a non-zero sum across the explicit splits.

### 2.3 Balance Assertions (`balance` and `treebal`)
Asserts that the cumulative balance of an account on a given date equals the specified amount(s).
- **Single-line syntax** (for accounts holding a single unit):
  ```keeper
  balance <DATE> <ACCTNAME> <DECIMAL> <USYMBOL>
  treebal <DATE> <ACCTNAME> <DECIMAL> <USYMBOL>
  ```
- **Multi-line syntax** (for accounts holding multiple units):
  ```keeper
  balance <DATE> <ACCTNAME>
  <DECIMAL> <USYMBOL>
  <DECIMAL> <USYMBOL>
  end

  treebal <DATE> <ACCTNAME>
  <DECIMAL> <USYMBOL>
  <DECIMAL> <USYMBOL>
  end
  ```
- **Difference between `balance` and `treebal`**: `balance` checks only the direct balance posted to `<ACCTNAME>`. `treebal` checks the aggregate balance of `<ACCTNAME>` plus all of its hierarchical sub-accounts (e.g., `Assets` includes `Assets:Cash`).

### 2.4 Account Metadata (`account` ... `end`)
Multi-line statement attaching arbitrary key-value metadata to an account.
```keeper
account <ACCTNAME>
meta <STRING_KEY> <STRING_VALUE>
meta <STRING_KEY> <STRING_VALUE>
end
```

### 2.5 Disable Account (`disable`)
Single-line statement preventing further postings to an account after a specified date.
```keeper
disable <DATE> <ACCTNAME>
```
