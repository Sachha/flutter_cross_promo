#!/usr/bin/env bash
# Vidéo légère d'une pub maison (AppInfo.videos) à partir d'un reel :
# 540 px de large, sans son, 15 s au plus, H.264 lisible partout, lecture
# dès les premiers octets (faststart). Un reel de 4 Mo donne ~0,5 Mo.
#
#   tool/promo_video.sh <reel.mp4> <sortie.mp4>
#
# La sortie va dans le site (happyapp-studio/apps/<app>/promo/), avec un
# nom versionné (doku-pays-fr-v1.mp4) : une nouvelle vidéo = un nouveau nom,
# puis son URL dans catalog.json et lib/src/data/app_catalog.dart.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage : $0 <reel.mp4> <sortie.mp4>" >&2
  exit 1
fi

ffmpeg -v error -y -i "$1" -t 15 \
  -vf "scale=540:-2" -an \
  -c:v libx264 -profile:v main -pix_fmt yuv420p -crf 28 -preset slow \
  -movflags +faststart "$2"

echo "$2 : $(du -h "$2" | cut -f1)"
