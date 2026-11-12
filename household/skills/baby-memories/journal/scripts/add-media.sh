#!/usr/bin/env bash
# Copy photos/videos into an entry folder, compressed and with location
# (GPS) and other metadata removed. Your originals are never modified.
#
#   scripts/add-media.sh content/entries/2026/2026-10-05-first-laugh ~/Desktop/IMG_1234.HEIC ~/Desktop/IMG_1235.MOV
#
# Photos -> JPEG, longest side max 2000px, quality 82, rotation fixed.
# Videos -> MP4 (H.264/AAC), short side max 720px, kept under 24 MB,
#           plus a "<name>-poster.jpg" still frame shown before playback.
# Prints the filename of each file it writes (except posters), one per line,
# so they can go straight into the entry's media list.
# Needs: ffmpeg, ffprobe, ImageMagick (brew install ffmpeg imagemagick).
set -eu

MAX_VIDEO_BYTES=$(( ${MAX_VIDEO_MB:-24} * 1024 * 1024 ))

die() { echo "add-media: $*" >&2; exit 1; }
[ $# -ge 2 ] || die "usage: scripts/add-media.sh ENTRY_FOLDER FILE..."
dest=$1; shift
[ -d "$dest" ] || die "entry folder not found: $dest"
command -v ffmpeg >/dev/null || die "ffmpeg not installed (brew install ffmpeg)"
if command -v magick >/dev/null; then IM=magick
elif command -v convert >/dev/null; then IM=convert
else die "ImageMagick not installed (brew install imagemagick)"; fi

# "IMG 1234 (2).HEIC" -> "img-1234-2"
slug() {
  local base
  base=$(basename "$1"); base=${base%.*}
  echo "$base" | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-z0-9]\{1,\}/-/g' -e 's/^-//' -e 's/-$//'
}

# Pick "name.ext", or "name-2.ext", ... if taken.
free_name() { # stem ext
  local n=$1 i=2
  while [ -e "$dest/$n.$2" ]; do n="$1-$i"; i=$((i + 1)); done
  echo "$n"
}

add_photo() {
  local stem
  stem=$(free_name "$(slug "$1")" jpg)
  # [0] = first frame/page only (Live Photos, multi-image HEIC)
  "$IM" "$1[0]" -auto-orient -resize '2000x2000>' -strip -quality 82 -interlace JPEG "$dest/$stem.jpg"
  echo "$stem.jpg"
}

add_video() {
  local stem out tmp size crf duration kbps
  stem=$(free_name "$(slug "$1")" mp4)
  out="$dest/$stem.mp4"; tmp="$dest/.$stem.tmp.mp4"
  # Short side capped at 720; landscape and portrait both handled.
  local scale="scale='if(gt(iw,ih),-2,min(720,iw))':'if(gt(iw,ih),min(720,ih),-2)'"
  encode() { # extra ffmpeg rate args...
    ffmpeg -nostdin -loglevel error -y -i "$1" -map 0:v:0 -map '0:a:0?' \
      -vf "$scale,format=yuv420p" -c:v libx264 -preset slow "${@:2}" \
      -c:a aac -b:a 128k -ac 2 \
      -map_metadata -1 -map_chapters -1 -movflags +faststart "$tmp"
  }
  for crf in 26 30; do
    encode "$1" -crf $crf
    size=$(wc -c < "$tmp" | tr -d ' ')
    [ "$size" -le "$MAX_VIDEO_BYTES" ] && break
  done
  if [ "$size" -gt "$MAX_VIDEO_BYTES" ]; then
    # Long video: aim for a bitrate that fits (90% of the cap, minus audio).
    duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$1")
    kbps=$(awk -v d="$duration" -v cap="$MAX_VIDEO_BYTES" 'BEGIN { k = int(cap*8*0.9/d/1000) - 128; if (k < 200) k = 200; print k }')
    encode "$1" -b:v "${kbps}k" -maxrate "${kbps}k" -bufsize "$((kbps * 2))k"
    size=$(wc -c < "$tmp" | tr -d ' ')
    [ "$size" -le "$MAX_VIDEO_BYTES" ] || echo "add-media: warning: $stem.mp4 is still $((size / 1048576)) MB (too long to fit 24 MB)" >&2
  fi
  mv "$tmp" "$out"
  # Poster frame from 1s in (or the first frame for very short clips).
  ffmpeg -nostdin -loglevel error -y -ss 1 -i "$out" -frames:v 1 -q:v 3 "$dest/$stem-poster.jpg" 2>/dev/null ||
    ffmpeg -nostdin -loglevel error -y -i "$out" -frames:v 1 -q:v 3 "$dest/$stem-poster.jpg"
  [ -s "$dest/$stem-poster.jpg" ] || ffmpeg -nostdin -loglevel error -y -i "$out" -frames:v 1 -q:v 3 "$dest/$stem-poster.jpg"
  echo "$stem.mp4"
}

for f in "$@"; do
  [ -f "$f" ] || die "file not found: $f"
  ext=$(echo "${f##*.}" | tr '[:upper:]' '[:lower:]')
  case "$ext" in
    jpg|jpeg|png|heic|heif|webp|gif|tif|tiff) add_photo "$f" ;;
    mov|mp4|m4v|avi|mkv|3gp|webm) add_video "$f" ;;
    *) die "don't know how to handle .$ext: $f" ;;
  esac
done
