#!/bin/sh

sh /usr/share/adbyby/rule-update

rm -f /tmp/adbyby.updated 
sleep 10
/etc/init.d/adbyby restart
