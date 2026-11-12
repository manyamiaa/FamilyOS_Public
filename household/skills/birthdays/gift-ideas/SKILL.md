---
name: gift-ideas
description: Brainstorm gift ideas for a specific person using what we know about them, and save the ones we like. Use when either of us asks "gift ideas for Maya", "what should we get Mom?", or says "save that idea" / "add a scarf as an idea for Mom". Also called by upcoming-birthdays for people with no open ideas.
---

# Gift Ideas

Shared data lives in `household/skills/birthdays/` (see its `README.md`, including the privacy rule). Read the person's file in `data/people/<slug>.md`. If they aren't tracked, offer to add them (`add-birthday`).

## Brainstorming

1. **Start with What we know.** Dated notes logged by `people-notes` get first priority:
   - `[wants]` notes (something they're actively looking for) come first, and recent notes outrank old ones.
   - If an open `[wants]` note exists (not marked fulfilled or superseded), the first suggestion should address it directly, e.g. "on the hunt for a purse" leads to specific purse options in budget. Cite the note.
2. Then use their **Interests**, **Wishlist**, **Sizes**, **relationship**, the age they're turning (if `birth_year` is known), and **Budget**. If there's no budget, give a spread (small / medium / splurge).
3. Respect `[dislikes]` and `[has]` notes: don't suggest things they dislike or already own. Factor in `[life]` notes (a new home, a new baby).
4. **Avoid repeats:** read **Gifts given** and don't suggest the same thing or a close variant. Lean toward the kinds of gifts noted as landing well.
5. Give **3–5 ideas**, one line each: what it is, why it fits them (naming the note or interest), a rough price, and a link if you looked one up.

## Saving ideas

"Save that", "save the second one", "add X as an idea for Y":
- Append it to **Gift ideas** as `- [ ] <idea>: why, ~price, link (added YYYY-MM-DD by <who>)`.
- Commit: `gifts: idea for <name>`.

## When called by upcoming-birthdays (digest)
- Generate **2–3** ideas using the rules above, and append them to **Gift ideas** marked `(suggested YYYY-MM-DD)`.
- Only add. Never check off or delete ideas, and don't commit; the digest commits everything together.
