require('auto_new\\autocack')
if not load_auto_ai_new then
	auto_cack('3')
	auto_cack('6')
	auto_cack('8')
	auto_cack('1')
	auto_cack('0')
	load_auto_ai = true
end
path_ini = nil
function main_form_init(form)
  form.Fixed = false
  form.choose_type_escort = 0
  form.map_ot = ''
end

function on_main_form_open(form)	
	path_ini = add_file_user('auto_ai')	
	updateBtn()	
	load_ai_ini()
end
function check_dir_and_file(file)	
	if not nx_function('ext_is_file_exist', file) then
		return true
	end
	return false
end
check_all_condition = function()
	if nx_execute('auto_new\\autocack','is_password_locked') then
		nx_execute('auto_new\\autocack','unlock_pass_auto_2')	
		nx_pause(0.5)
	end	
	if nx_execute('auto_new\\autocack','is_password_locked') then
		showUtf8Text(AUTO_LOG_UNLOCK_PASS_2)
		return true
	end	
	if not nx_running(nx_current(), 'auto_start_ai') then
		if nx_execute('auto_new\\autocack','get_bag_free_slot',2) <= 2 or nx_execute('auto_new\\autocack','get_bag_free_slot',125) <= 2 then
			showUtf8Text(AUTO_LOG_ERROR_SLOT_BAG,2)	
		end
	end
	local form = nx_value("auto_new\\form_auto_ai_new")
	if not nx_is_valid(form) then return false end
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end
	ini.FileName = path_ini
	if ini:LoadFromFile() then
		if ini:FindSection(AUTO_AI) then
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "hk", "")) == nx_string("true")	then
				local file = add_file('auto_jh')
				if nx_number(readIni(path_ini,AUTO_HK,"data_change","")) == 1 then
					file = add_file_res('auto_jh')	
				end
				if nx_string(ini:ReadString(nx_string(AUTO_HK), "active", "")) == "" or check_dir_and_file(file) then
					showUtf8Text(AUTO_LOG_HK_CANT_SETTING)
					return true
				end
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "tt", "")) == nx_string("true")	then
				local file = add_file('auto_tt')
				if (nx_string(ini:ReadString(nx_string(AUTO_CROP), "change_type", "")) ~= nx_string('1') and nx_string(ini:ReadString(nx_string(AUTO_CROP), "pos_active", "")) == "") or (nx_string(ini:ReadString(nx_string(AUTO_CROP), "change_type", "")) ~= nx_string('1') and nx_string(ini:ReadString(nx_string(AUTO_CROP), "pos_active", "")) == nx_string('0')) then
					showUtf8Text(AUTO_LOG_CROP_CANT_SETTING_RESOURCE)
					return true
				end
				if nx_string(ini:ReadString(nx_string(AUTO_CROP), "active", "")) == "" or check_dir_and_file(file) then
					showUtf8Text(AUTO_LOG_CROP_CANT_SETTING)
					return true
				end
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "ts", "")) == nx_string("true")	then
				local file = add_file('auto_ts')
				if nx_string(ini:ReadString(nx_string(AUTO_TS), "active", "")) == "" or check_dir_and_file(file) then
					showUtf8Text(AUTO_LOG_HU_CANT_SETTING)
					return true
				end
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "thth", "")) == nx_string("true")	then
				local file = add_file('auto_ti')
				if check_dir_and_file(file) then
					showUtf8Text(AUTO_LOG_TI_CANT_SETTING)
					return true
				end
			end	
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "tq", "")) == nx_string("true")	then
				local file = add_file('auto_tq')
				if check_dir_and_file(file) then
					showUtf8Text(AUTO_LOG_TI_TD_CANT_SETTING)
					return true
				end
			end				
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "trong", "")) == nx_string("true")	then				
				local item2_pos = find_item_pos('nongyao10002')
				local item3_pos = find_item_pos('nongyao10003')	
				if item2_pos == 0 then				
					showUtf8Text(AUTO_LOG_CANT_ITEM.. getUtf8Text("nongyao10002"))
					return true
				end
				if item3_pos == 0 then				
					showUtf8Text(AUTO_LOG_CANT_ITEM.. getUtf8Text("nongyao10003"))
					return true
				end				
			end	
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "nt", "")) == nx_string("true")	then
				local item2_pos = find_item_pos('nongyao10004')
				local item3_pos = find_item_pos('nongyao10005')	
				if item2_pos == 0 then				
					showUtf8Text(AUTO_LOG_CANT_ITEM.. getUtf8Text("nongyao10004"))
					return true
				end
				if item3_pos == 0 then				
					showUtf8Text(AUTO_LOG_CANT_ITEM.. getUtf8Text("nongyao10005"))
					return true
				end				
			end	
		end
	end
	return false
end
function btn_start_ai(btn)
	local form = btn.ParentForm
	saving_ai_ini()
	if check_all_condition() then
		return
	end	
	if nx_running('auto_new\\autocack','exe_auto_ab_state') or nx_running('auto_new\\form_auto_ab','exe_auto_ab_state') then
		showUtf8Text(AUTO_LOG_STOP_AI_AB)
		return 
	end
	if nx_running('auto_new\\auto_script','auto_start_use_item_neixiu')  then
		showUtf8Text('Hãy dừng auto nội tu')
		return 
	end
	nx_execute(nx_current(),'ai_start')		
end
function btn_setting_ai(btn)
	util_auto_show_form('auto_new\\form_auto_setting_ai')
end
function btn_setting_hk(btn)
	util_auto_show_hide_form('auto_new\\form_auto_hk')
end
function btn_setting_lc(btn)
	util_auto_show_hide_form('auto_new\\form_auto_lc')
end
function btn_setting_tn(btn)
	util_auto_show_hide_form('auto_new\\form_auto_tn')
end
function btn_setting_spy(btn)
	util_auto_show_hide_form('auto_new\\form_auto_spy')
end
function btn_setting_vt(btn)
	util_auto_show_hide_form('auto_new\\form_auto_vt')
end
function btn_setting_ct(btn)
	util_auto_show_hide_form('auto_new\\form_auto_ct')
end
function btn_setting_macth(btn)
	util_auto_show_hide_form('auto_new\\form_auto_match')
end
function btn_setting_ot(btn)
	util_auto_show_hide_form('auto_new\\form_auto_ot')
end
function btn_setting_thuthap(btn)
	util_auto_show_hide_form('auto_new\\form_auto_tt')
end
function btn_setting_thosan(btn)
	util_auto_show_hide_form('auto_new\\form_auto_hunter')
end
function btn_setting_trongcay(btn)
	util_auto_show_hide_form('auto_new\\form_auto_farm')
end
function btn_setting_nuoitam(btn)
	util_auto_show_hide_form('auto_new\\form_auto_sw')
end
function btn_setting_thth(btn)
	util_auto_show_hide_form('auto_new\\form_auto_ti')
end
function btn_setting_tq(btn)
	util_auto_show_hide_form('auto_new\\form_auto_tq')
end
function btn_setting_qn(btn)
	util_auto_show_hide_form('auto_new\\form_auto_qn')
end
function btn_setting_force(btn)
	util_auto_show_hide_form('auto_new\\form_auto_force')
end

function update_btn_ai()
	local form = nx_value('auto_new\\form_auto_ai_new')
	if nx_running(nx_current(), 'auto_start_ai') then
		form.btn_start_ai.Text = nx_widestr('Stop')
	else
		form.btn_start_ai.Text = nx_widestr('Start')
	end
end
updatePlay = function(task_value)
	local self = nx_value('auto_new\\form_auto_ai_new')
	if not nx_is_valid(self) then
		return
	end
	if not task_value then
		self.btn_start_ai.Text = nx_widestr('Stop')
	else
		self.lbl_running_auto.Text = utf8ToWstr(task_value)
	end
end
updateStop = function(task_value)
	local self = nx_value('auto_new\\form_auto_ai_new')
	if not nx_is_valid(self) then
		return
	end
	if not task_value then
		self.btn_start_ai.Text = nx_widestr('Start')
	else	
		self.lbl_running_auto.Text = utf8ToWstr(NO_EXE)
	end
end
updateBtn = function()
	if not nx_running(nx_current(), 'auto_start_ai') then
		updateStop()
	else
		updatePlay()
	end
end
function on_main_form_close(form) 
	 nx_destroy(form)	
end
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_ai_new")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
utf8ToWstr_load = function(str)
	if not str then return nx_wstr("")
	else 
		return utf8ToWstr(str)
	end
end
function load_ai_ini()
	local form = nx_value("auto_new\\form_auto_ai_new")
	if not nx_is_valid(form) then return false end
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end
	ini.FileName = path_ini
	if ini:LoadFromFile() then
		if ini:FindSection(AUTO_AI) then			
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "lc", "")) == nx_string("true") then				
				form.checked_lc.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "tn", "")) == nx_string("true") then				
				form.checked_tn.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "spy", "")) == nx_string("true") then				
				form.Checked_spy.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "es", "")) == nx_string("true") then				
				form.checked_vt.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "bf", "")) == nx_string("true") then				
				form.checked_ct.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "mr", "")) == nx_string("true") then				
				form.checked_thienthe.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "hk", "")) == nx_string("true") then				
				form.checked_hk.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "tt", "")) == nx_string("true") then				
				form.checked_thu_thap.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "ts", "")) == nx_string("true") then				
				form.checked_thosan.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "trong", "")) == nx_string("true") then				
				form.checked_cauca.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "nt", "")) == nx_string("true") then				
				form.checked_nuoitam.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "ot", "")) == nx_string("true") then				
				form.checked_ontuyen.Checked = true
			end
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "thth", "")) == nx_string("true") then				
				form.checked_thth.Checked = true
			end	
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "tq", "")) == nx_string("true") then				
				form.checked_tq.Checked = true
			end	
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "qn", "")) == nx_string("true") then				
				form.checked_qn.Checked = true
			end	
		end
		if ini:FindSection(AUTO_TN) then
			
		end
		if ini:FindSection(AUTO_LC) then
			form.edt_lc_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_LC), "start_time", ""))
			form.edt_lc_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_LC), "end_time", ""))			
		end
		if ini:FindSection(AUTO_CT) then			
			form.edt_ct_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CT), "start_time", ""))
			form.edt_ct_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CT), "end_time", ""))					
		end
		if ini:FindSection(AUTO_ESCORT) then
			form.edt_vt_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_ESCORT), "start_time", ""))
			form.edt_vt_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_ESCORT), "end_time", ""))
		end	
		if ini:FindSection(AUTO_TT) then
			form.edt_tthe_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TT), "start_time", ""))
			form.edt_tthe_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TT), "end_time", ""))
		end	
		if ini:FindSection(AUTO_SPY) then
			form.edt_spy_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_SPY), "start_time", ""))
			form.edt_spy_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_SPY), "end_time", ""))
		end	
		
		if ini:FindSection(AUTO_HK) then
			form.edt_hk_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_HK), "start_time", ""))
			form.edt_hk_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_HK), "end_time", ""))
		end
		if ini:FindSection(AUTO_CROP) then
			form.edt_tt_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CROP), "start_time", ""))
			form.edt_tt_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_CROP), "end_time", ""))
		end
		if ini:FindSection(AUTO_TS) then
			form.edt_ts_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TS), "start_time", ""))
			form.edt_ts_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TS), "end_time", ""))
		end
		if ini:FindSection(AUTO_TC) then
			form.edt_farm_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TC), "start_time", ""))
			form.edt_farm_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TC), "end_time", ""))
		end
		if ini:FindSection(AUTO_NT) then
			form.edt_nuoitam_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_NT), "start_time", ""))
			form.edt_nuoitam_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_NT), "end_time", ""))
		end
		if ini:FindSection(AUTO_TG) then
			form.edt_thth_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TG), "start_time", ""))
			form.edt_thth_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TG), "end_time", ""))
		end
		if ini:FindSection(AUTO_TG_ONE) then
			form.edt_tq_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TG_ONE), "start_time", ""))
			form.edt_tq_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_TG_ONE), "end_time", ""))
		end
		if ini:FindSection(AUTO_QN) then
			form.edt_qn_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_QN), "start_time", ""))
			form.edt_qn_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_QN), "end_time", ""))
		end
		if ini:FindSection(AUTO_FORCE) then
			form.edt_force_start.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_FORCE), "start_time", ""))
			form.edt_force_end.Text = utf8ToWstr_load(ini:ReadString(nx_string(AUTO_FORCE), "end_time", ""))
		end
	end
end
function saving_ai_ini()
	local form = nx_value("auto_new\\form_auto_ai_new")
	if not nx_is_valid(form) then return false end
	writeIni(path_ini,nx_string(AUTO_AI), "lc", nx_string(form.checked_lc.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "tn", nx_string(form.checked_tn.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "spy", nx_string(form.Checked_spy.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "es", nx_string(form.checked_vt.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "bf", nx_string(form.checked_ct.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "mr", nx_string(form.checked_thienthe.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "hk", nx_string(form.checked_hk.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "tt", nx_string(form.checked_thu_thap.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "ts", nx_string(form.checked_thosan.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "trong", nx_string(form.checked_cauca.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "nt", nx_string(form.checked_nuoitam.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "ot", nx_string(form.checked_ontuyen.Checked))	
	writeIni(path_ini,nx_string(AUTO_AI), "thth", nx_string(form.checked_thth.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "tq", nx_string(form.checked_tq.Checked))
	writeIni(path_ini,nx_string(AUTO_AI), "qn", nx_string(form.checked_qn.Checked))
	
	
	writeIni(path_ini,nx_string(AUTO_LC), "start_time", nx_string(form.edt_lc_start.Text))
	writeIni(path_ini,nx_string(AUTO_LC), "end_time", nx_string(form.edt_lc_end.Text))	
	
	writeIni(path_ini,nx_string(AUTO_SPY), "start_time", nx_string(form.edt_spy_start.Text))
	writeIni(path_ini,nx_string(AUTO_SPY), "end_time", nx_string(form.edt_spy_end.Text))

	
	writeIni(path_ini,nx_string(AUTO_ESCORT), "start_time", nx_string(form.edt_vt_start.Text))
	writeIni(path_ini,nx_string(AUTO_ESCORT), "end_time", nx_string(form.edt_vt_end.Text))

	
	writeIni(path_ini,nx_string(AUTO_TT), "start_time", nx_string(form.edt_tthe_start.Text))
	writeIni(path_ini,nx_string(AUTO_TT), "end_time", nx_string(form.edt_tthe_end.Text))
	
	writeIni(path_ini,nx_string(AUTO_CT), "start_time", nx_string(form.edt_ct_start.Text))
	writeIni(path_ini,nx_string(AUTO_CT), "end_time", nx_string(form.edt_ct_end.Text))
	
	writeIni(path_ini,nx_string(AUTO_HK), "start_time", nx_string(form.edt_hk_start.Text))
	writeIni(path_ini,nx_string(AUTO_HK), "end_time", nx_string(form.edt_hk_end.Text))
	
	writeIni(path_ini,nx_string(AUTO_CROP), "start_time", nx_string(form.edt_tt_start.Text))
	writeIni(path_ini,nx_string(AUTO_CROP), "end_time", nx_string(form.edt_tt_end.Text))	
	
	writeIni(path_ini,nx_string(AUTO_TS), "start_time", nx_string(form.edt_ts_start.Text))
	writeIni(path_ini,nx_string(AUTO_TS), "end_time", nx_string(form.edt_ts_end.Text))
	
	writeIni(path_ini,nx_string(AUTO_TC), "start_time", nx_string(form.edt_farm_start.Text))
	writeIni(path_ini,nx_string(AUTO_TC), "end_time", nx_string(form.edt_farm_end.Text))
	
	writeIni(path_ini,nx_string(AUTO_NT), "start_time", nx_string(form.edt_nuoitam_start.Text))
	writeIni(path_ini,nx_string(AUTO_NT), "end_time", nx_string(form.edt_nuoitam_end.Text))
	
	writeIni(path_ini,nx_string(AUTO_TG), "start_time", nx_string(form.edt_thth_start.Text))
	writeIni(path_ini,nx_string(AUTO_TG), "end_time", nx_string(form.edt_thth_end.Text))
	
	writeIni(path_ini,nx_string(AUTO_TG_ONE), "start_time", nx_string(form.edt_tq_start.Text))
	writeIni(path_ini,nx_string(AUTO_TG_ONE), "end_time", nx_string(form.edt_tq_end.Text))
	
	writeIni(path_ini,nx_string(AUTO_QN), "start_time", nx_string(form.edt_qn_start.Text))
	writeIni(path_ini,nx_string(AUTO_QN), "end_time", nx_string(form.edt_qn_end.Text))	
	
	-- writeIni(path_ini,nx_string(AUTO_FORCE), "start_time", nx_string(form.edt_force_start.Text))
	-- writeIni(path_ini,nx_string(AUTO_FORCE), "end_time", nx_string(form.edt_force_end.Text))	
end


function load_jianghu_ini_info(active)
	local record_info_list = {}
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	local file = add_file('auto_jh')
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,'data_change','')) == 1 then
		file = add_file_res('auto_jh')	
	end
	ini.FileName = file
	if not ini:LoadFromFile()then nx_destroy(ini) return end
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	if ini:FindSection(active) then
		record_info_list[active] = {}
		record_info_list[active].info = nx_string(ini:ReadString(nx_string(active), nx_string('pos'), ''))
	end
	nx_destroy(ini)
	return record_info_list
end
get_nearest_target_npc_battle = function()
	local scene = auto_game_client:GetScene()
	local scene_obj_table = scene:GetSceneObjList()
	local r = 1000
	local obj = nil
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	for i = 1, table.getn(scene_obj_table) do
		local scene_obj = scene_obj_table[i]
		if nx_is_valid(scene_obj) then
			local can_attack = nx_value('fight'):CanAttackNpc(client_player, scene_obj)
			if can_attack and not scene_obj:FindProp('Dead') and (string.find(nx_string(scene_obj:QueryProp('ConfigID')),'battle_gmphong') ~= nil or string.find(nx_string(scene_obj:QueryProp('ConfigID')),'battle_gmplan') ~= nil) then
				local tmp_r = getDistance(scene_obj)
				if tmp_r and tmp_r <= 35 and tmp_r < r then
					local vis_target = auto_game_visual:GetSceneObj(nx_string(scene_obj.Ident))					
					r = tmp_r
					obj = scene_obj
				end
			end
		end
	end
	if obj ~= nil then
		local id = obj.Ident
		autoSelectObj(id)		
		nx_pause(1)
		return obj
	end
	return nil
end
check_enter_count_tg = function(form,name_id)
	if not nx_is_valid(form) then return end
	local guan_node = form.tree_guan.RootNode:FindNode(util_text(name_id))
	if nx_is_valid(guan_node) then
		if nx_number(guan_node.entercount) < nx_number(guan_node.limitcount) then
			return true
		end
	end
	return false
end
check_enter_count_today_tg = function(form,name_id)
	if not nx_is_valid(form) then return end
	local guan_node = form.tree_guan.RootNode:FindNode(util_text(name_id))
	if nx_is_valid(guan_node) then
		if nx_number(guan_node.todaysucceed) < nx_number(guan_node.limitsucceed) then
			return true
		end
	end	
	return false
end

