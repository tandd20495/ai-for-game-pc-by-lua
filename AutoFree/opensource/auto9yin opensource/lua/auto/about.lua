require("util_gui")
require("util_move")
require("util_functions")
local THIS_FORM = "auto/about"
function on_close_click(btn)
	util_auto_show_hide_form(THIS_FORM)
end
function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	form.is_minimize = false
end
function on_main_form_close(form)
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
	end
