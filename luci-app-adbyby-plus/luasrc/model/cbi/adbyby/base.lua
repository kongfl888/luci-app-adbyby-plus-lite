local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"

local DL = SYS.exec("head -1 /tmp/adbyby/data/lazy.txt | awk -F' ' '{print $3,$4}'") or ""
local DV = SYS.exec("head -1 /tmp/adbyby/data/video.txt | awk -F' ' '{print $3,$4}'") or ""
local UD = NXFS.readfile("/tmp/adbyby.updated") or "1970-01-01 00:00:00"
local VE = SYS.exec("/usr/share/adbyby/adbyby --version | grep -oE '[0-9]+(\.[0-9]+)*'")

if (VE == nil or VE == "" ) then
VE="???"
end

m = Map("adbyby")
m.title = translate("Adbyby Plus +, Lite")
m.description = translate("Adbyby is a good guarder for family. It can prevent tracking, privacy theft and a variety of malicious websites, but only http/1.1 way.")

m:section(SimpleSection).template  = "adbyby/adbyby_status"

s = m:section(TypedSection, "adbyby")
s.anonymous = true

o = s:option(Flag, "enable", translate("Enable"))
o.description = "Adbyby "..translate("Version").." "..VE
o.default = 0
o.rmempty = false

o = s:option(ListValue, "wan_mode", translate("Running Mode"))
o:value("0", translate("Global Mode (The slowest and the best effects)"))
o:value("1", translate("Plus + Mode (Filter domain name list and blacklist website.Recommended)"))
o:value("2", translate("No filter Mode (Must set in Client Filter Mode Settings manually)"))
o.default = 1
o.rmempty = false

o = s:option(Button, "restart", translate("Adbyby and Rule state"))
o.inputtitle = translate("Update Adbyby Rules Manually")
o.description = string.format("<strong>"..translate("Last Update Checked")..":</strong> %s<br /><strong>"..translate("Lazy Rule")..":</strong>%s <br /><strong>"..translate("Video Rule")..":</strong>%s", UD, DL, DV)
o.inputstyle = "reload"
o.write = function()
	SYS.call("rm -rf /tmp/adbyby.updated /tmp/adbyby/admd5.json && /usr/share/adbyby/adbybyupdate.sh > /tmp/adupdate.log 2>&1 &")
	SYS.call("sleep 3")
	HTTP.redirect(DISP.build_url("admin", "services", "adbyby"))
end

o = s:option(Button, "re_adbyby", translate("Restart"))
o.inputtitle = translate("Restart Adbyby")
o.inputstyle = "reload"
o.write = function()
	SYS.exec("/etc/init.d/adbyby restart &")
	SYS.call("sleep 2")
	HTTP.redirect(DISP.build_url("admin", "services", "adbyby"))
end

o = s:option(ListValue, "exe_arch", translate("Adbyby online"))
o:value("0", translate("No check"))
o:value("1", translate("armv5"))
o:value("2", translate("armv7"))
o:value("3", translate("mips"))
o:value("4", translate("mipsle"))
o:value("5", translate("i386"))
o:value("6", translate("x86_64"))
o.description = translate("If not found adbyby, will download it base on this.")
o.default = 0
o.rmempty = false

o = s:option(Flag, "exe_update", translate("Adbyby Application Auto Update"))
o.description = translate("It is impossible to have a new version.")
o.default = 0
o.rmempty = false

t = m:section(TypedSection, "acl_rule", translate("<strong>Client Filter Mode Settings</strong>"))
t.description = translate("Filter mode settings can be set to specific LAN clients ( <font color=blue> No filter , Global filter </font> ) . Does not need to be set by default.")
t.template = "cbi/tblsection"
t.sortable = true
t.anonymous = true
t.addremove = true

e = t:option(Value, "ipaddr", translate("IP Address"))
e.width = "40%"
e.datatype = "ip4addr"
e.placeholder = "0.0.0.0/0"
luci.ip.neighbors({ family = 4 }, function(entry)
	if entry.reachable then
		e:value(entry.dest:string())
	end
end)

e = t:option(ListValue, "filter_mode", translate("Filter Mode"))
e.width = "40%"
e.default = "disable"
e.rmempty = false
e:value("disable", translate("No filter"))
e:value("global", translate("Global filter"))

return m
