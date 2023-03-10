require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_hk'
inifile = nil
listsrc = ''
array_list_src = nil
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end
	
function on_main_form_open(form)	
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"trash","")) == 1 then
		form.cbtn_pick_trash.Checked = true
	end
	if nx_number(readIni(ini_file,AUTO_HK,"vlts","")) == 1 then
		form.cbtn_pick_vlts.Checked = true
	end
	if nx_number(readIni(ini_file,AUTO_HK,"dp","")) == 1 then
		form.cbtn_pick_dp.Checked = true
	end
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		form.cbtn_change_data.Checked = true
	end
	if nx_number(readIni(ini_file,AUTO_HK,"next","")) == 1 then
		form.cbtn_next_map.Checked = true
	end
	updateBtnAuto()
	loadGridAutoSkill(form)
	loadAutoHunterCombo(form)
	click_mouse_fast = 0
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_hk")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function on_main_form_close(form)	
	nx_destroy(form)
end
array_config = {}
function loadAutoHunterCombo(form)
	form.cbx_input_item_pick.DropListBox:ClearString()
	form.cbx_input_item_pick.InputEdit.Text = ""	 	
	local file = add_file('auto_jh')
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		file = add_file_res('auto_jh')	
	end
	local countini = nx_execute('auto_new\\autocack','sectionCount',file)
	array_config = {}
	local countName = ""
	if countini > 0 then
		for j = 1, countini do
			countName = getSectionName(file,j)
			for k = 1, table.getn(countName) do				
				form.cbx_input_item_pick.DropListBox:AddString(util_text(countName[k]))
				table.insert(array_config,countName)
			end
		end
	end
	local index_cbx = 0
	local get_string = 0	
	local index = nx_number(readIni(ini_file,nx_string(AUTO_HK), "index", ""))
	if index and index ~= 0 then
		index_cbx = index - 1
		get_string = index - 1
	end
	form.cbx_input_item_pick.DropListBox.SelectIndex = nx_int(index_cbx)
	form.cbx_input_item_pick.InputEdit.Text = form.cbx_input_item_pick.DropListBox:GetString(nx_int(get_string))
end
function getSectionName(inifile,index)	
    local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local set = {}
	ini.FileName = inifile
	if ini:LoadFromFile() then
		local sect_list = ini:GetSectionList()
		if #sect_list >= 1 then
			for k, v in pairs(sect_list) do
				if nx_number(k) == nx_number(index) then
					table.insert(set,v)
					return set
				end
			end
		end
	end
end
function on_cbx_item_pick_selected(cbx)
	local form = cbx.ParentForm
	local file = add_file_user('auto_ai')
	local array_string = ''
	local index = form.cbx_input_item_pick.DropListBox.SelectIndex	
	if index < table.getn(array_config) then		
		array_string = array_config[index + 1][1]
		writeIni(file,AUTO_HK,'index',index + 1)	
		writeIni(file,AUTO_HK,'active',array_string)	
	end
	loadGridAutoSkill(form)
end
function btn_add_start(btn)
	local form = btn.ParentForm
	if click_mouse_fast == nil then click_mouse_fast = 0 end
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()		
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ji_state_only') then
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_ji',false)		
		-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_ji_state_only')
		-- if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ji_state_only') then			
			-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_ji_state_only')
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
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_ji_only')	
		nx_pause(1)	
	end	
	updateBtnAuto()
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_hk")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Start')	
end
function updateBtnStart()
	local form = nx_value("auto_new\\form_auto_hk")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Stop')	
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_hk")
	if not nx_is_valid(form) then return end		
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ji_state_only') then
		form.btn_add_start.Text = nx_widestr('Stop')
	else
		form.btn_add_start.Text = nx_widestr('Start')		
	end
end
function cbtn_change_data(cbtn) 
	local form = cbtn.ParentForm
	local inifile = add_file_user('auto_ai')
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	writeIni(inifile,nx_string(AUTO_HK), "data_change", nx_string(check))
	writeIni(inifile,AUTO_HK,'index',1)	
	writeIni(inifile,AUTO_HK,'active','city05')	
	form.cbx_input_item_pick.DropListBox.SelectIndex = 1
	loadGridAutoSkill(form)
	loadAutoHunterCombo(form)
	on_cbx_item_pick_selected(form)
end  
function cbtn_pick_trash(cbtn) 
	local form = cbtn.ParentForm
	local inifile = add_file_user('auto_ai')
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	writeIni(inifile,nx_string(AUTO_HK), "trash", nx_string(check))
end  
function cbtn_next_map(cbtn) 
	local form = cbtn.ParentForm
	local inifile = add_file_user('auto_ai')
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	writeIni(inifile,nx_string(AUTO_HK), "next", nx_string(check))
end  
function cbtn_pick_dp(cbtn) 
	local form = cbtn.ParentForm
	local inifile = add_file_user('auto_ai')
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	writeIni(inifile,nx_string(AUTO_HK), "dp", nx_string(check))
end  
function cbtn_pick_vlts(cbtn) 
	local form = cbtn.ParentForm
	local inifile = add_file_user('auto_ai')
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	writeIni(inifile,nx_string(AUTO_HK), "vlts", nx_string(check))
end  
FORM_MAP_SCENE= 'form_stage_main\\form_map\\form_map_scene'
function removeSection(inifile,section, item)	 
    local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(inifile) 
	if ini:LoadFromFile() then
		if ini:FindSection(section) then
			ini:DeleteItem(section,item)
			ini:SaveToFile()
			nx_destroy(ini)
		end
	end
end


function removeEmptyItems(input) 
	for i = #input, 1, -1 do 
		if input[i] == nil or input[i] == '' then 
			table.remove(input, i) 
		end 
	end 
	return input
end  
function auto_split_string(input, splitChar) 
	local t = util_split_string(input, splitChar) 
	return removeEmptyItems(t) 
end  
function on_click_hyper_move(btn)
	if btn.DataSource ~= "" and btn.DataSource ~= nil then
		local pos_data = auto_split_string(btn.DataSource,';')
		local pos = auto_split_string(pos_data[2],',')
		local x,y,z = pos[1],pos[2],pos[3]
		local form_map = nx_value('form_stage_main\\form_map\\form_map_scene')
		local form_map_scene = 'form_stage_main\\form_map\\form_map_scene'
		if not nx_is_valid(form_map) then		
		   return
		end
		if not form_map.Visible then
			nx_execute(form_map_scene,'auto_show_hide_map_scene')
		end	
		nx_execute(form_map_scene,'set_map_center_according_world_pos',form_map,x,z)
		moveTo(x,y,z)
	end
end
function on_click_btn_move(btn)
	local x,y,z = btn.x,btn.y,btn.z
	local form_map = nx_value('form_stage_main\\form_map\\form_map_scene')
	local form_map_scene = 'form_stage_main\\form_map\\form_map_scene'
	if not nx_is_valid(form_map) then		
	   return
	end
	if not form_map.Visible then
		nx_execute(form_map_scene,'auto_show_hide_map_scene')
	end	
	nx_execute(form_map_scene,'set_map_center_according_world_pos',form_map,x,z)
	moveTo(x,y,z)
end


function loadGridAutoSkill(form)
	local gui = nx_value("gui")
	local grid = form.textgrid_pos	
	grid:ClearRow()
	grid:ClearSelect()
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end	
	local file = add_file('auto_jh')
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		file = add_file_res('auto_jh')	
	end
	ini.FileName = file
	local inifile = add_file_user('auto_ai')	
	local active = wstrToUtf8(readIni(inifile,AUTO_HK,'active',''))
	if ini:LoadFromFile() then	
		if ini:FindSection(active) then		
			local pos_table = wstrToUtf8(readIni(file,nx_string(active),'pos',''))			
			local count_pos = auto_split_string(pos_table,'|')			
			listsrc = pos_table
			array_list_src = count_pos			
			if nx_number(table.getn(count_pos)) > 0 then				
				for i = 1, table.getn(count_pos) do
					local split_item = auto_split_string(count_pos[i],';')
					local scene = split_item[1]
					local config_id = split_item[2]
					local pos = split_item[3]		
					local pos_split = auto_split_string(nx_string(pos),',')
					local name = split_item[4]					
					local x,y,z = nx_string(pos_split[1]),nx_string(pos_split[2]),nx_string(pos_split[3])
					if x ~= nil and config_id ~= nil then	
					local btn_del = create_multitextbox(THIS_FORM, 'on_click_btn_del',auto_del,count_pos[i], 'HLStypebargaining')
					local btn_up = create_multitextbox(THIS_FORM, 'on_click_up',auto_up,nx_string(i), 'HLStypelaba')	
					local btn_down = create_multitextbox(THIS_FORM, 'on_click_down',auto_down,nx_string(i), 'HLStypelaba')
					local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move', name,nx_string(scene) .. ';' .. nx_string( x) .. ',' .. nx_string(y) .. ',' .. nx_string(z), 'HLChatItem1')		
					gridAndFunc(grid,multitextbox,btn_up,btn_down,btn_del)
					end
				end				
			end			
		end		
	end
end
function gridAndFunc(grid,mTextName,btn_up,btn_down,btn_del)
	local form = nx_value(THIS_FORM)
	local row = grid:InsertRow(-1)
	grid:SetGridControl(row, 0, mTextName)
	grid:SetGridControl(row, 1, btn_up)
	grid:SetGridControl(row, 2, btn_down)
	grid:SetGridControl(row, 3, btn_del)		
end
function on_click_btn_del(btn)
	local form = btn.ParentForm	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map		
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local file = add_file('auto_jh')
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		file = add_file_res('auto_jh')	
	end
	ini.FileName = file
	local inifile = add_file_user('auto_ai')	
	local active = wstrToUtf8(readIni(inifile,AUTO_HK,'active',''))
	local str = wstrToUtf8((readIni(file,nx_string(active), 'pos', '')))
	local list =  auto_split_string(str,'|')	
	if nx_int(table.getn(array_list_src)) == nx_int(1) then		
		if ini:LoadFromFile() then	
			if ini:FindSection(active) then
				ini:DeleteSection(active)
				ini:SaveToFile()
				loadGridAutoSkill(form)
				return
			end
		end
	end		
	local data = btn.DataSource		
	local data_item = ''
	for i =1, table.getn(list) do	
		if list[i] == data then			
			table.remove(list, i)
		end
	end
	for j = 1, table.getn(list) do		
		data_item = data_item..'|'..list[j]
	end
	writeIniString(file,nx_string(active), "pos", data_item)	
	loadGridAutoSkill(form)
	loadAutoHunterCombo(form)
end
writeIniString = function(file, section, key, value)
  local ini = nx_create('IniDocument')
  ini.FileName = file
  if not ini:LoadFromFile() then
    local create_file = io.open(file, 'w+')
    create_file:close()
  end
  if not ini:LoadFromFile() then
    nx_destroy(ini)
    return 0
  end
  ini:WriteString(section, key, value)
  ini:SaveToFile()
  nx_destroy(ini)
  return 1
end
function on_click_up(btn)
	local form = btn.ParentForm
	local index = nx_number(btn.DataSource)
	local file = add_file('auto_jh')
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		file = add_file_res('auto_jh')	
	end
	local inifile = add_file_user('auto_ai')	
	local cur_scene_id = wstrToUtf8(readIni(inifile,AUTO_HK,'active',''))
	if index == 1 then return end	
	local record_arr = auto_split_string(nx_string(listsrc),'|')
	local tmp = record_arr[index]		
	record_arr[index] = record_arr[index - 1]
	record_arr[index - 1] = tmp	
	local tmp_str = ""
	for i = 1, table.getn(record_arr) do
		tmp_str = tmp_str .. "|" .. record_arr[i]
	end
	listsrc = tmp_str
	writeIniString(file,nx_string(cur_scene_id), "pos",listsrc)
	loadGridAutoSkill(form)	
end
function on_click_down(btn)
	local form = btn.ParentForm
	local file = add_file('auto_jh')
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		file = add_file_res('auto_jh')	
	end
	local inifile = add_file_user('auto_ai')	
	local cur_scene_id = wstrToUtf8(readIni(inifile,AUTO_HK,'active',''))
	local index = nx_number(btn.DataSource)
	local record_arr = auto_split_string(nx_string(listsrc),'|')
	if index == table.getn(record_arr) then return end
	local tmp = record_arr[index]
	record_arr[index] = record_arr[index + 1]
	record_arr[index + 1] = tmp
	local tmp_str = ""
	for i = 1, table.getn(record_arr) do
		tmp_str = tmp_str ..  "|" .. record_arr[i]
	end
	listsrc = tmp_str
	writeIniString(file,nx_string(cur_scene_id), "pos",listsrc)
	loadGridAutoSkill(form)	
end
function btn_add_mon_hk(btn)
	local form = btn.ParentForm
	util_show_form('auto_new\\form_auto_hk_st',true)
	-- local x, y, z = getCurPos()	
	-- local tmp_str = ''
	-- local file = add_file('auto_jh')	
	-- local ini_file = add_file_user('auto_ai')
	-- if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		-- file = add_file_res('auto_jh')	
	-- end
	-- local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map	
	-- local check_list = nx_string(readIni(file,nx_string(cur_scene_id),'pos',''))
	-- local list_src = auto_split_string(check_list,'|')	
	-- local game_client = nx_value('game_client')	
	-- local scene = game_client:GetScene()
	-- local scene_obj_table = scene:GetSceneObjList()
	-- if array_list_src == nil then array_list_src = {} end	
	-- for i = 1, table.getn(scene_obj_table) do
		-- local scene_obj = scene_obj_table[i]
		-- if nx_is_valid(scene_obj) then
			-- if scene_obj:QueryProp('Type') == 4 and scene_obj:QueryProp('NpcType') == 14 and getDistance(scene_obj) <= 35 then	
				-- tmp_str = tmp_str .. ';' .. nx_string(scene_obj:QueryProp('ConfigID'))			
			-- end
		-- end
	-- end
	-- local tmp_arr = auto_split_string(tmp_str, ';')
	-- if tmp_arr[2] == nil or nx_string(tmp_arr[2]) == "" then
		-- showUtf8Text(AUTO_LOG_NOT_MON_AROUND)
		-- return
	-- end	
	-- local target = nx_value('game_select_obj')
	-- if nx_is_valid(target) then			
		-- for i =1, table.getn(list_src) do	
			-- local tmp_arr2 = auto_split_string(list_src[i], ';')	
			-- if string.find(nx_string(list_src[2]), nx_string(target:QueryProp('ConfigID')), 1, true) then
				-- showUtf8Text(AUTO_LOG_INV_LIS)
				-- return
			-- end	
		-- end
	-- end
	-- check_mon(tmp_str,list_src)
	-- loadGridAutoSkill(form)
	-- loadAutoHunterCombo(form)
	-- on_cbx_item_pick_selected(form)
end
function check_mon(tmp_str,list_src)
	local file = add_file('auto_jh')
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		file = add_file_res('auto_jh')	
	end	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map	
	local game_client = nx_value('game_client')	
	local scene = game_client:GetScene()	
	local x, y, z = getCurPos()		
	local tmp_arr = auto_split_string(tmp_str, ';')	
	listsrc = ''
	local check_list = nx_string(readIni(file,nx_string(cur_scene_id),'pos',''))
	local list_mon = auto_split_string(check_list,'|')
	local check_map =  auto_split_string(list_mon[1],';')
	if check_map[1] ~= cur_scene_id then		
		array_list_src = nil
	end
	if array_list_src == nil then array_list_src = {} end	
	local target = nx_value('game_select_obj')
	local npcname = ''	
	if nx_is_valid(target) then			
		npcname = nx_string(cur_scene_id)..';'..nx_string(target:QueryProp('ConfigID'))..';'.. nx_string(x) .. ',' .. nx_string(y) .. ',' .. nx_string(z)
		table.insert(list_mon,npcname)
		for k = 1, table.getn(list_mon) do
			if list_mon[k] ~= "" and list_mon[k] ~= '0' then
				listsrc = listsrc..list_mon[k]..'|'				
			end
		end	
		-- table.insert(array_list_src,npcname)
		-- for k = 1, table.getn(array_list_src) do
			-- if array_list_src[k] ~= "" then
				-- listsrc = listsrc..array_list_src[k]..'|'
			-- end
		-- end	
		writeIni(file,nx_string(cur_scene_id), "pos",listsrc)
	else
		showUtf8Text(AUTO_LOG_TARGET_NPC)
	end			
end
create_multitextbox = function(script_name, call_back_func_name, text, data_source, style)
	local multitextbox = nx_value('gui'):Create('MultiTextBox')
	multitextbox.DrawMode = 'Expand'
	multitextbox.LineColor = '0,0,0,0'
	multitextbox.Solid = false
	multitextbox.AutoSize = false
	multitextbox.Font = 'font_text_title1'
	multitextbox.LineTextAlign = 'Top'	
	multitextbox.SelectBarColor = '0,0,0,0'
	multitextbox.MouseInBarColor = '0,0,0,0'
	multitextbox.BackColor = '0,255,255,255'
	multitextbox.ViewRect = '12,12,180,150'
	multitextbox.Width = 180	
	multitextbox.HtmlText = utf8ToWstr('<a style="'..nx_string(style)..'"> ' .. nx_string(text) .. '</a>') -- 
	multitextbox.Height = multitextbox:GetContentHeight() + 5
	multitextbox.Left = 10
	multitextbox.Top = 0		
	multitextbox.DataSource = nx_string(data_source)
	nx_bind_script(multitextbox, nx_string(script_name))
	nx_callback(multitextbox, 'on_click_hyperlink', nx_string(call_back_func_name))
	return multitextbox
end


