---
name: baby-activities
description: Age-targeted development activity ideas for Baby (motor, sensory, language & social, cognitive), grounded in trusted sources, no screens, using what we have at home (household items plus the toys and books in our inventory). Also adds sources we like ("add <site> as a source"). Use when either of us asks for activity ideas ("something to do with Baby this afternoon"), logs an activity and how he reacted ("tried the mirror game, he loved it"), or asks what milestones to expect. Also provides the activities section of the Saturday household digest.
---

# Baby Development Activities

All data lives in `household/skills/baby-activities/data/`.

| Path | What it is |
|---|---|
| `data/profile.md` | Birth date, languages, constraints, last milestone window shown. **Read first.** |
| `data/household-items.md` | Everyday household things we can play with. |
| `household/skills/baby-inventory/data/inventory.csv` | Toys and books we own (maintained by the `baby-inventory` skill). |
| `data/sources.md` | Trusted sources that suggestions must come from. We add to it over time. |
| `data/activity-bank.md` | Every activity suggested so far, by age window (format: `templates/activity.md`). |
| `data/activity-log.csv` | What we tried and how he reacted: `date,activity,area,age_weeks,reaction,notes,logged_by`. |

## Working out where he is

1. **Age:** run `household/skills/baby-memories/journal/scripts/age.sh <today>` (it reads the birth date from the journal's `hugo.toml`, the single source of truth). Get weeks from the day count if needed. Use **weeks** under 3 months and **months** after that. If he was born early and we've noted an adjusted age in `profile.md`, use the adjusted age for targeting.
2. **What he's actually doing** (read-only): scan journal entries from the last ~8 weeks (`household/skills/baby-memories/journal/content/entries/**/index.md`), especially those tagged `milestone` or `firsts`, plus recent `activity-log.csv` notes. If he's already doing something (e.g. rolled over), shift those suggestions toward the next skill; if he's working on it, keep supporting it. **Never write to the journal.** If there are no recent entries, go by age alone.

## Suggesting activities

Triggered by "activity ideas", "what can we do with Baby", or the digest. Default to **5 suggestions**; use fewer if we asked for one thing ("something calm before bed").

Each set should:
- **Cover all four areas** across the set: motor, sensory, language & social, cognitive. A single on-request ask can focus on one area.
- **Use what we have where it fits:** household items from `household-items.md` and toys and books from the inventory. It's fine to mix in activities needing nothing at all; there's no quota. Name the specific item or book when you use one. Don't suggest buying things unless we ask.
- **Urdu/Hindi when it fits naturally**, e.g. a song, rhyme, or naming words (e.g. "Machli Jal Ki Rani Hai", "Lakdi Ki Kathi", "Chanda Mama"; body parts, colors, animal sounds). It's not required in every set. Write non-English lyrics in Roman script with a short English gloss.
- **Grounded in trusted sources:** every activity and every milestone must be supported by a source in `sources.md` (see **Sources** below).
- **No screens**, ever.
- **Use the log:**
  - Bring back one **loved** activity, or a harder version of it.
  - Retry anything marked **not-ready** after 3+ weeks, if it still fits his age.
  - Don't repeat **fussy** ones for at least 4 weeks.
  - The rest should be new to him (not in the log).
- **Be age-appropriate and safe:** follow standard guidance (AAP/CDC/Zero to Three style): tummy time only when he's awake and supervised, nothing in the sleep space, no small parts within reach, sensory bottles glued shut, no honey or food play before it's age-appropriate. Put a **Safety** line on any activity that needs one.

Use `templates/activity.md` for each suggestion, kept short enough to read on a phone. Append new suggestions to the matching age window in `activity-bank.md` (skip any already there, matching by slug).

## Sources

`data/sources.md` lists the sources we trust: a default list of established pediatric and early-childhood organizations, plus **our own additions**.

- **Only suggest what a listed source supports.** When web access is available, look the activity or milestone up on the source's site and link the specific page. If you can't fetch it, cite the source and the topic by name, and only suggest things you're confident that source recommends.
- **Prefer, in order:** sources we added and marked as favorites, then the official bodies (AAP/HealthyChildren, CDC, NHS, WHO), then the other defaults.
- **Don't use** random blogs, product sites, or influencer content unless we've added them. If a source contradicts official safety guidance (sleep, choking, feeding), follow the official guidance and say so.
- Each activity gets a **Source** line (name + link).

### Adding a source
"Add <site/book/account> as a source", "I like Lovevery's guides", "use Janet Lansbury too":
1. Identify it: name, URL (look it up if we only gave a name), and what it's good for.
2. If it's commercial, or not evidence-based, say so in a line. It's still our call; add it if we confirm.
3. Append it under **Our sources** in `sources.md` with today's date, who added it, and a note. If we say we especially like it, mark it ⭐ (preferred).
4. "Stop using X" moves it to **Removed** with the date, so it's never silently lost.

## Logging what we tried

"Tried tummy time on the rolled towel, he lasted 3 min and got fussy", "he loved the crinkly paper":

- Append a row to `activity-log.csv`:
  - `date`: today unless we said otherwise
  - `activity`: the bank slug if it matches one, else a short name
  - `area`
  - `age_weeks`: computed from his birth date
  - `reaction`: one of `loved | liked | neutral | fussy | not-ready`. Infer it from our words; if unclear, ask.
  - `notes`: our words, lightly trimmed
  - `logged_by`
- If it sounds like a milestone or a first ("first time he grabbed it on purpose!"), mention in one line that it might be worth a journal entry (`baby-memories` skill). Only mention it; don't draft or write it.

## Milestones (gently)

Use the CDC "Learn the Signs. Act Early." checkpoints and milestone lists (cite them): **2, 4, 6, 9, 12, 15, 18, 24, 30, 36 months**.

- When his age passes a checkpoint not yet shown (check **Last milestone window shown** in `profile.md`), include a short **"What's typical around N months"** note: 4–6 common milestones across the four areas, framed as things to watch for and enjoy, plus a line saying babies vary widely.
- Close with: *If anything stands out or worries you, it's worth mentioning at the next pediatrician visit.* Never diagnose, never say he's "behind", and don't compare with other babies.
- Then update **Last milestone window shown**.
- "What should he be doing around now?" gets the same gentle answer, on request.

## As part of the weekly digest

When the `weekly-digest` skill invokes this (Saturday morning, nobody present):
- Compute his age and read recent journal and log entries as above.
- Produce **5 activities for the coming week** following all the rules above (each with a Source line), and append them to the bank. If a toy or book was added to the inventory this week, try to feature it.
- Include the milestone note if a new checkpoint was crossed since the last digest.
- **Needs a decision:** normally nothing. If no activity has been logged in 3+ weeks, add one gentle line suggesting we log how the activities went so suggestions can adapt. Don't nag.
- Don't add log rows or edit the journal. The digest commits everything together.
