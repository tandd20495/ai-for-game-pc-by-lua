require('auto_new\\autocack')

function main_form_init(form)
  form.Fixed = false
end
FORM_MAP_SCENE= 'form_stage_main\\form_map\\form_map_scene'
local sw_scene_info_list = {
{'city01', '578.185,-143.602,1234.753'},
{'born04', '623.345,-39.684,678.738'},
{'born04', '714.927,-3.940,1025.943'},
{'city02', '798.378,3.547,772.174'},
{'city02', '103.343,18.101,1302.65'},
{'city02', '97.450,18.101,1334.474'},
{'born03', '604.876,2.111,787.207'},
{'born03', '740.004,10.135,1033.341'},
{'born03', '740.943,10.135,1057.896'},
}
function on_main_form_open(form)
	load_farm_scene(form.combobox_itemname)
	local seed_list = on_bag_sw_reload()
	form.edt_item_add.Text = utf8ToWstr(seed_list)
	local file = add_file('auto_sw')	
	local only = readIni(file,'Setting','only_scene','')
	if nx_string(only) == nx_string('true') then
		form.check_box_6.Checked = true
	end
	click_mouse_fast = 0
end
function on_main_form_close(form) 
	 nx_destroy(form)	
end
function on_btn_close_click(form)
	local form = nx_value('auto_new\\form_auto_sw')
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function btn_start_add(btn)
	local form = btn.ParentForm
	save_data_auto_sw(form)
	nx_destroy(form)
end
function save_data_auto_sw(form)
	local file = add_file('auto_sw')	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	local select_index = form.combobox_itemname.DropListBox.SelectIndex+1
	local list_item = form.edt_item_add.Text
	local list_name = sw_scene_info_list[select_index]	
	local only_scene = form.check_box_6.Checked
	writeIni(file,'Setting','index',select_index)
	writeIni(file,'Setting','scene',list_name[1])
	writeIni(file,'Setting','pos',list_name[2])
	writeIni(file,'Setting','item_list',list_item)
	writeIni(file,'Setting','only_scene',only_scene)
	if form.check_box_6.Checked then
		local x,y,z = getCurPos()
		writeIni(file,'Setting','pos',string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z))
		writeIni(file,'Setting','scene',cur_scene_id)
	end
end
function btn_start_auto(btn)
	local form = btn.ParentForm
	if click_mouse_fast == nil then click_mouse_fast = 0 end
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()		
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_sw_state_only') then
		showUtf8Text(auto_please_wait_stop)
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_sw','',false)		
		-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_sw_state_only')
		-- if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_sw_state_only') then			
			-- nx_kill('auto_new\\form_auto_ai_new','exe_auto_sw_state_only')
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
		save_data_auto_sw(form)
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_sw_only')	
		nx_pause(1)			
	end	
	updateBtnAuto()
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_sw")
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_sw_state_only') then
		form.btn_start_auto.Text = nx_widestr('Stop')
	else
		form.btn_start_auto.Text = nx_widestr('Start')		
	end
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_sw")
	if not nx_is_valid(form) then return end			
	form.btn_start_auto.Text = nx_widestr('Start')	
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_sw")
	if not nx_is_valid(form) then return end			
	form.btn_start_auto.Text = nx_widestr('Stop')	
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

load_farm_scene = function(cbx)
	cbx.DropListBox:ClearString()
	cbx.InputEdit.Text = ""
	local current_map = nx_value("form_stage_main\\form_map\\form_map_scene").current_map
	local index = 0
	for i = 1, table.getn(sw_scene_info_list) do
		if nx_string(current_map) == nx_string(sw_scene_info_list[i][1]) then index = i - 1 end
		local tmp = auto_split_string(sw_scene_info_list[i][2], ',')
		local x = string.format("%d", nx_number(tmp[1]))
		local z = string.format("%d", nx_number(tmp[3]))
		local str = utf8ToWstr(wstrToUtf8(getText(sw_scene_info_list[i][1])).. ' - Tọa Độ: ' .. x ..','.. z)
		cbx.DropListBox:AddString(str)
	end
	cbx.DropListBox.SelectIndex = index
	cbx.InputEdit.Text = cbx.DropListBox:GetString(index)
end
function btn_start_reload(btn)
	local form = btn.ParentForm
	local seed_list = on_bag_sw_reload()
	form.edt_item_add.Text = utf8ToWstr(seed_list)
end
on_bag_sw_reload = function()
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return end
	local seed_list = ''
	local view = game_client:GetView(nx_string('123'))
	if not nx_is_valid(view) then return end
	local view_obj_table = view:GetViewObjList()
	for i = 1, table.getn(view_obj_table) do
		local tmp_conf_id = view_obj_table[i]:QueryProp('ConfigID')
		local item_type = view_obj_table[i]:QueryProp('ItemType')
		if item_type == 40 and string.match(nx_string(tmp_conf_id), '^seed6[3-9]$') then
			seed_list = getUtf8Text(tmp_conf_id) .. ',' .. seed_list
		end
	end
	return seed_list
end