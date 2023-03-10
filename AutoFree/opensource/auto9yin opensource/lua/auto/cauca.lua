require("util_gui")
require('auto\\lib')

local THIS_FORM = "auto\\cauca"
local item = {}
function InitSetting()
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "ht_auto_" .. account 
	local file = ""
	if not nx_function("ext_is_exist_directory", nx_string(dir)) then
	  nx_function("ext_create_directory", nx_string(dir))
	end
	file = dir .. nx_string("\\auto_cauca.txt")
	if not nx_function("ext_is_file_exist", file) then
		local thth = nx_create("StringList")
		thth:SaveToFile(file)
	end
end

function LoadSetting(form)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "ht_auto_" .. account 
	local file = dir .. nx_string("\\auto_cauca.txt")
	local gm_list = nx_create("StringList")
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
		return 0
	end
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
	local dir = nx_function("ext_get_current_exe_path") .. "ht_auto_" .. account 
	local file = dir .. nx_string("\\auto_cauca.txt")
	local gm_list = nx_create("StringList")
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
		return 0
	end
	local string = scene .. "," .. x .. "," .. y .. "," .. z
	gm_list:AddString(string)
	gm_list:SaveToFile(file)
	LoadSetting(form)
	AutoSendMessage("Lưu tọa độ thành công : " .. nx_string(string))
end

function RemoveSetting(form)
	local game_config = nx_value("game_config")
	local account = game_config.login_account
	local dir = nx_function("ext_get_current_exe_path") .. "ht_auto_" .. account 
	local file = dir .. nx_string("\\auto_cauca.txt")
	local gm_list = nx_create("StringList")
	local removestring = item[form.select_index]
	item[form.select_index] = ""

	for k = 1, table.getn(item) do
		if item[k] ~= "" then
			gm_list:AddString(item[k])
		end
	end
	AutoSendMessage("Xóa tọa độ thành công : " .. nx_string(removestring))
	gm_list:SaveToFile(file)
	LoadSetting(form)

end


function UpdateScriptStatus()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if form.auto_start then 
			form.btn1.Text = nx_function("ext_utf8_to_widestr", "Bắt đầu")
		    form.auto_start = false
			
		else
			form.btn1.Text = nx_function("ext_utf8_to_widestr", "Kết thúc")
		    form.auto_start = true
		end
	end
end


-- type : 1 normal, 2 sick, 3 can pick
function GetCa()

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
							if object:FindProp("GatherPara1") and object:FindProp("GatherRange") then
								local distance = GetDistanceBetweenTwoPoint(vis_object.PositionX, vis_object.PositionY, vis_object.PositionZ, visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ)
								if object:QueryProp("GatherPara1") == "sh_yf" and distance <= 16 then
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

function is_in_fishing()
  local form = nx_value("form_stage_main\\form_life\\form_fishing_op")
  if not nx_is_valid(form) then
    return false
  end
  return true
end

function on_script_init(form)
	form.Fixed = false
	form.auto_start = false
	form.select_index = 0
	form.cur_point = 1
	form.total_point = 0
	InitSetting()
end

function on_script_open(form)
	LoadSetting(form)
end

function on_script_close(form)
end

function on_close_click(btn)
	util_auto_show_hide_form(THIS_FORM)
end
function on_btn3_click(cbtn)
	local form = cbtn.ParentForm
	RemoveSetting(form)
end
function on_btn2_click(cbtn)
	local form = cbtn.ParentForm
	local game_client = nx_value("game_client")
	local game_visual = nx_value("game_visual")
	if nx_is_valid(game_client) and nx_is_valid(game_visual) then

		local client_player = game_client:GetPlayer()
		local visual_player = game_visual:GetPlayer()
		local scene = game_client:GetScene()
		if nx_is_valid(scene) then
			AddSetting(scene:QueryProp("Resource"),visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ)
		end
	end
end

function on_btn1_click(cbtn)
	local form = cbtn.ParentForm

	if form.total_point <= 0 then
		AutoSendMessage("Bạn chưa thiết lập vị trí câu cá nào !")
		return 
	end

	UpdateScriptStatus()



	while form.auto_start do

		nx_pause(1)
		local game_client = nx_value("game_client")
		local game_visual = nx_value("game_visual")
		if nx_is_valid(game_client) and nx_is_valid(game_visual) then

			local client_player = game_client:GetPlayer()
			local visual_player = game_visual:GetPlayer()
			local scene = game_client:GetScene()
			if is_in_fishing() then
				while is_in_fishing() do
					nx_pause(0.1)
					fishing_state = nx_number(client_player:QueryProp("FishingState"))
					if fishing_state == 2 then
						nx_execute("custom_sender", "custom_op_fishing")
					end
					if fishing_state == 0 then
						nx_execute("custom_sender", "custom_begin_fishing", 1)
						nx_execute("custom_sender", "custom_select_cancel")
					end
				end
			else

				if not is_busy() then
					nx_execute("custom_sender", "custom_pickup_single_item", 1)
					nx_execute("custom_sender", "custom_pickup_single_item", 2)
					nx_execute("custom_sender", "custom_pickup_single_item", 3)
					nx_execute("custom_sender", "custom_pickup_single_item", 4)
					local kt_object = GetCa()
					if kt_object ~= nil then
						local vis_object = game_visual:GetSceneObj(kt_object.Ident)
						if nx_is_valid(vis_object) then
							if not is_busy() and nx_is_valid(kt_object) then
								nx_execute("custom_sender", "custom_select", kt_object.Ident) 
								nx_execute("custom_sender", "custom_begin_fishing", 0)
							end
						end
					end
				end
			end


		end
	end
	
end

function on_combobox1_selected(boxitem)
	local form = boxitem.ParentForm
	form.select_index = form.combobox1.DropListBox.SelectIndex + 1
end