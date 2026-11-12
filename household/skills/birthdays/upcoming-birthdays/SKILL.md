---
name: upcoming-birthdays
description: Lists birthdays coming up in the next 4 weeks with gift status, and suggests ideas for anyone who has none. Use when either of us asks "whose birthday is coming up?", "any birthdays this month?", or "do we have gifts sorted?". Also provides the Birthdays section of the Saturday household digest.
---

# Upcoming Birthdays

Shared data lives in `household/skills/birthdays/` (see its `README.md`).

1. Read `data/people.csv` and find everyone whose next birthday falls within the next **28 days**, wrapping around the year end. Skip people with no birthday. For a `02-29` birthday, use Feb 28 in non-leap years.
2. For each person, sorted by date, list:
   - date, weekday and days away
   - "turning N", if `birth_year` is known
   - **Gift status:** whether a gift is already logged for this year under **Gifts given**, and how many open ideas they have (plus any open `[wants]` note, in a few words)
   - If they have **no open gift ideas**, get 2–3 from the `gift-ideas` skill (its digest rules), and show them.
   - Anyone **≤ 14 days away with nothing given or chosen** gets flagged ⚠️ as needing a decision soon, because of shipping time.
3. If nobody is coming up, say so and name the next birthday after the window.

## As part of the weekly digest
- The `weekly-digest` skill runs the steps above and puts the result in its **Birthdays** section. Each ⚠️ person goes into **Needs a decision**.
- Only add ideas. Never delete or check off anything, and never log a gift as given.
- Don't write separate files or commit; the digest commits everything together.
