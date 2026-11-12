# Birthdays & gifts

Several skills share this folder's data:

| Skill | Does |
|---|---|
| `add-birthday/` | Add or update a person: birthday interview, interests, sizes, wishlist, budget |
| `people-notes/` | File offhand observations ("Maya's hunting for a purse") under **What we know** |
| `gift-ideas/` | Brainstorm gift ideas for a person (What we know first) and save the ones we like |
| `log-gift/` | Record a gift we gave; check off ideas and fulfilled wants |
| `upcoming-birthdays/` | Who's coming up in the next 4 weeks; the Saturday digest's Birthdays section |

| Shared data | |
|---|---|
| `data/people.csv` | Index: `slug,name,birthday,birth_year,relationship,side`. `birthday` is `MM-DD` (blank if unknown); `birth_year` is optional. **Source of truth for dates.** |
| `data/people/<slug>.md` | One file per person (`templates/person.md`): interests, sizes, wishlist, What we know, gift ideas, gifts given |

## Privacy (applies to every skill here)
These files hold personal details about other people. Keep them in this repo. Don't paste them into external services except to search for a gift product, and never include personal details in those searches.
