---
name: weekly-digest
description: Builds the single Saturday-morning household digest that bundles every household automation (birthday reminders, the weekly meal-plan draft, Baby's weekly activities, new journal entries, and any automations added later) into one report. Use when the scheduled Saturday task fires, or when either of us asks for "the digest", "this week's household summary", or to re-run it.
---

# Weekly Household Digest

**The one place all automated household updates go.** Individual skills don't schedule or report on their own; they contribute a section here. By default, any new automation becomes a row in `data/automations.md` rather than a separate scheduled task.

| Path | What it is |
|---|---|
| `data/automations.md` | Registry: which skills contribute, in what order, enabled or not |
| `data/digests/YYYY-MM-DD.md` | One digest per run (format: `templates/digest.md`) |

## Running the digest

Normally fired by the Saturday-morning scheduled task, with no one in the conversation.

1. Pull the latest from the remote branch so both of our recent edits are included.
2. If `data/digests/<today>.md` already exists, don't overwrite it. Report that it's already been run, unless we explicitly asked to re-run.
3. Read `data/automations.md`. For each **enabled** row, in order, follow that skill's "As part of the weekly digest" instructions and collect its section.
   - If one section fails (missing data, an error), write what went wrong in that section and carry on with the rest. One broken automation shouldn't block the digest.
4. Build **Needs a decision** at the top: every item from any section that needs one of us to act, most time-sensitive first. Keep it short; the details live in the sections below.
5. Write `data/digests/<today>.md` from the template.
6. Commit everything the run created or changed (the digest, the meal plan and grocery files, person files with suggested ideas) in **one commit**: `household digest: YYYY-MM-DD`. Then push.
7. Final message (what shows up as the scheduled run's result): the **Needs a decision** list plus a link to the digest file. Keep it brief enough to read on a phone.

## Adding a new automation

When a skill gains something that should run on a schedule:
1. Give that skill an "As part of the weekly digest" section describing what to produce, what it may change unattended (the default is to suggest only, never delete), and what counts as "needs a decision".
2. Add a row to `data/automations.md`.
3. Add a placeholder section to `templates/digest.md`.

Only propose a separate schedule if it truly can't wait for Saturday, e.g. a same-day reminder. Ask us first.

## Rules for unattended runs
- Suggest and draft; don't decide. No deleting, no checking things off, no marking plans final, no logging gifts given.
- Never overwrite existing dated files (plans, digests).
- If nothing needs a decision, say "Nothing this week." Don't pad it.
