---
name: emacsclient
description: Facilitates running Elisp code within a remote Emacs server instance using the `emacsclient` command for evaluation purposes. Use this when debugging or executing small, specific Elisp expressions on a running server.
---

# Emacsclient Elisp Evaluation Skill

This skill provides instructions for using `emacsclient` to evaluate arbitrary Elisp code on a connected Emacs server instance.

## Prerequisites
This skill requires the following to be installed and configured in the environment where this agent runs:
1.  `emacsclient` must be accessible in the system's PATH.
2.  A running Emacs server instance must be addressable via `emacsclient`.
3.  The user must have the necessary permissions to connect to the remote server.

## Usage Instructions

The primary function of this skill is to send Elisp code strings to the remote Emacs session for immediate evaluation.

### Manual Evaluation Flow

1.  **Identify Target:** Determine the connection details and target process ID (PID) or session name for the desired Emacs server using `emacsclient`.
2.  **Formulate Command:** Construct the appropriate command to pipe or send the Elisp expression to the server's REPL. This often involves using an interactive session or piped input depending on the specific setup (e.g., a running shell session attached via `emacsclient`).
3.  **Execute Evaluation:** Execute the command sequence that sends the Elisp to the running Emacs process connected by `emacsclient`.

### Example Scenario: Evaluating a Simple Expression

Assume you have an Emacs server running and you want to evaluate the expression `(define-fun my-test x (x * 2))` in the session.

```bash
# This is a conceptual flow, actual implementation depends on environment specifics
emacsclient -e "(define-fun my-test x (x * 2))"
```

### Agent Guidance

When an agent requires Elisp evaluation:
*   **Stateless vs. Live Session Evaluation (CRITICAL):** For performing tasks that do not involve or mutate the user's running session—such as looking up documentation, searching Emacs/Elisp Info manuals, or testing stateless Elisp expressions—prefer using headless Emacs directly via `emacs -Q --batch --eval "<expression>"` rather than `emacsclient`. Using `emacsclient` connects to the user's live session and can cause unintended visual side effects (e.g., popping up windows, changing buffers, or mutating running state).
*   **Context:** Always check if the context implies a remote Emacs interaction with the running server. If not, this skill should not be invoked; use `emacs -Q --batch --eval` instead.
*   **Input:** The agent must provide the exact Elisp expression to be evaluated.
*   **Error Handling:** Be prepared for potential errors related to network communication or syntax errors within the Emacs Lisp itself. Errors returned by `emacsclient` (or the underlying Emacs process) should be carefully analyzed.
