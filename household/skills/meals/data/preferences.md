# Meal planning preferences

Edit this file to change how plans are generated. The recipes skill reads it before every plan.

## Hard restrictions (never violate)
Both meal skills (`add-recipe`, `meal-planning`) enforce these.

- **No pork, ever.** Includes bacon, ham, prosciutto, pancetta, guanciale, most chorizo/salami/pepperoni, pork sausage, lard, and pork-based stocks. Substitutes to suggest: turkey bacon, chicken sausage, smoked paprika for smokiness.

## Plan scope
- Meals: lunch, dinner
- Brunch: not planned; suggestions on demand
- Days: Monday–Friday (weekends are left unplanned)
- Week convention: ISO weeks (Monday start), files named `YYYY-Www`
- Default servings per meal: 2 adults

## Selection rules
- Avoid repeats: don't plan any recipe that was cooked or planned in the last **2 weeks**
- Baby: not considered yet (revisit as he starts solids)
- Leftovers-for-lunch: off

## Meal composition
- **Lunch:** only **two lunch variations per week**: one for Mon–Wed and one for Thu–Fri, each repeated on its days (so the same lunch can be batch-cooked). Every lunch covers **one protein + one veg + one carb**. That can be a single dish that covers all three (e.g. a chicken rice bowl with greens) or 2–3 separate dishes combined (e.g. dal + sabzi + roti).
- **Dinner:** same balance (protein + veg + carb), and **lean South Asian**: aim for 3–4 of the 5 dinners to be South Asian; the rest can be anything.

## Automation
- Weekly auto-draft: on, as part of the **Saturday morning household digest**, for the following week (status: draft until we approve)

## Grocery list
- Output: Markdown checklist in `data/meal-plans/`
- Store section order:
  1. Produce
  2. Meat & fish
  3. Dairy & eggs
  4. Bakery
  5. Pantry & dry goods
  6. Spices & condiments
  7. Frozen
  8. Other
