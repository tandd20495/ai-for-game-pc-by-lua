require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_swap_old'
function main_form_init(form)
  form.Fixed = false
  
end
FORM_STALL_MAIN = 'form_stage_main\\form_stall\\form_stall_main'
function on_main_form_open(form)
  init_ui_content(form)
end
function init_ui_content(form)		
	updateBtnText_swap(form)
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


function updateBtnText_swap(form)	
	if not nx_is_valid(form) then		
		return
	end
	if nx_running(nx_current(),'swapauto') then
		form.btn_auto_swap.Text = nx_widestr("Stop")
	else
		form.btn_auto_swap.Text = nx_widestr("Start")
	end
end
function btn_auto_swap(btn)
	local form = btn.ParentForm	
	if nx_running(nx_current(),'swapauto') then
		nx_execute(nx_current(),'setAutoSwapState',false)
		nx_kill(nx_current(),'swapauto')
	else
		nx_execute(nx_current(),'setAutoSwapState',true)
		nx_execute(nx_current(),'swapauto')
	end
	updateBtnText_swap(form)
end
