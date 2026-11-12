# FamilyOS: household agent

Shared by two of us (a married couple). Either of us may be talking; if it matters who (e.g. "added_by", "from"), ask once.

## Layout
- `household/skills/<domain>/`: one folder per domain, holding that domain's shared `data/` and `templates/`.
  - **Multi-skill domains** put each skill in a subfolder with a domain `README.md` describing the shared data: `meals/` (`add-recipe`, `meal-planning`) and `birthdays/` (`add-birthday`, `people-notes`, `gift-ideas`, `log-gift`, `upcoming-birthdays`).
  - **Single-skill domains** keep `SKILL.md` at the domain root: `baby-activities/`, `baby-inventory/`, `baby-memories/`, `weekly-digest/`, and `video-transcribe/` (a helper other skills call to get the text from a video link; no data of its own).
- `household/skills/baby-memories/journal/`: Baby's journal, a Hugo site (entries in `content/entries/`). Plain files in this repo, with no external dependency.
- `.claude/skills/<skill>`: symlinks into `household/skills/` so Claude Code discovers them. Add one for every new skill.

## Conventions
- **All automated comms go through the Saturday-morning `weekly-digest`.** A new automation becomes a row in `household/skills/weekly-digest/data/automations.md`, not its own schedule, unless we explicitly ask otherwise.
- Unattended runs suggest and draft only: no deleting, no finalizing, no overwriting dated files.
- Show drafts and get approval before saving anything we didn't dictate word for word.
- Commit data changes with a short descriptive message so both of us see them.

