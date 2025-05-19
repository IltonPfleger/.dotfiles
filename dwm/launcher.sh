#!/bin/bash
APP=$(find /usr/share/applications -name '*.desktop' \
    | while read f; do
		grep -qi '^NoDisplay=true' "$f" && continue
		NAME=$(grep -m1 '^Name=' "$f" | sed 's/^Name=//')
		[ -n "$NAME" ] && echo "$NAME"
	done | sort -f | dmenu -i -p "Launcher: ")


if [ -n "$APP" ]; then
	find /usr/share/applications -name "*.desktop" | while read f; do
	NAME=$(grep -m1 '^Name=' "$f" | sed 's/^Name=//')
	if [ "$NAME" == "$APP" ]; then
		CMD=$(grep -m1 '^Exec=' "$f" | sed -E 's/^Exec=//; s/ *%[a-zA-Z]//g')
		exec $CMD &
		break
	fi
	done
fi
