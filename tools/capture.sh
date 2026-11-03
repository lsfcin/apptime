# capture.sh — screenshot one phone screen top to bottom: capture.sh <out_dir> <name> [tap_x tap_y]
A=${ADB:-~/Android/platform-tools/adb}
OUT=$1
name=$2
mkdir -p "$OUT"
[ -n "$3" ] && $A shell input tap "$3" "$4" && sleep 2
prev=""
for i in 01 02 03 04 05 06 07 08 09 10 11 12; do
  f="$OUT/$name-$i.png"
  $A exec-out screencap -p > "$f"
  # compare below the status bar: the clock and the overlay timer change every capture
  sum=$($A exec-out screencap | tail -c +$((16 + 150 * 1080 * 4)) | md5sum)
  [ "$sum" = "$prev" ] && rm "$f" && break
  prev=$sum
  $A shell input swipe 540 1700 540 700 600
  sleep 1.5
done
ls "$OUT" | grep -c "^$name-"
