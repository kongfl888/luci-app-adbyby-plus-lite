#!/bin/sh

rm -f /tmp/adbyby.updated /tmp/adbyby/admd5.json

sh /usr/share/adbyby/rule-update

sleep 10
/etc/init.d/adbyby restart
