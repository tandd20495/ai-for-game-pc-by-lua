require('auto_new\\autocack')
local THIS_FORM = 'auto_new\\form_auto_at'
inifile = nil
listsrc = ''
array_list_src = nil
function main_form_init(form)
	form.Fixed = false
	form.skillid = ""	
end

	
function on_main_form_open(form)	
	
	local ini_file = add_file('auto_ai')
	--updateBtnAuto()
	form.cbx_input_sh.config = ''
	local inifile = add_file('auto_at')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(inifile) 
	if ini:LoadFromFile() then
	else		
		writeIni(inifile,'Setting', "list_title", 'ui_tiguan_name_2')
	end	
	loadGridAutoSkill(form)
	load_tiguan_one(form)	
end 
function load_tiguan_one(form)
	form.cbx_input_sh.DropListBox:ClearString()
	for i = 2 , 32 do
		form.cbx_input_sh.DropListBox:AddString(util_text('ui_tiguan_name_'..i))		
	end
	form.cbx_input_sh.DropListBox.SelectIndex = 0
	form.cbx_input_sh.InputEdit.Text = form.cbx_input_sh.DropListBox:GetString(0)
end
function on_cbx_input_sh_selected(cbx)
	
end

function btn_add_mon_hk(btn)	
	local form = btn.ParentForm
	local file = add_file('auto_at')	
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
	list_mon = wstrToUtf8(form.cbx_input_sh.InputEdit.Text)	
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
  local form = nx_value("auto_new\\form_auto_at")
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
	if run then
		showUtf8Text(AUTO_LOG_AUTO_ERROR_START_WITH_AI)
		return
	end
	if nx_running('auto_new\\autocack','exe_auto_tun_ti_today') then
		nx_execute('auto_new\\autocack','exe_auto_tun_ti_today')
		start_ti_td = false
		if nx_running('auto_new\\autocack','exe_auto_tun_ti_today') then
			nx_kill('auto_new\\autocack','exe_auto_tun_ti_today')
		end
	else
		nx_execute('auto_new\\autocack','exe_auto_tun_ti_today')		
	end	
	updateBtnAuto()
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_at")
	if nx_running('auto_new\\autocack','exe_auto_tun_ti_today') then
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
	local file = add_file('auto_at')
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
	local file = add_file('auto_at')
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


