require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
if not load_spec_blug_bug then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_blug_bug = true
end
local THIS_FORM = 'auto_new\\form_auto_bug_plus'
function main_form_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
  init_ui_content(form)
end
function init_ui_content(form)		
	update_btn_bug_kc(form)
end

function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end

function btn_bug_kc(btn)
	local form = btn.ParentForm	
	nx_execute('auto_new\\autocack','auto_set_bug_qg')
	nx_pause(1)
	update_btn_bug_kc(form)	
end
update_btn_bug_kc = function(form)
	if not nx_is_valid(form) then		
		return
	end
	if nx_running('auto_new\\autocack','auto_set_bug_qg') then
		form.btn_bug_kc.Text = nx_widestr("Stop")
	else
		form.btn_bug_kc.Text = nx_widestr("Start")
	end
end
