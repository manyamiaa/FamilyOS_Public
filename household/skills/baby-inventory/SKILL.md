---
name: baby-inventory
description: Keep a list of Baby's toys and books by snapping a photo. Use when either of us uploads or shares a photo of toys, books, a bookshelf, or a toy basket ("here's his new toys", "add these books"), or names items to add, remove, or mark outgrown. Extracts each item's name and type and saves it to the inventory used by baby-activities. Photos are never saved.
---

# Baby Inventory (toys & books)

The list of toys and books we own. `baby-activities` reads it to suggest activities using things we already have.

| Path | What it is |
|---|---|
| `data/inventory.csv` | One row per item: `name,type,category,author_or_brand,age_range,areas,language,added,added_by,status,notes` |

Column values:
- `type`: `toy` or `book`
- `category`:
  - toys: `rattle | teether | soft toy | play mat/gym | stacking/nesting | blocks | shape sorter | musical | ball | push/pull | puzzle | bath | mirror | other`
  - books: `board book | cloth book | touch-and-feel | high-contrast | lift-the-flap | picture book | other`
- `author_or_brand`: author for books, brand for toys, if visible
- `age_range`: as printed on the item or box (e.g. `0m+`, `6–12m`); blank if not visible. Don't guess.
- `areas`: which development areas it suits: `motor`, `sensory`, `language`, `cognitive` (one or more, separated by `;`)
- `language`: books only: `English`, `Hindi`, `Urdu`, `bilingual`, …
- `status`: `active` (default), `outgrown`, `stored`, or `gone`

## Adding from a photo

1. **Look at the photo** and find every distinct toy or book. For books, read the title and author from the cover or spine. For toys, use the brand and product name if visible ("Lamaze Freddie the Firefly"); otherwise give a clear description ("wooden rainbow stacker, 6 pieces").
2. **Don't guess names you can't read.** Mark partially visible or uncertain items as `(unsure)` in the draft, and ask us to confirm or skip them.
3. **Check for duplicates** against `inventory.csv` (same name and type). Mention them instead of re-adding. If one was marked `outgrown`, `stored` or `gone`, offer to make it `active` again.
4. **Show a short table** of what you found (name, type, category, age range, areas) and wait for approval. We may edit or drop rows.
5. On approval, append the rows with `added` set to today, `added_by` set to who's talking, and `status` set to `active`.
6. **Don't save the photo.** Never copy, move, or commit the image file into this repo. Once the items are extracted, the photo isn't needed.
7. Confirm in one line, e.g. "Added 4 books and 2 toys. 1 was already on the list."

Adding by text works the same way ("add a Sophie the giraffe teether"): skip straight to the draft row.

## Updating

- "He's outgrown the play gym" / "we gave away the rattle" / "put the bath toys in storage": set `status`, and append a dated note in `notes`. Don't delete rows.
- "What books do we have in Hindi?" / "which toys are good for tummy time?": answer from the CSV, using `active` items only unless we ask otherwise.
