---
name: convid
description: Print the current conversation ID and attempt to copy it to the system clipboard.
---

# Instructions

1. Identify the current Conversation ID from `<google_user_information>` in your context (or via environment variables / agent metadata).
2. Output the Conversation ID directly and concisely in chat.
3. Copy the Conversation ID to the system clipboard by executing the following terminal command using the OSC 52 escape sequence:
   ```bash
   printf "\033]52;c;$(printf "%s" "<CONVERSATION_ID>" | base64 | tr -d '\r\n')\a"
   ```
