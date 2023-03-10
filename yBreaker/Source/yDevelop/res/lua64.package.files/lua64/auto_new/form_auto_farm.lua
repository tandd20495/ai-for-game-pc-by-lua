require('auto_new\\autocack')

function main_form_init(form)
  form.Fixed = false
end
FORM_MAP_SCENE= 'form_stage_main\\form_map\\form_map_scene'
local pl_scene_info_list = {
{'born01', '540.639,18.976,202.848'},
{'born01', '563.517,18.976,198.182'},
{'born01', '597.035,18.976,203.763'},
{'born01', '629.486,15.498,171.609'},
{'born01', '611.965,16.056,167.616'},
{'born01', '589.799,16.471,158.853'},
{'born01', '564.178,16.272,157.463'},
{'born01', '539.335,16.092,157.762'},
{'born01', '516.073,15.125,164.599'},
{'city05', '516.295,16.776,788.824'},
{'city05', '484.672,20.508,776.765'},
{'city05', '472.634,16.738,736.321'},
{'city05', '482.849,20.671,776.242'},
{'city05', '499.034,19.498,797.232'},
{'city02', '780.055,4.709,591.171'},
{'city02', '782.321,5.708,612.158'},
{'city02', '780.839,4.787,633.040'},
{'city02', '798.438,4.709,652.690'},
{'city02', '777.549,0.101,661.764'},
{'city02', '796.275,0.187,692.987'},
{'city02', '778.904,-0.410,716.533'},
{'city02', '744.460,-0.410,692.067'},
{'city02', '734.506,-0.410,655.182'},
{'city01', '869.522,-91.354,-39.594'},
{'city01', '871.492,-92.872,-23.550'},
{'city01', '872.662,-95.480,-4.945'},
{'city01', '872.359,-96.970,11.107'},
{'city01', '872.246,-96.846,9.916'},
{'city01', '821.642,-97.928,9.096'},
{'city01', '818.006,-97.928,-13.125'},
{'city01', '816.045,-97.928,-30.785'},
{'city04', '1257.323,-26.885,813.927'},
{'city04', '1234.283,-26.884,830.751'},
{'city04', '1223.140,-26.884,846.815'},
}
function on_main_form_open(form)
	load_farm_scene(form.combobox_itemname)
	updateBtnAuto()
	local file = add_file('auto_crop')
	local seed_list = on_bag_seed_reload()
	form.edt_item_add.Text = utf8ToWstr(seed_list)
	local remove_list = wstrToUtf8(readIni(file,'Setting','remove_list',''))
	form.edt_item_remove.Text = utf8ToWstr(remove_list)	
	local trash = readIni(file,'Setting','trash','')
	if nx_string(trash) == nx_string('true') then
		form.check_box_7.Checked = true
	end
	local only = readIni(file,'Setting','only_scene','')
	if nx_string(only) == nx_string('true') then
		form.check_box_6.Checked = true
	end
	local only1 = readIni(file,'Setting','type','')
	if nx_string(only1) == nx_string('nlb') then
		form.check_box_3.Checked = true
	elseif nx_string(only1) == nx_string('hoa') then
		form.check_box_2.Checked = true
	else
		form.check_box_1.Checked = true
	end	
	click_mouse_fast = 0
end
function on_main_form_close(form) 
	 nx_destroy(form)	
end
function on_btn_close_click(form)
	local form = nx_value('auto_new\\form_auto_farm')
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
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
	local file = add_file('auto_crop')
	local list_save = ''
	local no_item = game_hand:IsEmpty() or game_hand.Type ~= "viewitem" or (para1 ~= "121" and para1 ~= "2" and para1 ~= "123" and para1 ~= "125")	
	if no_item then return nil end	
    local item = nx_execute('goods_grid', 'get_view_item', game_hand.Para1, game_hand.Para2)
	if nx_is_valid(item) then
		local list_item = wstrToUtf8(readIni(file,'Setting','remove_list',''))
		local list_split = auto_split_string(list_item,',')
		local item_config = item:QueryProp('ConfigID')
		local item_name = getUtf8Text(item_config)	
		table.insert(list_split,item_name)
		for i = 1 , table.getn(list_split) do
			if list_split[i] ~= '' then
				list_save = list_save..','..list_split[i]
			end
		end
		writeIni(file,'Setting','remove_list',utf8ToWstr(list_save))		
	end 
	local remove_list = wstrToUtf8(readIni(file,'Setting','remove_list',''))
	form.edt_item_remove.Text = utf8ToWstr(remove_list)	
	game_hand:ClearHand()
end
function btn_start_add(btn)
	local form = btn.ParentForm
	save_data_auto_farm(form)
	nx_destroy(form)
end
function save_data_auto_farm(form)
	local file = add_file('auto_crop')	
	local cur_scene_id = nx_value(FORM_MAP_SCENE).current_map
	local select_index = form.combobox_itemname.DropListBox.SelectIndex+1
	local list_item = form.edt_item_add.Text
	local list_name = pl_scene_info_list[select_index]	
	local trash_check = form.check_box_7.Checked
	local only_scene = form.check_box_6.Checked
	writeIni(file,'Setting','index',select_index)
	writeIni(file,'Setting','scene',list_name[1])
	writeIni(file,'Setting','trash',trash_check)
	writeIni(file,'Setting','pos',list_name[2])	
	writeIni(file,'Setting','item_list',list_item)
	writeIni(file,'Setting','only_scene',only_scene)
	writeIni(file,'Setting','remove_list',form.edt_item_remove.Text)	
	if form.check_box_6.Checked then
		local x,y,z = getCurPos()
		writeIni(file,'Setting','pos',string.format('%.3f', x) .. ',' .. string.format('%.3f', y) .. ',' .. string.format('%.3f', z))
		writeIni(file,'Setting','scene',cur_scene_id)
	end
	if form.check_box_3.Checked then
		writeIni(file,'Setting','type','nlb')
	elseif form.check_box_2.Checked then
		writeIni(file,'Setting','type','hoa')
	else
		writeIni(file,'Setting','type','trong')
	end	
end
function btn_add_start(btn)
	local form = btn.ParentForm	
	if click_mouse_fast == nil then click_mouse_fast = 0 end
	if timerDiff(click_mouse_fast) < 2 then
			showUtf8Text('Bạn không được click quá nhanh')
		return
	end		
	click_mouse_fast = timerStart()		
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_pl_state_only') then	
		showUtf8Text(auto_please_wait_stop)		
		auto_execute_full('auto_new\\form_auto_ai_new','turn_off_auto_pl',false)
		click_mouse_fast = 0	
	else		
		if auto_ai_status or nx_running('auto_new\\autocack','auto_start_ai') or nx_running('auto_new\\form_auto_ai_new','auto_start_ai') or nx_running('auto_new\\form_auto_ai','auto_start_ai2') then
			showUtf8Text(auto_ai_running_wait_stop)
			return
		end
		if not check_auto_special_running() then
			return
		end
		save_data_auto_farm(form)
		auto_execute_full('auto_new\\form_auto_ai_new','exe_auto_pl_only')
		nx_pause(1)	
	end	
	updateBtnAuto()
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_farm")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Start')	
end
function updateBtnStop()
	local form = nx_value("auto_new\\form_auto_farm")
	if not nx_is_valid(form) then return end			
	form.btn_add_start.Text = nx_widestr('Stop')	
end
function updateBtnAuto()
	local form = nx_value("auto_new\\form_auto_farm")
	if auto_running_full('auto_new\\form_auto_ai_new','exe_auto_pl_state_only') then	
		form.btn_add_start.Text = nx_widestr('Stop')
	else
		form.btn_add_start.Text = nx_widestr('Start')		
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

load_farm_scene = function(cbx)
	cbx.DropListBox:ClearString()
	cbx.InputEdit.Text = ""
	local current_map = nx_value("form_stage_main\\form_map\\form_map_scene").current_map
	local index = 0
	for i = 1, table.getn(pl_scene_info_list) do
		if nx_string(current_map) == nx_string(pl_scene_info_list[i][1]) then index = i - 1 end
		local tmp = auto_split_string(pl_scene_info_list[i][2], ',')
		local x = string.format("%d", nx_number(tmp[1]))
		local z = string.format("%d", nx_number(tmp[3]))
		local str = utf8ToWstr(wstrToUtf8(getText(pl_scene_info_list[i][1])).. ' - Tọa Độ: ' .. x ..','.. z )
		cbx.DropListBox:AddString(str)
	end
	cbx.DropListBox.SelectIndex = index
	cbx.InputEdit.Text = cbx.DropListBox:GetString(index)
end
function btn_start_reload(btn)
	local form = btn.ParentForm
	local seed_list = on_bag_seed_reload()
	form.edt_item_add.Text = utf8ToWstr(seed_list)
end

on_bag_seed_reload = function()
	local game_client = nx_value('game_client')
	if not nx_is_valid(game_client) then return end
	local seed_list = ''
	local view = game_client:GetView(nx_string('123'))
	if not nx_is_valid(view) then return end
	local view_obj_table = view:GetViewObjList()
	for i = 1, table.getn(view_obj_table) do
		local tmp_conf_id = view_obj_table[i]:QueryProp('ConfigID')
		local item_type = view_obj_table[i]:QueryProp('ItemType')
		if item_type == 40 and not string.match(nx_string(tmp_conf_id), '^seed6[3-9]$') then
			seed_list = getUtf8Text(tmp_conf_id) .. ',' .. seed_list
		end
	end
	return seed_list
end
function check_box_auto(cbtn)
	if cbtn.Checked == false then
		return
	end
	local form = cbtn.ParentForm	
	local i = nx_number(cbtn.TabIndex) 
	set_tag_enable(form, i) 
end
function set_tag_enable(form, i)
  local k = "check_box_"
  for l = 1, 3 do
    local h = k .. nx_string(l)
    if nx_find_custom(form, h) then
      local enable = nx_custom(form, h)
      enable.Checked = nx_int(i) == nx_int(l)
    end
  end
end
function check_box_cay(cbtn)
	local form = cbtn.ParentForm
	if not nx_is_valid(form) then
		return
	end	
	-- nx_pause(0)
	-- if form.check_box_hoa.Checked then
		
	-- end
	-- if form.check_box_niemla.Checked then
		
	-- end
	if not form.check_box_cay.Checked then
		form.check_box_hoa.Checked = false
		form.check_box_niemla.Checked = false
		form.check_box_cay.Checked = true		
	end	
end
function check_box_hoa(cbtn)
	local form = cbtn.ParentForm
	if not nx_is_valid(form) then
		return
	end	
	-- nx_pause(0)	
	-- if form.check_box_cay.Checked then
		
	-- end
	-- if form.check_box_niemla.Checked then
		
	-- end
	if not form.check_box_hoa.Checked then
		form.check_box_cay.Checked = false
		form.check_box_niemla.Checked = false
		form.check_box_hoa.Checked = true		
	end
	
end
function check_box_niemla(cbtn)
	local form = cbtn.ParentForm	
	if not nx_is_valid(form) then
		return
	end	
	-- nx_pause(0)	
	-- if form.check_box_hoa.Checked then
		
	-- end
	-- if form.check_box_cay.Checked then
		
	-- end	
	if not form.check_box_niemla.Checked then
		form.check_box_hoa.Checked = false
		form.check_box_cay.Checked = false
		form.check_box_niemla.Checked = true	
	end	
end
