---
name: lookup-docs
description: Load reference documentation from ~/.claude/context/reference-docs/ before answering questions. Use when user asks to consult specific docs (e.g., argo-cd, kubernetes).
---

# Reference Documentation Lookup

You have been instructed to consult reference documentation before answering the user's question.

## Workflow

1. **Identify the documentation topic** from the user's request (e.g., "argo-cd", "kubernetes")

2. **Search local reference docs** at `~/.claude/context/reference-docs/<topic>/`
   - Use Grep to find files containing keywords from the user's question
   - Prioritize files whose names suggest relevance

3. **Load relevant documentation**
   - Read the 1-4 most relevant files
   - If the docs are large, use targeted searches within them

4. **If not found locally**
   - Report that the docs aren't available in `~/.claude/context/reference-docs/`
   - Ask if the user wants you to: proceed without the docs, lookup docs online, wait for the user to add the docs to the reference folder, or some other approach

5. **Answer the original question**
   - Synthesize information from the loaded docs
   - Cite specific sections/files when possible
   - If docs don't fully answer the question, note what's missing

## Important
- This skill loads docs into context, then you continue the conversation
- Don't just summarize docs - answer the specific question asked
- Reference file paths when citing information
