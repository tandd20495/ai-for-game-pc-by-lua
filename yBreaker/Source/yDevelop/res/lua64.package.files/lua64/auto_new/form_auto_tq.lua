require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_tq'
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
	form.cbx_input_sh.config = ''
	local inifile = add_file('auto_tq')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	local clone = wstrToUtf8(readIni(inifile,'Setting', "clone", ''))
	local cap = wstrToUtf8(readIni(inifile,'Setting', "caption", ''))
	local bug_lam = wstrToUtf8(readIni(inifile,'Setting', "bug_lam", ''))
	local ruong = wstrToUtf8(readIni(inifile,'Setting', "nhat_ruong", ''))
	local fight_pos = wstrToUtf8(readIni(inifile,'Setting', "fight_pos", ''))
	if fight_pos == nx_string('true') then
		form.check_box_10.Checked = true
	end
	if clone == nx_string('true') then
		form.check_box_2.Checked = true
	end
	if cap == nx_string('true') then
		form.check_box_1.Checked = true
	end
	if bug_lam == nx_string('true') then
		form.check_box_3.Checked = true
	end
	if ruong == nx_string('true') then
		form.check_box_4.Checked = true
	end
	-- ini.FileName = nx_string(inifile) 
	-- if ini:LoadFromFile() then
	-- else		
		-- writeIni(inifile,'Setting', "list_title", util_text('ui_tiguan_name_7'))
	-- end	
	loadGridAutoSkill(form)
	-- load_qt_list(form)
	load_tiguan_one(form)	
	click_mouse_fast = 0
end 
function on_right_grid(self)
  local form = self.ParentForm
  if not nx_find_custom(self,'UniqueID') then nx_set_custom(self,'UniqueID','1') end
  local gui = nx_value('gui')
  local game_hand = gui.GameHand
  local para1 = game_hand.Para1
  local para2 = game_hand.Para2
  local ini = nx_create('IniDocument')
  if not nx_is_valid(ini) then
	return 
  end 
  local no_item = game_hand:IsEmpty() or game_hand.Type ~= "viewitem" or (para1 ~= "121" and para1 ~= "2" and para1 ~= "123" and para1 ~= "125")	
	if no_item then return nil end	
    local item = nx_execute('goods_grid', 'get_view_item', game_hand.Para1, game_hand.Para2)
	if nx_is_valid(item) then 	
		local str = nil
		ini.FileName = add_file('auto_tq')		
		if ini:LoadFromFile()then
			if ini:FindSection(nx_string('Setting')) then
				str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
			else
				os.remove(add_file('auto_tq'))
			end
		end	
		if string.find(nx_string(str),getUtf8Text(item:QueryProp('ConfigID')),1,true) then
			showUtf8Text('Item already exists')
			return
		end
		str = str .. getUtf8Text(item:QueryProp('ConfigID')) .. ","	
		ini:WriteString(nx_string('Setting'), "pick_item", str)
		ini:SaveToFile()
		nx_destroy(ini)				
	end 
	--load_qt_list(form)
	game_hand:ClearHand()
end
function load_qt_list(form)
	local grid = form.textgrid_pos_2
	local file  = add_file('auto_tq')	
	local gui = nx_value('gui') 
	grid:ClearRow()
	grid:ClearSelect()	
	local list_pick = wstrToUtf8(readIni(file,'Setting','pick_item',''))
	if list_pick == nx_string('0') then return end
	local array_pick = auto_split_string(list_pick,',')
	for i = 1, table.getn(array_pick) do
		local npc_name = utf8ToWstr(array_pick[i])
		local multitextbox = create_multitextbox(THIS_FORM, 'on_right_grid', wstrToUtf8(npc_name), 'HLChatItem1')
		local btn_del = create_multitextbox(THIS_FORM, 'on_btn_remove_npc_add',auto_del,array_pick[i], 'HLStypebargaining')	
		gridAndFunc(grid,multitextbox,btn_del)
	end	
end

btn_add_item = function(btn)
	local f = btn.ParentForm	
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
		return 
	end
	local str = nil
	ini.FileName = add_file('auto_tq')
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string('Setting')) then
			str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
		else
			os.remove(add_file('auto_tq'))
		end
	end	
	if string.find(nx_string(str),wstrToUtf8(f.edt_item_add.Text),1,true) then
		showUtf8Text('Item already exists')
		return
	end
	str = str .. wstrToUtf8(f.edt_item_add.Text) .. ","	
	ini:WriteString(nx_string('Setting'), "pick_item", str)
	ini:SaveToFile()
	nx_destroy(ini)	
	f.edt_item_add.Text = ""
	-- load_qt_list(f)	
end
function on_cbtn_auto_box_1(cbtn)
	local form = cbtn.ParentForm
	local inifile = add_file('auto_tq')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	if form.check_box_1.Checked then
		form.check_box_2.Checked = false
		writeIni(inifile,'Setting', "caption", 'true')
		writeIni(inifile,'Setting', "clone", 'false')
	end
end
function on_cbtn_auto_box_3(cbtn)
	local form = cbtn.ParentForm
	local inifile = add_file('auto_tq')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	if form.check_box_3.Checked then
		writeIni(inifile,nx_string('Setting'), "bug_lam", nx_string(form.check_box_3.Checked))
	else		
		writeIni(inifile,nx_string('Setting'), "bug_lam", nx_string(form.check_box_3.Checked))
	end
end
function on_cbtn_auto_box_4(cbtn)
	local form = cbtn.ParentForm
	local inifile = add_file('auto_tq')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	if form.check_box_4.Checked then
		writeIni(inifile,nx_string('Setting'), "nhat_ruong", nx_string(form.check_box_4.Checked))	
	else		
		writeIni(inifile,nx_string('Setting'), "nhat_ruong", nx_string(form.check_box_4.Checked))	
	end
end
function on_cbtn_auto_box_10(cbtn)
	local form = cbtn.ParentForm
	local inifile = add_file('auto_tq')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	if form.check_box_10.Checked then
		writeIni(inifile,nx_string('Setting'), "fight_pos", nx_string(form.check_box_10.Checked))	
	else		
		writeIni(inifile,nx_string('Setting'), "fight_pos", nx_string(form.check_box_10.Checked))	
	end
end
function on_cbtn_auto_box_2(cbtn)
	local form = cbtn.ParentForm
	local inifile = add_file('auto_tq')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	if form.check_box_2.Checked then
		writeIni(inifile,'Setting', "caption", 'false')
		writeIni(inifile,'Setting', "clone", 'true')
		form.check_box_1.Checked = false		
	end
end
function btn_add_pick(btn)
	local form = btn.ParentForm
	util_auto_show_hide_form('auto_new\\form_auto_pick')
end
function on_ipt_search_key_changed(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end
	if nx_ws_length(self.Text) < 3 then
		form.combobox_itemname.DropListBox:ClearString()
		return
	end	
	if nx_ws_equal(self.Text, util_text('ui_trade_search_key')) then
		return
	end
	local gui = nx_value('gui')
	if not nx_is_valid(gui) then
		return
	end
	local ItemQuery = nx_value('ItemQuery')
	if not nx_is_valid(ItemQuery) then
		return
	end
	
	form.combobox_itemname.DropListBox:ClearString()
	local search_table = ItemQuery:FindItemsByName(self.Text)
	market_item_table = {}
	for _, item_config in pairs(search_table) do
		local bExist = ItemQuery:FindItemByConfigID(item_config)
		if bExist then
			if gui.TextManager:IsIDName(item_config) then
				form.combobox_itemname.DropListBox:AddString(util_text(item_config))
				table.insert(market_item_table, item_config)
			end
		end
	end
	if not form.combobox_itemname.DroppedDown then
		form.combobox_itemname.DroppedDown = true
	end
end
function load_tiguan_one(form)
	form.cbx_input_sh.DropListBox:ClearString()
	local guan_ui_ini = nx_execute("util_functions", "get_ini", "ini\\ui\\tiguan\\changguan.ini")
	local guan_share_ini = nx_execute("util_functions", "get_ini", "share\\War\\tiguan.ini")
	local section_count = guan_ui_ini:GetSectionCount()
	market_item_table = {}
	for k = section_count - 1 , 0, -1 do
		local guan_id = guan_ui_ini:GetSectionByIndex(k)
		local sec_1 = guan_ui_ini:FindSectionIndex(nx_string(guan_id))
		local sec_2 = guan_share_ini:FindSectionIndex(nx_string(guan_id))			
		if nx_number(sec_1) >= 0 and nx_number(sec_2) >= 0 then				
			local isopen = guan_ui_ini:ReadString(sec_1, "IsOpen", 0)
			if nx_number(isopen) ~= 0 then				
				local name_id = nx_string(guan_ui_ini:ReadString(sec_1, "Name", ""))
				form.cbx_input_sh.DropListBox:AddString(util_text(name_id))
				table.insert(market_item_table, name_id)	
			end
		end
	end	
	form.cbx_input_sh.DropListBox.SelectIndex = 0
	form.cbx_input_sh.InputEdit.Text = form.cbx_input_sh.DropListBox:GetString(0)
end
function on_cbx_input_sh_selected(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end	
	form.cbx_input_sh.config = ''
	local index = form.cbx_input_sh.DropListBox.SelectIndex
	
	if index < table.getn(market_item_table) then
		form.cbx_input_sh.config = market_item_table[index + 1]		
	end	
end
on_btn_remove_npc_add = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	ini.FileName = add_file('auto_tq')
	local str = ""
	if not ini:LoadFromFile()or not ini:FindSection(nx_string('Setting')) then return end
	str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
	str = string.gsub(str, nx_string(btn.DataSource) .. ",", "")
	ini:WriteString(nx_string('Setting'), "pick_item", str)
	ini:SaveToFile()
	-- load_qt_list(form)
end
function btn_add_mon_hk(btn)	
	local form = btn.ParentForm
	local file = add_file('auto_tq')	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	local tmp_str = ''
	local check_list = nx_string(readIni(file,nx_string('Setting'),'list_title',''))
	local list_src = form.cbx_input_sh.InputEdit.Text
	local game_client = nx_value('game_client')	
	local scene = game_client:GetScene()
	local scene_obj_table = scene:GetSceneObjList()
	local check_npc = false
	listsrc = ''
	local client_player = game_client:GetPlayer()
	if array_list_src == nil then array_list_src = {} end
	list_mon = ''		
	list_mon = form.cbx_input_sh.config--wstrToUtf8(form.cbx_input_sh.InputEdit.Text)
	--if string.find(check_list, nx_string(form.cbx_input_sh.InputEdit.Text), 1, true)  then
	if string.find(check_list, nx_string(form.cbx_input_sh.InputEdit.Text), 1, true)  then
		showUtf8Text("Đã có trong danh sách")
		return
	end
	table.insert(array_list_src,list_mon)
	for k = 1, table.getn(array_list_src) do
		if array_list_src[k] ~= "" then			
			listsrc = listsrc..array_list_src[k]..','
		end
	end
	writeIni(file,nx_string('Setting'), "list_title",utf8ToWstr(listsrc))
	loadGridAutoSkill(form)
end
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_tq")
	if not nx_is_valid(form) then
		return
	end	
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end

function btn_add_start(btn)
	local form = btn.ParentForm	
	local run = true
	if click_mouse_fast == nil then click_mouse_fast = 0 end
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()		
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ti_today_state_only') then	
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_ti_today',false)			
		click_mouse_fast = 0		
	else		
		if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
			showUtf8Text(auto_ai_running_wait_stop)
			return
		end	
		if not check_auto_special_running() then
			return
		end
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_ti_today_only')
		nx_pause(1)			
	end	
	updateBtnAuto()
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_tq")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ti_today_state_only') then		
		form.btn_add_start.Text = nx_widestr('Stop')
	else		
		form.btn_add_start.Text = nx_widestr('Start')		
	end
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_tq")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Start')	
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_tq")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Stop')	
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



function loadGridAutoSkill(form)
	local gui = nx_value("gui")
	local grid = form.textgrid_pos	
	grid:ClearRow()
	grid:ClearSelect()
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local file = add_file('auto_tq')
	ini.FileName = file
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	if ini:LoadFromFile() then	
		if ini:FindSection('Setting') then		
			local pos_table = wstrToUtf8(readIni(file,nx_string('Setting'),'list_title',''))
			local split_item = auto_split_string(pos_table,',')
			listsrc = pos_table
			array_list_src = split_item
			if nx_number(table.getn(split_item)) > 0 then
				for i = 1, table.getn(split_item) do									
					local btn_del = create_multitextbox(THIS_FORM, 'on_click_btn_del',auto_del,split_item[i], 'HLStypebargaining')
					local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move', getUtf8Text(split_item[i]), 'HLChatItem1')	
					gridAndFunc(grid,multitextbox,btn_del)	
				end
			end
		end		
	end
end
function gridAndFunc(grid,mTextName,btn_del)
	local form = nx_value(THIS_FORM)
	local row = grid:InsertRow(-1)
	grid:SetGridControl(row, 0, mTextName)
	grid:SetGridControl(row, 1, btn_del)		
end
function on_click_btn_del(btn)
	local form = btn.ParentForm	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	local data_item = ''
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local file = add_file('auto_tq')
	ini.FileName = file	
	if not ini:LoadFromFile()or not ini:FindSection(nx_string('Setting')) then return end
	local str = ini:ReadString(nx_string('Setting'), 'list_title', '')
	local list =  auto_split_string(nx_string(str),',')	
	if table.getn(list) == 1 then		
		if ini:LoadFromFile() then	
			if ini:FindSection('Setting') then
				ini:DeleteSection('Setting')
				ini:SaveToFile()
				loadGridAutoSkill(form)
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
		data_item = data_item..','..list[j]
	end
	ini:WriteString(nx_string('Setting'), "list_title", data_item)
	ini:SaveToFile()	
	loadGridAutoSkill(form)
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


