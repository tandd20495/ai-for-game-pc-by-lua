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

local THIS_FORM = 'auto_new\\form_auto_set_item'
local FORM_TARGET = 'auto_new\\form_auto_use_item'
function main_form_init(form)
  form.Fixed = false 
end

function on_main_form_open(form)
	form.combobox_itemname.config = ""
	form.config_item = ''
	form.edit_key.Text = nx_widestr('')
	form.picture_item.Image = nx_widestr('')
	form.edt_item_add.Text = nx_widestr('')	
end
function on_combobox_itemname_selected(self)
	local form = self.ParentForm
	if not nx_is_valid(form) then
		return
	end
	form.edt_item_add.Text = form.combobox_itemname.Text
	form.combobox_itemname.Text = nx_widestr('')
	local index = form.combobox_itemname.DropListBox.SelectIndex	
	if index < table.getn(market_item_table) then
		form.combobox_itemname.config = market_item_table[index + 1]
		form.edit_key.Text =  nx_widestr(util_text(market_item_table[index + 1]))
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
	local search_table = ItemQuery:FindItemsByName(self.Text)
	market_item_table = {}
	for _, item_config in pairs(search_table) do
		local bExist = ItemQuery:FindItemByConfigID(item_config)
		if bExist then
			if gui.TextManager:IsIDName(item_config) then
				form.combobox_itemname.DropListBox:AddString(util_text(item_config))
				table.insert(market_item_table, item_config)
			end
		end
	end
	if not form.combobox_itemname.DroppedDown then
		form.combobox_itemname.DroppedDown = true
	end
end

function on_main_form_close(form)
  form.Visible = false
end
function btn_save_setting(btn)
	local form = btn.ParentForm
	local form_main = nx_value(FORM_TARGET)
	saveHotKeyIni()
	nx_execute('auto_new\\autocack','util__auto_show_form',THIS_FORM)	
	if nx_is_valid(form_main) then
		nx_execute('auto_new\\autocack','nx_autoexecute',FORM_TARGET,'loadGridChat',form_main)
	end	
end
function get_item_info(view_ident,view_index)
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then return end
  local view = game_client:GetView(view_ident)
  if not nx_is_valid(view) then return end
  return view:GetViewObj(view_index)
end
function get_game_hand_item()
	local gui = nx_value("gui")
	local game_hand = gui.GameHand
	local para1 = game_hand.Para1
	local para2 = game_hand.Para2
	local no_item = game_hand:IsEmpty() or game_hand.Type ~= "viewitem" or (para1 ~= "121" and para1 ~= "2" and para1 ~= "123" and para1 ~= "125")
	if no_item then return nil end
	local item_obj = get_item_info(para1,para2)
	if not nx_is_valid(item_obj) then return nil end
	return nx_string(item_obj:QueryProp("ConfigID"))
end

function on_right_item_click(image_grid)
    local form = nx_value(THIS_FORM) 
	local pictureForm = ""
	local namePic = image_grid.Name
	if nx_find_custom(form, namePic) then
		local image = nx_custom(form, namePic)
		pictureForm = image
	end	
	local ini = add_file('auto_item')
	removeSection(ini,nx_string(form.config_item))			
	pictureForm.Image = "" 
	form.config_item = ''	
end
reload_pic = function()
	local form = nx_value(THIS_FORM) 
	local ini = add_file('auto_item')
	local itemphoto = nx_string(readIni(ini,nx_string(form.config_item),"pic",""))
	form.picture_item.Image = itemphoto
end
function on_left_item_click(self)
  local form = self.ParentForm
  if not nx_find_custom(self,'UniqueID') then nx_set_custom(self,'UniqueID','1') end
  local gui = nx_value('gui')
  local game_hand = gui.GameHand
  local ini = add_file('auto_item')
  local para1 = game_hand.Para1
  local para2 = game_hand.Para2
  local no_item = game_hand:IsEmpty() or game_hand.Type ~= "viewitem" or (para1 ~= "121" and para1 ~= "2" and para1 ~= "123" and para1 ~= "125")	
	if no_item then return nil end	
    local item = nx_execute('goods_grid', 'get_view_item', game_hand.Para1, game_hand.Para2)
	if nx_is_valid(item) then 
		form.config_item = item:QueryProp('ConfigID')		
		writeIni(ini,nx_string(form.config_item),'pic',game_hand.Image)
		writeIni(ini,nx_string(form.config_item),'view_index',para1)
		form.edit_key.Text = nx_widestr(util_text(form.config_item))		
		reload_pic()
	end 
  game_hand:ClearHand()
end

function saveHotKeyIni()
	local form = nx_value('auto_new\\form_auto_set_item')
	local ini = add_file('auto_item')
	local section = ''
	if nx_string(form.combobox_itemname.config) ~= '' then
		section = form.combobox_itemname.config
		writeIni(ini,nx_string(section),'view_index',2)
	else
		section = form.config_item
	end
	writeIni(ini,nx_string(section),'buff_type',1)
end

function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
