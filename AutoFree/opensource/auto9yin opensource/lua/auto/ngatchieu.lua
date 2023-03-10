require("util_gui")
require('auto\\lib')

local THIS_FORM = "auto\\ngatchieu"
local item = {}

function UpdateScriptStatus()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if form.auto_start then 
			form.btn1.Text = nx_function("ext_utf8_to_widestr", "Bắt đầu")
		    form.auto_start = false
			
		else
			form.btn1.Text = nx_function("ext_utf8_to_widestr", "Kết thúc")
		    form.auto_start = true
		end
	end
end



function on_script_init(form)
	form.Fixed = false
	form.auto_start = false
	form.select_index = 0
	form.cur_point = 1
	form.total_point = 0
end

function on_script_open(form)
end

function on_script_close(form)
end

function on_close_click(btn)
	util_auto_show_hide_form(THIS_FORM)
end

function on_btn1_click(cbtn)
	local form = cbtn.ParentForm
	UpdateScriptStatus()
end