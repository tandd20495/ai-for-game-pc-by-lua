require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_qt'
inifile = nil
listsrc = ''
array_list_src = nil
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end
function on_main_form_open(form)
	updateBtnAuto()
	local ini_file = add_file('auto_qt')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(ini_file) 
	if ini:LoadFromFile() then
	else		
		writeIni(ini_file,nx_string(1), "info", '')
	end	
	load_qt_list(form)
	load_qt_list_remove(form)
end 
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_qt")
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
	if nx_execute('custom_handler','getStateAutoQT') then		
		nx_execute('custom_handler','setStateAutoQT',false)
		if nx_running('auto_new\\auto_script','exe_auto_run_qt') then
			nx_kill('auto_new\\auto_script','exe_auto_run_qt')
		end
	else
		nx_execute('custom_handler','setStateAutoQT',true)
	end	
	updateBtnAuto()
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_qt")	
	if nx_execute('custom_handler','getStateAutoQT') then
		form.btn_add_start.Text = utf8ToWstr('Đang Bật')
	else
		form.btn_add_start.Text = utf8ToWstr('Đang Tắt')		
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


function load_qt_list(form)
	local ini = nx_create('IniDocument')
	local grid = form.textgrid_pos
	if not nx_is_valid(ini) then return end
	ini.FileName = add_file('auto_qt')
	local remove_info = nil
	local add_info = nil
	if ini:LoadFromFile() and ini:FindSection(nx_string(1)) then
		remove_info = ';' .. ini:ReadString(nx_string(1), nx_string('remove_info'), '')			
		add_info = ini:ReadString(nx_string(1), nx_string('info'), '')
	end
	local add_npc_list_array = auto_split_string(nx_string(add_info), ';')
	nx_destroy(ini)
	local gui = nx_value('gui') 
	grid:ClearRow()
	grid:ClearSelect()
	for j = 1, table.getn(add_npc_list_array) do			
		local npc_name = utf8ToWstr(add_npc_list_array[j])
		if gui.TextManager:IsIDName(add_npc_list_array[j]) then
			npc_name = getText(nx_string(add_npc_list_array[j]))
		end	
		local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move', wstrToUtf8(npc_name), 'HLChatItem1')			
		local btn_del = create_multitextbox(THIS_FORM, 'on_btn_remove_npc_add',auto_del,add_npc_list_array[j], 'HLStypebargaining')	
		gridAndFunc(grid,multitextbox,btn_del)	
	end
	for i = 1, table.getn(list_kyngo) do
		local npc_name = utf8ToWstr(list_kyngo[i])
		local tmp_name = ';' .. list_kyngo[i] .. ';'
		if not remove_info or not string.find(remove_info, tmp_name, 1, true) then			
			if gui.TextManager:IsIDName(list_kyngo[i]) then
				npc_name = getText(nx_string(list_kyngo[i]))
				local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move', wstrToUtf8(npc_name), 'HLChatItem1')
				local btn_del = create_multitextbox(THIS_FORM, 'on_btn_remove_npc',auto_del,list_kyngo[i], 'HLStypebargaining')	
				gridAndFunc(grid,multitextbox,btn_del)		
			end
		end
	end	
end
function load_qt_list_remove(form)
	local ini = nx_create('IniDocument')
	local grid = form.textgrid_pos_1	
	grid.Visible = false
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end
	ini.FileName = add_file('auto_qt')
	if not ini:LoadFromFile() then nx_destroy(ini) return end
	local gui = nx_value('gui') 
	if not ini:FindSection(nx_string(1)) then return end
	local remove_QT_list = ini:ReadString(nx_string(1), nx_string('remove_info'), '')
	if remove_info ~= '' then  else nx_destroy(ini) return end
	if remove_QT_list == nil or remove_QT_list == '' then
		nx_destroy(ini)
		return
	else
		grid.Visible = true
	end
	local remove_npc_list_array = auto_split_string(remove_QT_list, ';')
	if remove_npc_list_array == nil or table.getn(remove_npc_list_array) == 0 then
		ini:WriteString(nx_string(1), 'remove_info', '')
		ini:SaveToFile()
		nx_destroy(ini)
		grid.Visible = false
		return
	end
	grid:ClearRow()
	grid:ClearSelect()
	for i = 1, table.getn(remove_npc_list_array) do		
		local npc_name = utf8ToWstr(remove_npc_list_array[i])
		if gui.TextManager:IsIDName(remove_npc_list_array[i]) then
			npc_name = getText(nx_string(remove_npc_list_array[i]))
			local multitextbox = create_multitextbox(THIS_FORM, 'on_click_hyper_move', wstrToUtf8(npc_name)..'-'..remove_npc_list_array[i], 'HLChatItem1')
			local btn_del = create_multitextbox(THIS_FORM, 'on_btn_add_npc_re',auto_del,remove_npc_list_array[i], 'HLStypebargaining')	
			gridAndFunc(grid,multitextbox,btn_del)	
		end		
	end
	nx_destroy(ini)	
end
on_cbtn_auto_box_2 = function(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then	
		return
	end	
	local inifile = add_file('auto_qt')
	if form.check_box_2.Checked then		
		writeIni(inifile,'Setting', "pick_all", 'true')
	else
		writeIni(inifile,'Setting', "pick_all", 'false')
	end
end
btn_add_mon_hk = function(btn)
	local f = btn.ParentForm	
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
		return 
	end
	local str = nil
	ini.FileName = add_file('auto_qt')
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string(1)) then
			str = ini:ReadString(nx_string(1), nx_string('info'), '')
		else
			os.remove(add_file('auto_qt'))
		end
	end
	if str == nil or str == "" then str = ";" end
	local target = nx_value('game_select_obj')
	local npcname = nil
	if nx_is_valid(target) then
		str = str .. ";" .. wstrToUtf8(util_text(target:QueryProp('ConfigID'))) .. ";"
	else
		str = str .. ";" .. wstrToUtf8(f.edt_item_add.Text) .. ";"
	end
	
	ini:WriteString(nx_string(1), "info", str)
	ini:SaveToFile()
	nx_destroy(ini)	
	f.edt_item_add.Text = ""
	load_qt_list(f)
	load_qt_list_remove(f)
end
on_btn_add_npc_re = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end
	local str = ";"
	ini.FileName = add_file('auto_qt')
	if not ini:LoadFromFile()or not ini:FindSection(nx_string(1)) then return end
	str = ini:ReadString(nx_string(1), nx_string('remove_info'), '')
	str = ";" .. str
	str = string.gsub(str, ";" .. nx_string(btn.DataSource) .. ";", "")
	ini:WriteString(nx_string(1), "remove_info", str)
	ini:SaveToFile()
	nx_destroy(ini)
	local npc_name = nx_string(btn.DataSource)
	if nx_value("gui").TextManager:IsIDName(npc_name) then
		npc_name = getUtf8Text(npc_name)
	end
	load_qt_list(form)
	load_qt_list_remove(form)
end
on_btn_remove_npc = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	ini.FileName = add_file('auto_qt')
	if ini:LoadFromFile()then
		if ini:FindSection(nx_string(1)) then
			str = ini:ReadString(nx_string(1), nx_string('remove_info'), '')
		else
			os.remove(add_file('auto_qt'))
		end
	else
		add_file('auto_qt')
	end
	str = str .. ";" .. nx_string(btn.DataSource) .. ";"
	ini:WriteString(nx_string(1), "remove_info", str)
	ini:SaveToFile()
	nx_destroy(ini)
	local npc_name = nx_string(btn.DataSource)
	if nx_value("gui").TextManager:IsIDName(npc_name) then
		npc_name = getUtf8Text(npc_name)
	end
	load_qt_list(form)
	load_qt_list_remove(form)
end
on_btn_remove_npc_add = function(btn)
	local form = btn.ParentForm
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then return end	
	ini.FileName = add_file('auto_qt')
	local str = ";"
	if not ini:LoadFromFile()or not ini:FindSection(nx_string(1)) then return end
	str = ini:ReadString(nx_string(1), nx_string('info'), '')
	str = ";" .. str
	str = string.gsub(str, ";" .. nx_string(btn.DataSource) .. ";", "")
	ini:WriteString(nx_string(1), "info", str)
	ini:SaveToFile()
	local npc_name = nx_string(btn.DataSource)
	if nx_value("gui").TextManager:IsIDName(npc_name) then
		npc_name = getUtf8Text(npc_name)
	end
	load_qt_list(form)
	load_qt_list_remove(form)
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


