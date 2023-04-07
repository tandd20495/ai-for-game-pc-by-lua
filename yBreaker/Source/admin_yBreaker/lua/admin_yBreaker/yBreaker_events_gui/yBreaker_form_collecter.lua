require("util_gui")
require("util_move")
require("share\\chat_define")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local inspect = require("admin_yBreaker\\yBreaker_admin_libraries\\inspect")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_collecter"
local item = {}
local list_job = {
	{
		name = "sh_kg",--Đào Khoáng
		type = 142
	},
	{
		name = "sh_qf",--Chặt Cây
		type = 143
	},
	{
		name = "sh_ds",--Độc Sư
		type = 145
	},
	{
		name = "sh_ys",--Dược Sư
		type = 144
	}		
	
}

function TeleportTest(x,y,z)
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		return false
	end
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return false
	end
	local client_player = game_client:GetPlayer()
	local visual_player = game_visual:GetPlayer()
	-- x,y,z = visual_player.PositionX - 1.5, visual_player.PositionY, visual_player.PositionZ
    game_visual:EmitPlayerInput(visual_player, PLAYER_INPUT_LOCATION, x, y, z, 1, 1)
    nx_pause(0.2)
    visual_player:SetPosition(x,y,z)
    local scene_obj = nx_value("scene_obj")
end

function InitSetting(type)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account 
	local file = ""
	if not nx_function("ext_is_exist_directory", nx_string(dir)) then
	  nx_function("ext_create_directory", nx_string(dir))
	end
	file = dir .. nx_string("\\JobsData_Collecter_" .. type ..".ini")
	if not nx_function("ext_is_file_exist", file) then
		local thth = nx_create("StringList")
		thth:SaveToFile(file)
	end
end

function LoadSetting(form)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account 
	local file = dir .. nx_string("\\JobsData_Collecter_" .. list_job[form.select_index2]["name"] .. ".ini")
	local gm_list = nx_create("StringList")
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
		return 0
	end
	item = {}
	form.select_index = 0
	form.combobox1.InputEdit.Text = ""
	form.combobox1.DropListBox.SelectIndex = 0
	form.total_point = 0
	form.combobox1.DropListBox:ClearString()
	local gm_num = gm_list:GetStringCount()
	for i = 0, gm_num - 1 do
		local gm = gm_list:GetStringByIndex(i)
		if gm ~= "" then
			local gui = nx_value("gui")
			if nx_is_valid(gui) then
				form.combobox1.DropListBox:AddString(nx_widestr(gm))
			end
			form.total_point = form.total_point + 1
			item[i+1] = gm
			form.combobox1.OnlySelect = true
			
		end
	end

end

function AddSetting(scene, x, y, z)
	local form = util_get_form(THIS_FORM, false, false)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account 
	local file = dir .. nx_string("\\JobsData_Collecter_" .. list_job[form.select_index2]["name"] .. ".ini")
	local gm_list = nx_create("StringList")
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
		return 0
	end
	local string = scene .. "," .. x .. "," .. y .. "," .. z
	gm_list:AddString(string)
	gm_list:SaveToFile(file)
	LoadSetting(form)
	
	tools_show_notice(nx_function("ext_utf8_to_widestr", "Lưu tọa độ thành công!"))
	--local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<font color=\"#5FD00B\">{@1:text}</font> {@0:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Lưu tọa độ thành công...!")), nx_widestr(nx_function("ext_utf8_to_widestr","yBreaker:")))
	--nx_value("form_main_chat"):AddChatInfoEx(textchat, CHATTYPE_SYSTEM, false)
	--nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
end

function RemoveSetting(form)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "yBreaker_" .. account 
	local file = dir .. nx_string("\\JobsData_Collecter_" .. list_job[form.select_index2]["name"] .. ".ini")
	local gm_list = nx_create("StringList")
	local removestring = item[form.select_index]
	item[form.select_index] = ""

	for k = 1, table.getn(item) do
		if item[k] ~= "" then
			gm_list:AddString(item[k])
		end
	end
	
	tools_show_notice(nx_function("ext_utf8_to_widestr", "Xóa tọa độ thành công!"))
	--local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<img src=\"skin\\QuaiCaiAuto\\quaicai.png\" valign=\"bottom\" /><font color=\"#5FD00B\">{@1:text}</font> {@0:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Xóa tọa độ thành công.....!")), nx_widestr(nx_function("ext_utf8_to_widestr","yBreaker:")))
	--nx_value("form_main_chat"):AddChatInfoEx(textchat, CHATTYPE_SYSTEM, false)
	--nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
	gm_list:SaveToFile(file)
	LoadSetting(form)

end


function UpdateScriptStatus()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if form.auto_start then 
			form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Bắt đầu")
			form.btn_control.ForeColor = "255,0,255,0"
		    form.auto_start = false
			
		else
			form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Kết thúc")
			form.btn_control.ForeColor = "255,255,0,0"
		    form.auto_start = true
		end
	end
end

function GetCa(type)

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
							if object:FindProp("NpcType") and object:FindProp("GatherRange") then
								local distance = distance2d(vis_object.PositionX, vis_object.PositionZ, visual_player.PositionX, visual_player.PositionZ)
								if object:QueryProp("NpcType") == type then
									return object
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


function GetNearPoint(lastpoint)
	local near = 1
	local distance = 10000

	for k = 1, table.getn(item) do
		local pos = util_split_string(nx_string(item[k]), ",")
		local game_visual = nx_value("game_visual")
		if nx_is_valid(game_visual) then
			local visual_player = game_visual:GetPlayer() 
			if nx_is_valid(visual_player) then
				console_log("TEST " .. inspect(pos))
				local cur_distance = distance2d(visual_player.PositionX, visual_player.PositionZ, pos[2], pos[4])
				if cur_distance < distance and k ~= lastpoint then
					distance = cur_distance
					near = k
				end
			end
		end
	end
	return near
end



function on_form_main_init(form)
	form.Fixed = false
	form.auto_start = false
	form.select_index = 0
	form.select_index2 = 0
	form.cur_point = 1
	form.total_point = 0
	form.mode = 0
	for i = 1, table.getn(list_job) do
		InitSetting(list_job[i]["name"])
	end
	
	
	local gui = nx_value("gui")
	form.Left = 140
	--form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
end

function on_main_form_open(form)
	form.combobox2.DropListBox:ClearString()
	local game_client=nx_value("game_client")
	local game_scence=game_client:GetScene()
	local i=game_scence:QueryProp("Resource")
	form.lbl_2.Text = util_text(i)
	for i = 1, table.getn(list_job) do
		local gui = nx_value("gui")
		if gui ~= nil then
			local text = gui.TextManager:GetFormatText(list_job[i]["name"])
			form.combobox2.DropListBox:AddString(text)
		end
		
	end
	form.combobox2.OnlySelect = true
	if form.select_index2 ~= 0 then
		local gui = nx_value("gui")
		if gui ~= nil then
	    	form.combobox2.InputEdit.Text = gui.TextManager:GetFormatText(list_job[form.select_index2]["name"])
	    end
		form.combobox2.DropListBox.SelectIndex = form.select_index2 - 1
	else
		form.combobox2.DropListBox.SelectIndex = 0
	end
end

function on_main_form_close(form)
	form.auto_start = false
	nx_destroy(form)
end

function on_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function show_hide_form_collecter()
	util_auto_show_hide_form(THIS_FORM)
end

function on_btn3_click(cbtn)
	local form = cbtn.ParentForm
	if nx_is_valid(form) then
		if form.select_index2 == 0 then
				tools_show_notice(nx_function("ext_utf8_to_widestr", "Chưa chọn nghề!"))
				--local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<img src=\"skin\\admin_yBreaker\\yBreaker_sign_dt.png\" valign=\"bottom\" /><font color=\"#5FD00B\">{@1:text}</font> {@0:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Bạn chưa chọn nghề!")), nx_widestr(nx_function("ext_utf8_to_widestr","yBreaker:")))
				--nx_value("form_main_chat"):AddChatInfoEx(textchat, CHATTYPE_SYSTEM, false)
				--nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
				return
		end
		RemoveSetting(form)
	end
end
function on_btn2_click(cbtn)
	local form = cbtn.ParentForm
	if nx_is_valid(form) then
		if form.select_index2 == 0 then
				tools_show_notice(nx_function("ext_utf8_to_widestr", "Chưa chọn nghề!"))
				--local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<img src=\"skin\\admin_yBreaker\\yBreaker_sign_dt.png\" /><font color=\"#5FD00B\">{@1:text}</font> {@0:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Bạn chưa chọn nghề.....!")), nx_widestr(nx_function("ext_utf8_to_widestr","yBreaker:")))
				--nx_value("form_main_chat"):AddChatInfoEx(textchat, CHATTYPE_SYSTEM, false)
				--nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
			return
		end
		local game_client = nx_value("game_client")
		local game_visual = nx_value("game_visual")
		if nx_is_valid(game_client) and nx_is_valid(game_visual) then

			local client_player = game_client:GetPlayer()
			local visual_player = game_visual:GetPlayer()
			local scene = game_client:GetScene()
			if nx_is_valid(scene) then
				  local x = string.format("%.3f", visual_player.PositionX)
				  local y = string.format("%.3f", visual_player.PositionY)
				  local z = string.format("%.3f", visual_player.PositionZ)
				AddSetting(scene:QueryProp("Resource"),x,y,z)
			end
		end
	end
end

function on_btn1_click(cbtn)
	local form = cbtn.ParentForm

	if form.total_point <= 0 then
		tools_show_notice(nx_function("ext_utf8_to_widestr", "Chưa thiết lập vị trí thu thập!"))
		--local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<img src=\"skin\\admin_yBreaker\\yBreaker_sign_dt.png\" /><font color=\"#5FD00B\">{@1:text}</font> {@0:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Chưa thiết lập ví trí nào cả.....!")), nx_widestr(nx_function("ext_utf8_to_widestr","yBreaker:")))
		--nx_value("form_main_chat"):AddChatInfoEx(textchat, CHATTYPE_SYSTEM, false)
		--nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
		return 
	end

	if form.select_index2 == 0 then
		tools_show_notice(nx_function("ext_utf8_to_widestr", "Chưa chọn nghề!"))
		--local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<img src=\"skin\\admin_yBreaker\\yBreaker_sign_dt.png\" /><font color=\"#5FD00B\">{@1:text}</font> {@0:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Bạn chưa chọn nghề!")), nx_widestr(nx_function("ext_utf8_to_widestr","yBreaker:")))
		--nx_value("form_main_chat"):AddChatInfoEx(textchat, CHATTYPE_SYSTEM, false)
		--nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
		return
	end
	local path_loc = false

	local start_x, start_y, start_z = 0,0,0
	LoadSetting(form)

	form.cur_point = nx_number(GetNearPoint(1))
	
	-- Check dụng cụ thu thập
	local goods_grid = nx_value("GoodsGrid")	
	if goods_grid:GetItemCount("tool_cai_01") == 0 then
	
		-- Check pass rương và tự mua dụng cụ thu thập
		local game_client=nx_value("game_client")
		local player_client=game_client:GetPlayer()
		if not player_client:FindProp("IsCheckPass") or player_client:QueryProp("IsCheckPass") ~= 1 then
			yBreaker_show_Utf8Text("Mở khóa rương để tự mua dụng cụ", 3)
			return 
		else 		
			-- Mua dụng cụ trong Tạp Hóa ------------- Shop Giang hồ ---- 1: Công Cụ, 18: số thứ tự dụng cụ thu thập, 1: Mua (Tương tự vậy thì 1,1,1: Tab Công Cụ, Mua Liệp Thú Đoản Kiếm)
			nx_execute("custom_sender", "custom_open_mount_shop", 1)
			nx_execute("custom_sender", "custom_buy_item", "Shop_zahuo_00102", 1,18,1)
			nx_execute("custom_sender", "custom_open_mount_shop", 0)
		end 
	end	

	UpdateScriptStatus()

	while form.auto_start and nx_is_valid(form) do

		nx_pause(0.1)
		local game_client = nx_value("game_client")
		local game_visual = nx_value("game_visual")
		if nx_is_valid(game_client) and nx_is_valid(game_visual) then

			local client_player = game_client:GetPlayer()
			local visual_player = game_visual:GetPlayer()
			local scene = game_client:GetScene()
			-- if nx_is_valid(scene) then
			-- 	AddSetting(scene:QueryProp("Resource"),visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ)
			-- end
				
			if client_player:QueryProp("Ene") <= 10 then
				UseItemById("tili10001", 2)
			end

			
			
			nx_execute("custom_sender", "custom_pickup_single_item", 1)
			nx_execute("custom_sender", "custom_pickup_single_item", 2)
			nx_execute("custom_sender", "custom_pickup_single_item", 3)
			nx_execute("custom_sender", "custom_pickup_single_item", 4)

			local pos = util_split_string(nx_string(item[form.cur_point]), ",")
			local kt_object = GetCa(list_job[form.select_index2]["type"])
			if scene:QueryProp("Resource") == pos[1] then
				if kt_object ~= nil then
					local vis_object = game_visual:GetSceneObj(kt_object.Ident)
					if nx_is_valid(vis_object) then
						if not is_busy() and nx_is_valid(kt_object) then


							local distance = distance2d(visual_player.PositionX, visual_player.PositionZ, vis_object.PositionX, vis_object.PositionZ)
							if distance <= 2.5 then
								nx_execute("custom_sender", "custom_select", kt_object.Ident) 
								nx_execute("custom_sender", "custom_select", kt_object.Ident) 
							else
								if not is_busy() and distance2d(visual_player.PositionX, visual_player.PositionZ, start_x, start_z) <= 0.5 then
									game_visual:SwitchPlayerState(visual_player, "jump", 5)
									TeleportTest(nx_float(start_x), nx_float(start_y), nx_float(start_z) + 0.5)
								end
								
								start_x, start_y, start_z = visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ
								

								local x = vis_object.PositionX
								local y = vis_object.PositionY
								local z = vis_object.PositionZ

								-- if distance > 2.5 and distance <= 6 then
								-- 	game_visual:SwitchPlayerState(visual_player, "jump", 5)
								-- 	TeleportTest(nx_float(x), nx_float(y), nx_float(z) + 0.5)

								-- end
								
								if path_loc then
									path_loc = false
									nx_execute("hyperlink_manager", "find_path_npc_item", "findpath," .. scene:QueryProp("Resource") .. ","  .. x .. "," .. z, 1)
								end
								if not nx_execute("util_move", "is_path_finding", visual_player) then
									
									--AutoSendMessage("Auto: ".. nx_string(form.cur_point) .. " - ".. nx_string(form.total_point))
									nx_execute("hyperlink_manager", "find_path_npc_item", "findpath," .. scene:QueryProp("Resource") .. ","  .. x .. "," .. z, 1)
								end
							end

							
						end
					end
				else
					local distance = distance2d(visual_player.PositionX, visual_player.PositionZ, nx_float(pos[2]), nx_float(pos[4]))
					if not is_busy() and distance >= 2 then

						path_loc = true
						if not is_busy() and distance2d(visual_player.PositionX, visual_player.PositionZ, start_x, start_z) <= 0 then
							game_visual:SwitchPlayerState(visual_player, "jump", 5)
							TeleportTest(nx_float(start_x), nx_float(start_y), nx_float(start_z) + 0.5)
						end

						start_x, start_y, start_z = visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ
						-- AutoSendMessage(nx_string(form.cur_point))
						-- game_visual:SwitchPlayerState(visual_player, "jump", 5)
						-- TeleportTest(nx_float(pos[2]), nx_float(pos[3]), nx_float(pos[4]))
						if not nx_execute("util_move", "is_path_finding", visual_player) then
							nx_execute("hyperlink_manager", "find_path_npc_item", "findnpc," .. scene:QueryProp("Resource") .. "," .. nx_string(pos[2]) .. "," .. nx_string(pos[3]) .. "," .. nx_string(pos[4]), 1)
						end
					else
						if form.mode == 0 then
							if form.cur_point + 1 >= form.total_point then
								form.mode = 1
								form.cur_point = form.total_point
							else 
								form.cur_point = form.cur_point + 1
							end
						else
							if form.cur_point - 1 <= 1 then
								form.mode = 0
								form.cur_point = 1
							else 
								form.cur_point = form.cur_point - 1
							end

						end
					end
				end

			else
				if form.mode == 0 then
					if form.cur_point + 1 >= form.total_point then
						form.mode = 1
						form.cur_point = form.total_point
					else 
						form.cur_point = form.cur_point + 1
					end
				else
					if form.cur_point - 1 <= 1 then
						form.mode = 0
						form.cur_point = 1
					else 
						form.cur_point = form.cur_point - 1
					end

				end
			end
			


		end
	end
	
end
function is_busy()
  local client = nx_value("game_client")
      if not nx_is_valid(client) then
        return 0
      end
  local client_player = client:GetPlayer()
  if client_player:FindProp("State") and not isempty(string.find(client_player:QueryProp("State"), "interact")) then return true end
  if client_player:FindProp("State") and not isempty(string.find(client_player:QueryProp("State"), "life")) then return true end
  return false
end
function isempty(s)
  return s == nil or s == ''
end
function on_combobox1_selected(boxitem)
	local form = boxitem.ParentForm
	form.select_index = form.combobox1.DropListBox.SelectIndex + 1
end

function on_combobox2_selected(boxitem)
	local form = boxitem.ParentForm
	form.select_index2 = form.combobox2.DropListBox.SelectIndex + 1


	LoadSetting(form)
end