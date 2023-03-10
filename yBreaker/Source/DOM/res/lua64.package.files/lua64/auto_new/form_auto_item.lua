require("util_gui")
require('auto_new\\autocack')
local THIS_FORM = "auto_new\\form_auto_item"
local item = {}
function player_busy()
	local game_client=nx_value("game_client")
	if nx_is_valid(game_client) then 
		local player_client=game_client:GetPlayer()
		if nx_is_valid(player_client) then
			if string.find(player_client:QueryProp("State"), "offact") or string.find(player_client:QueryProp("State"), "interact") or string.find(player_client:QueryProp("State"), "life") then
				return true
			end
		end
	end
	return false
end
function getitem()
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string("2")  then --or view.Ident == nx_string("123") or view.Ident == nx_string("125") 
    			local view_obj_table = view:GetViewObjList()
    			for k = 1, table.getn(view_obj_table) do
     				local view_obj = view_obj_table[k]
     				item[#item+1] = view_obj:QueryProp("ConfigID")
     			end
			end
		end
	end
end
function on_combobox_mode_selected(boxitem)
	local form = boxitem.ParentForm
	form.select_index = form.combobox_mode.DropListBox.SelectIndex + 1
	form.select_item = item[form.select_index]
	if form.select_index > 0 then
		form.btn_control.Enabled = true
	end
end
function auto_item()
	local form = nx_value(THIS_FORM)
	updateBtnAuto()
	if nx_is_valid(form) then	
		while form.auto_start do
			nx_pause(0.1)
			local game_client=nx_value("game_client")
			if nx_is_valid(game_client) then
			local player_client=game_client:GetPlayer()
				if nx_is_valid(player_client) then
					nx_execute("custom_sender", "custom_pickup_single_item", 1)
					nx_execute("custom_sender", "custom_pickup_single_item", 2)
					nx_execute("custom_sender", "custom_pickup_single_item", 3)
					nx_execute("custom_sender", "custom_pickup_single_item", 4)
					local goods_grid = nx_value("GoodsGrid")
					if goods_grid:GetItemCount(form.select_item) > 0 then				
						if not nx_execute(nx_current(), "player_busy") then
							local form_bag = nx_value("form_stage_main\\form_bag")
							local item_query = nx_value("ItemQuery")
							local bag_no = item_query:GetItemPropByConfigID(form.select_item, "ViewID")
							bag_no = tonumber(bag_no)
							if nx_is_valid(form_bag) then
								if bag_no == 1 then
									form_bag.rbtn_tool.Checked = false
								elseif bag_no == 2 then
									form_bag.rbtn_equip.Checked = true
								elseif bag_no == 3 then
									form_bag.rbtn_material.Checked = false
								elseif bag_no == 4 then
									form_bag.rbtn_task.Checked = false
								end
							end
							if not nx_is_valid(FORM_SHOP) then
								nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", form.select_item)
							end
						end
					else
						updateBtnAuto()
					end
				end
			end
		end
		local goods_grid = nx_value("GoodsGrid")
		if goods_grid:GetItemCount(form.select_item) == 0 then
			nx_pause(0.15)
			showUtf8Text(AUTO_USE_ITEM_SUCCESS..wstrToUtf8(util_text(form.select_item)),3)
			nx_destroy(form)
		end
	end
end
function updateBtnAuto()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if form.auto_start then 
			form.btn_control.Text = util_text("ui_begin")
			form.btn_control.ForeColor = "255,0,255,0"
		    form.auto_start = false	
		else
			form.btn_control.Text = util_text("ui_off_end")
			form.btn_control.ForeColor = "255,255,0,0"
		    form.auto_start = true
		end
	end
end
function main_form_init(form)
	form.Fixed = false
	form.auto_start = false
	form.select_index = 0
	form.select_item = ""
end
function main_form_open(form)
	if not form.auto_start then
		form.btn_control.Text = util_text("ui_begin")
		form.btn_control.ForeColor = "255,0,255,0"
	else
		form.btn_control.Text = util_text("ui_off_end")
		form.btn_control.ForeColor = "255,255,0,0"
	end
	if form.select_index > 0 then
		form.btn_control.Enabled = true
	else
		form.btn_control.Enabled = false
	end
	item = {}	
	getitem()
	local gui = nx_value("gui")
	if nx_is_valid(gui) then
		for r = 1, table.getn(item) do
			form.combobox_mode.DropListBox:AddString(util_text(item[r]))
		end
	end
	form.combobox_mode.OnlySelect = true
	form.combobox_mode.DropListBox.SelectIndex = 0
	if form.select_index == 0 then 
    	form.combobox_mode.DropListBox.SelectIndex = 0
    else 
    	local gui = nx_value("gui")
		if gui ~= nil then
	    	form.combobox_mode.InputEdit.Text = gui.TextManager:GetFormatText(item[form.select_index])
	    end
		form.combobox_mode.DropListBox.SelectIndex = form.select_index - 1
	end
end
function on_main_form_close(form)
end
function close_form(form)
	nx_destroy(form)
end
function minimizeBtnClick(btn)
	util_auto_show_hide_form(THIS_FORM)
end
function closeBtnClick(btn)
	local form = btn.ParentForm
	if not form.auto_start then
		local formab = nx_value(THIS_FORM)
		if not nx_is_valid(formab) then
			return
		end
		close_form(form)
	else
	showUtf8Text(AUTO_LOG_STOP_AUTO_CLOSE,3)
	end
end