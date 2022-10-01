# Copyright (C) 2020 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for Adbyby
LUCI_DEPENDS:=+adbyby +uclient-fetch +ipset +dnsmasq-full
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-adbyby-plus
PKG_VERSION:=2.0
PKG_RELEASE:=76

define Package/$(PKG_NAME)/conffiles
/usr/share/adbyby/adhost.conf
/usr/share/adbyby/adblack.conf
/usr/share/adbyby/blockip.conf
/usr/share/adbyby/adesc.conf
/usr/share/adbyby/rules.txt
/usr/share/adbyby/dnsmasq.adblock
endef

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
