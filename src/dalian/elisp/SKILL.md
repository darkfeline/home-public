---
name: elisp
description: Use this skill when the user wants to write, debug, test, or evaluate Emacs Lisp (elisp) code, look up Emacs Lisp functions or variables, search Emacs Info manuals or documentation, or develop Emacs packages and customizations.
---

## Emacs Lisp (Elisp) Development & Documentation Guide

This skill provides instructions for developing, testing, and evaluating Emacs Lisp (`elisp`) code, as well as programmatically querying Emacs documentation and Info manuals without disrupting user sessions.

### Stateless vs. Live Session Evaluation (CRITICAL)

1. **Prefer Stateless Headless Evaluation (`emacs -Q --batch --eval`)**:
   - For any task that does not explicitly require interacting with or modifying the user's running Emacs session—such as looking up docstrings, searching Info manuals, testing functions, or evaluating stateless scripts—**always use headless batch Emacs**:
     ```bash
     emacs -Q --batch --eval "<elisp-expression>"
     ```
   - Why: Using `emacs -Q --batch` runs in a clean, isolated environment with zero visual or state side effects on the user's live Emacs session.
2. **When to Use `emacsclient`**:
   - Only invoke `emacsclient -e` (referencing the `emacsclient` skill) when the task explicitly mandates querying or mutating the user's active, running Emacs server session (e.g., inspecting open buffers, modifying live frame state, or debugging an in-situ session issue).

---

### Looking Up Documentation and Info Manuals

When running in `--batch` mode, interactive documentation commands (such as `describe-symbol`, `describe-function`, and `info-lookup-symbol`) output to internal Emacs buffers (`*Help*`, `*info*`) rather than standard output. You must explicitly extract and print these buffers using `princ`.

#### 1. Symbol Documentation (`describe-symbol`, `describe-function`, `describe-variable`)
- **Get full formatted help (signatures, documentation, and links to Info manuals)**:
  ```bash
  emacs -Q --batch --eval "(with-temp-buffer (describe-symbol 'mapcar) (princ (with-current-buffer \"*Help*\" (buffer-string))))"
  ```
- **Get raw docstring only**:
  ```bash
  emacs -Q --batch --eval "(princ (documentation 'mapcar))"
  ```
- **Get variable docstring only**:
  ```bash
  emacs -Q --batch --eval "(princ (documentation-property 'load-path 'variable-documentation))"
  ```

#### 2. Automatic Info Manual Lookup for a Symbol (`info-lookup-symbol`)
To automatically jump to the Elisp or Emacs manual section documenting a specific symbol and print its contents:
```bash
emacs -Q --batch --eval "(progn (require 'info-look) (info-lookup-symbol 'mapcar 'emacs-lisp-mode) (princ (with-current-buffer \"*info*\" (buffer-string))))"
```

#### 3. Direct Info Node Lookup
When you know the manual and node name (e.g., from a docstring reference like `See Info node '(elisp)Hash Tables'`):
```bash
emacs -Q --batch --eval "(progn (require 'info) (with-temp-buffer (Info-mode) (Info-find-node \"elisp\" \"Hash Tables\") (princ (buffer-string))))"
```
*Tip: To avoid flooding output on large nodes, wrap `(buffer-string)` with `(substring (buffer-string) 0 1000)` or use Elisp search functions.*

#### 4. Searching Info Manual Indexes
To search the Index of a manual (`elisp`, `emacs`, `cl`, etc.) to discover which nodes discuss a topic or keyword:
```bash
emacs -Q --batch --eval "(progn (require 'info) (with-temp-buffer (Info-mode) (Info-find-node \"elisp\" \"Index\") (goto-char (point-min)) (while (re-search-forward \"\\* hash table\" nil t) (princ (buffer-substring (line-beginning-position) (line-end-position))) (princ \"\\n\"))))"
```

#### 5. Apropos Search
To search for functions, variables, or properties matching a regular expression pattern:
```bash
emacs -Q --batch --eval "(with-temp-buffer (apropos \"^hash-table-\") (princ (with-current-buffer \"*Apropos*\" (buffer-string))))"
```

---

### Writing and Testing Elisp Code

#### 1. Output and Printing in Batch Mode
- **`princ`**: Prints unquoted human-readable text (best for formatted strings and documentation).
- **`prin1`**: Prints Lisp-readable data structures (symbols, lists, quoted strings).
- **`with-output-to-string`**: Captures text sent to `standard-output` (via `princ`/`prin1`/`print`), but **not** text sent to message logs or special help buffers.

#### 2. Safe Error Handling
When evaluating complex or exploratory Elisp expressions, use `condition-case` to catch and format errors cleanly without aborting batch execution:
```elisp
(condition-case err
    (progn
      ;; Exploratory or risky Elisp logic
      (do-something-risky))
  (error (princ (format "Error encountered: %s\n" (error-message-string err)))))
```

#### 3. Common Gotchas
- **No Interactive UI Commands**: Never invoke commands that require UI interaction or minibuffer prompts (`read-from-minibuffer`, `yes-or-no-p`, `y-or-n-p`, `x-popup-menu`) in `--batch` mode or automated scripts.
- **Window/Frame Navigation**: Commands like `switch-to-buffer`, `pop-to-buffer`, or `delete-other-windows` have different behavior in `--batch` mode where only a single dummy frame exists. Always use buffer-direct operations (`with-current-buffer`, `with-temp-buffer`, `set-buffer`) instead of window-based navigation.
