require("util_gui")
require("util_move")
require("util_functions")
require("util_static_data")
require("define\\sysinfo_define")
require("share\\chat_define")
require("const_define")
require("player_state\\state_const")
require("player_state\\logic_const")
require("player_state\\state_input")
require("tips_data")
require('auto_new\\autocack')
local THIS_FORM = 'auto_new\\form_auto_ot'
function main_form_init(form)
  form.Fixed = false  
end

function on_main_form_open(form)
	updateBtnAuto()
	load_map_match(form)
	click_mouse_fast = 0
	if not nx_is_valid(form) then return false end	
end
function load_map_match(form)	
	form.cbx_map_ontuyen.DropListBox:ClearString()
	local current_map = nx_value("form_stage_main\\form_map\\form_map_scene").current_map
	local index = 0
	for i = 1, 5 do
		local scene_id = 'city0'.. i
		local str = getText(nx_string(scene_id))
		form.cbx_map_ontuyen.DropListBox:AddString(str)
		if nx_string(scene_id) == nx_string(current_map) then index = i - 1 end
	end
	form.cbx_map_ontuyen.DropListBox.SelectIndex = index
	form.cbx_map_ontuyen.InputEdit.Text = form.cbx_map_ontuyen.DropListBox:GetString(index)	
		
end
function on_cbx_ot_selected(cbx)
	local form = cbx.ParentForm	
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	local path_ini = add_file_user('auto_ai')		
	writeIni(path_ini,nx_string(AUTO_OT), "scene", nx_string(form.cbx_map_ontuyen.DropListBox.SelectIndex + 1))

	nx_destroy(form)
end
function btn_auto_start(btn)
	local form = btn.ParentForm	
	if click_mouse_fast == nil then click_mouse_fast = 0 end
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()	
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ot_state_only') then
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_ot',false)		
		-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_ot_state_only')
		-- if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ot_state_only') then			
			-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_ot_state_only')
		-- end
		click_mouse_fast = 0 
	else		
		if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
			showUtf8Text(auto_ai_running_wait_stop)
			return
		end
		if not check_auto_special_running() then
			return
		end
		local path_ini = add_file_user('auto_ai')		
		writeIni(path_ini,nx_string(AUTO_OT), "scene", nx_string(form.cbx_map_ontuyen.DropListBox.SelectIndex + 1))
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_ot_only')	
		nx_pause(1)			
	end	
	updateBtnAuto()
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_ot")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Start')	
end
function updateBtnStart()
	local form = nx_value("auto_new\\form_auto_ot")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Stop')	
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_ot")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ot_state_only') then
		form.btn_auto_start.Text = nx_widestr('Stop')
	else
		form.btn_auto_start.Text = nx_widestr('Start')		
	end
end
function on_main_form_close(form)
  nx_destroy(form)
end
function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
