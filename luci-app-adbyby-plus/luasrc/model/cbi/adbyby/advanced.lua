
local SYS  = require "luci.sys"

local rule_count=0
if nixio.fs.access("/tmp/adbyby/data/count.txt") then
rule_count=nixio.fs.readfile("/tmp/adbyby/data/count.txt") or "0"
end

m = Map("adbyby")

s = m:section(TypedSection, "adbyby")
s.anonymous = true

o = s:option(Flag, "cron_mode")
o.title = translate("Auto update rules")
o.description = translate("Update the rule at 6:10 a.m. every morning and restart adbyby")
o.default = 0
o.rmempty = false

o = s:option(Flag, "plus_help")
o.title = translate("Extract the domain name to plus")
o.description = translate("Try to extract the domain name to plus mode. But it may become heavy.")
o.default = 0
o.rmempty = false

o=s:option(DummyValue,"rule_data",translate("Subscribe 3rd Rules Data"))
o.rawhtml  = true
o.template = "adbyby/refresh"
o.value =rule_count .. " " .. translate("Records")
o.description = translate("Adp rules for Adbyby, but AdGuardHome / Host / DNSMASQ rules also be supported")

o = s:option(Button,"delete",translate("Delete All Subscribe Rules"))
o.inputstyle = "reset"
o.write = function()
  SYS.exec("rm -rf /tmp/rules/* /tmp/adbyby/data/count.txt")
  SYS.exec("/etc/init.d/adbyby restart 2>&1 &")
  luci.http.redirect(luci.dispatcher.build_url("admin", "services", "adbyby", "advanced"))
end

o = s:option(DynamicList, "subscribe_url", translate("Anti-AD Rules Subscribe"))
o:value("https://cdn.jsdelivr.net/gh/cjx82630/cjxlist/cjx-annoyance.txt", translate("CJX-Annoyance"))
o.rmempty = true

return m
