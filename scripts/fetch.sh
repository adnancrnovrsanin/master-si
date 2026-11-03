#!/usr/bin/env bash
# Preuzima materijale iz courses/<predmet>/links.txt u courses/<predmet>/materijali/<folder>/
#
#   scripts/fetch.sh <pp1|ps|is> [folder]
#   scripts/fetch.sh is vezbe
#   scripts/fetch.sh pp1 kolokvijumi
#
# Linije u links.txt: folder|url|[ime fajla]. Vec preuzeti fajlovi se preskacu.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
short="${1:?koristi: fetch.sh <pp1|ps|is> [folder]}"
only="${2:-}"

dir=$(ls -d "$root"/courses/"$short"-* 2>/dev/null | head -1)
[ -n "$dir" ] || { echo "nema predmeta '$short'" >&2; exit 1; }
[ -f "$dir/links.txt" ] || { echo "$dir nema links.txt" >&2; exit 1; }

ok=0; skip=0; fail=0
while IFS='|' read -r folder url name; do
  case "$folder" in ''|'#'*) continue ;; esac
  [ -z "$only" ] || [ "$folder" = "$only" ] || continue
  # URL moze imati razmake i unicode, pa ga enkodujemo
  enc=$(python3 -I -c 'import sys,urllib.parse as u; print(u.quote(sys.argv[1], safe=":/?&=%~"))' "$url")
  [ -n "$name" ] || name=$(python3 -I -c 'import sys,urllib.parse as u,os; print(os.path.basename(u.unquote(u.urlparse(sys.argv[1]).path)))' "$url")
  out="$dir/materijali/$folder/$name"
  if [ -s "$out" ]; then skip=$((skip+1)); continue; fi
  mkdir -p "$dir/materijali/$folder"
  if curl -fsSL --max-time 120 -A "Mozilla/5.0" -o "$out" "$enc"; then
    ok=$((ok+1)); echo "ok   $folder/$name"
  else
    rm -f "$out"; fail=$((fail+1)); echo "FAIL $url" >&2
  fi
done < "$dir/links.txt"

echo "gotovo: $ok preuzeto, $skip vec postoji, $fail neuspelo"
