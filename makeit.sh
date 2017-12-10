#!/bin/bash
[ $# -lt 2 ] && echo "USAGE: $0 <ESSID> <PASSWORD> [<logo>]" && exit 1
ESSID="$1"
PASSWORD="$2"
LOGO="$3"
[ -n "$LOGO" ] && LOGOGEN="\( -gravity center -background none $LOGO -resize 400x400 \) -composite"
qrencode -o "$ESSID.svg" -l H -s 1 -d 1 -m 0 -t SVG "WIFI:T:WPA;S:${ESSID};P:${PASSWORD};H:false;"
convert \( \
		\( $ESSID.svg -resize 1000x1000 \) $LOGOGEN \
		\( -gravity North -splice 0x200 \) \
		\( -gravity North -fill black -font FreeMono -pointsize 200 -annotate +0+0 "WiFi" \) \
		\( -gravity East -splice 200x0 \) \
		\( -gravity West -splice 200x0 \) \
		\( -gravity South -splice 0x160 \) \
		\( -gravity South -fill black -font FreeMono -pointsize 70 -annotate +0+80  "ESSID: $ESSID" \) \
		\( -gravity South -fill black -font FreeMono -pointsize 70 -annotate +0+10 "PASSWORD: $PASSWORD" \) \
	\) $ESSID.png
rm -v "$ESSID.svg"
okular $ESSID.png
