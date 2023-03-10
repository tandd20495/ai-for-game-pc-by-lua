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

local THIS_FORM = 'auto_new\\form_auto_set_item_buff'
local FORM_TARGET = 'auto_new\\form_auto_use_item'
local item = {}
local uid = {}
local faculty = {}
item_list_buff = nil
function main_form_init(form)
  form.Fixed = false
  form.skillid = ""
  form.check_type = 0
  form.select_index = 0
  form.item_config_id = "" 
  form.item_view_index = "" 
  
end
function on_main_form_open(form)			
	loadItemAutoDrop(form)
	item_buff_id = ""
end

function loadItemAutoDrop(form)
	local gui = nx_value("gui")	
	form.cbx_load_auto.DropListBox:ClearString()
	local game_client = nx_value("game_client")
	local player = game_client:GetPlayer()
	if not nx_is_valid(player) then return end
	local buffer_list = nx_function("get_buffer_list", player)
	local buffer_count = #buffer_list/2
	if item_list_buff ~= nil then item_list_buff = nil end
	if item_list_buff == nil then item_list_buff = {} end
	form.cbx_load_auto.Text = nx_widestr('none')
	for i = 1, buffer_count do
		local buff_id = nx_string(buffer_list[i*2-1])
		local buffer_info = nx_function("get_buffer_info", player, buff_id, player)
  		if #buffer_info == 3 then
    		local level = buffer_info[1]
    		local desc_buff	= "desc_" .. buff_id .. "_" .. nx_string(level)
    		local desc_utf8 = util_text("desc_" .. buff_id .. "_" .. nx_string(level))
			local buff = getUtf8Text(buff_id)--
			form.cbx_load_auto.DropListBox:AddString(utf8ToWstr(buff))
			table.insert(item_list_buff,buff_id)
    	end
	end	
end
on_cbx_load_auto_selected = function(cbx)
	local form = cbx.ParentForm
	local index = form.cbx_load_auto.DropListBox.SelectIndex
	if index < table.getn(item_list_buff) then
		item_buff_id = item_list_buff[index + 1]	
	end
end
function on_main_form_close(form)
  nx_destroy(form)
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	local form_main = nx_value('auto_new\\form_auto_use_item')
	saveHotKeyIni()
	nx_destroy(form)
	--util_show_form('auto_new\\form_auto_set_item_buff',false)	
	if nx_is_valid(form_main) then
		nx_execute('auto_new\\autocack','nx_autoexecute','auto_new\\form_auto_use_item','loadGridChat',form_main)
	end
end

function saveHotKeyIni()
	local form = nx_value('auto_new\\form_auto_set_item_buff')
	local file = add_file('auto_item')	
	if item_buff_id == "" or  item_buff_id == nil or item_buff_id == 'none' then
		 item_buff_id = "none"
	end	
	writeIni(file,form.item_config_id, "buff_type", form.check_type)	
	writeIni(file,form.item_config_id, "view_index",form.item_view_index)
	writeIni(file,form.item_config_id, "buff_id",item_buff_id)
end
function on_cbtn_on_no_delay(cbtn)
	local form = cbtn.ParentForm
	if form.cbtn_on_buff.Checked then
		form.cbtn_on_buff.Checked = false
	end
	form.check_type = 1
end
function cbtn_on_buff(cbtn)
	local form = cbtn.ParentForm
	if form.cbtn_on_no_delay.Checked then
		form.cbtn_on_no_delay.Checked = false
	end
	form.check_type = 2	
end

function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
