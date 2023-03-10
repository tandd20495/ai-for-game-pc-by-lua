require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_ti'
inifile = nil
listsrc = ''
array_list_src = nil
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end

function on_main_form_open(form)
	--form.combobox_itemname.config = ''
	local ini_file = add_file('auto_ti')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(ini_file) 
	if ini:LoadFromFile() then
		local turn_ti = wstrToUtf8(readIni(ini_file,'Setting','turn_ti',''))
		local lv = wstrToUtf8(readIni(ini_file,'Setting','tiquan_lv',''))
		local array_lv = auto_split_string(lv,',')
		local lv1 = array_lv[1]
		local lv2 = array_lv[2]
		local lv3 = array_lv[3]
		local lv4 = array_lv[4]
		local boss_red = wstrToUtf8(readIni(ini_file,'Setting','boss_red',''))
		local kcl = wstrToUtf8(readIni(ini_file,'Setting','kcl',''))
		local bug_lam = wstrToUtf8(readIni(ini_file,'Setting','bug_lam',''))
		local xingfen = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "xingfen", ''))
		local mp = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "mp", ''))
		local hp = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "hp", ''))
		local buff_bathe = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "buff_bathe", ''))
		local stop_turn = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "stop_turn", ''))
		local buff_turn = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "buff_turn", ''))
		local bathe_list = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "bathe_list",''))
		local not_box = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "not_box", ''))
		local reset = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "reset", ''))
		local fight_pos = wstrToUtf8(readIni(ini_file,nx_string('Setting'), "fight_pos", ''))
		form.tab_0_input.Text = nx_widestr(turn_ti)
		form.tab_1_input.Text = nx_widestr(lv1)
		form.tab_2_input.Text = nx_widestr(lv2)
		form.tab_3_input.Text = nx_widestr(lv3)
		form.tab_4_input.Text = nx_widestr(lv4)
		form.tab_5_input.Text = nx_widestr(boss_red)
		form.tab_6_input.Text = nx_widestr(buff_turn)
		if fight_pos == nx_string('true') then
			form.check_box_10.Checked = true
		end
		if kcl == nx_string('true') then
			form.check_box_1.Checked = true
		end
		if bug_lam == nx_string('true') then
			form.check_box_2.Checked = true
		end
		if xingfen == nx_string('true') then
			form.check_box_3.Checked = true
		end
		if mp == nx_string('true') then
			form.check_box_4.Checked = true
		end
		if hp == nx_string('true') then
			form.check_box_5.Checked = true
		end
		if buff_bathe == nx_string('true') then
			form.check_box_6.Checked = true
		end
		if not_box == nx_string('true') then
			form.check_box_7.Checked = true
		end
		if reset == nx_string('true') then
			form.check_box_8.Checked = true
		end
		if stop_turn == nx_string('true') then
			form.check_box_9.Checked = true
		end
		form.edt_item_boss.Text = utf8ToWstr(bathe_list)
		
	else		
		writeIni(ini_file,'Setting', "turn_ti", 4)
	end	
	updateBtnAuto()
	--load_qt_list(form)
	click_mouse_fast = 0
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_ti")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end

function on_cbtn_auto_box_2(cbtn)
	local skill_id = 'CS_wd_tjq07'
	local fight = nx_value('fight')
	local skill = fight:FindSkill(skill_id)
	if not nx_is_valid(skill) then
		showUtf8Text(AUTO_LOG_NOT_LAM)
		cbtn.Checked = false
	end
end
function btn_add_start(btn)
	if click_mouse_fast == nil then click_mouse_fast = 0 end
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()	
	local form = btn.ParentForm
	save_setting_tiguan()	
	local run = true	
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ti_state_only') then
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_ti',false)				
		-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_ti_state_only')
		-- if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ti_state_only') then			
			-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_ti_state_only')
		-- end
	else		
		if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
			showUtf8Text(auto_ai_running_wait_stop)
			return
		end
		if not check_auto_special_running() then
			return
		end
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_ti_only')		
		nx_pause(1)
	end	
	updateBtnAuto()
end
function btn_add_pick(btn)
	local form = btn.ParentForm
	util_auto_show_hide_form('auto_new\\form_auto_pick')
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_ti")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ti_state_only') then
		form.btn_add_start.Text = nx_widestr('Stop')
	else		
		form.btn_add_start.Text = nx_widestr('Start')		
	end
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_ti")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Start')	
end
function updateBtnStart()
	local form = nx_value("auto_new\\form_auto_ti")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Stop')	
end
function btn_add_save(btn)
	local form = btn.ParentForm
	save_setting_tiguan()
	util_show_form('auto_new\\form_auto_ti',false)
end
save_setting_tiguan = function()
	local form = nx_value('auto_new\\form_auto_ti')
	local ini_file = add_file('auto_ti')
	local lv = nx_string(form.tab_1_input.Text)..','..nx_string(form.tab_2_input.Text)..','..nx_string(form.tab_3_input.Text)..','..nx_string(form.tab_4_input.Text)
	writeIni(ini_file,nx_string('Setting'), "tiquan_lv", nx_string(lv))
	writeIni(ini_file,nx_string('Setting'), "boss_red", nx_string(form.tab_5_input.Text))
	writeIni(ini_file,nx_string('Setting'), "kcl", nx_string(form.check_box_1.Checked))
	writeIni(ini_file,nx_string('Setting'), "bug_lam", nx_string(form.check_box_2.Checked))
	writeIni(ini_file,nx_string('Setting'), "turn_ti", nx_string(form.tab_0_input.Text))
	writeIni(ini_file,nx_string('Setting'), "xingfen", nx_string(form.check_box_3.Checked))
	writeIni(ini_file,nx_string('Setting'), "mp", nx_string(form.check_box_4.Checked))
	writeIni(ini_file,nx_string('Setting'), "hp", nx_string(form.check_box_5.Checked))
	writeIni(ini_file,nx_string('Setting'), "buff_bathe", nx_string(form.check_box_6.Checked))
	writeIni(ini_file,nx_string('Setting'), "bathe_list", form.edt_item_boss.Text)
	writeIni(ini_file,nx_string('Setting'), "not_box", nx_string(form.check_box_7.Checked))
	writeIni(ini_file,nx_string('Setting'), "reset", nx_string(form.check_box_8.Checked))
	writeIni(ini_file,nx_string('Setting'), "stop_turn", nx_string(form.check_box_9.Checked))
	writeIni(ini_file,nx_string('Setting'), "buff_turn", nx_string(form.tab_6_input.Text))
	writeIni(ini_file,nx_string('Setting'), "fight_pos", nx_string(form.check_box_10.Checked))
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
		ini.FileName = add_file('auto_ti')		
		if ini:LoadFromFile()then
			if ini:FindSection(nx_string('Setting')) then
				str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
			else
				os.remove(add_file('auto_ti'))
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

function load_qt_list(form)
	local grid = form.textgrid_pos
	local file  = add_file('auto_ti')	
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
	local str = nil
	ini.FileName = add_file('auto_ti')
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string('Setting')) then
			str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
		else
			os.remove(add_file('auto_ti'))
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
	ini.FileName = add_file('auto_ti')
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


