# Baby's journal

Part of the FamilyOS household repo, at `household/skills/baby-memories/journal/`. Commands below run from this folder unless noted.

A private journal of observations about Baby (born January 15, 2026), with photos and videos.
Each entry is a Markdown file. [Hugo](https://gohugo.io) turns the entries into a small website for reading.

Private by design: no analytics, trackers, external fonts or scripts. Every page tells search engines not to index it.

## One-time setup (Mac)

```sh
brew install hugo ffmpeg imagemagick
git clone https://github.com/manyamiaa/FamilyOS_Public.git
cd FamilyOS_Public/household/skills/baby-memories/journal
```

Built and tested with Hugo **v0.167.0**. Any newer version should work; check with `hugo version`.

## Reading the journal

| Where | How |
|---|---|
| On your computer | Run `hugo`, then open `public/index.html` (double-click it). |
| On your phone (home Wi-Fi) | Run `hugo server --bind 0.0.0.0` on your computer, then open `http://<your-computer's-IP>:1313` on the phone. Stop it with Ctrl-C. |

`public/` is rebuilt from the entries every time, so it isn't saved in git.

## Writing entries

**With Claude Code (usual way):** open Claude Code at the FamilyOS repo root and give it your notes, e.g. *"/baby-memories he rolled over this morning on the play mat, tried it twice more"*, plus any photo or video files.
The skill (`household/skills/baby-memories/SKILL.md`):
- keeps your wording, with light cleanup only
- suggests tags
- shows you the draft before saving
- compresses and files your media
- rebuilds the site
- commits and pushes the entry as a backup

**By hand:**

```sh
mkdir -p content/entries/2026/2026-10-05-first-laugh
scripts/age.sh 2026-10-05            # prints the age lines for the frontmatter
scripts/add-media.sh content/entries/2026/2026-10-05-first-laugh ~/Desktop/IMG_1234.HEIC
```

Then write `content/entries/2026/2026-10-05-first-laugh/index.md`:

```markdown
---
date: 2026-10-05
title: "First real laugh"
age: "2 months, 13 days"
age_months: 2
tags: [milestone, funny]
media:
  - file: img-1234.jpg
    caption: "On the play mat"
---

What happened, in your words.
```

## Layout

```
hugo.toml                  name, birth date, known tags
content/entries/YYYY/YYYY-MM-DD-slug/
    index.md               the entry
    *.jpg, *.mp4           its media (and *-poster.jpg still frames for videos)
layouts/                   page templates
assets/style.css           look and feel
assets/filter.js           tag / month / age filters
scripts/age.sh             date -> age
scripts/add-media.sh       compress media, strip location data
archetypes/default.md      blank entry template
```

## Media

- **Photos:** converted to JPEG, longest side 2000px, rotation fixed.
- **Videos:** converted to 720p MP4, kept under 24 MB, with a still frame shown before playback.
- **Location (GPS) and other metadata** are removed from both.
- **Originals** stay in Photos/iCloud as the master copies; the journal holds the compressed versions.

GitHub works best under about 5 GB in total, which is years of entries at these sizes.

## Publishing later

The site is plain files, so most hosts work. The plan is **Cloudflare Pages** (builds from the private FamilyOS repo, with the build root set to `household/skills/baby-memories/journal`) behind **Cloudflare Access** (only allowlisted family emails can log in). Pages has a 25 MB per-file limit, which is why videos are capped at 24 MB.
