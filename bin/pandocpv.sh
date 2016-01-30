#!/bin/sh
# Just pass a markdown filename.  A non-default browser can be specified with
# the -b switch.  Example:
#
#   pandocpv.sh -b 'open -g -a "Google Chrome"' myfile.md

set -e

if [[ $(uname -s) == "Darwin" ]]; then 
  alias browser="open"
elif [[ $(uname -s) == "Linux" ]]; then
  alias browser="xdg-open"
fi

while [[ $# > 1 ]]
do
  key="$1"

  case $key in 
    -b)
      alias browser="$2"
      shift
      ;;
    *)
      ;;
  esac
  shift
done

FILE="$1"

out="/tmp/$(basename $FILE).htm"
pandoc --mathjax --highlight-style=monochrome --toc -s "$FILE" >"$out"
browser "$out"
