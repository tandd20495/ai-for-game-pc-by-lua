require("util_gui")
require('auto\\lib')

local THIS_FORM = "auto\\trongcay"
local item = {}
local start_x, start_y, start_z = 0,0,0
local first_time = true
function GetSeedItem()
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string("123") then
    			local view_obj_table = view:GetViewObjList()
    			for k = 1, table.getn(view_obj_table) do
     				local view_obj = view_obj_table[k]
     				if view_obj:FindProp("NeedJob") and view_obj:FindProp("FarmLandType") and view_obj:QueryProp("NeedJob") == "sh_nf" and view_obj:QueryProp("FarmLandType") == 1 then
     					item[#item+1] = view_obj:QueryProp("ConfigID")
     				end
     			end
			end
		end
	end
end

function UpdateScriptStatus()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if form.auto_start then 
			form.btn1.Text = nx_function("ext_utf8_to_widestr", "Bắt đầu")
		    form.auto_start = false
		    start_x = 0
		    start_y = 0
		    start_z = 0
		    first_time = true
		else
			form.btn1.Text = nx_function("ext_utf8_to_widestr", "Kết thúc")
		    form.auto_start = true
		end
	end
end

function UseEtcItem(itemid)
	local result = false
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then

		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string("123") then
    			local view_obj_table = view:GetViewObjList()
    			for k = 1, table.getn(view_obj_table) do
     				local view_obj = view_obj_table[k]
     				if view_obj:QueryProp("ConfigID") == itemid then
     					nx_execute("custom_sender", "custom_use_item", 123, view_obj.Ident)
     					result = true
     					break
     				end
     			end
			end
		end
	end
	return result
end

-- type : 1 normal, 2 sick, 3 can pick
function GetCay(type)
	local form = util_get_form("auto\\nuoitam", false, false)
	local limit_distance = 15
	if  nx_is_valid(form) then 
		limit_distance  = nx_number(form.input2.Text)
	end
	local game_client = nx_value("game_client")
	local game_visual = nx_value("game_visual")
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	if nx_is_valid(client_player) and nx_is_valid(visual_player) then
		local scene = game_client:GetScene()
		local visual_objlist = scene:GetSceneObjList()
		if nx_is_valid(scene) then
			for k = 1, table.getn(visual_objlist) do
				local object = visual_objlist[k]
				if nx_is_valid(object) then
					if not game_client:IsPlayer(object.Ident) and object:QueryProp("Type") == 4 then
						local vis_object = game_visual:GetSceneObj(object.Ident)
						if nx_is_valid(vis_object) then
							local distance = GetDistanceBetweenTwoPoint(vis_object.PositionX, vis_object.PositionY, vis_object.PositionZ, start_x, start_y, start_z)
							if distance <= limit_distance  then
								if type == 3 then
									if object:FindProp("Owner") and object:FindProp("IsRipe") then
										if object:QueryProp("Owner") == client_player:QueryProp("Name") then
											return object
										end
									end
								end
								if type == 2 then
									if object:FindProp("Owner") and object:FindProp("CropTempState") then
										if object:QueryProp("Owner") == client_player:QueryProp("Name") and object:QueryProp("CropTempState") ~= 0 then
											return object
										end
									end
								end
								if type == 1 then
									if object:FindProp("Owner") and object:FindProp("NpcType")  then
										if object:QueryProp("NpcType") == 201 and object:QueryProp("Owner") == client_player:QueryProp("Name") then
											return object
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return nil
end

function on_script_init(form)
	form.Fixed = false
	form.select_index = 0
	form.select_item = ""
	form.auto_start = false
end

function on_script_open(form)
	item = {}
	GetSeedItem()
	form.combobox1.DropListBox:ClearString()

	local gui = nx_value("gui")
	if nx_is_valid(gui) then
		for r = 1, table.getn(item) do
			form.combobox1.DropListBox:AddString(util_text(item[r]))
		end
	end
	form.combobox1.OnlySelect = true
	form.combobox1.DropListBox.SelectIndex = 0
	if form.select_index == 0 then 
    	form.combobox1.DropListBox.SelectIndex = 0
    else 
    	local gui = nx_value("gui")
		if gui ~= nil then
	    	form.combobox1.InputEdit.Text = gui.TextManager:GetFormatText(item[form.select_index])
	    end
		form.combobox1.DropListBox.SelectIndex = form.select_index - 1
	end
end

function on_script_close(form)
end

function on_close_click(btn)
	util_auto_show_hide_form(THIS_FORM)
end

function on_btn1_click(cbtn)
	local form = cbtn.ParentForm
	
	UpdateScriptStatus()
	while form.auto_start do
		nx_pause(1)
		local game_client = nx_value("game_client")
		local game_visual = nx_value("game_visual")
		if nx_is_valid(game_client) and nx_is_valid(game_visual) then

			local client_player = game_client:GetPlayer()
			local visual_player = game_visual:GetPlayer()
			local scene = game_client:GetScene()
			if first_time then
				start_x = visual_player.PositionX
				start_y = visual_player.PositionY
				start_z = visual_player.PositionZ
				first_time = false
			end

			if nx_is_valid(visual_player) and nx_is_valid(client_player) and nx_is_valid(scene) then
				if start_x == 0 and start_y == 0 and start_z == 0 then
					start_x = visual_player.PositionX
					start_y = visual_player.PositionY
					start_z = visual_player.PositionZ
				end
			end
			local party = client_player:GetRecordRows("crop_rec")
			local distance = GetDistanceBetweenTwoPoint(visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ, start_x, start_y, start_z)
			if party <= 0 and not is_busy() and distance >= nx_number(form.input2.Text) then
				if not nx_execute("util_move", "is_path_finding", visual_player) then
					nx_execute("hyperlink_manager", "find_path_npc_item", "findnpc," .. scene:QueryProp("Resource") .. "," .. start_x .. "," .. start_y .. "," .. start_z, 1)
				end
			end

			nx_execute("custom_sender", "custom_pickup_single_item", 1)
			nx_execute("custom_sender", "custom_pickup_single_item", 2)


			local kt_object = GetCay(2)

			if kt_object ~= nil then
				local vis_object = game_visual:GetSceneObj(kt_object.Ident)
				if nx_is_valid(vis_object) then
					local distance = GetDistanceBetweenTwoPoint(visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ, vis_object.PositionX, vis_object.PositionY, vis_object.PositionZ)
					if not is_busy() and distance >= 2 then
						if not nx_execute("util_move", "is_path_finding", visual_player) then
							nx_execute("hyperlink_manager", "find_path_npc_item", "findnpc," .. scene:QueryProp("Resource") .. "," .. vis_object.PositionX .. "," .. vis_object.PositionY .. "," .. vis_object.PositionZ, 1)
						end
					else
						if not is_busy() and nx_is_valid(kt_object) then
							nx_execute("custom_sender", "custom_select", kt_object.Ident) 
							if kt_object:QueryProp("CropTempState") == 256 then UseEtcItem("nongyao10003") 
							else UseEtcItem("nongyao10002") end
						end
					end

				end
			else

				kt_object = GetCay(3)
				if kt_object ~= nil then
					local vis_object = game_visual:GetSceneObj(kt_object.Ident)
					if nx_is_valid(vis_object) then
						local distance = GetDistanceBetweenTwoPoint(visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ, vis_object.PositionX, vis_object.PositionY, vis_object.PositionZ)
						if not is_busy() and distance >= 2 then
							if not nx_execute("util_move", "is_path_finding", visual_player) then
								nx_execute("hyperlink_manager", "find_path_npc_item", "findnpc," .. scene:QueryProp("Resource") .. "," .. vis_object.PositionX .. "," .. vis_object.PositionY .. "," .. vis_object.PositionZ, 1)
							end
						else
							if not is_busy() and nx_is_valid(kt_object) then
								nx_execute("custom_sender", "custom_select", kt_object.Ident) 
							end
						end
					end
				else 
					
					kt_object = GetCay(1)
					if kt_object ~= nil and party >= 8 then
						local vis_object = game_visual:GetSceneObj(kt_object.Ident)
						if nx_is_valid(vis_object) then
							local distance = GetDistanceBetweenTwoPoint(visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ, vis_object.PositionX, vis_object.PositionY, vis_object.PositionZ)
							if not is_busy() and distance >= 2 then
								if not nx_execute("util_move", "is_path_finding", visual_player) then
									nx_execute("hyperlink_manager", "find_path_npc_item", "findnpc," .. scene:QueryProp("Resource") .. "," .. vis_object.PositionX .. "," .. vis_object.PositionY .. "," .. vis_object.PositionZ, 1)
								end
							else
								if not is_busy() and nx_is_valid(kt_object) then
									nx_execute("custom_sender", "custom_select", kt_object.Ident) 
									UseEtcItem("nongyao10001") 
								end
							end
						end
					else
						UseEtcItem(form.select_item) 
					end
				end
			end


		end
	end
	
end

function on_combobox1_selected(boxitem)
	local form = boxitem.ParentForm
	form.select_index = form.combobox1.DropListBox.SelectIndex + 1
	form.select_item = item[form.select_index]
end