---
name: log-gift
description: Record a gift we gave someone, so future ideas avoid repeats and learn what landed well. Use when either of us says "we gave Mom the scarf", "got Sam a bike light for his birthday", "Maya loved the purse", or adds how a past gift went.
---

# Log Gift

Shared data lives in `household/skills/birthdays/` (see its `README.md`). Find the person in `data/people.csv`. If they aren't tracked, offer to add them (`add-birthday`).

1. Add a row to **Gifts given** in `data/people/<slug>.md`: `| Year | Occasion | Gift | Notes |`
   - **Occasion** defaults to "Birthday"; use whatever we said otherwise (Eid, Diwali, wedding, housewarming, …).
   - **Notes:** how it went and the price, if we said. Don't invent reactions.
2. If it matches an open idea under **Gift ideas**, check it off (`- [x]`) rather than deleting it.
3. If it fulfils a `[wants]` note under **What we know**, append ` → fulfilled YYYY-MM-DD` to that note.
4. **Reaction later** ("she loved the purse", "he never used it") updates that gift's Notes. That's what tells `gift-ideas` which kinds of gifts land well.
5. Confirm in one line, then commit: `gifts: gave <name> <gift>`.
