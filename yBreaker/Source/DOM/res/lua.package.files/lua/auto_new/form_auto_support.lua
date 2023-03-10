require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_support'
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

function btn_start_msct(btn)
	nx_execute('auto_new\\auto_msct','auto_run_msct')
end
function btn_start_join(btn)
	util_auto_show_hide_form('auto_new\\form_auto_join')
end
function btn_start_searchbook(btn)
	nx_execute('auto_new\\auto_script','searchBook')
end
function btn_start_spa(btn)
	nx_execute('auto_new\\auto_script','autoRunSpa')
end
function btn_start_set_key(btn)
	util_auto_show_hide_form('auto_new\\form_auto_hotkey')
end
function btn_start_skill(btn)
	util_auto_show_hide_form('auto_new\\form_auto_skill')
end
function btn_start_set(btn)
	util_auto_show_hide_form('auto_new\\form_auto_chat_func')
end
function btn_start_qt(btn)
	util_auto_show_hide_form('auto_new\\form_auto_qt')
end
function btn_start_use_item(btn)
	util_auto_show_hide_form('auto_new\\form_auto_use_item')
end