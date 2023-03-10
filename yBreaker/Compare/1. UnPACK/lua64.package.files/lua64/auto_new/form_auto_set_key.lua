require("util_gui")
require("util_move")
require("util_functions")
require("util_static_data")
require("define\\sysinfo_define")
require("share\\chat_define")
require("const_define")
require("player_state\\state_const")
require("player_state\\logic_const")
require("player_state\\state_input")
require("tips_data")
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_set_key'
local FORM_TARGET = 'auto_new\\form_auto_hotkey'
local item = {}
local uid = {}
local faculty = {}
function main_form_init(form)
  form.Fixed = false
  form.skillid = ""
  form.inifile = ""
  form.select_index = 0
  form.faculty = ""
  form.config_item1 = ""
  form.uid_item1 = ""
  form.config_item2 = ""
  form.uid_item2 = ""
end

function on_main_form_open(form)		
	getItem()
	getFaculty()
	loadItemAutoDrop(form)
end
function loadItemAutoDrop(form)
	local gui = nx_value("gui")	
	form.cbx_item1.DropListBox:ClearString()
	form.cbx_item2.DropListBox:ClearString()
	form.cbx_faculty.DropListBox:ClearString()
	if nx_is_valid(gui) then
		for i = 1, table.getn(item) do
			form.cbx_item1.DropListBox:AddString(util_text(item[i]))
		end
		for i = 1, table.getn(item) do
			form.cbx_item2.DropListBox:AddString(util_text(item[i]))
		end
		for i = 1, table.getn(faculty) do
			form.cbx_faculty.DropListBox:AddString(util_text(faculty[i]))
		end
	end

end
function on_main_form_close(form)
  form.Visible = false
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	local form_main = nx_value('auto_new\\form_auto_hotkey')
	saveHotKeyIni()
	nx_execute('auto_new\\autocack','util__auto_show_form','auto_new\\form_auto_set_key')	
	if nx_is_valid(form_main) then
		nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\form_auto_hotkey','loadGridHotKey',form_main)
	end
end
function getFaculty()
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string("43") then
    			local view_obj_table = view:GetViewObjList()
    			for k = 1, table.getn(view_obj_table) do
     				local view_obj = view_obj_table[k]
     				faculty[#faculty+1] = view_obj:QueryProp("ConfigID")					
     			end
			end
		end
	end
end
function getItem()
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string("121") then
    			local view_obj_table = view:GetViewObjList()
    			for k = 1, table.getn(view_obj_table) do
     				local view_obj = view_obj_table[k]
     				item[#item+1] = view_obj:QueryProp("ConfigID")
					uid[#uid+1] = view_obj:QueryProp("UniqueID")
     			end
			end
		end
	end
end

function saveHotKeyIni()
	local form = nx_value('auto_new\\form_auto_set_key')
	local ini = add_file_user('setkey')
	local key = nx_ws_upper(form.edit_key.Text)
	writeIni(ini,nx_string(key),'type',2)
	if form.faculty ~= '' then
		writeIni(ini,nx_string(key),'faculty',form.faculty)
	else
		writeIni(ini,nx_string(key),'faculty','false')
	end
	if form.config_item1 ~= '' then
		writeIni(ini,nx_string(key),'item1',form.config_item1..','..form.uid_item1)
	else
		writeIni(ini,nx_string(key),'item1','')
	end
	if form.config_item2 ~= '' then
		writeIni(ini,nx_string(key),'item2',form.config_item2..','..form.uid_item2)
	else
		writeIni(ini,nx_string(key),'item2','')	
	end
	if form.cbtn_on_shift.Checked  then
		writeIni(ini,nx_string(key),'shift','true')
	else
		writeIni(ini,nx_string(key),'shift','false')
	end
	if form.cbtn_on_ctrl.Checked  then
		writeIni(ini,nx_string(key),'ctrl','true')
	else
		writeIni(ini,nx_string(key),'ctrl','false')
	end
end
function on_cbtn_ctrl_changed(cbtn)
	local form = cbtn.ParentForm
	if form.cbtn_on_shift.Checked then
		form.cbtn_on_shift.Checked = false
	end
end
function on_cbtn_shift_changed(cbtn)
	local form = cbtn.ParentForm
	if form.cbtn_on_ctrl.Checked then
		form.cbtn_on_ctrl.Checked = false
	end
end
function on_cbx_cbx_faculty_selected(cbx)
	local form = cbx.ParentForm
	form.select_index = form.cbx_faculty.DropListBox.SelectIndex + 1
	form.faculty = faculty[form.select_index]
	if form.cbx_item1.InputEdit.Text ~= '' or form.cbx_item2.InputEdit.Text ~= '' or form.config_item1 ~= '' or form.config_item2 ~= '' then
		form.cbx_item1.InputEdit.Text = ''
		form.cbx_item2.InputEdit.Text = ''
		form.config_item1 = ''
		form.uid_item1 = ''
		form.config_item2 = ''
		form.uid_item2 = ''		
	end	
end
function on_cbx_item1_selected(cbx)
	local form = cbx.ParentForm
	form.select_index = form.cbx_item1.DropListBox.SelectIndex + 1
	form.config_item1 = item[form.select_index]
	form.uid_item1 = uid[form.select_index]	
	if form.cbx_faculty.InputEdit.Text ~= '' or form.faculty ~= '' then
		form.cbx_faculty.InputEdit.Text = ''
		form.faculty = ''
	end	
end
function on_cbx_item2_selected(cbx)
	local form = cbx.ParentForm
	form.select_index = form.cbx_item2.DropListBox.SelectIndex + 1
	form.config_item2 = item[form.select_index]
	form.uid_item2 = uid[form.select_index]
	if form.cbx_faculty.InputEdit.Text ~= '' or form.faculty ~= '' then
		form.cbx_faculty.InputEdit.Text = ''
		form.faculty = ''	
	end	
end

function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
