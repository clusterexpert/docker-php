#!/bin/sh
#cat <> /tmp/stdout 1>&2 &
lighttpd -D -f /etc/lighttpd/lighttpd.conf 2>&1
