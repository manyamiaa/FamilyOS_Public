---
name: baby-memories
description: Baby's journal. Turn the parent's rough notes (quick notes, voice-to-text, fragments) and any photos/videos into an entry in Baby's journal. Writes in the parent's own voice with light cleanup only, suggests tags, shows the draft for approval, files and compresses the media, and rebuilds the site. Use whenever either of us shares notes, a memory, or media about Baby to record, or asks to add to or edit an entry. Also provides the journal section of the Saturday household digest.
---


# baby-memories (Baby's journal)

You turn the parent's raw notes about Baby into one journal entry. It is
**their** journal: you are a careful transcriber, not a writer.

Project facts:
- **The journal lives at `household/skills/baby-memories/journal/`.** It's a small Hugo site. **Run every command below from inside that folder**; all paths are relative to it.
- Entries: `content/entries/YYYY/YYYY-MM-DD-slug/index.md`, with media files in the same folder.
- Birth date, name and the known tag list: `[params]` in `hugo.toml`.
- Age: `scripts/age.sh YYYY-MM-DD` prints the `age:` and `age_months:` lines. Always use it. Never calculate age yourself.
- Media: `scripts/add-media.sh ENTRY_FOLDER FILE...` compresses, strips location data, and prints the new filenames.
- Build: `hugo` (output goes to `public/`, which is not committed).

## 1. Gather and ask only what's missing

Read everything they gave you: notes, fragments, voice-to-text, file paths or attachments.

The only essential is **the date**:
- No date mentioned → use today. Don't ask; the date is visible in the draft and they can correct it.
- A relative date ("yesterday", "Sunday", "this morning") → work it out from today's date and show the result.
- Vague in a way that matters ("the other day", "last week") → ask for the date.

Don't ask about anything else unless the notes are too garbled to understand. If one phrase is unclear, mark it in the draft (step 2) and don't hold up the whole entry with questions.

If they mention media but you can't find or open a file, say so and ask for it.

## 2. Write the entry in their voice

**Light cleanup only:**
- Fix spelling, typos, punctuation and capitalization.
- Fix obvious voice-to-text mistakes, where the intended word is clear from context.
- Drop spoken filler ("um", "so yeah", "like" used as filler) and accidental repeats.
- Join fragments into sentences using **their words**, adding only small connecting words ("and", "then", "he").
- Split into paragraphs where the topic changes.
- Keep their order, unless the notes are plainly jumbled.

**Never:**
- Add details, events, feelings, reactions or conclusions that aren't in the notes. No "my heart melted", "it was magical" or "we'll never forget", unless they said it.
- Add adjectives, sensory description or flourishes. Don't make it "warmer" or "nicer" than they wrote it.
- Swap their words for fancier ones, or change their tone. Keep their nicknames, slang and phrasing.
- Change facts: names, numbers, times, weights, doses, words Baby said.
- Invent media captions. Use a caption only if they described that photo or video; otherwise leave it `""`.

If a phrase is unclear (likely mis-transcription, ambiguous meaning), keep your best reading and flag it with `[?]` in the draft. List it under the draft so they can confirm.

**Title:** short and plain, built from their own words ("First real laugh", "Shots at the 2-month visit"). No puns or sentimentality they didn't use.

## 3. Suggest tags

Read the known tags from `hugo.toml` (`params.tags`). Based on what the entry is actually about:
- Suggest the tags that fit, usually 1–3. Don't tag something just because it's mentioned in passing.
- If the entry has a clear recurring theme no existing tag covers (e.g. `bath`, `words`, `travel`, `grandparents`), you may suggest **one** new tag. Mark it as new and say why in a few words.
- Lowercase, single words or hyphenated.

When they approve a new tag, add it to `params.tags` in `hugo.toml`.

## 4. Show the draft, then wait

Run `scripts/age.sh YYYY-MM-DD` for the entry date, then show:

1. The path it will be saved to: `content/entries/YYYY/YYYY-MM-DD-slug/index.md` (slug = 2–5 lowercase words from the title, hyphenated).
2. The complete file: frontmatter + body. List media by their **planned** names (the slugged original name, e.g. `IMG_1234.HEIC` → `img-1234.jpg`, videos → `.mp4`).
3. Below it, briefly: suggested tags (marking any new one with the reason), any `[?]` items, and the date if you assumed or worked it out.

Format:

```markdown
---
date: 2026-10-05
title: "First real laugh"
age: "2 months, 13 days"
age_months: 2
tags: [milestone, funny]
media:
  - file: img-1234.jpg
    caption: ""
  - file: img-1235.mp4
    caption: ""
---

Body in their words.
```

**Do not save anything until they approve.** Apply their edits and show the draft again if the changes are more than trivial.

## 5. Save, file media, rebuild

After approval:
1. Create the folder and write `index.md`. If that folder exists (two entries the same day), use a different slug.
2. If there is media, run `scripts/add-media.sh <entry folder> <files...>`. Use the filenames it prints in the `media:` list, keeping the order they gave and any captions. If a printed name differs from the planned one, update the entry. Never edit or delete the originals.
3. If they approved a new tag, add it to `params.tags` in `hugo.toml`.
4. Run `hugo` and confirm it builds with no warnings. A "media file not found" warning means a filename in the entry doesn't match a file; fix it.
5. Commit the entry folder (and `hugo.toml` if changed) to FamilyOS with the message `Entry: YYYY-MM-DD <title>`, then push to back it up. If the push fails, say so; the entry is still saved locally.
6. Reply in one or two lines: where it was saved, that the site is rebuilt, and how to view it (`public/index.html`, or `hugo server`).

## Editing or adding to an entry

If they want to change an existing entry ("add this to yesterday's entry", "fix the title"), find it by date or title. Apply the same voice rules to any new text, show the changed entry, and on approval save, rebuild and commit with `Edit: YYYY-MM-DD <title>`. Leave `age` alone unless the date changes; if it does, re-run `scripts/age.sh` and move the folder to match the new date.

## Tooling notes

`hugo`, `ffmpeg` and ImageMagick are installed on the Mac (see `journal/README.md`) but may be missing in a cloud session.
- If `hugo` is missing, save and commit the entry anyway, skip the build, and say the site will rebuild on the Mac or Cloudflare.
- If the media tools are missing, don't add uncompressed media. Save the text entry and say the photos/videos need adding from the Mac (`scripts/add-media.sh`).

## As part of the weekly digest

When the `weekly-digest` skill invokes this (Saturday morning, nobody present). This is read-only, so never write or edit entries:

1. **This week's entries:** journal entries *added* in the last 7 days, going by git history rather than the entry's `date` field (entries are often written after the fact):
   `git log --since="7 days ago" --diff-filter=A --name-only --format= -- 'household/skills/baby-memories/journal/content/entries/*/*/index.md'`
   List each one as `date · title · age` with its path, so whoever didn't write it can read it.
2. **Gentle nudge:** if no entry has been added in **14+ days**, add one line to **Needs a decision**: "No journal entries since <date of last added entry>. Anything to capture?" Otherwise add nothing there.
