require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
local THIS_FORM = 'auto_new\\form_auto_cack'
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
function btn_start_blink_1(btn)
	util_auto_show_hide_form('auto_new\\form_auto_khd')
end
function btn_start_tdc(btn)
	util_auto_show_hide_form('auto_new\\form_auto_encrypt')
end
function btn_start_tdcd(btn)
	util_auto_show_hide_form('auto_new\\form_auto_tdc')
end
function btn_start_quest_nc6(btn)
	util_auto_show_hide_form('auto_new\\form_auto_nc6')
end
function btn_start_ltt(btn)
	util_auto_show_hide_form('auto_new\\form_auto_ltt')
end
function btn_start_dmqt(btn)
	util_auto_show_hide_form('auto_new\\form_auto_dmqt')
end
function btn_start_shop(btn)
	util_auto_show_hide_form('auto_new\\form_auto_stall')
end
function btn_start_train(btn)
	util_auto_show_hide_form('auto_new\\form_auto_train')
end
function btn_start_quest_anthe(btn)
	util_auto_show_hide_form('auto_new\\form_auto_task_round')
end
function btn_start_ab(btn)
	util_auto_show_hide_form('auto_new\\form_auto_ab')
end
