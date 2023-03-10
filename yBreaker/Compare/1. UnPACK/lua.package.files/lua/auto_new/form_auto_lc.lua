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
local THIS_FORM = 'auto_new\\form_auto_lc'
function main_form_init(form)
  form.Fixed = false  
end

function on_main_form_open(form)
	updateBtnAuto()
	if not nx_is_valid(form) then return false end
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end
	local path_ini = add_file_user('auto_ai')
	ini.FileName = path_ini
	if ini:LoadFromFile() then			
		if ini:FindSection(AUTO_LC) then			
			form.edit_chat_lc.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_LC), "chat_text", ""))
			
			if nx_string(ini:ReadString(nx_string(AUTO_LC), "chat_text", "")) == "" or nx_string(ini:ReadString(nx_string(AUTO_LC), "chat_text", "")) == '0' then
				form.edit_chat_lc.Text = utf8ToWstr_load('LC yyy/xxx')
			end
			if nx_string(ini:ReadString(nx_string(AUTO_LC), "open_fa", "")) == nx_string("true") then		
				form.checked_open_fa.Checked = true
			end	
			if nx_string(ini:ReadString(nx_string(AUTO_LC), "fa_pos", "")) == nx_string("true") then	
				form.checked_pos.Checked = true
			end	
			if nx_string(ini:ReadString(nx_string(AUTO_LC), "full_date", "")) == nx_string("true") then	
				form.checked_lc_day.Checked = true
			end	
		end
	end
	click_mouse_fast = 0
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	save_data_auto_lc(form)
	nx_destroy(form)
end
function save_data_auto_lc(form)
	local path_ini = add_file_user('auto_ai')		
	writeIni(path_ini,nx_string(AUTO_LC), "chat_text", form.edit_chat_lc.Text)
	writeIni(path_ini,nx_string(AUTO_LC), "open_fa", nx_string(form.checked_open_fa.Checked))
	writeIni(path_ini,nx_string(AUTO_LC), "fa_pos", nx_string(form.checked_pos.Checked))
	writeIni(path_ini,nx_string(AUTO_LC), "full_date", nx_string(form.checked_lc_day.Checked))	
end
function btn_auto_start(btn)
	local form = btn.ParentForm	
	if click_mouse_fast == nil then click_mouse_fast = 0 end	
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()	
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_fa_state_only') then
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_fa',false)			
		click_mouse_fast = 0 
	else		
		if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
			showUtf8Text(auto_ai_running_wait_stop)
			return
		end
		if not check_auto_special_running() then
			return
		end
		save_data_auto_lc(form)
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_fa_only')	
		nx_pause(1)		
	end	
	updateBtnAuto()
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_lc")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Start')	
end
function updateBtnStart()
	local form = nx_value("auto_new\\form_auto_lc")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Stop')	
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_lc")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_fa_state_only') then
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
