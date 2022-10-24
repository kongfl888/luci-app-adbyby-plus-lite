# Copyright (C) 2020 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for Adbyby
LUCI_DEPENDS:=+uclient-fetch +ipset +dnsmasq-full
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-adbyby-plus
PKG_VERSION:=2.0K5
PKG_RELEASE:=76

define Package/$(PKG_NAME)/postinst
#!/bin/sh
	chmod a+x ${IPKG_INSTROOT}/etc/init.d/adbyby >/dev/null 2>&1
	chmod a+x ${IPKG_INSTROOT}/usr/share/adbyby/* >/dev/null 2>&1
	exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
