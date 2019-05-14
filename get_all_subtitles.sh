for f in movies/*; do
  echo "get-subtitles: $f"
  filebot -get-subtitles "$f" -non-strict
done
