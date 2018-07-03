#!/bin/bash

# Stop on first error
set -e

# Define defaults
RES="${RES:-1920x1080}"
DEPTH="${DEPTH:-24}"
FRAMES="${FRAMES:-30}"
SEC_PER_DAY=${SEC_PER_DAY:-0.2}
HIDE="${HIDE:-filenames,progress}"
GOURCE_ARGS=${GOURCE_ARGS:-}

generate () {
  screen -dmS recording xvfb-run -a -s "-screen 0 ${RES}x${DEPTH}" gource --auto-skip-seconds 0.1 --stop-at-end --seconds-per-day ${SEC_PER_DAY} --hide ${HIDE} ${GOURCE_ARGS} --title "Kowala kCoin Github Development Visualization" -o gource.ppm
  lastsize="0"
  filesize="0"
  while [[ "$filesize" -eq "0" || $lastsize -lt $filesize ]] ;
  do
      sleep 5
      lastsize="$filesize"
      filesize=$(stat -c '%s' gource.ppm)
      echo 'Polling the size. Current size is' $filesize
  done
  echo 'Force stopping recording because file size is not growing'
  screen -S recording -X quit
}

convertToMp4 () {
    xvfb-run -a -s "-screen 0 ${RES}x${DEPTH}" ffmpeg -y -r ${FRAMES} -f image2pipe -loglevel info -vcodec ppm -i gource.ppm -vcodec libx264 -preset medium -vprofile baseline -level 3.0 -pix_fmt yuv420p -threads 0 -bf 0 gource.mp4
}

addAudio () {
  ffmpeg -y -i gource.mp4 -i /tmp/background.mp3 -map 0:v:0 -map 1:a:0 -shortest -strict -2 gource-audio.mp4
}

generate
convertToMp4
addAudio

rm gource.ppm
