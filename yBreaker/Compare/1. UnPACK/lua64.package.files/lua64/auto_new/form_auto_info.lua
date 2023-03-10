require("util_gui")
require('auto_new\\autocack')
if not load_auto_info then
auto_cack('0')
auto_cack('2')
load_auto_info = true
end
local Main_Form = "auto_new\\form_auto_info"
function main_form_init(form)
	form.Fixed = false
end
function on_script_open(form)
	local form = nx_value(Main_Form)
	if not nx_is_valid(form) then
		return
	end	
	nx_execute(nx_current(),'getInfoTarget',form)	
end
function close_form(btn)
	local form = btn.ParentForm
	local formab = nx_value(Main_Form)
	if not nx_is_valid(formab) then
		return
	end
	nx_destroy(form)
end