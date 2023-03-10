--[[ **form_auto_ai_set.lua**
	@Author: Nockasdd (nockasdd@gmail.com)
	@Package: Auto AUTO CACK
	@Version: 1.0
--]]
require('auto_new\\autocack')
require('auto_new\\form_auto_ai')

--Define
local path_lib = 'auto_new\\autocack'
local path_form = 'auto_new\\form_auto_ai_set'
local path_form_main = 'auto_new\\form_auto_ai'
local index_select = 0
local index_selec_2 = 0
function main_form_init(form)
    form.Fixed = false		
	form.index = 0
	index_select = 0
	index_selec_2 = 0
end
function on_main_form_open(form)	
  init_ui_content(form)
end
function show_hide_form()
  util_auto_show_hide_form(path_form)
end

function init_ui_content(form)	
	loadAutoHunterCombo(form)
	form.btn_start_use.Enabled = false
	local file = add_file_user('auto_ai')
	local string_ini = wstrToUtf8(readIni(file,nx_string('Setting'),'list',''))
	local string_list = auto_split_string(string_ini,';')	
	if nx_number(form.index) > nx_number(0) then
		local split_auto = auto_split_string(string_list[nx_number(form.index)],',')
		form.edt_start_time.Text = nx_widestr(split_auto[2])
		form.edt_end_time.Text = nx_widestr(split_auto[3])	
		form.cbx_list_auto_select.DropListBox.SelectIndex = nx_int(split_auto[4])
		form.cbx_list_auto_select.InputEdit.Text = form.cbx_list_auto_select.DropListBox:GetString(nx_int(split_auto[4]))
		on_cbx_item_pick_selected_2(form,split_auto[4])
	end
end
function on_cbx_item_pick_selected_2(form,index2)	
	local index = form.cbx_list_auto_select.DropListBox.SelectIndex	+ 1	
	index_select = nx_number(index2 + 1)
	if nx_int(index) == nx_int(0) then
		index = 1
	end	
	if nx_int(AUTO_AI_ARRAY[index].EDIT) == nx_int(1) then
		form.btn_start_use.Enabled = true
	else	
		form.btn_start_use.Enabled = false		
	end	
end
array_config = {}
function loadAutoHunterCombo(form)
	form.cbx_list_auto_select.DropListBox:ClearString()
	form.cbx_list_auto_select.InputEdit.Text = ""	
	for i = 1,table.getn(AUTO_AI_ARRAY) do
		if AUTO_AI_ARRAY[i].EXE ~= 'none' then
			form.cbx_list_auto_select.DropListBox:AddString(utf8ToWstr(AUTO_AI_ARRAY[i].NAME))
		end		
	end
	form.cbx_list_auto_select.DropListBox.SelectIndex = nx_int(0)
	form.cbx_list_auto_select.InputEdit.Text = form.cbx_list_auto_select.DropListBox:GetString(nx_int(0))
end
load_text_auto_main = function(form)
	if nx_is_valid(form) then
		form.lbl_siri_highest_priority_title.Text = utf8ToWstr(auto_title_fish_main)
		form.btn_help.HintText = utf8ToWstr(auto_help_fish_main)
		form.lbl_1_2.Text = utf8ToWstr(auto_select_map)		
		form.btn_add_mon_fish.Text = utf8ToWstr(auto_add)		
	end
end
function btn_start_use(btn)
	local form = btn.ParentForm
	if index_select == 0 or index_select == nil then
		showUtf8Text('Select')
		return
	end
	local form_btn = AUTO_AI_ARRAY[index_select].SCRIPT	
	if form_btn ~= '' then
		util_auto_show_hide_form(form_btn)
	end
end

function on_btn_close_click(form)
	local form = nx_value(path_form)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end
get_load_setting = function(index,starttime,endtime)
	local form = nx_value(path_form)	
	if not index and not starttime and not endtime and not nx_is_valid(form) then return end
	form.edt_start_time.Text = starttime
	form.edt_end_time.Text = endtime
	form.cbx_list_auto_select.DropListBox.SelectIndex = nx_int(index)
	form.cbx_list_auto_select.InputEdit.Text = form.cbx_list_auto_select.DropListBox:GetString(nx_int(index))
end
function btn_start_save(btn)
	local form = btn.ParentForm
	local file = add_file_user('auto_ai')
	local list_new = ''
	local string_ini = wstrToUtf8(readIni(file,nx_string('Setting'),'list',''))
	local string_list = auto_split_string(string_ini,';')	
	local index_check = form.cbx_list_auto_select.DropListBox.SelectIndex
	local index = index_select	
	if nx_int(index) == nx_int(0) then
		index = 1
	end		
	local start_time = form.edt_start_time.Text
	local end_time = form.edt_end_time.Text	
	if nx_number(form.index) > nx_number(0) then
		local split_auto = auto_split_string(string_list[nx_number(form.index)],',')		
		local string_new = nx_string(index)..','..nx_string(start_time)..','..nx_string(end_time)..','..nx_string(index_check)..','..nx_string(split_auto[5])		
		for i = 1 , table.getn(string_list) do		
			string_list[nx_number(form.index)] = string_new	
			list_new = list_new..';'..string_list[i]
		end	
		writeIniString(file,nx_string('Setting'), "list",list_new)
		local form_main = nx_value(path_form_main)
		nx_execute(path_form_main,'load_auto_grid',form_main)	
		util_show_form('auto_new\\form_auto_ai_set',false)
		return
	end	
	local string_new = nx_string(index)..','..nx_string(start_time)..','..nx_string(end_time)..','..nx_string(index_check)..','..'1'	
	table.insert(string_list,string_new)
	for i = 1 , table.getn(string_list) do
		if string_list[i] ~= "" and string_list[i] ~= '0' then 
			list_new = list_new..';'..string_list[i]		
		end			
	end	
	writeIniString(file,nx_string('Setting'), "list",list_new)
	local form_main = nx_value(path_form_main)
	nx_execute(path_form_main,'load_auto_grid',form_main)	
	util_show_form('auto_new\\form_auto_ai_set',false)
end
function on_cbx_item_pick_selected(cbx)
	local form = cbx.ParentForm
	local index = form.cbx_list_auto_select.DropListBox.SelectIndex	+ 1	
	index_select = index
	if nx_int(index_select) == nx_int(0) then
		index_select = 1
	end
	if nx_int(AUTO_AI_ARRAY[index_select].INDEX) == nx_int(AI_AB) then
		show_notice('Nếu chọn Auto Cóc hãy ấn chuyển Auto cóc lên đầu không Auto Sẽ lỗi')
	end
	if nx_int(AUTO_AI_ARRAY[index_select].EDIT) == nx_int(1) then
		form.btn_start_use.Enabled = true
	else	
		form.btn_start_use.Enabled = false		
	end	
end
