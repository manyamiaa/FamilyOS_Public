---
name: meal-planning
description: Weekly meal planner and grocery list builder from our recipe box. Use when either of us asks for a meal plan, wants to swap or revise a planned meal, needs the grocery list, or asks what we can make ("what can we make with chicken and spinach?", "what haven't we had in a while?"). Also provides the meal-plan section of the Saturday household digest.
---

# Meal Planning

Shared data for all meal skills lives in `household/skills/meals/` (see its `README.md`). Recipes are added and updated by the `add-recipe` skill; this skill only reads them.

| Path (relative to `household/skills/meals/`) | |
|---|---|
| `data/preferences.md` | Hard restrictions, plan scope, repeat window, meal composition, store sections. **Read first, every time.** |
| `data/staples.md` | Things we always have, kept off grocery lists |
| `data/recipes/<slug>.md` | The recipe box (read-only here) |
| `data/meal-plans/YYYY-Www.md` | One plan per ISO week (`templates/meal-plan.md`) |
| `data/meal-plans/YYYY-Www-recipes.md` | Ingredients and steps for that week's suggested dishes (not saved to the recipe box) |
| `data/meal-plans/YYYY-Www-grocery.md` | That week's grocery checklist (`templates/grocery-list.md`) |

## 1. Generating a weekly meal plan

Default scope (from `preferences.md`): **lunch + dinner, Monday–Friday** of the target ISO week. Unless told otherwise, the target is the *next* week.

1. Read `preferences.md`, `staples.md`, every recipe's frontmatter, and the meal plans for the previous weeks covered by the repeat window.
2. Build the candidate pool:
   - only recipes whose `meal_type` includes the slot (lunch / dinner),
   - excluding anything that violates the hard restrictions,
   - excluding anything cooked or planned within the repeat window (default 2 weeks; check both `last_cooked` and prior plan files).
3. Fill the 10 slots following **Meal composition** in `preferences.md`:
   - **Every meal covers protein + veg + carb.** A slot can be one recipe whose `components` cover all three, or a combo of 2–3 recipes or simple sides that together do (e.g. dal [P] + sabzi [V] + rice or roti [C]). Plain carbs like rice, roti, or bread don't need a recipe file; just name them.
   - **Lunch:** just **two variations a week**: one lunch for Mon–Wed and a different one for Thu–Fri, each repeated on its days for batch cooking. Any cuisine, as long as it's balanced and the two differ in main protein.
   - **Dinner:** lean South Asian, with 3–4 of the 5 dinners South Asian (by `cuisine`) and the same balance.
   - Otherwise, use judgment: vary the main protein across dinners, and don't put the same dish at lunch and dinner on the same day.
   - Apply any **Notes & tweaks** from the chosen recipes.
   - In the plan table, tag each item with its component(s) as `(P)`, `(V)`, `(C)`.
4. **If the library can't fill every slot** (expected early on, while the recipe box is small), fill the gaps with suggestions clearly marked `(suggested — not in library)` with a one-line description. Offer to save any we like via `add-recipe`. Never quietly repeat a recipe inside the window to fill gaps.
5. **Recipe links for every meal.** Library recipes link to their file in `data/recipes/`. For each suggested (not-in-library) dish, write ingredients and short numbered steps (serves 2; lunches say how much to batch-cook) into `data/meal-plans/YYYY-Www-recipes.md`, one `## Dish name` heading per dish, and link each plan-table cell to its section (e.g. `YYYY-Www-recipes.md#chicken-shawarma-bowl`). Never put pork in them.
6. Write the plan to `data/meal-plans/YYYY-Www.md` from `templates/meal-plan.md`, with `status: draft`.
7. Generate the grocery list (section 2).
8. Show the plan and list. We can swap meals ("swap Tuesday dinner for something quicker"); update the plan, recipes and grocery files on each change.
9. When we approve, set `status: final` and commit: `meal plan: YYYY-Www`. Do **not** change any recipe's `last_cooked`. Plans are intentions; `last_cooked` changes only when we say we cooked it (via `add-recipe`). The repeat check already reads plan files, so planned meals are still avoided.

## 2. Grocery list

Built from the plan's library recipes (and suggested meals, if we've given them ingredients).

1. Collect every ingredient from every planned meal, scaled to the plan's servings if they differ from the recipe's.
2. Merge duplicates across recipes and sum the quantities when the units are compatible (e.g. `2 onions + 1 onion → 3 onions`). If the units can't be combined, list both amounts (`1 cup + 200 g`).
3. Anything matching `staples.md` goes into a short **Check you have** section at the bottom instead of the main list.
4. Group by store section in the order listed in `preferences.md`.
5. After each item, note which meal(s) it's for in brackets, so we can drop items if we swap a meal.
6. Write to `data/meal-plans/YYYY-Www-grocery.md` as a `- [ ]` checklist.

## 3. Lookups

Answer questions like "what can we make with chicken and spinach?", "what haven't we had in a while?", or "our top-rated dinners" by reading recipe files. Cite the recipe files you used.

## As part of the weekly digest

When the `weekly-digest` skill invokes this (Saturday morning, no one is in the conversation):

- Do steps 1–7 of section 1 for Monday–Friday of the coming week. If that week's plan file already exists, don't overwrite it; stop and report.
- Leave `status: draft`. Put a short summary at the top: how many slots came from the library vs. suggestions, and anything that needs a decision.
- Don't save new recipes or edit existing ones. Only suggest.
- Don't commit or report separately. Hand the digest a short summary (the plan table with every dish deep-linked to its recipe file or section, slot counts, decisions needed, and links to the plan, recipes and grocery files, using relative paths from the digest file); the digest commits everything together.
