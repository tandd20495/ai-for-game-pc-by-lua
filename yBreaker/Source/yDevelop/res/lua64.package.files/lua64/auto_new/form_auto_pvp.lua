require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
if not load_spec_pvp then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	auto_cack('14')
	load_spec_pvp = true
end
local THIS_FORM = 'auto_new\\form_auto_pvp'
function main_form_init(form)
  form.Fixed = false
end
function on_main_form_open(form)
  init_ui_content(form)
end
function init_ui_content(form)		
	
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
function btn_start_target(btn)
	util_auto_show_hide_form('auto_new\\form_auto_target')
end
function btn_start_thbb(btn)
	nx_execute(nx_current(),'autoTHBB')
end
function btn_start_searchnv(btn)
	util_auto_show_hide_form('auto_new\\auto_searchnv')
end
function btn_start_def(btn)
	util_auto_show_hide_form('auto_new\\autoDef')
end
function btn_start_swap(btn)
	util_auto_show_hide_form('auto_new\\form_auto_swap')
end
function btn_start_bug_plus(btn)
	util_auto_show_hide_form('auto_new\\form_auto_bug_plus')
end
function btn_start_invite(btn)
	util_auto_show_hide_form('auto_new\\auto_invitewar')
end
function btn_start_mach(btn)
	util_auto_show_hide_form('auto_new\\auto_kinhmach')
end
function btn_start_party(btn)
	util_auto_show_hide_form('auto_new\\auto_party')
end