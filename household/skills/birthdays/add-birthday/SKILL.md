---
name: add-birthday
description: Add a person to our birthday list through a short interview, or update what we know about them (birthday, relationship, interests, sizes, wishlist, budget). Use when either of us says "add a birthday", "add Leah", "track Sam's birthday", or gives a profile update like "Mom's shoe size is 8" or "Sam's birthday is actually the 15th".
---

# Add Birthday

Shared data lives in `household/skills/birthdays/` (see its `README.md`, including the privacy rule).

## Adding a person (interview)

If we give everything in one line ("Add Leah, Mar 14 1990, my cousin, loves pottery"), take it all and only ask for what's missing. Otherwise interview **one question at a time**, skipping anything we already said:

1. **Name** (required)
2. **Birthday**: month and day. Ask for the year too, which is optional and enables "turning N". If we don't know the birthday, leave it blank; the person can still be tracked for gifts.
3. **Relationship**: e.g. mom, cousin, friend from work, nephew
4. **Side**: whose person they are (one of our names, "both", or "friends"). Use names, not "mine", since either of us may be talking. If you don't know who's speaking, ask once.
5. **Interests**: hobbies, things they love, things to avoid
6. **Sizes**: clothing, shoe, anything else relevant. "Skip" is fine. For kids, record age-based sizing and note that it goes stale.
7. **Wishlist**: links or things they've mentioned wanting
8. **Budget**: optional, per person (e.g. "$50–75")
9. **Any gift ideas already in mind?**

Then:
- Check `data/people.csv` for an existing match first (people-notes may have created a stub with no birthday). If one exists, fill in that person rather than adding a duplicate.
- Generate a slug (`kebab-case` name; if it's taken, add a distinguisher like `leah-sharma` or `leah-cousin`).
- Show a short summary and confirm.
- Append the row to `data/people.csv`, keeping rows sorted by `birthday` (MM-DD; blanks last).
- Create `data/people/<slug>.md` from `templates/person.md`. Remove empty template sections only if we said "skip"; otherwise leave them as placeholders.
- Commit: `birthdays: add <name>`.
- If the birthday is within 4 weeks, say so right away and offer gift ideas (`gift-ideas` skill).

## Updating a person

"Mom's shoe size is 8", "Sam's budget is $40", "Leah's birthday is the 15th, not the 14th":
- Edit the relevant section in place.
- `people.csv` is the source of truth for dates and names. Changing either means updating **both** the CSV and the person file's frontmatter. If they disagree when you open a file, fix the file to match the CSV and mention it.
- Offhand observations ("she's been eyeing a purse") belong to `people-notes`, not here.
- Commit: `birthdays: update <name>`.
