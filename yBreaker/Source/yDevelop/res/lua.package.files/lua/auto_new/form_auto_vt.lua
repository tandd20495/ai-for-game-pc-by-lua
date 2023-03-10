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
local THIS_FORM = 'auto_new\\form_auto_vt'
function main_form_init(form)
   form.Fixed = false  
   form.choose_type_escort = 0
end
local Escort_Data = 
	{
		[1] = {map= 'city05', accept_npc = "EscortAcceptNpc001", accept_type = 251},
		[2] = {map= 'city05', accept_npc = "EscortAcceptNpc001", accept_type = 252},
		[3] = {map= 'city05', accept_npc = "EscortAcceptNpc001", accept_type = 254},
		[4] = {map= 'city04', accept_npc = "EscortAcceptNpc003", accept_type = 228},
		[5] = {map= 'city04', accept_npc = "EscortAcceptNpc003", accept_type = 230},
		[6] = {map= 'city04', accept_npc = "EscortAcceptNpc003", accept_type = 232},
		[7] = {map= 'city03', accept_npc = "EscortAcceptNpc005", accept_type = 240,},
		[8] = {map= 'city03', accept_npc = "EscortAcceptNpc005", accept_type = 242},
		[9] = {map= 'city03', accept_npc = "EscortAcceptNpc005", accept_type = 243},
		[10] = {map= 'city02', accept_npc = "EscortAcceptNpc002", accept_type = 212},
		[11] = {map= 'city02', accept_npc = "EscortAcceptNpc002", accept_type = 213},
		[12] = {map= 'city02', accept_npc = "EscortAcceptNpc002", accept_type = 219},
		[13] = {map= 'city01', accept_npc = "EscortAcceptNpc004", accept_type = 206},
		[14] = {map= 'city01', accept_npc = "EscortAcceptNpc004", accept_type = 208},
		[15] = {map= 'city01', accept_npc = "EscortAcceptNpc004", accept_type = 207}
		
	} 
function on_main_form_open(form)
	updateBtnAuto()
	load_map_escort(form)
	if not nx_is_valid(form) then return false end
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end
	rest_auto_only_to_date()
	local path_ini = add_file_user('auto_ai')
	ini.FileName = path_ini
	if ini:LoadFromFile() then			
		if ini:FindSection(AUTO_ESCORT) then	
			local index = ini:ReadString(nx_string(AUTO_ESCORT), "index", "")
			if index and index ~= "" then
				form.cbx_map_vt.DropListBox.SelectIndex = index - 1
				form.cbx_map_vt.InputEdit.Text = form.cbx_map_vt.DropListBox:GetString(index - 1)
			end
			form.edt_turn_end_vt.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_ESCORT), "turn", ""))	
			form.lbl_turn_vt.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_ESCORT),'cur_turns',''))
			form.edt_mld_vt.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_ESCORT),'mld',''))
			local type_es = false
			local type = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_ESCORT),'type_es',''))
			if nx_string(type) == nx_string('true') then
				type_es = true
			end
			local accept_es = false
			local accept = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_ESCORT),'accept_es',''))
			if nx_string(accept) == nx_string('true') then
				accept_es = true
			end		
			form.checked_vt_type.Checked = 	type_es
			form.checked_vt_accept.Checked = accept_es
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
function on_cbx_vt_selected(cbx) 
	local form=cbx.ParentForm
	form.choose_type_escort = form.cbx_map_vt.DropListBox.SelectIndex + 1		
end
function load_map_escort(form)	
	form.cbx_map_vt.DropListBox:ClearString()
	for i =1,table.getn(Escort_Data) do
		form.cbx_map_vt.DropListBox:AddString(util_text("desc_escortendarea_0"..Escort_Data[i].accept_type))
	end
	form.cbx_map_vt.DropListBox.SelectIndex = 5
	form.cbx_map_vt.InputEdit.Text = form.cbx_map_vt.DropListBox:GetString(5)		
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	save_data_auto_vt(form)
	nx_destroy(form)
end
function save_data_auto_vt(form)
	nx_pause(0.1)
	local path_ini = add_file_user('auto_ai')		
	form.choose_type_escort = form.cbx_map_vt.DropListBox.SelectIndex + 1
	writeIni(path_ini,nx_string(AUTO_ESCORT), "index", nx_string(form.choose_type_escort))
	writeIni(path_ini,nx_string(AUTO_ESCORT), "turn", nx_string(form.edt_turn_end_vt.Text))
	writeIni(path_ini,nx_string(AUTO_ESCORT), "map", Escort_Data[form.choose_type_escort].map)
	writeIni(path_ini,nx_string(AUTO_ESCORT), "npc_id", nx_string(Escort_Data[form.choose_type_escort].accept_npc))
	writeIni(path_ini,nx_string(AUTO_ESCORT), "type", nx_string(Escort_Data[form.choose_type_escort].accept_type))
	writeIni(path_ini,nx_string(AUTO_ESCORT), "type_es", nx_string(form.checked_vt_type.Checked))
	writeIni(path_ini,nx_string(AUTO_ESCORT), "accept_es", nx_string(form.checked_vt_accept.Checked))
	writeIni(path_ini,nx_string(AUTO_ESCORT), "mld", nx_string(form.edt_mld_vt.Text))
	local cur_turns = wstrToUtf8(readIni(path_ini,nx_string(AUTO_ESCORT),'cur_turns',''))	
	if nx_int(cur_turns) == nx_int(0) then
		writeIni(path_ini,nx_string(AUTO_ESCORT), "cur_turns", 0)
	end
end
function btn_auto_start(btn)	
	local form = btn.ParentForm		
	if click_mouse_fast == nil then click_mouse_fast = 0 end
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()	
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_es_state_only') then
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_es',false)		
		click_mouse_fast = 0
	 else
		if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
			showUtf8Text(auto_ai_running_wait_stop)
			return
		end
		if not check_auto_special_running() then
			return
		end
		save_data_auto_vt(form)
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_es_only')
		nx_pause(1)			
	end			
	updateBtnAuto()
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_vt")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Start')	
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_vt")
	if not nx_is_valid(form) then return end			
	form.btn_auto_start.Text = nx_widestr('Stop')	
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_vt")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_es_state_only') then
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
