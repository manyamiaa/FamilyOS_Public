---
name: add-recipe
description: Add recipes to our household recipe box and keep each one's history. Use when either of us shares a recipe (URL, pasted text, photo of a recipe, or a description) to save, wants to edit or retag one, rates a dish, says we cooked something ("we made the dal last night"), or notes a tweak ("next time less salt").
---

# Add Recipe

Shared data for all meal skills lives in `household/skills/meals/` (see its `README.md`). This skill writes recipes; `meal-planning` reads them.

| Path (relative to `household/skills/meals/`) | |
|---|---|
| `data/preferences.md` | **Hard restrictions** (no pork, etc.). Read before saving any recipe. |
| `data/recipes/<slug>.md` | One file per recipe |
| `templates/recipe.md` | Recipe format |

Never invent ratings, "loved by", or cooked dates. Only record what we tell you.

## 1. Extract

Triggered by a URL, pasted text, a photo of a recipe, or "save this recipe".

1. Pull out: **name, source, meal type(s), servings, ingredients with amounts, steps**. For a URL, fetch the page and use its structured recipe data if present; don't copy the blog story. For a **video** link (reel, short, TikTok, YouTube), use the `video-transcribe` skill with `--frames`: post text, then the platform's captions, then speech-to-text, plus frames for on-screen ingredients and amounts. Note in **Notes & tweaks** that the recipe came from the video, and leave unstated amounts blank rather than inventing them. Once the draft is written, delete the downloaded video (see video-transcribe's **Clean up**). For a photo, read the text; mark anything unreadable with `[?]`.
2. Normalize ingredients to one per line, `amount unit ingredient, prep` (e.g. `2 tbsp olive oil`, `1 large onion, diced`). Keep any sub-group headings (e.g. "For the sauce").
3. **Check the hard restrictions** in `preferences.md`. If the recipe breaks one (e.g. contains pork), flag it and propose a substitute before going further.

## 2. Tag

Infer these and include them in the draft so we can correct them:
- `meal_type`: any of breakfast, brunch, lunch, dinner, snack
- `components`: which of protein / veg / carb the dish provides (meal planning uses this to build balanced meals)
- `cuisine`: e.g. South Asian, Italian, Mexican

## 3. Approve and save

1. **Show the draft and wait for approval.** Ask for anything we'd want to capture now (rating, who loves it, tweaks), but don't block on it.
2. On approval, save to `data/recipes/<kebab-case-name>.md` using `templates/recipe.md`. If that slug exists, ask whether it's a duplicate or a variant (`-2`, or a more specific name).
3. Set `added` to today and `added_by` to whoever is talking, if known.
4. Commit: `recipe: add <name>`.

## 4. Logging and feedback

- **Cooked it:** "we made X" / "had X last night" sets `last_cooked` to the actual date, and appends a dated line to **Notes & tweaks** if we said anything about it.
- **Rating:** 1–5. **`loved_by`:** who in the household likes it.
- **Tweaks:** "next time less salt" goes under **Notes & tweaks** with the date. `meal-planning` applies these when the recipe is planned.
- **Edits / retags:** change the field in place, keeping the format.
- Commit: `recipe: update <name>`.
