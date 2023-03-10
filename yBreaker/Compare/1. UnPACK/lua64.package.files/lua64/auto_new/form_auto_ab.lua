require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
if not load_auto_ab then
	auto_cack('0')
	auto_cack('1')
	auto_cack('4')
	auto_cack('8')	
	load_auto_ab = true
end
local THIS_FORM = 'auto_new\\form_auto_ab'
inifile = nil
listsrc = ''
array_list_src = nil
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end
getUpperSilver = function()
	local game_client = nx_value('game_client')
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then
		return
	end
	return client_player:QueryProp('CapitalType2')
end
function add_file_res(inifile)
	local game_client = nx_value('game_client')	
	local client_player = game_client:GetPlayer()
	local stage = nx_value("stage")
	if not nx_is_valid(client_player) then return end	
	if stage == 'main' then	
		local dir = nx_resource_path() .. 'auto_data' 
		if not nx_function('ext_is_exist_directory', nx_string(dir)) then
		  nx_function('ext_create_directory', nx_string(dir))	 
		end
		local ini = nx_create('IniDocument')
		if not nx_is_valid(ini) then
			return
		end
		ini.FileName = dir .. '\\'..nx_string(inifile)..'.ini'
		return ini.FileName
	end
end
function on_main_form_open(form)
	updateBtnAuto()
	local ini_file = add_file('auto_ab')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(ini_file)	
	if ini:LoadFromFile() then	
		if ini:FindSection('Setting') then			
			--local greed = wstrToUtf8(readIni(ini_file,'Setting', "greed", ""))
			local time_attack = wstrToUtf8(readIni(ini_file,'Setting', "time_attack", ""))
			local time_buff_after = wstrToUtf8(readIni(ini_file,'Setting', "time_buff_after", ""))
			local time_buff_sell = wstrToUtf8(readIni(ini_file,'Setting', "time_buff_sell", ""))			
			local greed_check = false
			-- if greed == nx_string('true') then
				-- greed_check = true
			-- end
			--form.checked_change_map.Checked = greed_check
			form.edt_buff_time_attack.Text = nx_widestr(time_attack)
			form.edt_buff_time_after.Text = nx_widestr(time_buff_after)
			form.edt_buff_time_sell.Text = nx_widestr(time_buff_sell)
		end
	end	
	local day = get_cur_day() 
	local total = wstrToUtf8(readIni(ini_file,'ab_day_total', nx_string(day), ''))
	local total_split = auto_split_string(total,';')
	if nx_number(total_split[1]) > nx_number(0) then
		form.lbl_total_price_ab.Text = nx_widestr(nx_string(getSilverFormat(total_split[1])))
	end
	if nx_number(total_split[2]) > nx_number(0) then
		form.lbl_total_ab.Text = nx_widestr(nx_string(total_split[2]))
	end		
	load_map_ab(form)
	load_map_ab_2(form)
	load_ab_list_chat(form)
	load_ab_list_npc(form)
	load_ab_list_pos(form)
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_ab")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end
save_data_auto_ab = function(form)
	local hide_pos = form.edt_pos_hide.Text
	local hide_pos2 = form.edt_pos_hide_2.Text
	local hide_pos_com = nx_string(hide_pos)..';'..nx_string(hide_pos2)
	local time_attack = form.edt_buff_time_attack.Text
	local time_buff_after = form.edt_buff_time_after.Text
	local time_buff_sell = form.edt_buff_time_sell.Text
	local ini_file = add_file('auto_ab')
	local inifile = add_file('auto_ab')	
	local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
	if nx_string(hide_pos) == '0' then
		writeIni(ini_file,active,'hide_pos','')
	end
	if nx_string(hide_pos) == '0' then
		writeIni(ini_file,active,'hide_pos','')
	end	
	--writeIni(ini_file,'Setting','greed',nx_string(form.checked_change_map.Checked))
	writeIni(ini_file,active,'hide_pos',hide_pos_com)
	writeIni(ini_file,'Setting','time_attack',time_attack)
	writeIni(ini_file,'Setting','time_buff_after',time_buff_after)
	writeIni(ini_file,'Setting','time_buff_sell',time_buff_sell)
end
function btn_add_start(btn)
	local form = btn.ParentForm
	save_data_auto_ab(form)
	if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
		showUtf8Text(AUTO_LOG_STOP_AB_AI)
		return
	end
	if nx_running(nx_current(),'exe_auto_ab_state') then		
		nx_execute(nx_current(),'turn_off_auto_ab')
		nx_kill(nx_current(),'exe_auto_ab_state')
		if nx_running(nx_current(),'exe_auto_ab_state') then			
			nx_kill(nx_current(),'exe_auto_ab_state')
		end
	else
		nx_execute(nx_current(),'exe_auto_ab')		
	end	
	updateBtnAuto()
end
load_hide_pos = function(hide_pos)
	if not hide_pos then
		return 0
	end
	local ab_random = ''
	local hide_pos_list = auto_split_string(hide_pos,';')
	math.randomseed(os.time())
	math.randomseed(os.time())
	for i = table.getn(hide_pos_list), 2, -1 do
		ab_random = math.random(#hide_pos_list)
	end
	return ab_random
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_ab")
	if nx_running(nx_current(),'exe_auto_ab_state') then
		form.btn_add_start.Text = nx_widestr('Stop')
	else
		form.btn_add_start.Text = nx_widestr('Start')		
	end
end
function btn_fix_size(btn)
	local form = btn.ParentForm
	local w = nx_number(form.edt_size_w.Text)
	local h = nx_number(form.edt_size_h.Text)
	nx_execute(nx_current(),'set_win_size_auto',w,h)
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
array_config = {}
function load_map_ab(form)
	form.cbx_map_ab.DropListBox:ClearString()
	form.cbx_map_ab.InputEdit.Text = ""
	local file = add_file_res('auto_ab')
	local countini = nx_execute('auto_new\\autocack','sectionCount',file)
	array_config = {}
	local countName = ""
	if countini > 0 then
		for j = 1, countini do
			countName = getSectionName(file,j)
			for k = 1, table.getn(countName) do				
				form.cbx_map_ab.DropListBox:AddString(util_text(countName[k]))
				table.insert(array_config,countName)
			end
		end
	end
	local index_cbx = 0
	local get_string = 0
	local ini_file = add_file('auto_ab')
	local index = nx_number(readIni(ini_file,'Setting', "index", ""))
	if index and index ~= 0 then
		index_cbx = index - 1
		get_string = index - 1
	end
	form.cbx_map_ab.DropListBox.SelectIndex = nx_int(index_cbx)
	form.cbx_map_ab.InputEdit.Text = form.cbx_map_ab.DropListBox:GetString(nx_int(get_string))
end
array_config_2 = {}
function load_map_ab_2(form)
	form.cbx_map_ab_2.DropListBox:ClearString()
	form.cbx_map_ab_2.InputEdit.Text = ""
	local file = add_file_res('auto_ab')
	local countini = nx_execute('auto_new\\autocack','sectionCount',file)
	array_config_2 = {}
	local countName = ""
	if countini > 0 then
		for j = 1, countini do
			countName = getSectionName(file,j)
			for k = 1, table.getn(countName) do				
				form.cbx_map_ab_2.DropListBox:AddString(util_text(countName[k]))
				table.insert(array_config_2,countName)
			end
		end
	end
	local index_cbx = 0
	local get_string = 0
	local ini_file = add_file('auto_ab')
	local index = nx_number(readIni(ini_file,'Setting', "index_2", ""))
	if index and index ~= 0 then
		index_cbx = index - 1
		get_string = index - 1
	end
	form.cbx_map_ab_2.DropListBox.SelectIndex = nx_int(index_cbx)
	form.cbx_map_ab_2.InputEdit.Text = form.cbx_map_ab_2.DropListBox:GetString(nx_int(get_string))
end
function on_cbx_map_ab_selected(cbx)
	local form = cbx.ParentForm
	local file = add_file('auto_ab')
	local array_string = ''
	local index = form.cbx_map_ab.DropListBox.SelectIndex	
	if index < table.getn(array_config) then		
		array_string = array_config[index + 1][1]
		writeIni(file,'Setting','index',index + 1)	
		writeIni(file,'Setting','active',array_string)	
	end
	load_ab_list_npc(form)
	load_ab_list_pos(form)
	load_ab_list_chat(form)
end
function on_cbx_map_2_ab_selected(cbx)
	local form = cbx.ParentForm
	local file = add_file('auto_ab')
	local array_string = ''
	local index = form.cbx_map_ab_2.DropListBox.SelectIndex	
	if index < table.getn(array_config_2) then		
		array_string = array_config_2[index + 1][1]
		writeIni(file,'Setting','index_2',index + 1)	
		writeIni(file,'Setting','active_school_war',array_string)	
	end	
end
function load_ab_list_npc(form)
	local ini = nx_create('IniDocument')
	local grid = form.textgrid_pos
	if not nx_is_valid(ini) then return end
	local file = add_file_res('auto_ab')	
	ini.FileName = file		
	local gui = nx_value('gui') 
	grid:ClearRow()
	grid:ClearSelect()
	local inifile = add_file('auto_ab')	
	local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
	if ini:LoadFromFile() then	
		if ini:FindSection(active) then		
			local pos_table = nx_string(readIni(file,nx_string(active),'npc_sell',''))			
			local split_item = auto_split_string(pos_table,',')	
			if table.getn(split_item) > 0 then
				for i = 1,table.getn(split_item) do 
					local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move_npc', wstrToUtf8(util_text(split_item[i])),split_item[i], 'HLChatItem1')			
					local btn_del = create_multitextbox(THIS_FORM, 'on_btn_remove_npc',auto_del,split_item[i], 'HLStypebargaining')	
					gridAndFunc(grid,multitextbox,btn_del)	
				end
			end
		end
	end		
end
function load_ab_list_chat(form)
	local ini = nx_create('IniDocument')
	local grid = form.textgrid_pos_2
	if not nx_is_valid(ini) then return end
	local file = add_file_res('auto_ab')	
	ini.FileName = file		
	local gui = nx_value('gui') 
	grid:ClearRow()
	grid:ClearSelect()
	local inifile = add_file('auto_ab')	
	local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
	if ini:LoadFromFile() then	
		if ini:FindSection(active) then		
			local pos_table = wstrToUtf8(readIni(file,nx_string(active),'chat_msg',''))			
			local split_item = auto_split_string(pos_table,',')	
			if table.getn(split_item) > 0 then
				for i = 1,table.getn(split_item) do 
					local chat = split_item[i]
					local multitextbox = create_multitextbox(THIS_FORM, 'on_click_chat', split_item[i],split_item[i], 'HLChatItem1')			
					local btn_del = create_multitextbox(THIS_FORM, 'on_btn_remove_chat',auto_del,split_item[i], 'HLStypebargaining')	
					gridAndFunc(grid,multitextbox,btn_del)	
				end
			end
		end
	end		
end
function on_click_hyper_move_npc(btn)
	if btn.DataSource ~= "" and btn.DataSource ~= nil then
		local inifile = add_file('auto_ab')	
		local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
		local x,y,z = find_npc_pos(nx_string(active),nx_string(btn.DataSource))
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
function on_click_hyper_move_pos(btn)
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
function load_ab_list_pos(form)
	local ini = nx_create('IniDocument')
	local grid = form.textgrid_pos_1
	if not nx_is_valid(ini) then return end
	local file = add_file_res('auto_ab')	
	ini.FileName = file		
	local gui = nx_value('gui') 
	grid:ClearRow()
	grid:ClearSelect()
	local inifile = add_file('auto_ab')	
	local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
	if ini:LoadFromFile() then	
		if ini:FindSection(active) then		
			local pos_table = nx_string(readIni(file,nx_string(active),'pos',''))			
			local split_item = auto_split_string(pos_table,';')			
			local hide_pos = wstrToUtf8(readIni(inifile,active, "hide_pos", ""))
			local hide_pos_split = auto_split_string(hide_pos,';')
			form.edt_pos_hide.Text = nx_widestr(hide_pos_split[1])
			form.edt_pos_hide_2.Text = nx_widestr(hide_pos_split[2])
			if nx_string(pos_table) == nx_string('0') then return end
			if nx_number(table.getn(split_item)) > nx_number(0) then
				for i = 1,table.getn(split_item) do 
					local pos = auto_split_string(split_item[i],',')					
					local x,y,z = pos[1],pos[2],pos[3]
					if x and y and z then
						local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move_pos', (string.format('%.0f', x) .. '-'..string.format('%.0f', z)),nx_string(active) .. ';' .. string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z), 'HLChatItem1')			
						local btn_del = create_multitextbox(THIS_FORM, 'on_btn_remove_pos',auto_del,split_item[i], 'HLStypebargaining')	
						gridAndFunc(grid,multitextbox,btn_del)	
					end
				end
			end
		end
	end	
end
btn_add_pos_npc_ab = function(btn)
	local f = btn.ParentForm	
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
		return 
	end
	local str = ''
	ini.FileName = add_file_res('auto_ab')
	local inifile = add_file('auto_ab')	
	local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
	local target = nx_value('game_select_obj')
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string(active)) then
			if nx_is_valid(target) then
				str = ini:ReadString(nx_string(active), nx_string('npc_sell'), '')
			else
				str = ini:ReadString(nx_string(active), nx_string('pos'), '')
			end
		else
			os.remove(add_file_res('auto_ab'))
		end
	end	
	
	local npcname = nil
	if nx_is_valid(target) then
		str = str .. nx_string(target:QueryProp('ConfigID')) .. ","
		ini:WriteString(nx_string(active), "npc_sell", str)
	else
		local x,y,z = getCurPos()
		local pos = string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z)
		str = str ..pos ..';'
		ini:WriteString(nx_string(active), "pos", str)
	end		
	ini:SaveToFile()
	nx_destroy(ini)		
	load_map_ab(f)
	load_ab_list_npc(f)
	load_ab_list_pos(f)
	load_ab_list_chat(f)
end
btn_add_chat = function(btn)
	local f = btn.ParentForm	
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
		return 
	end
	local str = ''
	ini.FileName = add_file_res('auto_ab')
	local inifile = add_file('auto_ab')	
	local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string(active)) then
			str = ini:ReadString(nx_string(active), nx_string('chat_msg'), '')
		else
			os.remove(add_file_res('auto_ab'))
		end
	end
	str = str .. wstrToUtf8(f.edt_chat_msg.Text) .. ","	
	ini:WriteString(nx_string(active), "chat_msg", str)
	ini:SaveToFile()
	nx_destroy(ini)	
	f.edt_chat_msg.Text = ""
	load_map_ab(f)
	load_ab_list_npc(f)
	load_ab_list_pos(f)
	load_ab_list_chat(f)
end
on_btn_remove_chat = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	ini.FileName = add_file_res('auto_ab')
	local inifile = add_file('auto_ab')	
	local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string(active)) then
			str = ini:ReadString(nx_string(active), nx_string('chat_msg'), '')
		else
			os.remove(add_file_res('auto_ab'))
		end
	else
		add_file_res('auto_ab')
	end
	str = string.gsub(str, nx_string(btn.DataSource) .. ",", "")	
	ini:WriteString(nx_string(active), "chat_msg", str)
	ini:SaveToFile()
	nx_destroy(ini)	
	load_ab_list_npc(form)
	load_ab_list_pos(form)
	load_ab_list_chat(form)
end
on_btn_remove_pos = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	ini.FileName = add_file_res('auto_ab')
	local inifile = add_file('auto_ab')	
	local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string(active)) then
			str = ini:ReadString(nx_string(active), nx_string('pos'), '')
		else
			os.remove(add_file_res('auto_ab'))
		end
	else
		add_file_res('auto_ab')
	end
	str = string.gsub(str, nx_string(btn.DataSource) .. ";", "")	
	ini:WriteString(nx_string(active), "pos", str)
	ini:SaveToFile()
	nx_destroy(ini)	
	load_ab_list_npc(form)
	load_ab_list_pos(form)
	load_ab_list_chat(form)
end
on_btn_remove_npc = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	ini.FileName = add_file_res('auto_ab')
	local inifile = add_file('auto_ab')	
	local active = wstrToUtf8(readIni(inifile,'Setting','active',''))
	local str = ""
	if not ini:LoadFromFile()or not ini:FindSection(nx_string(active)) then return end
	str = ini:ReadString(nx_string(active), nx_string('npc_sell'), '')
	str = string.gsub(str, nx_string(btn.DataSource) .. ",", "")
	ini:WriteString(nx_string(active), "npc_sell", str)
	ini:SaveToFile()	
	load_ab_list_npc(form)
	load_ab_list_pos(form)
	load_ab_list_chat(form)
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
	multitextbox.HtmlText = utf8ToWstr('<a style="'..nx_string(style)..'"> ' .. nx_string(text) .. '</a>') 
	multitextbox.Height = multitextbox:GetContentHeight() + 5
	multitextbox.Left = 10
	multitextbox.Top = 0		
	multitextbox.DataSource = nx_string(data_source)
	nx_bind_script(multitextbox, nx_string(script_name))
	nx_callback(multitextbox, 'on_click_hyperlink', nx_string(call_back_func_name))
	return multitextbox
end


