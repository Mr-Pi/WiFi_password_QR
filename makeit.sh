#!/bin/bash
[ $# -lt 2 ] && echo "USAGE: $0 <ESSID> <PASSWORD> [<logo>]" && exit 1
ESSID="$1"
LOGO="$3"

password_plain="$2"
password_split=()
while read -n 20 pw_part; do
	password_split+=("$pw_part")
done <<< "$password_plain"
[ -z "${password_split[-1]}" ] && unset 'password_split[${#password_split[@]}-1]'

extra_space=$((80+${#password_split[@]}*72))

password_option_str=""
for ((i=1; i<${#password_split[@]}; i++)); do
	[ -n "${password_split[$i]}" ] &&
	password_option_str+=" -gravity South -fill black -font FreeMono -pointsize 70 -annotate +0+$((${extra_space}-${i}*72-150)) ${password_split[$i]} "
done

[ -n "$LOGO" ] && LOGOGEN="( $LOGO -gravity center -resize 400x400 ) -composite "

echo $password_option_str

qrencode -o "$ESSID.svg" -l H -s 1 -d 1 -m 0 -t SVG "WIFI:T:WPA;S:${ESSID};P:${password_plain};H:false;"

convert $ESSID.svg \
		-resize 1000x1000 \
		$LOGOGEN \
		-gravity North -splice 0x200 \
		-gravity East -splice 200x0 \
		-gravity West -splice 200x0 \
		-gravity South -splice 0x$((${extra_space}+5)) \
		-gravity North -fill black -font FreeMono -pointsize 200 -annotate +0+0 "WiFi" \
		-gravity South -fill black -font FreeMono -pointsize 70 -annotate +0+$((${extra_space}-80))  "ESSID: $ESSID" \
		-gravity South -fill black -font FreeMono -pointsize 70 -annotate +0+$((${extra_space}-150)) "PASSWORD: ${password_split[0]}" \
		$password_option_str \
	$ESSID.png
rm -v "$ESSID.svg"

if which geeqie; then
	geeqie $ESSID.png
elif which okular; then
	okular $ESSID.png
fi
