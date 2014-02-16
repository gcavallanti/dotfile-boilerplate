#!/bin/sh

FILE="$1"
BROWSER="${2:-open}"

out="/tmp/$(basename $FILE).htm"
pandoc --from markdown_github -s "$FILE" >"$out"
$BROWSER "$out"
