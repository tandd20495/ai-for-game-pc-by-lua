require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_tt'
inifile = nil
listsrc = ''
array_list_src = nil
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end

	
function on_main_form_open(form)	
	local ini_file = add_file_user('auto_ai')	
	updateBtnAuto()	
	load_sh(form)
	loadAutoHunterCombo(form)	
	local change_type = nx_string(readIni(ini_file,nx_string(AUTO_CROP), "change_type", ""))
	if change_type == nx_string('1') then
		form.checked_crop_change_type.Checked = true
		loadGridAutoSkill_full(form)	
	else
		loadAutoItemCombo(form)
		loadGridAutoSkill(form)
		form.checked_crop_change_type.Checked = false
	end
	if nx_string(readIni(ini_file,nx_string(AUTO_CROP), "pos_active", "")) == "" or nx_string(readIni(ini_file,nx_string(AUTO_CROP), "pos_active", "")) == nx_string('0') then
		loadAutoItemCombo(form)
	end
	on_load_around_resource()
	click_mouse_fast = 0
end 
on_load_around_resource = function()
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return end
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then return end
	local form = nx_value('auto_new\\form_auto_tt')
	local gui = nx_value('gui')
	while nx_is_valid(form) and form.Visible do
		local scene = game_client:GetScene()
		if nx_string(nx_value('loading')) == nx_string('false') and nx_string(nx_value('stage_main')) == nx_string('success') and nx_is_valid(scene) then
			local scene_id = get_cur_scene_id()						
			local target = nx_value('game_select_obj')
			if nx_is_valid(target) then				
				if target:QueryProp('Type') == 4 and getDistance(target) <= 20 then
					local text_config = 'Target : '..getUtf8Text(nx_string(target:QueryProp('ConfigID')))
					form.lbl_target.Text = utf8ToWstr(text_config)
				end
			end					
		end
		nx_pause(1)
	end
	if nx_is_valid(form) and form.Visible then form:Close() end
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
array_config = {}
city_select = ''
function loadAutoHunterCombo(form)
	form.cbx_input_map_pick.DropListBox:ClearString()
	form.cbx_input_map_pick.InputEdit.Text = ""	
	local file = add_file('auto_tt')
	local countini = nx_execute('auto_new\\autocack','sectionCount',file)
	array_config = {}
	local countName = ""
	if countini > 0 then
		for j = 1, countini do
			countName = getSectionName(file,j)
			for k = 1, table.getn(countName) do				
				form.cbx_input_map_pick.DropListBox:AddString(util_text(countName[k]))
				table.insert(array_config,countName)
			end
		end
	end	
	local index_cbx = 0
	local ini_file = add_file_user('auto_ai')
	local index = nx_number(readIni(ini_file,nx_string(AUTO_CROP), "index", ""))	
	if index > nx_number(0) then
		index_cbx = index - 1
	end	
	
	form.cbx_input_map_pick.DropListBox.SelectIndex = index_cbx
	form.cbx_input_map_pick.InputEdit.Text = form.cbx_input_map_pick.DropListBox:GetString(index_cbx)	
end
array_item = {}
array_config_item = {}
array_item_crop = {}
array_item_config = {}
function loadAutoItemCombo(form)
	form.cbx_input_crop_item.DropListBox:ClearString()
	form.cbx_input_crop_item.InputEdit.Text = ""	
	local file = add_file('auto_tt')
	local inifile = add_file_user('auto_ai')	
	local countini = nx_execute('auto_new\\autocack','sectionCount',file)	
	local active = wstrToUtf8(readIni(inifile,AUTO_CROP,'active',''))
	if array_config_item ~= nil then array_config_item = nil end
	if array_config_item == nil then array_config_item = {} end
	if array_item ~= nil then array_item = nil end
	if array_item == nil then array_item = {} end
	if array_item_crop ~= nil then array_item_crop = nil end
	if array_item_crop == nil then array_item_crop = {} end	
	if array_item_config ~= nil then array_item_config = nil end
	if array_item_config == nil then array_item_config = {} end
	local countName = ""
	local res = {}	
	local check = {}
	if countini > 0 then
		for j = 1, countini do
			countName = getSectionName(file,j)
			for k = 1, table.getn(countName) do				
				local item_pos = wstrToUtf8(readIni(file,nx_string(countName[k]), "pos", ""))
				local split_pos = auto_split_string(item_pos,'|')
				for i = 1, table.getn(split_pos) do					
					local split_item  = auto_split_string(split_pos[i],';')	
					if nx_string(active) == nx_string(split_item[1]) then
						--table.insert(array_config_item,split_item[2])	
						table.insert(array_item_crop,split_item[2])	
						table.insert(array_item,split_pos[i])
					end
				end				
			end
		end
	end	
	if table.getn(array_item_crop) == 0 then return end
	for _,v in ipairs(array_item_crop) do
	   if (not check[v]) then
		   res[#res+1] = v 
		   check[v] = true
	   end
	end
	for z = 1,table.getn(res) do
		form.cbx_input_crop_item.DropListBox:AddString(util_text(res[z]))	
		table.insert(array_item_config,res[z])	
	end	
	local index_cbx = 0
	local get_string = 0
	local ini_file = add_file_user('auto_ai')
	local index = nx_number(readIni(ini_file,nx_string(AUTO_CROP), "index_config", ""))
	if index > nx_number(0) then
		index_cbx = index - 1
	end	
	nx_pause(0.1)
	form.cbx_input_crop_item.DropListBox.SelectIndex = index_cbx
	form.cbx_input_crop_item.InputEdit.Text = form.cbx_input_crop_item.DropListBox:GetString(index_cbx)
	npc_name = form.cbx_input_crop_item.InputEdit.Text		
end
function cbtn_checked_crop_change_type(cbtn) 
	local form = cbtn.ParentForm
	local inifile = add_file_user('auto_ai')
	local check = 0
	if cbtn.Checked == true then
		check = 1
	end
	writeIni(inifile,nx_string(AUTO_CROP), "change_type", nx_string(check))
	local change_type = nx_string(readIni(inifile,nx_string(AUTO_CROP), "change_type", ""))
	if change_type == nx_string('1') then		
		loadGridAutoSkill_full(form)
	else
		loadAutoItemCombo(form)
	end		
end 
function on_cbx_item_load_pick_selected(cbx)
	local form = cbx.ParentForm
	npc_name = form.cbx_input_crop_item.InputEdit.Text	
	local array_string = ''	
	local file = add_file_user('auto_ai')	
	local index = form.cbx_input_crop_item.DropListBox.SelectIndex	
	if index < table.getn(array_item_config) then		
		array_string = array_item_config[index + 1]
		writeIni(file,AUTO_CROP,'index_config',index + 1)
		writeIni(file,AUTO_CROP,'active_config',array_string)	
	end	
	local pos_active = save_config_ai_file()	
	writeIni(file,AUTO_CROP,'pos_active',pos_active)
	loadGridAutoSkill(form)
end
save_config_ai_file = function()
	local pos_active = ''	
	local inifile = add_file_user('auto_ai')	
	local active = wstrToUtf8(readIni(inifile,AUTO_CROP,'active_config',''))
	for i = 1,table.getn(array_item) do
		local get_array = auto_split_string(array_item[i],';')		
		if get_array[2] == active then
			pos_active = pos_active..array_item[i]..'|'
		end
	end
	return pos_active
end
function on_cbx_map_pick_selected(cbx)
	local form = cbx.ParentForm
	form.cbx_input_crop_item.DropListBox:ClearString()
	form.cbx_input_crop_item.InputEdit.Text = ""
	local file = add_file_user('auto_ai')
	local array_string = ''
	local index = form.cbx_input_map_pick.DropListBox.SelectIndex	
	if index < table.getn(array_config) then		
		array_string = array_config[index + 1][1]	
		writeIni(file,AUTO_CROP,'index',index + 1)
		writeIni(file,AUTO_CROP,'active',array_string)
	end	
	local change_type = nx_string(readIni(file,nx_string(AUTO_CROP), "change_type", ""))
	if change_type == nx_string('1') then		
		loadGridAutoSkill_full(form)
	else
		loadAutoItemCombo(form)
	end		
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
	local file = add_file('auto_tt')
	ini.FileName = file
	local inifile = add_file_user('auto_ai')	
	local active = wstrToUtf8(readIni(inifile,AUTO_CROP,'active',''))
	local name = npc_name
	if name == nil then return end
	if ini:LoadFromFile() then	
		if ini:FindSection(active) then		
			local pos_table = nx_string(readIni(file,nx_string(active),'pos',''))			
			local count_pos = auto_split_string(nx_string(pos_table),'|')
			array_list_src = count_pos
			listsrc = pos_table			
			if nx_number(table.getn(count_pos)) > 0 then				
				for i = 1, table.getn(count_pos) do
					local split_item = auto_split_string(nx_string(count_pos[i]),';')
					local scene = split_item[1]					
					local config_id = split_item[2]
					local pos = split_item[3]		
					local pos_split = auto_split_string(nx_string(pos),',')
					local x,y,z = nx_string(pos_split[1]),nx_string(pos_split[2]),nx_string(pos_split[3])					
					if x ~= nil and config_id ~= nil and wstrToUtf8(name) == getUtf8Text(config_id) then
						local btn_del = create_multitextbox(THIS_FORM, 'on_click_btn_del',auto_del,count_pos[i], 'HLStypebargaining')
						local btn_up = create_multitextbox(THIS_FORM, 'on_click_up',auto_up,nx_string(i), 'HLStypelaba')	
						local btn_down = create_multitextbox(THIS_FORM, 'on_click_down',auto_down,nx_string(i), 'HLStypelaba')	
						local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move', wstrToUtf8(util_text(config_id)),nx_string(scene) .. ';' .. string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z), 'HLChatItem1')		
						gridAndFunc(grid,multitextbox,btn_up,btn_down,btn_del)	
					end					
				end				
			end
		end		
	end
end
function loadGridAutoSkill_full(form)
	local gui = nx_value("gui")
	local grid = form.textgrid_pos	
	grid:ClearRow()
	grid:ClearSelect()
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local file = add_file('auto_tt')
	ini.FileName = file
	local inifile = add_file_user('auto_ai')	
	local active = wstrToUtf8(readIni(inifile,AUTO_CROP,'active',''))
	local name = npc_name
	if name == nil then return end
	if ini:LoadFromFile() then	
		if ini:FindSection(active) then		
			local pos_table = nx_string(readIni(file,nx_string(active),'pos',''))			
			local count_pos = auto_split_string(nx_string(pos_table),'|')
			array_list_src = count_pos
			listsrc = pos_table			
			if nx_number(table.getn(count_pos)) > 0 then				
				for i = 1, table.getn(count_pos) do
					local split_item = auto_split_string(nx_string(count_pos[i]),';')
					local scene = split_item[1]					
					local config_id = split_item[2]
					local pos = split_item[3]		
					local pos_split = auto_split_string(nx_string(pos),',')
					local x,y,z = nx_string(pos_split[1]),nx_string(pos_split[2]),nx_string(pos_split[3])					
					if x ~= nil and config_id ~= nil then
						local btn_del = create_multitextbox(THIS_FORM, 'on_click_btn_del',auto_del,count_pos[i], 'HLStypebargaining')
						local btn_up = create_multitextbox(THIS_FORM, 'on_click_up',auto_up,nx_string(i), 'HLStypelaba')	
						local btn_down = create_multitextbox(THIS_FORM, 'on_click_down',auto_down,nx_string(i), 'HLStypelaba')	
						local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move', wstrToUtf8(util_text(config_id)),nx_string(scene) .. ';' .. string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z), 'HLChatItem1')		
						gridAndFunc(grid,multitextbox,btn_up,btn_down,btn_del)	
					end					
				end				
			end
		end		
	end
end
list_sh = {'sh_ds','sh_kg','sh_qf','sh_ys','sh_yf'}
npc_type = 0
npc_id = ''
npc_name = ''
function load_sh(form)
	form.cbx_input_sh.DropListBox:ClearString()
	for i=1,table.getn(list_sh) do
		if nx_execute("form_stage_main\\form_life\\form_job_main_new", "find_life_job", list_sh[i]) then
			form.cbx_input_sh.DropListBox:AddString(util_text(list_sh[i]))
		end
	end
	form.cbx_input_sh.DropListBox.SelectIndex = 0
	form.cbx_input_sh.InputEdit.Text = form.cbx_input_sh.DropListBox:GetString(0)
end
get_double_string = function(test)
	if not test then return end
	local hash = {}
	for _,v in ipairs(test) do
		hash[v] = true
	end
	local res = {}
	for k,_ in pairs(hash) do
		res[#res+1] = k
	end
	return res
end
function on_cbx_input_sh_selected(cbx)
	local form = cbx.ParentForm
	local scene_creator = nx_value("SceneCreator")
	local map_query = nx_value("MapQuery")
	local sh_name = wstrToUtf8(form.cbx_input_sh.InputEdit.Text)	
	if sh_name == wstrToUtf8(util_text('sh_ds')) then
		npc_type = 145	
	elseif 	sh_name == wstrToUtf8(util_text('sh_kg')) then
		npc_type = 142
	elseif 	sh_name == wstrToUtf8(util_text('sh_qf')) then
		npc_type = 143	
	elseif 	sh_name == wstrToUtf8(util_text('sh_ys')) then
		npc_type = 144
	elseif 	sh_name == wstrToUtf8(util_text('sh_yf')) then
		npc_type = 141
	end	
	local npcs = scene_creator:GetNpcConfigIDByNpcType(map_query:GetCurrentScene(), npc_type, true)
	if nx_number(table.getn(npcs)) > 0 then
		form.cbx_input_item_pick.DropListBox:ClearString()
		for i = 1 , table.getn(npcs) do
			form.cbx_input_item_pick.DropListBox:AddString(util_text(npcs[i]))
		end
		form.cbx_input_item_pick.DropListBox.SelectIndex = 0
		form.cbx_input_item_pick.InputEdit.Text = form.cbx_input_item_pick.DropListBox:GetString(0)
	else
		showUtf8Text('Không có tài nguyên trong map này')
	end
end
function on_cbx_item_pick_selected(cbx)
	local form = cbx.ParentForm
	local sh_name = wstrToUtf8(form.cbx_input_item_pick.InputEdit.Text)
	local scene_creator = nx_value("SceneCreator")
	local map_query = nx_value("MapQuery")		
	local npcs = scene_creator:GetNpcConfigIDByNpcType(map_query:GetCurrentScene(), npc_type, true)
	for i = 1 , table.getn(npcs) do
		if sh_name == wstrToUtf8(util_text(npcs[i])) then
			npc_id = nx_string(npcs[i])
		end
	end
end
function getHighPosY(x, z)
    local scene = nx_value("game_scene")
    if not nx_is_valid(scene) then
        return nil
    end
    local terrain = scene.terrain
    if not nx_is_valid(terrain) then
        return nil
    end   
    local posY = terrain:GetPosiY(nx_int(x), nx_int(z))
    return posY
end
function auto_load_npc(npctype,npcid)
	local scene_creator = nx_value('SceneCreator')
	local map_query = nx_value('MapQuery')
	local list_auto = {}
	local listx = {}
	local listy = {}
	local listz = {}		
	local npcs = scene_creator:GetNpcConfigIDByNpcType(map_query:GetCurrentScene(), npctype, true)
	for k = 1, table.getn(npcs) do			
		if nx_string(npcs[k]) == nx_string(npcid) then		
			local res = scene_creator:GetNpcPosition(map_query:GetCurrentScene(), nx_string(npcid))
			if table.getn(res) >= 3 then		
				local x,y,z = 0,0,0
				local count = 1
				for n = 1, table.getn(res) do			
					if count >= 3 then					
						if count == 3 then z = res[n] end
						table.insert(listx,x)
						table.insert(listy,y)
						table.insert(listz,z)
						list_auto = {xx = listx,yy = listy,zz = listz}
						count = 1
					else
						if count == 1 then x = res[n] end
						if count == 2 then y = res[n] end
						if count == 3 then z = res[n] end				
						count = count + 1
					end				
				end
			end
		end	
	end
	return list_auto
end
function btn_add_mon_hk(btn)	
	local form = btn.ParentForm
	local file = add_file('auto_tt')	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	local tmp_str = ''
	local check_list = nx_string(readIni(file,nx_string(cur_scene_id),'pos',''))
	local list_src = auto_split_string(check_list,'|')
	local game_client = nx_value('game_client')	
	local scene = game_client:GetScene()
	local scene_obj_table = scene:GetSceneObjList()
	local check_npc = false
	local list_mon = ''
	local client_player = game_client:GetPlayer()	
	local x, y, z = getCurPos()
	local tmp_str1 = nx_string(string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z))
	if string.find(nx_string(listsrc), nx_string(tmp_str1), 1, true)  then
		showUtf8Text("Đã có trong danh sách")
		return
	end
	for i = 1, table.getn(scene_obj_table) do
		local scene_obj = scene_obj_table[i]
		if nx_is_valid(scene_obj) then
			if scene_obj:QueryProp('Type') == 4 and scene_obj:FindProp('GatherRange') then
				local conf_id = nx_string(scene_obj:QueryProp('ConfigID'))
				local d = scene_obj:QueryProp('GatherRange')
				if not ((scene_obj:FindProp('GatherPara1') and scene_obj:QueryProp('GatherPara1') == 'sh_yf') or (scene_obj:FindProp('GatherPara1') and scene_obj:QueryProp('GatherPara1') == 'sh_qf')) or getDistance(scene_obj) < d then
					if not scene_obj:FindProp('GatherPara1') or client_player:FindRecordRow('job_rec', 0, nx_string(scene_obj:QueryProp('GatherPara1')), 0) >= 0 then
						tmp_str = tmp_str .. ';' .. conf_id
						check_npc = true
					end
				end
			end
		end
	end	
	local check_map =  auto_split_string(list_src[1],';')	
	if check_map[1] ~= cur_scene_id then		
		array_list_src = nil
	end
	if array_list_src == nil then array_list_src = {} end
	if check_npc then		
		check_mon(tmp_str)
	end	
	if check_npc == false then
		if npc_id == '' or npc_type == 0 then return end
		local load_npc = auto_load_npc(nx_number(npc_type),nx_string(npc_id))
		if 	load_npc.zz == nil then showUtf8Text('Select Item') return end
		listsrc = ''
		list_mon = ''	
		for i = 1, table.getn(load_npc.zz) do
			local x1,y1,z1 = load_npc.xx[i],load_npc.yy[i],load_npc.zz[i]
			list_mon = nx_string(cur_scene_id) .. ';' ..  nx_string(npc_id)..';'.. string.format('%.3f', x1) .. ',' .. string.format('%.3f', y1) .. ',' .. string.format('%.3f', z1)	
			table.insert(array_list_src,list_mon)
		end
		for k = 1, table.getn(array_list_src) do
			if array_list_src[k] ~= "" then
				listsrc = listsrc..array_list_src[k]..'|'
			end
		end
		writeIni(file,nx_string(cur_scene_id), "pos",listsrc)
	end	
	loadAutoHunterCombo(form)
	local file_ai = add_file_user('auto_ai')
	local change_type = nx_string(readIni(file_ai,nx_string(AUTO_CROP), "change_type", ""))
	if change_type == nx_string('1') then		
		loadGridAutoSkill_full(form)
	else
		loadGridAutoSkill(form)
	end		
	on_cbx_map_pick_selected(form)
end
function check_mon(tmp_str)
	local file = add_file('auto_tt')	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map	
	local game_client = nx_value('game_client')	
	local scene = game_client:GetScene()	
	local x, y, z = getCurPos()		
	local tmp_arr = auto_split_string(tmp_str, ';')	
	listsrc = ''	
	if array_list_src == nil then array_list_src = {} end	
	local target = nx_value('game_select_obj')
	local npcname = ''		
	if nx_is_valid(target) then		
		npcname = nx_string(cur_scene_id)..';'..nx_string(target:QueryProp('ConfigID'))..';'.. string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z)
		table.insert(array_list_src,npcname)
		for k = 1, table.getn(array_list_src) do
			if array_list_src[k] ~= "" and array_list_src[k] ~= '0' then
				listsrc = listsrc..array_list_src[k]..'|'				
			end
		end	
		writeIni(file,nx_string(cur_scene_id), "pos",listsrc)
	else
		showUtf8Text('Hãy target vào nguyên liệu muốn thu thập')
	end	
end
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_tt")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end
function check_dir_and_file(file)	
	if not nx_function('ext_is_file_exist', file) then
		return true
	end
	return false
end
function btn_add_start(btn)
	local form = btn.ParentForm	
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end	
	ini.FileName = add_file_user('auto_ai')		
	if click_mouse_fast == nil then click_mouse_fast = 0 end
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()	
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ga_state_only') then
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_ga','',false)		
		-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_ga_state_only')
		-- nx_pause(0.2)
		-- if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ga_state_only') then			
			-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_ga_state_only')
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
		if ini:LoadFromFile() then
			if nx_string(ini:ReadString(nx_string(AUTO_AI), "tt", "")) == nx_string("true")	then
				local file = add_file('auto_tt')
				if (nx_string(ini:ReadString(nx_string(AUTO_CROP), "change_type", "")) ~= nx_string('1') and nx_string(ini:ReadString(nx_string(AUTO_CROP), "pos_active", "")) == "") or (nx_string(ini:ReadString(nx_string(AUTO_CROP), "change_type", "")) ~= nx_string('1') and nx_string(ini:ReadString(nx_string(AUTO_CROP), "pos_active", "")) == nx_string('0')) then
					showUtf8Text(AUTO_LOG_CROP_CANT_SETTING_RESOURCE)
					return 
				end
				if nx_string(ini:ReadString(nx_string(AUTO_CROP), "active", "")) == "" or check_dir_and_file(file) then
					showUtf8Text(AUTO_LOG_CROP_CANT_SETTING)
					return 
				end
			end
		end	
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_ga_only')	
		nx_pause(1)			
	end	
	updateBtnAuto()
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_tt")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ga_state_only') then
		form.btn_add_start.Text = nx_widestr('Stop')
	else
		form.btn_add_start.Text = nx_widestr('Start')		
	end
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_tt")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Start')	
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_tt")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Stop')	
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


function gridAndFunc(grid,mTextName,btn_up,btn_down,btn_del)
	local form = nx_value(THIS_FORM)
	local row = grid:InsertRow(-1)
	grid:SetGridControl(row, 0, mTextName)
	grid:SetGridControl(row, 1, btn_up)
	grid:SetGridControl(row, 2, btn_down)
	grid:SetGridControl(row, 3, btn_del)		
end
on_click_btn_del = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	local file = add_file('auto_tt')
	ini.FileName = add_file('auto_tt')
	local str = ""
	local data_item = ''
	local inifile = add_file_user('auto_ai')	
	local active = wstrToUtf8(readIni(inifile,AUTO_CROP,'active',''))
	if not ini:LoadFromFile()or not ini:FindSection(nx_string(active)) then return end
	local str = wstrToUtf8(readIni(file,nx_string(active), 'pos', ''))
	local list =  auto_split_string(nx_string(str),'|')
	if table.getn(array_list_src) == 1 then		
		if ini:LoadFromFile() then	
			if ini:FindSection(active) then
				ini:DeleteSection(active)
				ini:SaveToFile()
				local change_type = nx_string(readIni(inifile,nx_string(AUTO_CROP), "change_type", ""))
				if change_type == nx_string('1') then		
					loadGridAutoSkill_full(form)
				else
					loadGridAutoSkill(form)
				end				
				return
			end
		end
	end	
	local data = btn.DataSource
	for i =1, table.getn(list) do
		if list[i] == data then
			table.remove(list, i)
		end
	end
	for j = 1, table.getn(list) do		
		data_item = data_item..'|'..list[j]
	end
	ini:WriteString(nx_string(active), "pos", data_item)
	ini:SaveToFile()	
	local change_type = nx_string(readIni(inifile,nx_string(AUTO_CROP), "change_type", ""))
	if change_type == nx_string('1') then		
		loadGridAutoSkill_full(form)
	else
		loadGridAutoSkill(form)
	end
end
function on_click_up(btn)
	local form = btn.ParentForm
	local index = nx_number(btn.DataSource)
	local file = add_file('auto_tt')
	local inifile = add_file_user('auto_ai')	
	local cur_scene_id = wstrToUtf8(readIni(inifile,AUTO_CROP,'active',''))
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
	writeIni(file,nx_string(cur_scene_id), "pos",listsrc)
	local change_type = nx_string(readIni(inifile,nx_string(AUTO_CROP), "change_type", ""))
	if change_type == nx_string('1') then		
		loadGridAutoSkill_full(form)
	else
		loadGridAutoSkill(form)
	end
end
function on_click_down(btn)
	local form = btn.ParentForm
	local file = add_file('auto_tt')
	local inifile = add_file_user('auto_ai')	
	local cur_scene_id = wstrToUtf8(readIni(inifile,AUTO_CROP,'active',''))
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
	writeIni(file,nx_string(cur_scene_id), "pos",listsrc)
	local change_type = nx_string(readIni(inifile,nx_string(AUTO_CROP), "change_type", ""))
	if change_type == nx_string('1') then		
		loadGridAutoSkill_full(form)
	else
		loadGridAutoSkill(form)
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


