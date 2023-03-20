require("util_gui")
require("util_move")
require("util_functions")

-- Initialize skin path for form
local THIS_FORM = "admin_yBreaker\\yBreaker_form_main"

-- Set value default
function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end

-- Handle event main form of yBreaker
function on_main_form_open(form)
	change_form_size()
	form.is_minimize = false
end

--
function on_main_form_close(form)
	nx_destroy(form)
end

--
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = (gui.Width - form.Width) / 2
	form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
end

--
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
	
