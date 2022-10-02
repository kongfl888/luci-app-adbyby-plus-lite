#!/bin/sh

PROG_PATH=$(cd $(dirname $0); pwd)

[ $(awk -F= '/^ipset/{print $2}' $PROG_PATH/adhook.ini) -eq 1 ] && \
{
	sed -i 's/adbyby_list/adbyby_wan/' /tmp/adbyby_host.conf
	echo conf-file=/tmp/adbyby_host.conf >> /tmp/dnsmasq.d/dnsmasq-adbyby.conf
	/etc/init.d/dnsmasq restart
}

$PROG_PATH/adbybyupdate.sh
