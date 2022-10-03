#!/bin/sh

# [K]2022

arc=""
# Hi,
# if you have your file to use, edit this
# path is file/*
# check and via https://github.com/kongfl888/no-adbyby/tree/master/files
baselink="https://raw.githubusercontents.com/kongfl888/no-adbyby/master/files"
downloader="uclient-fetch -q --no-check-certificate -T 20 -O"

case "$1" in
	"1")
	arc="arm"
	;;
	"2")
	arc="armv7"
	;;
	"3")
	arc="mips"
	;;
	"4")
	arc="mipsle"
	;;
	"5")
	arc="x86"
	;;
	"6")
	arc="amd64"
	;;
	*)
	arc=""
	;;
esac

if [ "$arc" == "" ];then
	echo "Unknown arguments...
Hi, friend.
You can also via https://github.com/kongfl888/no-adbyby/tree/master/files by youself, if you need.
If you need to reinstall adbyby, please delete it first.
Thank you for looking at me.
usage: 1 - armv5, 2 - armv7, 3 - mips, 4 - mipsle, 5 - i386, 6 - x86_64
"
exit 0
fi

PROG_PATH=/usr/share/adbyby
downto=/tmp/adbyby_exe
mkdir -p $downto
rm -rf $downto/*
mkdir -p $downto/doc
mkdir -p $downto/data
ping -c1 baidu.com >/dev/null 2>&1 || exit
echo "Working on it..."
$downloader $downto/adbyby.sh $baselink/adbyby.sh
$downloader $downto/adhook.ini $baselink/adhook.ini
$downloader $downto/update.info $baselink/update.info
$downloader $downto/user.action $baselink/user.action
$downloader $downto/doc/hidecss.js $baselink/doc/hidecss.js
$downloader $downto/data/lazy.bin $baselink/data/lazy.bin
$downloader $downto/data/lazy.txt $baselink/data/lazy.txt
$downloader $downto/data/rules.txt $baselink/data/rules.txt
$downloader $downto/data/user.txt $baselink/data/user.txt
$downloader $downto/data/video.txt $baselink/data/video.txt
$downloader $downto/adbyby $baselink/$arc/adbyby
go=1
if [ -f $PROG_PATH/adbyby ]; then
	md5=0
	oldstr=""
	newstr=""
	go=0
	which md5sum >/dev/null && md5=1
	if [ $md5 -eq 1 ];then
		oldstr=`md5sum $PROG_PATH/adbyby |awk '{print $1}'`
		newstr=`md5sum $downto/adbyby |awk '{print $1}'`
		[ "$oldstr" == "$newstr" ] || go=1
	else
		oldstr=`ls -l $PROG_PATH/adbyby |awk '{print $5}'`
		newstr=`ls -l $downto/adbyby |awk '{print $5}'`
		[ "$oldstr" == "$newstr" ] || go=1
	fi
fi

if [ $go -eq 0 ]; then
echo "Update needlessly."
else
echo "Copy files"
touch $downto/user.action
cp -rf $downto/* $PROG_PATH
fi

if [ -f $PROG_PATH/adbyby ]; then
chmod 0777 $PROG_PATH/adbyby
chmod 0755 $PROG_PATH/*.sh
$PROG_PATH/adbyby --version
fi
