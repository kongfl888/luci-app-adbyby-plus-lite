local fs = require "nixio.fs"
local conffile = "/usr/share/adbyby/adesc.conf"

f = SimpleForm("custom")
f.reset=false
f.submit=false
t = f:field(TextValue, "conf")
t.rmempty = true
t.rows = 15
function t.cfgvalue()
	return fs.readfile(conffile) or ""
end

function sync_value_to_file(value, file)
	value = value:gsub("\r\n?", "\n")
	local old_value = nixio.fs.readfile(file)
	if value ~= old_value then
		nixio.fs.writefile(file, value)
	end
end
function t.write(self, section, value)
	sync_value_to_file(value, conffile)
end
o = f:field(Button,"save_esc")
o.inputtitle=translate("Save")
o.inputstyle = "submit"
o.description=translate("After saving, you may need restart adbyby")

return f
