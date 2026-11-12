---
name: people-notes
description: File away offhand observations about people in our life so they shape future gift recommendations. Use whenever either of us mentions something we've learned about a person, e.g. "Maya seems to be on the hunt for a purse", "Sam just got into bouldering", "Mom said she has too many candles", "Leah is moving to Denver in March". Saves a dated note to that person's file in the shared birthdays data.
---

# People Notes

Turns quick remarks about people into dated notes that the `gift-ideas` skill gives **priority** when recommending gifts.

**Storage:** shared data in `household/skills/birthdays/` (see its `README.md`). Notes go in the **What we know** section of `household/skills/birthdays/data/people/<slug>.md`, so everything about a person stays in one file. Find the slug in `household/skills/birthdays/data/people.csv`.

## Logging a note

1. **Identify the person.** Match the name against `people.csv` (name or slug; allow nicknames and first names only).
   - One match: use it.
   - Several matches (two Priyas): ask which one.
   - No match: say they aren't tracked yet and offer to add them. If we want to, create a minimal entry: a CSV row with `birthday` left blank and a person file from `templates/person.md`. Then mention we can add the birthday any time, via `add-birthday`. A blank birthday is fine; the digest skips them.
2. **Classify the note** with one tag:
   - `[wants]`: something they're looking for, need, or mentioned wanting ("on the hunt for a purse")
   - `[loves]`: a new or ongoing interest, hobby, or favorite ("into bouldering", "obsessed with matcha")
   - `[dislikes]`: things to avoid ("hates scented candles")
   - `[has]`: things they already own or just bought (so we don't duplicate it)
   - `[life]`: life events that change what's useful (new home, new baby, new job, moving, travel)
   - `[size]`: a size or fit detail. Also update the **Sizes** section.
3. **Write it** at the top of **What we know** (newest first):
   `- YYYY-MM-DD [tag] <the observation, in close to our words> (from <who said it>)`
   Keep our phrasing; don't embellish or infer beyond what was said. If you don't know who's talking, leave off "(from …)".
4. **Supersede, don't delete.** If a new note contradicts an older one ("Maya found a purse she likes"), add the new note and append ` → superseded YYYY-MM-DD` to the old one. A `[has]` note that covers an open `[wants]` marks it ` → fulfilled YYYY-MM-DD`.
5. **Confirm in one line**, e.g. "Saved to Maya: [wants] on the hunt for a purse." If their birthday is within 4 weeks, add "Maya's birthday is in N days. Want ideas now?" (use their name rather than a pronoun). Then commit: `people: note on <name>`.

Several people in one message ("Sam's into cycling and his sister wants a new phone case") produce one note per person. Confirm them together.

## Reviewing

"What do we know about Maya?" means summarize their **What we know** notes (open `[wants]` first), plus interests, wishlist, and open gift ideas.
