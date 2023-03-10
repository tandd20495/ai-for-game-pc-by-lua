require('auto_new\\autocack')
local THIS_FORM = 'auto_new\\form_auto_ct'
function main_form_init(form)
  form.Fixed = false  
end

function on_main_form_open(form)
	updateBtnAuto()
	rest_auto_only_to_date()
	if not nx_is_valid(form) then return false end
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end
	local path_ini = add_file_user('auto_ai')
	ini.FileName = path_ini
	if ini:LoadFromFile() then			
		if ini:FindSection(AUTO_CT) then		
			form.edt_turn_end_ct.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CT), "turn", ""))			
			form.lbl_turn_ct.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CT),'cur_turns',''))
			local change = false
			local type_change = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CT),'change',''))
			if nx_string(type_change) == nx_string('true') then
				change = true
			end	
			local use_dcd = false
			local type_dcd = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CT),'use_dcd',''))
			if nx_string(type_dcd) == nx_string('true') then
				use_dcd = true
			end	
			local use_tld = false
			local type_tld = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CT),'use_tld',''))
			if nx_string(type_tld) == nx_string('true') then
				use_tld = true
			end	
			local use_tnd = false
			local type_tnd = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CT),'use_tnd',''))
			if nx_string(type_tnd) == nx_string('true') then
				use_tnd = true
			end	
			local use_hp_cb = false
			local use_hp = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CT),'use_hp',''))
			if nx_string(use_hp) == nx_string('true') then
				use_hp_cb = true
			end		
			form.checked_change_map.Checked = change
			form.cb_can_dcd.Checked = use_dcd
			form.cb_can_tld.Checked = use_tld
			form.cb_can_tnd.Checked = use_tnd
			form.cb_change_hp.Checked = use_hp_cb
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "ctr", "")) == nx_string("true") then				
				form.cb_can_hop_ct.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "rutthu", "")) == nx_string("true") then				
				form.cb_rut_thu.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "del_dcd", "")) == nx_string("true") then				
				form.cb_delete_dcd.Checked = true
			end			
		end
	end
	click_mouse_fast = 0 
end
rest_auto_only_to_date = function()
	local ini_file = add_file_user('auto_ai')
	local date_time = wstrToUtf8(readIni(ini_file,'Reset','date_check',''))
	if nx_int(date_time) == nx_int(0) or (date_time ~= '' and nx_number(date_time) < nx_number(get_cur_time())) then
		writeIni(ini_file,'Reset','date_check',nx_string(get_tomorow_time()))
		writeIni(ini_file,AUTO_ESCORT,'cur_turns',0)
		writeIni(ini_file,AUTO_CT,'cur_turns',0)
		local cur_turns_bf = wstrToUtf8(readIni(ini_file,AUTO_CT,'cur_turns',''))
		local cur_turns_es = wstrToUtf8(readIni(ini_file,AUTO_ESCORT,'cur_turns',''))
		local f = nx_value('auto_new\\form_auto_ct')
		local f1 = nx_value('auto_new\\form_auto_vt')
		if not nx_is_valid(f) then util_show_form(FORM_AUTO_AI,true) end
		if nx_is_valid(f) then  	
			f.lbl_turn_ct.Text = nx_widestr(nx_string(cur_turns_bf))					
		end
		if nx_is_valid(f1) then
			f1.lbl_turn_vt.Text = nx_widestr(nx_string(cur_turns_es))
		end		
	end
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	save_data_auto_ct(form)
	nx_destroy(form)
end
function save_data_auto_ct(form)
	local path_ini = add_file_user('auto_ai')		
	writeIni(path_ini,nx_string(AUTO_CT), "turn", nx_string(form.edt_turn_end_ct.Text))
	writeIni(path_ini,nx_string(AUTO_CT), "change", nx_string(form.checked_change_map.Checked))
	writeIni(path_ini,nx_string(AUTO_CT), "use_dcd", nx_string(form.cb_can_dcd.Checked))
	writeIni(path_ini,nx_string(AUTO_CT), "use_tld", nx_string(form.cb_can_tld.Checked))
	writeIni(path_ini,nx_string(AUTO_CT), "use_tnd", nx_string(form.cb_can_tnd.Checked))
	writeIni(path_ini,nx_string(AUTO_CT), "use_hp", nx_string(form.cb_change_hp.Checked))	
	local cur_turns = wstrToUtf8(readIni(path_ini,nx_string(AUTO_CT),'cur_turns',''))
	writeIni(path_ini,nx_string(AUTO_AI), "ctr", nx_string(form.cb_can_hop_ct.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "rutthu", nx_string(form.cb_rut_thu.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "del_dcd", nx_string(form.cb_delete_dcd.Checked))	
	if nx_int(cur_turns) == nx_int(0) then
		writeIni(path_ini,nx_string(AUTO_CT), "cur_turns", 0)
	end	
end
function btn_auto_start(btn)
	if click_mouse_fast == nil then click_mouse_fast = 0 end
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()	
	local form = btn.ParentForm		
	 if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_bf_state_only') then	
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_bf',false)	
		click_mouse_fast = 0 	
	 else		
		if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
			showUtf8Text(auto_ai_running_wait_stop)
			return
		end
		if not check_auto_special_running() then
			return
		end
		save_data_auto_ct(form)
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_bf_only')	
		nx_pause(1)	
	end	
	updateBtnAuto()
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_ct")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_bf_state_only') then
		form.btn_auto_start.Text = nx_widestr('Stop')
	else
		form.btn_auto_start.Text = nx_widestr('Start')		
	end
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_ct")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Start')	
end
function updateBtnStart()
	local form = nx_value("auto_new\\form_auto_ct")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Stop')	
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
