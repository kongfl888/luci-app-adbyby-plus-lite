
module("luci.controller.adbyby", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/adbyby") then
		return
	end
	
	entry({"admin", "services", "adbyby"}, alias("admin", "services", "adbyby", "base"), _("ADBYBY Plus +"), 9).dependent = true
	
	entry({"admin", "services", "adbyby", "base"}, cbi("adbyby/base"), _("Base Setting"), 10).leaf = true
	entry({"admin", "services", "adbyby", "advanced"}, cbi("adbyby/advanced"), _("Advance Setting"), 20).leaf = true
	entry({"admin", "services", "adbyby", "help"}, form("adbyby/help"), _("Custom Plus+ Domain List"), 30).leaf = true
	entry({"admin", "services", "adbyby", "esc"}, form("adbyby/esc"), _("Bypass Domain List"), 40).leaf = true
	entry({"admin", "services", "adbyby", "user"}, form("adbyby/user"), _("User-defined Rule"), 50).leaf = true
	
	entry({"admin", "services", "adbyby", "refresh"}, call("refresh_data"))
	entry({"admin", "services", "adbyby", "run"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep adbyby >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end


function refresh_data()
	local set = luci.http.formvalue("set")
	local icount = 0

	if set == "rule_data" then
	luci.sys.exec("/usr/share/adbyby/rule-update")
	icount = nixio.fs.readfile("/tmp/adbyby/data/count.txt") or "0"

	if tonumber(icount)>0 then
		luci.sys.exec("/etc/init.d/adbyby restart &")
		retstring=tostring(math.ceil(tonumber(icount)))
	else
		retstring ="-1"
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json({ ret=retstring ,retcount=icount})
end
end
