# FamilyOS

A household agent my spouse and I share, built from [Claude Code](https://claude.com/claude-code) skills. We talk to it the way we'd talk to each other ("save this reel", "we made the dal last night", "Mom said she has too many candles"), and it keeps track of our recipes and meal plans, birthdays and gifts, and our baby's toys, activities and journal. Every Saturday morning it sends one digest.

**[See how it fits together →](https://claude.ai/artifact/GxtT499NujH7cAFN3LKwUc)** A diagram of the flows and a card for each skill.

This is the public copy. The real one is a private repo holding our actual data. **Everything under `data/` and `journal/content/` here is sample data.** Names and dates are placeholders.

## How it works

- **Skills, not code.** Each skill is a `SKILL.md` with instructions plus the files it owns. Claude Code picks the right skill from what we say. Skills in the same domain share a `data/` folder.
- **Plain files in git.** Recipes, people and journal entries are Markdown and CSV. Every change is a commit with a readable message, so either of us can see what the other told it.
- **Drafts first.** Anything we didn't dictate word for word is shown as a draft and saved only after approval.
- **One scheduled task.** The `weekly-digest` skill runs on Saturday morning, calls each automation in `household/skills/weekly-digest/data/automations.md`, and writes a single digest with a "Needs a decision" list at the top. Unattended runs only suggest and draft: no deleting, nothing marked final, no dated file overwritten.

## Skills

| Domain | Skill | What it does |
|---|---|---|
| Meals | `add-recipe` | Saves a recipe from a link, photo, text or cooking video; tags it; logs cooked dates, ratings and tweaks |
| | `meal-planning` | Mon–Fri lunch and dinner plan (protein + veg + carb, no repeats within 2 weeks) and a merged grocery list |
| Birthdays & gifts | `add-birthday` | Adds a person through a short interview |
| | `people-notes` | Files offhand remarks as dated, tagged notes (`[wants]`, `[loves]`, `[dislikes]`, `[has]`, `[life]`, `[size]`) |
| | `gift-ideas` | Gift ideas that start from what the person has said they want, avoiding repeats and dislikes |
| | `log-gift` | Records a gift given and how it landed |
| | `upcoming-birthdays` | Birthdays in the next 4 weeks with gift status; flags anything close with nothing chosen |
| Baby | `baby-inventory` | Photo of toys or books → inventory (the photo is never saved) |
| | `baby-activities` | Five screen-free, age-targeted activities using what we own, each citing a trusted source |
| | `baby-memories` | Rough notes → a journal entry in the parent's own voice, built into a small Hugo site |
| Helper | `video-transcribe` | Gets the words out of a video link (caption, captions, or local speech-to-text) |
| Orchestrator | `weekly-digest` | The Saturday digest that bundles every automation |

## Layout

```
CLAUDE.md                      household conventions Claude Code reads first
.claude/skills/<skill>         symlinks so Claude Code discovers each skill
household/skills/<domain>/     one folder per domain: SKILL.md(s), templates/, data/
household/skills/baby-memories/journal/   the journal's Hugo site
```

## Using it yourself

1. Clone the repo and open Claude Code at its root. The skills load from `.claude/skills/`.
2. Replace the sample data: set the baby's name and birth date in `household/skills/baby-memories/journal/hugo.toml` and `household/skills/baby-activities/data/profile.md`, edit `household/skills/meals/data/preferences.md`, and delete the sample recipe, person, journal entry and digest.
3. Schedule one weekly task that runs the `weekly-digest` skill.
4. Keep your copy private. It will fill up with personal details.
