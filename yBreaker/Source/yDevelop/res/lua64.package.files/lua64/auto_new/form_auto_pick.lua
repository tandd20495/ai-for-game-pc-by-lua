require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_pick'
inifile = nil
listsrc = ''
array_list_src = nil
market_item_table = {}
ITT_CANJUAN = 20
ITT_NEIGONG = 21
ITT_SHUYE = 2017
ITT_ZHAOSHI = 23
ITT_ANQI = 26
ITT_QQ1 = 24
ITT_QQ2 = 27
ITT_ZHENFA = 28
ITT_TUJIE = 191
ITT_KUANGSHI = 2021
ITT_BULIAO = 2045
ITT_MUTOU = 2031
ITT_ZHONGZI = 40
ITT_CAOYAO = 2081
ITT_DUCAO = 2091
ITT_WUPIN = 1206
ITT_PIZI= 1
ITT_TUPU = 35
ItemData ={
	[ITT_CANJUAN] = true,
	[ITT_NEIGONG] = true,
	[ITT_SHUYE] = true,
	[ITT_ZHAOSHI] = true,
	[ITT_ANQI] = true,
	[ITT_QQ1] = true,
	[ITT_QQ2] = true,
	[ITT_ZHENFA] = true,
	[ITT_TUJIE] = true,
	[ITT_KUANGSHI] = true,
	[ITT_BULIAO] = true,
	[ITT_MUTOU] = true,
	[ITT_ZHONGZI] = true,
	[ITT_CAOYAO] = true,
	[ITT_DUCAO] = true,
	[ITT_WUPIN] = true,
	[ITT_PIZI] = true,
	[ITT_TUPU] = true
	
} 
function form_init(form)  
    PickControlList = {
    	{ITT_CANJUAN, form.check_box_2},
    	{ITT_NEIGONG, form.check_box_3},
    	{ITT_SHUYE,form.check_box_4},
    	{ITT_ZHAOSHI,form.check_box_5},
    	{ITT_ANQI,form.check_box_6},
    	{ITT_QQ1,form.check_box_7},
    	{ITT_QQ2,form.check_box_8},
    	{ITT_ZHENFA,form.check_box_9},
    	{ITT_TUJIE,form.check_box_10},
    	{ITT_KUANGSHI,form.check_box_12},
    	{ITT_BULIAO,form.check_box_13},
    	{ITT_MUTOU,form.check_box_14},
    	{ITT_ZHONGZI,form.check_box_15},
    	{ITT_CAOYAO,form.check_box_16},
    	{ITT_DUCAO,form.check_box_17},
    	{ITT_WUPIN,form.check_box_18},
    	{ITT_PIZI,form.check_box_19},
    	{ITT_TUPU,form.check_box_20}
	}

end
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end

	
function on_main_form_open(form)	
	local inifile = add_file('auto_pick')	
	form_init(form)
	for item_type,value in pairs(ItemData) do
		local key = nx_string(readIni(inifile, "PickItem", nx_string(item_type), "0"))
		ItemData[item_type] = key == "1" and true or false
	end
	local pick_all = wstrToUtf8(readIni(inifile,'Setting', "pick_all", ''))	
	local list_item_string = wstrToUtf8(readIni(inifile,'Setting', "pick_item", ''))
	local split_item = auto_split_string(list_item_string,',')
	if nx_number(table.getn(split_item)) <= nx_number(0) then
		writeIni(inifile,'Setting', "pick_item", utf8ToWstr('TG_item_02,TG_item_01,qizhen_0108,qizhen_0107,qizhen_0106,qizhen_0105,qizhen_0104,qizhen_0102,qizhen_0103,qizhen_0109,qizhen_0115,qizhen_0114,equip_tihuan_601,ore_1005,ore_1007,buliao_1008,buliao_1007,kuangshi_1009,kuangshi_1007,qpitem_10092,book_QG_JH_gjskill_00104,qpitem_10093,item_ng_cjbook_dh,cjbook_CS_wd_tjq,cjbook_CS_jh_chz,buliao_1005,ore_1008,buliao_1002,buliao_1001,fenjie_10005,fenjie_10004,fenjie_10003,fenjie_10002,drug_1005,buliao_1006,buliao_1009,ng_cjbook_jh_201,ng_cjbook_jh_202,ng_cjbook_jh_205,ng_cjbook_jh_208,ng_cjbook_jh_108,fenjie_30004,fenjie_30003,fenjie_20003'))
		writeIni(inifile,'Setting', "pick_all", 'false')
	end
	if pick_all == nx_string('true') then
		form.check_box_1.Checked = true
	end	
	form.combobox_itemname.config = ''
	form.combobox_itemname.Text = nx_widestr('')
	for i,control in pairs(PickControlList) do
		control[2].Checked = ItemData[control[1]]
	end
	load_qt_list(form)	
end 
btn_del_item = function(btn)
	local f = btn.ParentForm
	local inifile = add_file('auto_pick')
	os.remove(inifile)
	local pick_all = wstrToUtf8(readIni(inifile,'Setting', "pick_all", ''))		
	if pick_all == nx_string('true') then
		f.check_box_1.Checked = true
	end	
	load_qt_list(f)
end
on_cbtn_auto_box = function(btn)
	local f = btn.ParentForm
	local inifile = add_file('auto_pick')
	for i,control in pairs(PickControlList) do
		writeIni(inifile, "PickItem", nx_string(control[1]), control[2].Checked and "1" or "0")
	end
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
		ini.FileName = add_file('auto_pick')		
		if ini:LoadFromFile()then
			if ini:FindSection(nx_string('Setting')) then
				str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
			else
				os.remove(add_file('auto_pick'))
			end
		end	
		if string.find(nx_string(str),item:QueryProp('ConfigID'),1,true) then
			showUtf8Text('Item already exists')
			return
		end
		str = str .. item:QueryProp('ConfigID') .. ","	
		ini:WriteString(nx_string('Setting'), "pick_item", str)
		ini:SaveToFile()
		nx_destroy(ini)				
	end 
	load_qt_list(form)
	game_hand:ClearHand()
end
function load_qt_list(form)
	local grid = form.textgrid_pos_2
	local file  = add_file('auto_pick')	
	local gui = nx_value('gui') 
	grid:ClearRow()
	grid:ClearSelect()	
	local list_pick = wstrToUtf8(readIni(file,'Setting','pick_item',''))
	if list_pick == nx_string('0') then return end
	local array_pick = auto_split_string(list_pick,',')
	for i = 1, table.getn(array_pick) do
		local npc_name = getUtf8Text(array_pick[i])
		local multitextbox = create_multitextbox(THIS_FORM, 'on_right_grid', npc_name, 'HLChatItem1')
		local btn_del = create_multitextbox(THIS_FORM, 'on_btn_remove_npc_add',auto_del,array_pick[i], 'HLStypebargaining')	
		gridAndFunc(grid,multitextbox,btn_del)
	end	
end
function on_combobox_itemname_selected(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end	
	local index = form.combobox_itemname.DropListBox.SelectIndex
	if index < table.getn(market_item_table) then
		form.combobox_itemname.config = market_item_table[index + 1]	
	end
	form.edt_item_add.Text = form.combobox_itemname.Text
	form.combobox_itemname.Text = nx_widestr("")
end
btn_add_item = function(btn)
	local f = btn.ParentForm	
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
		return 
	end
	local str = ''
	ini.FileName = add_file('auto_pick')
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string('Setting')) then
			str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
		else
			os.remove(add_file('auto_pick'))
		end
	end	
	if string.find(nx_string(str),nx_string(f.combobox_itemname.config),1,true) then
		showUtf8Text('Item already exists')
		return
	end
	str = str .. nx_string(f.combobox_itemname.config) .. ","	
	ini:WriteString(nx_string('Setting'), "pick_item", str)
	ini:SaveToFile()
	nx_destroy(ini)	
	f.edt_item_add.Text = ""
	load_qt_list(f)	
end
function on_cbtn_auto_box_1(cbtn)
	local form = cbtn.ParentForm
	local inifile = add_file('auto_pick')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	if form.check_box_1.Checked then		
		writeIni(inifile,'Setting', "pick_all", 'true')
	else
		writeIni(inifile,'Setting', "pick_all", 'false')
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
	market_item_table = {}
	local search_table = ItemQuery:FindItemsByName(self.Text)	
	for _, item_config in pairs(search_table) do
		local bExist = ItemQuery:FindItemByConfigID(item_config)
		if bExist then		
			local static_data = ItemQuery:GetItemPropByConfigID(nx_string(item_config), nx_string("LogicPack"))
			local bind_type = item_static_query(nx_int(static_data), "BindType", STATIC_DATA_ITEM_LOGIC)
			if nx_int(bind_type) ~= nx_int(1) and gui.TextManager:IsIDName(item_config) then
			  form.combobox_itemname.DropListBox:AddString(nx_widestr(util_text(item_config)))
			  table.insert(market_item_table, item_config)
			end				
		end
	end
	if not form.combobox_itemname.DroppedDown then
		form.combobox_itemname.DroppedDown = true
	end
end
function on_cbx_input_sh_selected(cbx)
	
end
on_btn_remove_npc_add = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	ini.FileName = add_file('auto_pick')
	local str = ""
	if not ini:LoadFromFile()or not ini:FindSection(nx_string('Setting')) then return end
	str = ini:ReadString(nx_string('Setting'), nx_string('pick_item'), '')
	str = string.gsub(str, nx_string(btn.DataSource) .. ",", "")
	ini:WriteString(nx_string('Setting'), "pick_item", str)
	ini:SaveToFile()	
	load_qt_list(form)
	form.combobox_itemname.config = ''
end

function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_pick")
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
	-- if run then
		-- showUtf8Text(AUTO_LOG_AUTO_ERROR_START_WITH_AI)
		-- return
	-- end
	if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
		showUtf8Text(auto_ai_running_wait_stop)
		return
	end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ti_today_state_only') then	
		showUtf8Text(auto_please_wait_stop)
		nx_kill('auto_new\\form_auto_ai_new','exe_auto_on_jump_ti')
		nx_kill('auto_new\\form_auto_ai_new','exe_auto_on_jump_ti_td')
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_ti_today',false)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_ti_today_only')
		nx_pause(0.2)	
		nx_kill('auto_new\\form_auto_ai_new','exe_auto_ti_today_state_only')
		if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ti_today_state_only') then			
			nx_kill('auto_new\\form_auto_ai_new','exe_auto_ti_today_state_only')
		end		
	else
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_ti_today_only')		
	end	
	updateBtnAuto()
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_pick")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_ti_today_state_only') then		
		form.btn_add_start.Text = nx_widestr('Stop')
	else		
		form.btn_add_start.Text = nx_widestr('Start')		
	end
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
	local file = add_file('auto_pick')
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
					local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move', split_item[i], 'HLChatItem1')	
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
	local file = add_file('auto_pick')
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


