require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
      
local THIS_FORM = 'auto_new\\form_auto_hk_st'
local FORM_HK = 'auto_new\\form_auto_hk'
inifile = nil
listsrc = ''
array_list_src = nil
record_str = ''
local jianghu_record_list = nil
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end
	
function on_main_form_open(form)	
	local ini_file = add_file_user('auto_ai')
	record_str = ''
	remove_record_list()
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map	
	local file = add_file('auto_jh')
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		file = add_file_res('auto_jh')	
	end
	local arr_config = wstrToUtf8(readIni(file,nx_string(cur_scene_id),'pos',''))
	jianghu_record_list = auto_split_string(arr_config,'|')
	on_load_jianghu_around_resource()
	--loadGridAutoSkill(form)
end 
function remove_record_list()
	if jianghu_record_list ~= nil then
		for i = 1, table.getn(jianghu_record_list) do
			if jianghu_record_list[i] ~= nil then jianghu_record_list[i] = nil end
		end
		jianghu_record_list = nil
	end
end

function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_hk_st")
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

on_load_jianghu_around_resource = function()
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return end
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then return end
	local form = nx_value('auto_new\\form_auto_hk_st')
	local gui = nx_value('gui')
	local grid = form.textgrid_pos_1
	while nx_is_valid(form) and form.Visible do
		local scene = game_client:GetScene()
		if nx_string(nx_value('loading')) == nx_string('false') and nx_string(nx_value('stage_main')) == nx_string('success') and nx_is_valid(scene) then
			local scene_id = get_cur_scene_id()
			local x, y, z = getCurPos()
			local tmp_str = ''
			local scene_obj_table = scene:GetSceneObjList()
			for i = 1, table.getn(scene_obj_table) do
				local scene_obj = scene_obj_table[i]
				if nx_is_valid(scene_obj) then
					if scene_obj:QueryProp('Type') == 4 and scene_obj:QueryProp('NpcType') == 14 and getDistance(scene_obj) <= 35 then
						tmp_str = tmp_str .. ';' .. nx_string(scene_obj:QueryProp('ConfigID'))
					end
				end
			end
			--------------------------------
			form.textgrid_pos_1:BeginUpdate()
			form.textgrid_pos_1:ClearRow()
			local tmp_arr = auto_split_string(tmp_str, ';')
			for i = 1, table.getn(tmp_arr) do
				local count = 0
				for i in string.gfind(tmp_str, nx_string(tmp_arr[i])) do
				   count = count + 1
				end
				if count ~= 0 then
					tmp_str = string.gsub(tmp_str, nx_string(tmp_arr[i]), '')
					local nRow = form.textgrid_pos_1:InsertRow(-1)
					local config = tmp_arr[i]
					local obj_name = gui.TextManager:GetText(nx_string(tmp_arr[i]))
					local check_count = create_multitextbox(THIS_FORM, 'on_click_hyper_move', count,nx_string(scene) .. ';' .. nx_string( x) .. ',' .. nx_string(y) .. ',' .. nx_string(z), 'HLChatItem1')
					form.textgrid_pos_1:SetGridText(nRow, 0, obj_name)
					--form.textgrid_pos_1:SetGridControl(nRow, 1, check_count)
					--nx_string(scene_id) ..';' .. nx_string(tmp_arr[i]).. ';' .. string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z) ..';'..wstrToUtf8(form.edt_name_pos.Text)
					local mul_text_box = create_multitextbox(THIS_FORM, 'on_btn_add_mon', 'Thêm',nx_string(tmp_arr[i]), 'HLStypelaba')
					form.textgrid_pos_1:SetGridControl(nRow, 1, mul_text_box)
				end
			end
			--------------------------------------------
			form.textgrid_pos_1:EndUpdate()
			form.textgrid_pos_1:ClearSelect()
			form.textgrid_pos_1:SelectRow(0)
			--------------------------------------------
		end
		nx_pause(1)
	end
	if nx_is_valid(form) and form.Visible then form:Close() end
end
function on_btn_add_mon(btn)
	local tmp_arr = auto_split_string(nx_string(btn.DataSource), ',')
	for i =1 ,table.getn(tmp_arr) do
		if string.find(nx_string(record_str), tmp_arr[i], 1, true) then
			showUtf8Text("Đã có trong danh sách")
			return
		end
	end
	record_str = record_str .. "," .. nx_string(btn.DataSource)
	on_load_jianghu_saved_item(record_str)
end
on_load_jianghu_saved_item = function(record_info_str)
	local script_name = 'auto_new\\form_auto_hk_st'
	local form = nx_value(script_name)
	if not nx_is_valid(form) or not form.Visible then return end
	local grid = form.textgrid_pos
	grid:BeginUpdate()
	grid:ClearRow()
	local gui = nx_value('gui')
	local record_arr = auto_split_string(nx_string(record_info_str), ',')
	for i = 1, table.getn(record_arr) do		
		local nRow = grid:InsertRow(-1)
		grid:SetGridText(nRow, 0, getText(nx_string(record_arr[i])))		
		local mul_text_box_del = create_multitextbox(THIS_FORM, 'on_btn_jianghu_saved_item_delete_click', auto_del, record_arr[i], 'HLStypelaba')
		grid:SetGridControl(nRow, 1, mul_text_box_del)		
	end
	--------------------------------------------
	grid:EndUpdate()
	grid:ClearSelect()
	grid:SelectRow(0)
	--------------------------------------------
end
function on_btn_jianghu_saved_item_delete_click(btn)
	local del_str = "," .. nx_string(btn.DataSource)
	record_str = string.gsub(record_str, del_str, '')
	on_load_jianghu_saved_item(record_str)
end
function on_btn_jianghu_saved_item_move_up_click(btn)
	local index = nx_number(btn.DataSource)
	if index == 1 then return end
	local record_arr = auto_split_string(nx_string(record_str), ',')
	local tmp = record_arr[index]
	record_arr[index] = record_arr[index - 1]
	record_arr[index - 1] = tmp
	local tmp_str = ""
	for i = 1, table.getn(record_arr) do
		tmp_str = tmp_str .. "," .. record_arr[i]
	end
	record_str = tmp_str
	on_load_jianghu_saved_item(record_str)
end
function on_btn_jianghu_saved_item_move_down_click(btn)
	local index = nx_number(btn.DataSource)
	local record_arr = auto_split_string(nx_string(record_str), ',')
	if index == table.getn(record_arr) then return end
	local tmp = record_arr[index]
	record_arr[index] = record_arr[index + 1]
	record_arr[index + 1] = tmp
	local tmp_str = ""
	for i = 1, table.getn(record_arr) do
		tmp_str = tmp_str ..  "," .. record_arr[i]
	end
	record_str = tmp_str
	on_load_jianghu_saved_item(record_str)
end


function btn_save_hk(btn)
	local form = btn.ParentForm
	local x, y, z = getCurPos()	
	local tmp_str = ''	
	local src = ''
	local list_mon = ""
	if record_str == "" then
		showUtf8Text('Add Data To JH',3)
		return
	end		
	local listsrc = ""
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	local x, y, z = getCurPos()
	local ini_file = add_file_user('auto_ai')
	local name = wstrToUtf8(form.edt_name_pos.Text)	
	src = '|'..cur_scene_id..';'..record_str..';'..x..','.. y..','.. z..';'..name
	save_jh_ini(src,cur_scene_id)
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
function save_jh_ini(src,cur_scene_id)
	if jianghu_record_list == nil then jianghu_record_list = {} end
	table.insert(jianghu_record_list, src)
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
		return 
	end	
	local listsrc = ''
	local file = add_file('auto_jh')	
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		file = add_file_res('auto_jh')	
	end	
	if not jianghu_record_list or table.getn(jianghu_record_list) == 0 then
		return
	end
	ini.FileName = file	
	local gui = nx_value("gui")
	for k = 1, table.getn(jianghu_record_list) do			
		if jianghu_record_list[k] ~= "" and jianghu_record_list[k] ~= '0' then
			listsrc = listsrc..jianghu_record_list[k]..'|'			
		end
	end			
	writeIniString(file,cur_scene_id, "pos",listsrc)
	local form_hk = nx_value(FORM_HK)
	nx_execute(FORM_HK,'loadGridAutoSkill',form_hk)
	nx_execute(FORM_HK,'loadAutoHunterCombo',form_hk)
	nx_execute(FORM_HK,'on_cbx_item_pick_selected',form_hk)
	util_show_form(THIS_FORM,false)
end
function btn_add_mon_hk1(btn)
	local form = btn.ParentForm
	local x, y, z = getCurPos()	
	local tmp_str = ''
	local file = add_file('auto_jh')	
	local ini_file = add_file_user('auto_ai')
	if nx_number(readIni(ini_file,AUTO_HK,"data_change","")) == 1 then
		file = add_file_res('auto_jh')	
	end
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map	
	local check_list = nx_string(readIni(file,nx_string(cur_scene_id),'pos',''))
	local list_src = auto_split_string(check_list,'|')	
	local game_client = nx_value('game_client')	
	local scene = game_client:GetScene()
	local scene_obj_table = scene:GetSceneObjList()
	if array_list_src == nil then array_list_src = {} end	
	for i = 1, table.getn(scene_obj_table) do
		local scene_obj = scene_obj_table[i]
		if nx_is_valid(scene_obj) then
			if scene_obj:QueryProp('Type') == 4 and scene_obj:QueryProp('NpcType') == 14 and getDistance(scene_obj) <= 35 then	
				tmp_str = tmp_str .. ';' .. nx_string(scene_obj:QueryProp('ConfigID'))			
			end
		end
	end
	local tmp_arr = auto_split_string(tmp_str, ';')
	if tmp_arr[2] == nil or nx_string(tmp_arr[2]) == "" then
		showUtf8Text(AUTO_LOG_NOT_MON_AROUND)
		return
	end	
	local target = nx_value('game_select_obj')
	if nx_is_valid(target) then			
		for i =1, table.getn(list_src) do	
			local tmp_arr2 = auto_split_string(list_src[i], ';')	
			if string.find(nx_string(list_src[2]), nx_string(target:QueryProp('ConfigID')), 1, true) then
				showUtf8Text(AUTO_LOG_INV_LIS)
				return
			end	
		end
	end
	check_mon(tmp_str,list_src)
	loadGridAutoSkill(form)
	loadAutoHunterCombo(form)
	on_cbx_item_pick_selected(form)
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


