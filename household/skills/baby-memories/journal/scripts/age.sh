#!/usr/bin/env bash
# Print Baby's age on a given date, as two YAML frontmatter lines:
#   scripts/age.sh 2026-10-05
#   age: "2 months, 13 days"
#   age_months: 2
# The birth date is read from hugo.toml (params.birthdate).
# Pure bash arithmetic, so it behaves the same on macOS and Linux.
set -eu

cd "$(dirname "$0")/.."
date_arg="${1:-}"
birth=$(sed -n 's/^[[:space:]]*birthdate[[:space:]]*=[[:space:]]*"\([0-9-]*\)".*/\1/p' hugo.toml)

valid() { [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; }
valid "$date_arg" || { echo "usage: scripts/age.sh YYYY-MM-DD" >&2; exit 1; }
valid "$birth" || { echo "birthdate missing from hugo.toml" >&2; exit 1; }

by=$((10#${birth:0:4})); bm=$((10#${birth:5:2})); bd=$((10#${birth:8:2}))
y=$((10#${date_arg:0:4})); m=$((10#${date_arg:5:2})); d=$((10#${date_arg:8:2}))

days_in_month() { # year month
  case $2 in
    2) if (( ($1 % 4 == 0 && $1 % 100 != 0) || $1 % 400 == 0 )); then echo 29; else echo 28; fi ;;
    4|6|9|11) echo 30 ;;
    *) echo 31 ;;
  esac
}
day_number() { # days since a fixed epoch (proleptic Gregorian)
  local yy=$1 mm=$2 dd=$3
  if (( mm <= 2 )); then yy=$((yy - 1)); mm=$((mm + 12)); fi
  echo $(( 365*yy + yy/4 - yy/100 + yy/400 + (153*(mm-3)+2)/5 + dd ))
}
plural() { if (( $1 == 1 )); then echo "$1 $2"; else echo "$1 ${2}s"; fi; }

total_days=$(( $(day_number $y $m $d) - $(day_number $by $bm $bd) ))
(( total_days >= 0 )) || { echo "date is before the birth date ($birth)" >&2; exit 1; }

# Whole months, then the leftover days.
months=$(( (y - by) * 12 + (m - bm) ))
if (( d >= bd )); then
  days=$(( d - bd ))
else
  months=$((months - 1))
  py=$y; pm=$((m - 1)); if (( pm == 0 )); then pm=12; py=$((y - 1)); fi
  dim=$(days_in_month $py $pm)
  start=$bd; if (( start > dim )); then start=$dim; fi
  days=$(( dim - start + d ))
fi

join() { if [ -n "$2" ]; then echo "$1, $2"; else echo "$1"; fi; }

if (( total_days == 0 )); then
  text="Day of birth"
elif (( months == 0 )); then
  w=$((total_days / 7)); r=$((total_days % 7))
  if (( w == 0 )); then text=$(plural $r day)
  else text=$(join "$(plural $w week)" "$( (( r > 0 )) && plural $r day || true)"); fi
elif (( months < 24 )); then
  text=$(join "$(plural $months month)" "$( (( days > 0 )) && plural $days day || true)")
else
  yrs=$((months / 12)); rem=$((months % 12))
  text=$(join "$(plural $yrs year)" "$( (( rem > 0 )) && plural $rem month || true)")
fi

echo "age: \"$text\""
echo "age_months: $months"
