require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_qn'
inifile = nil
listsrc = ''
array_list_src = nil
array_questn = nil
function main_form_init(form)
	form.Fixed = false
	form.title = ''
	form.qn_task = ''	
end


function on_main_form_open(form)	
	updateBtnAuto()
	local ini_file = add_file_user('auto_ai')	
	
	form.cbx_input_sh.config = ''
	form.qn_task = ''
	form.title = ''
	local inifile = add_file('auto_qn')
	local ini = nx_create('IniDocument')
	if not nx_is_valid(ini) then
        return
    end
	ini.FileName = nx_string(inifile) 
	if ini:LoadFromFile() then
		loadGridAutoSkill(form)
	end		
	load_tiguan_one(form)	
end 
function get_new_school()
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return "0"
  end
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return "0"
  end
  local playerschool = client_player:QueryProp("NewSchool")
  return nx_string(playerschool)
end
function load_tiguan_one(form)
	form.cbx_input_sh.DropListBox:ClearString()	
	local file_data = add_file_res('auto_qn')	
	local new_school = get_new_school()
	local IniManager = nx_value("IniManager")
	if not nx_is_valid(IniManager) then
		return false
	end
	local file = "auto_data\\auto_qn.ini"
	if not IniManager:IsIniLoadedToManager(file) then
		IniManager:LoadIniToManager(file)
	end
	local ini = IniManager:GetIniDocument(file)
	if not nx_is_valid(ini) then
		return false
	end
	local sec_index = ini:FindSectionIndex((new_school))
 	if sec_index < 0 then
		return false
 	end
	local keys_count = ini:GetSectionItemCount(sec_index)	 
	for i = 1, keys_count do		
		local query_school = ini:GetSectionItemValue(sec_index,i-1)--wstrToUtf8(readIni(file_data,new_school,i,''))
		local split_item = auto_split_string(query_school,';')
		if split_item[2] ~= nil then
			form.cbx_input_sh.DropListBox:AddString(nx_value('gui').TextManager:GetText(split_item[2]))
		end
	end	
end

function btn_add_mon_hk(btn)	
	local form = btn.ParentForm
	local file = add_file('auto_qn')	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	local tmp_str = ''
	local check_list = nx_string(readIni(file,nx_string('Setting'),'list_title',''))
	local list_src = form.cbx_input_sh.InputEdit.Text
	local game_client = nx_value('game_client')	
	local scene = game_client:GetScene()
	local scene_obj_table = scene:GetSceneObjList()
	local check_npc = false
	listsrc = ''
	list_tasks = ''
	local client_player = game_client:GetPlayer()
	if array_list_src == nil then array_list_src = {} end
	if array_questn == nil then array_questn = {} end
	list_task = nx_string(form.qn_task)	
	list_mon = wstrToUtf8(form.cbx_input_sh.InputEdit.Text)	
	table.insert(array_questn,list_task)
	table.insert(array_list_src,list_mon)
	for k = 1, table.getn(array_list_src) do
		if array_list_src[k] ~= "" then			
			listsrc = listsrc..array_list_src[k]..','
		end
	end
	for j = 1, table.getn(array_questn) do
		if array_questn[j] ~= "" then			
			list_tasks = list_tasks..array_questn[j]..','
		end
	end
	writeIni(file,nx_string('Setting'), "list_title",utf8ToWstr(listsrc))
	writeIni(file,nx_string('Setting'), "list_task",utf8ToWstr(list_tasks))
	loadGridAutoSkill(form)
end
function on_btn_close_click(form)   
  local form = nx_value("auto_new\\form_auto_qn")
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end
function on_cbx_input_sh_selected(cbx)
	local form = cbx.ParentForm	
	local new_school = get_new_school()
	form.qn_task = ''
	local file_data = add_file_res('auto_qn')	
	local new_school = get_new_school()
	local IniManager = nx_value("IniManager")
	if not nx_is_valid(IniManager) then
		return false
	end
	local file = "auto_data\\auto_qn.ini"
	if not IniManager:IsIniLoadedToManager(file) then
		IniManager:LoadIniToManager(file)
	end
	local ini = IniManager:GetIniDocument(file)
	if not nx_is_valid(ini) then
		return false
	end
	local sec_index = ini:FindSectionIndex((new_school))
 	if sec_index < 0 then
		return false
 	end
	local keys_count = ini:GetSectionItemCount(sec_index)	
	for i = 1, keys_count do		
		local query_school = ini:GetSectionItemValue(sec_index,i-1)--wstrToUtf8(readIni(file_data,new_school,i,''))
		local split_item = util_split_string(query_school,';')		
		if split_item[2] ~= nil then
			if form.cbx_input_sh.InputEdit.Text == nx_value('gui').TextManager:GetText(split_item[2]) then
				form.qn_task = split_item[1]
				form.title = nx_value('gui').TextManager:GetText(split_item[2])
				if nx_string(split_item[1]) == ('30001') then
					show_notice(utf8ToWstr('Nhiệm Vụ này có sử dụng blink khi dùng hảy chú ý'))
				end
			end
		end
	end	
end
function btn_add_start(btn)
	local form = btn.ParentForm	
	local run = true
	if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') then
		showUtf8Text('Please Stop Running AI')
		return
	end
	if nx_running('auto_new\\form_auto_ai_new','exe_auto_qn_state_only') then		
		nx_execute('auto_new\\form_auto_ai_new','turn_off_auto_qn_only')
		nx_kill('auto_new\\form_auto_ai_new','exe_auto_qn_state_only')
		if nx_running('auto_new\\form_auto_ai_new','exe_auto_qn_state_only') then			
			nx_kill('auto_new\\form_auto_ai_new','exe_auto_qn_state_only')
		end
	else
		nx_execute('auto_new\\form_auto_ai_new','exe_auto_quest_newschool_only')	
		nx_pause(1)
	end		
	updateBtnAuto()
end
-- function btn_add_start(btn)
	-- local form = btn.ParentForm	
	-- -- if click_mouse_fast == nil then click_mouse_fast = 0 end	
	-- -- if timerDiff(click_mouse_fast) < 2 then
			-- -- showUtf8Text('Bạn không được click quá nhanh')
		-- -- return
	-- -- end			
	-- -- click_mouse_fast = timerStart()	
	-- -- if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_qn_state_only') then	
		-- -- showUtf8Text(auto_please_wait_stop)
		-- -- auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_qn',false)		
		-- -- -- nx_kill('auto_new\\form_auto_ai_new','exe_auto_qn_state_only')
		-- -- -- if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_qn_state_only') then			
			-- -- -- nx_kill('auto_new\\form_auto_ai_new','exe_auto_qn_state_only')
		-- -- -- end
	-- -- else		
		-- -- if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
			-- -- showUtf8Text(auto_ai_running_wait_stop)
			-- -- return
		-- -- end
		-- -- if not check_auto_special_running() then
			-- -- return
		-- -- end
		-- -- auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_quest_newschool_only')	
		-- -- updateBtnAuto()
		-- -- nx_pause(1)
	-- -- end	
	-- -- updateBtnAuto()
-- end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_qn")
	if not nx_is_valid(form) then return end
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_qn_state_only') then
		form.btn_add_start.Text = nx_widestr('Stop')
	else
		form.btn_add_start.Text = nx_widestr('Start')		
	end
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_qn")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Start')	
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_qn")
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
	local file = add_file('auto_qn')
	ini.FileName = file
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	if ini:LoadFromFile() then	
		if ini:FindSection('Setting') then		
			local pos_table = wstrToUtf8(readIni(file,nx_string('Setting'),'list_title',''))
			local list_task = wstrToUtf8(readIni(file,nx_string('Setting'),'list_task',''))
			local split_task = auto_split_string(list_task,',')
			local split_item = auto_split_string(pos_table,',')
			listsrc = pos_table
			array_questn = split_task
			array_list_src = split_item
			if nx_number(table.getn(split_item)) > 0 then
				for i = 1, table.getn(split_item) do									
					local btn_del = create_multitextbox(THIS_FORM, 'on_click_btn_del',auto_del,split_item[i], 'HLStypebargaining',split_task[i])
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
	local data_item2 = ''
	local ini = nx_create("IniDocument")
	if not nx_is_valid(ini) then
        return
    end
	local file = add_file('auto_qn')
	ini.FileName = file	
	if not ini:LoadFromFile()or not ini:FindSection(nx_string('Setting')) then return end
	local str = ini:ReadString(nx_string('Setting'), 'list_title', '')
	local list_tasks = ini:ReadString(nx_string('Setting'), 'list_task', '')
	local list_task =  auto_split_string(nx_string(list_tasks),',')	
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
	local data2 = btn.DataSource2
	for i =1, table.getn(list_task) do		
		if list_task[i] == data2 then			
			table.remove(list_task, i)
		end
	end
	for j = 1, table.getn(list_task) do		
		data_item2 = data_item2..','..list_task[j]
	end	
	for i =1, table.getn(list) do		
		if list[i] == data then			
			table.remove(list, i)
		end
	end
	for j = 1, table.getn(list) do		
		data_item = data_item..','..list[j]
	end
	ini:WriteString(nx_string('Setting'), "list_title", data_item)
	ini:WriteString(nx_string('Setting'), "list_task", data_item2)
	ini:SaveToFile()	
	loadGridAutoSkill(form)
end

create_multitextbox = function(script_name, call_back_func_name, text, data_source,style,data_source2)
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
	multitextbox.DataSource2 = nx_string(data_source2)
	nx_bind_script(multitextbox, nx_string(script_name))
	nx_callback(multitextbox, 'on_click_hyperlink', nx_string(call_back_func_name))
	return multitextbox
end


