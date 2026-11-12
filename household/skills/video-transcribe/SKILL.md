---
name: video-transcribe
description: Get the words out of a video link (Facebook, Instagram, YouTube, TikTok and most other platforms): the post's own text, the platform's closed captions, or a speech-to-text transcript when there are none, plus frame sheets for on-screen text. Use when a shared link is a video/reel/short and what we need is in the video, e.g. add-recipe given a recipe reel, or either of us asks "what does this video say?" or "transcribe this".
---

# Video Transcribe

A helper that other skills call (`add-recipe` uses it for recipe reels). It returns text only; it never saves videos, audio, or transcripts to the repo.

```
python3 -I household/skills/video-transcribe/scripts/transcribe.py <url> <scratchpad>/<new-dir> [--frames] [--force-audio]
```

It writes `transcript.md` to the output dir (use a fresh dir in the scratchpad) with the title, uploader, **post text** and **transcript**, and with `--frames`, contact sheets of the video (one frame every 4 s).

## How it gets the words, in order

1. **Post text** (caption/description) from the page metadata. Sometimes it already holds the full recipe.
2. **Platform closed captions**: creator-uploaded subtitles first, then auto-generated ones (YouTube has these for most videos; Facebook and Instagram only sometimes expose them).
3. **Speech-to-text fallback**: if there are no captions, it downloads the video and transcribes the audio locally with Whisper. Marked in the output as speech-to-text: names, spices, and numbers can be misheard (e.g. "tourniquet" for turmeric), so sanity-check them.
4. **On-screen text** (`--frames`): many reels burn in subtitles, ingredient cards, or amounts that are never spoken. Read the sheets with the Read tool. Use them to confirm ingredients and catch amounts the audio left out.

## Using it

- Set it up first if needed: `pip install yt-dlp faster-whisper` (ffmpeg must be present). The first audio run downloads the Whisper model.
- Run with `--frames` for anything where visuals matter (recipes, how-tos). Look at the frames whenever the transcript is ambiguous or quantities are missing.
- If the download fails (private post, login wall), say so and ask us to paste the caption or share a screenshot. Don't guess the content.
- Report what came from where. Anything inferred rather than heard or seen gets a `[?]` and goes in the draft for us to confirm.
- The output dir holds the downloaded video. Keep it in the scratchpad, never in the repo.

## Clean up

Once the caller has what it needs (for `add-recipe`, once the recipe draft is written from the transcript and frames), delete the whole output dir, including the video, audio, captions and frame sheets:

```
rm -rf <scratchpad>/<that-dir>
```

Don't wait for the recipe to be approved: the draft holds everything we need, and the link is still in `source` if we need to check the video again.
