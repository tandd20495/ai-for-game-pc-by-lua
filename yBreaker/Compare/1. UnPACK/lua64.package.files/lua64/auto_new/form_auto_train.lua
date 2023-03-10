require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
if not load_auto_train then
	auto_cack('0')
	auto_cack('1')
	auto_cack('6')
	auto_cack('8')
	auto_cack('7')
	load_auto_train = true
end
local THIS_FORM = 'auto_new\\form_auto_train'
inifile = nil
listsrc = ''
array_list_src = nil
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end

function on_main_form_open(form)
	local ini_file = add_file('auto_train')
	local active_type =  wstrToUtf8(readIni(ini_file,'Setting','active_type',''))	
	if nx_number(active_type) == nx_number(1) then
		form.check_box_1.Checked = true
	end
	if nx_number(active_type) == nx_number(2) then
		form.check_box_2.Checked = true
	end
	local at_drop = wstrToUtf8(readIni(ini_file,'Setting','at_drop',''))
	local at = wstrToUtf8(readIni(ini_file,'Setting','at',''))
	local drop = wstrToUtf8(readIni(ini_file,'Setting','drop',''))
	local poslocal = wstrToUtf8(readIni(ini_file,'Setting','poslocal',''))
	--if at_drop == '0' then 
	if at_drop == 'true' then
		form.check_box_4.Checked = true
	else
		form.check_box_4.Checked = false
	end
	if at == 'true' then
		form.check_box_6.Checked = true
	else
		form.check_box_6.Checked = false
	end
	if drop == 'true' then
		form.check_box_5.Checked = true
	else
		form.check_box_5.Checked = false
	end
	if poslocal == 'true' then
		form.check_box_7.Checked = true
	else
		form.check_box_7.Checked = false
	end
	-- local active = wstrToUtf8(readIni(ini_file,'Setting','active',''))	
	-- if active == '' then
		-- local x,y,z = getCurPos()
		-- local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
		-- local src =  string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z)
		-- writeIni(ini_file,'NONE', "scene", nx_string(cur_scene_id))
		-- writeIni(ini_file,'NONE', "pos", nx_string(src))
		-- writeIni(ini_file,'NONE', "range", 50)
		-- writeIni(ini_file,'Setting','active','NONE')	
	-- end	
	updateBtnAuto()
	--load_qt_list(form)
	load_map_train(form)
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_train")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
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
		local str = ''
		ini.FileName = add_file('auto_train')		
		if ini:LoadFromFile()then
			if ini:FindSection(nx_string('Setting')) then
				str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
			else
				ini:WriteString(nx_string('Setting'), "pick_item", '')
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
	load_qt_list(form)
	game_hand:ClearHand()
end
function on_cbtn_auto_box(cbtn)
	if cbtn.Checked == false then
		return
	end
	local form = cbtn.ParentForm	
	local i = nx_number(cbtn.TabIndex) 
	set_tag_enable(form, i) 	
	local ini_file = add_file('auto_train')
	writeIni(ini_file,'Setting','active_type',i)
end
function set_tag_enable(form, i)
  local k = "check_box_"
  for l = 1, 2 do
    local h = k .. nx_string(l)
    if nx_find_custom(form, h) then
      local enable = nx_custom(form, h)
      enable.Checked = nx_int(i) == nx_int(l)
    end
  end
end
function btn_add_start(btn)
	local form = btn.ParentForm	
	-- local ini_file = add_file('auto_train')
	-- local active_type = wstrToUtf8(readIni(ini_file,'Setting','active',''))
	-- if active_type == nx_string('NONE') then
		-- local x,y,z = getCurPos()
		-- local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
		-- local src =  string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z)
		-- writeIni(ini_file,'NONE', "scene", nx_string(cur_scene_id))
		-- writeIni(ini_file,'NONE', "pos", nx_string(src))
		-- writeIni(ini_file,'NONE', "range", 50)
		-- writeIni(ini_file,'Setting','active','NONE')
	-- end
	if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
		showUtf8Text(auto_ai_running_wait_stop)
		return
	end
	if nx_running(nx_current(),'auto_start_train') then
		nx_execute(nx_current(),'exe_auto_train')	
		if nx_running(nx_current(),'auto_start_train') then
			nx_kill(nx_current(),'auto_start_train')
		end
	else
		nx_execute(nx_current(),'exe_auto_train')		
	end	
	updateBtnAuto()
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_train")
	if nx_running(nx_current(),'auto_start_train') then
		form.btn_add_start.Text = nx_widestr('Stop')
	else
		form.btn_add_start.Text = nx_widestr('Start')		
	end
end
function on_cbx_train_selected(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end
	local ini_file = add_file('auto_train')
	writeIni(ini_file,'Setting','active',form.cbx_map_train.InputEdit.Text)
	writeIni(ini_file,'Setting', "index_open", nx_string(form.cbx_map_train.DropListBox.SelectIndex))
end
show_log_system_t = function(str)
	local form_main_chat_logic = nx_value('form_main_chat')
	if nx_is_valid(form_main_chat_logic) then
		form_main_chat_logic:AddChatInfoEx(utf8ToWstr(str), 17, false)
	end
end
function load_map_train(form)
	form.cbx_map_train.DropListBox:ClearString()
	local current_map = nx_value("form_stage_main\\form_map\\form_map_scene").current_map
	local index = 0
	local ini_file = add_file('auto_train')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	local active_type = wstrToUtf8(readIni(ini_file,'Setting','active',''))		
	local index_open = wstrToUtf8(readIni(ini_file,'Setting','index_open',''))		
	ini.FileName = nx_string(ini_file) 
	if ini:LoadFromFile() then		
		local countini = nx_execute('auto_new\\autocack','sectionCount',ini_file)		
		if countini > 0 then
			for j = 1, countini do
				funcname = getSectionName(ini_file,j)			
				for i = 1, table.getn(funcname) do
					if funcname[i] ~= nx_string('Setting') then
						local range = wstrToUtf8(readIni(ini_file,funcname[i],'range',''))
						local src = funcname[i]--..' - '..range
						form.cbx_map_train.DropListBox:AddString(utf8ToWstr(src))						
					end		
				end
			end	
		end	
		form.cbx_map_train.DropListBox.SelectIndex = nx_int(index_open)
		form.cbx_map_train.InputEdit.Text = form.cbx_map_train.DropListBox:GetString(nx_int(index_open))
	end
end
function btn_add_pos(btn)
	local form = btn.ParentForm
	local ini_file = add_file('auto_train')
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	local _name = ''
	local dialog1 = nx_execute('util_gui', 'util_get_form', 'form_common\\form_input_name', true, false)
	dialog1.lbl_title.Text = nx_function('ext_utf8_to_widestr', 'Nhập Tên Tọa Độ')
	dialog1.info_label.Text = utf8ToWstr('Tên') 		
	dialog1:ShowModal()
	local res, new_name = nx_wait_event(100000000, dialog1, 'input_name_return')
	if res == 'cancel' then
		_name = ''
		return 0
	else
		_name = new_name					
	end	
	nx_pause(0.5)
	local range = ''
	local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_inputbox", true, false)
    dialog.info_label.Text = nx_function("ext_utf8_to_widestr", "Khoảng Cách")
    dialog.name_edit.Text = nx_widestr("50")
    dialog:ShowModal()
    local res, text = nx_wait_event(100000000, dialog, "input_box_return")
    if res == 'cancel' then
		range = ''
		return 0
	else
		range = text					
	end	
	local x,y,z = getCurPos()
	local src =  string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z)
	writeIni(ini_file,wstrToUtf8(_name), "scene", nx_string(cur_scene_id))
	writeIni(ini_file,wstrToUtf8(_name), "pos", nx_string(src))
	writeIni(ini_file,wstrToUtf8(_name), "range", nx_string(range))		
	writeIni(ini_file,'Setting', "active", _name)		
	load_map_train(form)
end
function btn_del_pos(btn)
	local form = btn.ParentForm
	local cbx = form.cbx_map_train.InputEdit.Text
	local inifile = add_file('auto_train')
	removeSection(inifile,wstrToUtf8(cbx))
	load_map_train(form)
end
function btn_add_pick(btn)
	local form = btn.ParentForm
	util_auto_show_hide_form('auto_new\\form_auto_pick')
end
FORM_MAP_SCENE= 'form_stage_main\\form_map\\form_map_scene'

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


function load_qt_list(form)
	local grid = form.textgrid_pos
	local file  = add_file('auto_train')	
	local gui = nx_value('gui') 
	grid:ClearRow()
	grid:ClearSelect()	
	local list_pick = wstrToUtf8(readIni(file,'Setting','pick_item',''))
	local array_pick = auto_split_string(list_pick,',')
	for i = 1, table.getn(array_pick) do
		local npc_name = utf8ToWstr(array_pick[i])
		local multitextbox = create_multitextbox(THIS_FORM, 'on_right_grid', wstrToUtf8(npc_name), 'HLChatItem1')
		local btn_del = create_multitextbox(THIS_FORM, 'on_btn_remove_npc_add',auto_del,array_pick[i], 'HLStypebargaining')	
		gridAndFunc(grid,multitextbox,btn_del)
	end	
end
getUtf8Text = function(codeStr)
	return wstrToUtf8(nx_value('gui').TextManager:GetText(codeStr))
end
btn_add_mon_hk = function(btn)
	local f = btn.ParentForm	
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
		return 
	end
	local str = ''
	ini.FileName = add_file('auto_train')
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string('Setting')) then
			str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
		else
			os.remove(add_file('auto_train'))
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
	load_qt_list(f)	
end

function on_combobox_itemname_selected(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end
	form.edt_item_add.Text = form.combobox_itemname.Text
	form.combobox_itemname.Text = nx_widestr('')
	local index = form.combobox_itemname.DropListBox.SelectIndex	
	if index < table.getn(market_item_table) then
		form.combobox_itemname.config = market_item_table[index + 1]		
	end
end
function check_box_4(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end	
	local ini_file = add_file('auto_train')
	if form.check_box_4.Checked then
		form.check_box_6.Checked = false
		form.check_box_5.Checked = false
		writeIni(ini_file,'Setting', "at_drop", 'true')
	else
		writeIni(ini_file,'Setting', "at_drop", 'false')
	end
	--load_map_train(form)
end
function check_box_5(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end	
	local ini_file = add_file('auto_train')
	if form.check_box_5.Checked then
		form.check_box_6.Checked = false
		form.check_box_4.Checked = false
		writeIni(ini_file,'Setting', "drop", 'true')
	else
		writeIni(ini_file,'Setting', "drop", 'false')
	end
	--load_map_train(form)
end
function check_box_6(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end	
	local ini_file = add_file('auto_train')
	if form.check_box_6.Checked then
		form.check_box_5.Checked = false
		form.check_box_4.Checked = false
		writeIni(ini_file,'Setting', "at", 'true')
	else
		writeIni(ini_file,'Setting', "at", 'false')
	end
	
	--load_map_train(form)
end
function check_box_7(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end	
	local ini_file = add_file('auto_train')
	if form.check_box_7.Checked then		
		writeIni(ini_file,'Setting', "poslocal", 'true')
	else
		writeIni(ini_file,'Setting', "poslocal", 'false')
	end	
	--load_map_train(form)
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
on_btn_remove_npc_add = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	ini.FileName = add_file('auto_train')
	local str = ""
	if not ini:LoadFromFile()or not ini:FindSection(nx_string('Setting')) then return end
	str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
	str = string.gsub(str, nx_string(btn.DataSource) .. ",", "")
	ini:WriteString(nx_string('Setting'), "pick_item", str)
	ini:SaveToFile()
	load_qt_list(form)
end
function gridAndFunc(grid,mTextName,btn_del)
	local form = nx_value(THIS_FORM)
	local row = grid:InsertRow(-1)
	grid:SetGridControl(row, 0, mTextName)	
	grid:SetGridControl(row, 1, btn_del)		
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


