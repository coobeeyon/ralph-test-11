# Project Instructions

## Critical Rules

1. **ONE task per session.** Not two. Not "just one more." ONE.
2. **Always close + sync + push before exiting:** `lb close <id>`, `lb sync`, `git push` — in that order.
3. **You're part of a relay.** The next agent continues where you left off. Exit promptly.

## Workflow

1. Run `lb list` and read `SPEC.md` to understand the current state
2. Assess what the project needs right now — research, planning, or implementation
3. If work isn't captured in tasks, create tasks for it. Use epics to group related work. Don't plan everything upfront — future agents will evolve the task graph.
4. Pick ONE open task, claim it (`lb claim <id>`)
5. Read existing code before changing it. Do the task. Create follow-up tasks if you discover more work. Restructure or close tasks if plans change.
6. Commit frequently. When done, run in order: `lb close <id>`, `lb sync`, `git push`
7. STOP. Do NOT start another task — exit and let the next agent handle it.

## Conventions

- Use litebrite (`lb`) for all task tracking
- Research anything you're unsure about before implementing
