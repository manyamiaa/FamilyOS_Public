#!/usr/bin/env python3
"""Get the words out of a social video: post text, platform captions, else speech-to-text.

Usage: transcribe.py URL OUT_DIR [--frames] [--force-audio]
Writes OUT_DIR/transcript.md (and OUT_DIR/frames/sheet_*.jpg with --frames).
Needs: yt-dlp, ffmpeg; faster-whisper only for the audio fallback.
"""
import argparse, glob, json, os, re, subprocess, sys, wave


def run(cmd, **kw):
    return subprocess.run(cmd, capture_output=True, text=True, **kw)


def vtt_to_text(path):
    """Flatten a .vtt/.srt file to plain lines, dropping timings, tags and the
    repeated lines that auto-captions roll forward cue to cue."""
    out = []
    for line in open(path, encoding="utf-8", errors="ignore"):
        line = line.strip()
        if (not line or "-->" in line or line.isdigit()
                or line.startswith(("WEBVTT", "Kind:", "Language:", "NOTE"))):
            continue
        line = re.sub(r"<[^>]+>", "", line).strip()
        if line and (not out or out[-1] != line):
            out.append(line)
    return "\n".join(out)


def captions(url, out):
    """Platform captions: uploaded subtitles first, then auto-generated."""
    sub_dir = os.path.join(out, "subs")
    os.makedirs(sub_dir, exist_ok=True)
    for flag, kind in (("--write-subs", "uploaded captions"),
                       ("--write-auto-subs", "auto-generated captions")):
        run(["yt-dlp", "-q", "--skip-download", flag, "--sub-langs", "en.*,en",
             "--sub-format", "vtt/srt/best", "-o", os.path.join(sub_dir, "%(id)s.%(ext)s"), url])
        files = sorted(glob.glob(os.path.join(sub_dir, "*.vtt")) + glob.glob(os.path.join(sub_dir, "*.srt")))
        if files:
            return kind, vtt_to_text(files[0])
    return None, None


def download(url, out):
    path = os.path.join(out, "video.mp4")
    if not os.path.exists(path):
        r = run(["yt-dlp", "-q", "-f", "b[ext=mp4]/bv*+ba/b", "--merge-output-format", "mp4", "-o", path, url])
        if not os.path.exists(path):
            sys.exit(f"Could not download the video:\n{r.stderr.strip()}")
    return path


def speech_to_text(video, out):
    try:
        import numpy as np
        from faster_whisper import WhisperModel
    except ImportError:
        sys.exit("faster-whisper not installed: pip install faster-whisper")
    wav = os.path.join(out, "audio.wav")
    run(["ffmpeg", "-v", "error", "-y", "-i", video, "-ac", "1", "-ar", "16000", wav], check=True)
    # Hand whisper raw samples rather than a path: its own decoder breaks on some PyAV versions.
    w = wave.open(wav)
    audio = np.frombuffer(w.readframes(w.getnframes()), np.int16).astype(np.float32) / 32768
    model = WhisperModel("small", device="cpu", compute_type="int8")
    segs, info = model.transcribe(audio)
    lines = [f"[{int(s.start) // 60}:{int(s.start) % 60:02d}] {s.text.strip()}" for s in segs]
    return info.language, "\n".join(lines)


def frames(video, out):
    """Contact sheets (8 frames each, one every 4s) for reading on-screen text."""
    d = os.path.join(out, "frames")
    os.makedirs(d, exist_ok=True)
    run(["ffmpeg", "-v", "error", "-y", "-i", video, "-vf", "fps=1/4,scale=360:-1,tile=4x2",
         os.path.join(d, "sheet_%02d.jpg")], check=True)
    return sorted(glob.glob(os.path.join(d, "sheet_*.jpg")))


def main():
    p = argparse.ArgumentParser()
    p.add_argument("url")
    p.add_argument("out_dir")
    p.add_argument("--frames", action="store_true", help="also save contact sheets of the video")
    p.add_argument("--force-audio", action="store_true", help="transcribe audio even if captions exist")
    a = p.parse_args()
    os.makedirs(a.out_dir, exist_ok=True)

    r = run(["yt-dlp", "-J", "--no-warnings", a.url])
    meta = json.loads(r.stdout) if r.returncode == 0 else {}
    if not meta:
        print(f"warning: no metadata ({r.stderr.strip()[:300]})", file=sys.stderr)

    kind, text = (None, None) if a.force_audio else captions(a.url, a.out_dir)
    video = None
    if not text:
        video = download(a.url, a.out_dir)
        lang, text = speech_to_text(video, a.out_dir)
        kind = f"speech-to-text (whisper, language: {lang}); check names and numbers"
    sheets = frames(video or download(a.url, a.out_dir), a.out_dir) if a.frames else []

    # Facebook/Instagram titles are the whole caption on one line; prefer the caption's first line.
    title = meta.get("title") or ""
    if len(title) > 80:
        title = (meta.get("description") or title).strip().split("\n")[0][:80]
    md = [f"# {title or 'Video transcript'}", "",
          f"- URL: {meta.get('webpage_url') or a.url}",
          f"- Uploader: {meta.get('uploader') or meta.get('channel') or '?'}",
          f"- Duration: {meta.get('duration') or '?'} s",
          f"- Transcript source: {kind}", "",
          "## Post text", "", (meta.get("description") or "(none)").strip(), "",
          "## Transcript", "", text.strip() or "(empty)", ""]
    if sheets:
        md += ["## Frame sheets", ""] + [f"- {s}" for s in sheets] + [""]
    path = os.path.join(a.out_dir, "transcript.md")
    open(path, "w").write("\n".join(md))
    print(path)


if __name__ == "__main__":
    main()
