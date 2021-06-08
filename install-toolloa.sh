#!/usr/bin/env bash

script_version="0.1"
commit_state="0.01"

set -e
: "${TERMUX_PREFIX:=/data/data/com.termux/files/usr}"
: "${TERMUX_ANDROID_HOME:=/data/data/com.termux/files/home}"

echo "Installing $TERMUX_PREFIX/bin/toolloa"
install -d -m 700 "$TERMUX_PREFIX"/bin
sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
	-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|g" \
	./toolloa.sh > "$TERMUX_PREFIX"/bin/toolloa
chmod 700 "$TERMUX_PREFIX"/bin/toolloa

install -d -m 700 "$TERMUX_PREFIX"/etc/toolloa
for script in ./distro-plugins/*.sh; do
	echo "Installing $TERMUX_PREFIX/etc/toolloa/$(basename "$script")"
	install -Dm600 -t "$TERMUX_PREFIX"/etc/toolloa/ "$script"
done