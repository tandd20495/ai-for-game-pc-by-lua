--local file = assert(loadfile(nx_resource_path() .. "res\\yBreaker\\scripts\\multiple.lua"))
--multiple = file()

--local file = assert(loadfile(nx_resource_path() .. "res\\yBreaker\\scripts\\thanhanh.lua"))
--file()

require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("util_functions")
require("share\\view_define")
require("util_gui")
require("share\\capital_define")
require("custom_sender")
require("form_stage_main\\form_die_util")
require("share\\client_custom_define")
require("define\\sysinfo_define")
require("form_stage_main\\form_tiguan\\form_tiguan_util")
require("util_static_data")
require("tips_data")
require("form_stage_main\\form_wuxue\\form_wuxue_util")
require("form_stage_main\\switch\\switch_define")
require("form_stage_main\\form_origin_new\\new_origin_define")

local hs_map_id = "school17"
function weekhs_isStarted()
	return true
end
function han_mang_kiem_tran()
	local step = 0
	local diem_ban = {1671.523,142.249,762.728,-0.945}
	local bach_thao_duong = "Reliveschool17A"
	while weekhs_isStarted do
		nx_pause(0.1)
		local scene = nx_value("form_stage_main\\form_map\\form_map_scene")
		if nx_is_valid(scene) then
			currentMap = yBreaker_get_current_map()
		else
			currentMap = ""
		end
		if step == 0 then
			if currentMap == hs_map_id then
				step = 2
			elseif currentMap ~= "" then
				--thanhanh_to_hp_by_id("HomePointschool17A") -- Hoa Son
				step = 1
			end
		elseif step == 1 then
			if currentMap == hs_map_id then
				step = 2 
			end
		elseif step == 2 then
			--add_chat_info("Den cho nhan Quest", 3)
			yBreaker_show_Utf8Text("Đến nhận nhiệm vụ")
			local pos = {1648.378,142.341,742.440,2.666}
			local npcId = "npc_hsp_wxjz_lh_04"
			--den_pos(pos, weekhs_isStarted)
			--talk(npcId, {0, 0}, weekhs_isStarted)
			step = 3
		elseif step == 3 then
			local tran_nhan_id = "npc_hsp_wxjz_lh_01"
			--add_chat_info("Dang cho tran nhan xuat hien", 3)
			yBreaker_show_Utf8Text("Chờ trận nhãn xuất hiện")
			if getNpcById(tran_nhan_id) ~= nil then 
				step = 4 
			end
		elseif step == 4 then
			jump_to(diem_ban)
			nx_pause(2)
			step = 5
		elseif step == 5 then
			local tran_nhan_id = "npc_hsp_wxjz_lh_01"
			if getNpcById(tran_nhan_id) ~= nil then
				target_npc(tran_nhan_id)
				nx_execute("custom_sender", "custom_huashan_school", nx_int(2), 42)
				if not arrived(diem_ban, 3) then 
					step = 4
				end
			else
				step = 6
			end
		elseif step == 6 then
			local npcId = "npc_hsp_wxjz_lh_04"
			if getNpcById(npcId) ~= nil then
				step = 7
			end
		elseif step == 7 then
			-- nhan_qua_hang_mang_kiem_tran()
			step = 8
		end
		if step == 8 then break end
	end
end


function talk(configId, choices, isStarted)
	local npc = getNpcById(configId)
	if npc ~= nil then 
		-- local dis = getDistanceToObj(npc)
		-- if dis > 3 then return end
		local is_talking = false
		while isStarted() and not is_talking do
			nx_execute("custom_sender", "custom_select", npc.Ident)
			if unexpected_condition then
				nx_pause(1)
			else
				nx_pause(0.5)
			end
			
			local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
			if nx_is_valid(form_talk) then
				is_talking = form_talk.Visible				
			else
				SendNotice("Anh là ai tôi không biết anh, anh đi ra đi", 3)
				is_talking = true
			end
		end
		nx_pause(0.5)
		local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
		
		if nx_is_valid(form_talk) then
			for i = 1, table.getn(choices) do
				local menu_id = form_talk.mltbox_menu:GetItemKeyByIndex(choices[i])
				nx_execute("form_stage_main\\form_talk_movie", "menu_select", menu_id)
				nx_pause(1)
			end
		end
	end
end

function den_pos(pos, isStarted, msg_pre)
	local isArrived = false
	local direct_run = true
	local game_client = nx_value("game_client")
	local player = game_client:GetPlayer()
	____last_move_time = os.time()
	while not arrived(pos, 3) and isStarted() and player ~= nil do
		local state = player:QueryProp("LogicState")
		if state == 0 or state == 1 or state == 2 or state == nil then
			local move_time = move(pos, 3, msg_pre, direct_run)
			if move_time ~= nil and move_time > 5 then 
				jump_to_next()
				____last_move_time = os.time()
			end
			direct_run = false
		end
		nx_pause(0.7)
	end
	nx_pause(0.5)
end

function getNpcById(id)
	local game_client = nx_value("game_client")
	local game_scence = game_client:GetScene()
	local game_scence_objs = game_scence:GetSceneObjList()
	for i = 1, table.getn(game_scence_objs) do
		if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID"):lower() == id:lower() then
			return game_scence_objs[i]
		end
	end
	return nil
end

function target_npc(id)
	local npc = getNpcById(id)
	if npc ~= nil then
		nx_execute("custom_sender", "custom_select", npc.Ident)
		nx_pause(0.5)
	end
end

function arrived(pos, d)
  local game_visual = nx_value("game_visual")
	if 
		not nx_is_valid(game_visual) 
		or pos == nil
		or pos[1] == nil
		or pos[2] == nil
		or pos[3] == nil
	then
    return false
  end
  local game_player = game_visual:GetPlayer()
  if not nx_is_valid(game_player) or game_player == nil then
    return false
  end
  if d == nil then
		d = 3
  end
  local px = string.format("%.3f", game_player.PositionX)
  local py = string.format("%.3f", game_player.PositionY)
	local pz = string.format("%.3f", game_player.PositionZ)
  local pxd =  nx_float(px) - nx_float(pos[1])
  local pyd =  nx_float(py) - nx_float(pos[2])
  local pzd =  nx_float(pz) - nx_float(pos[3])
	local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
	--add_chat_info("distance: " ..tostring(distance))
  if d >= distance then
    return true
  end
  return false
end

function jump_to(pos, prefix)
	prefix = prefix or ""
	local role = nx_value("role")
	if not arrived(pos, 0.5) and nx_is_valid(role) then
		local x = nx_float(pos[1])
		local y = nx_float(pos[2])
		local z = nx_float(pos[3])
		local px = string.format("%.3f", nx_string(x))
		local py = string.format("%.3f", nx_string(y))
		local pz = string.format("%.3f", nx_string(z))
		--add_chat_info(prefix.."Jumping to " .."X:" ..px .." Y:"..py .." Z:" ..pz)
		local game_visual = nx_value("game_visual")
		local role = nx_value("role")
		local scene_obj = nx_value("scene_obj")
		scene_obj:SceneObjAdjustAngle(role, x, z)
		role.move_dest_orient = role.AngleY
		role.server_pos_can_accept = true
		-- game_visual:SwitchPlayerState(role, 1, 5)
		-- game_visual:SwitchPlayerState(role, 1, 6)
		-- game_visual:SwitchPlayerState(role, 1, 7)
		-- if y > role.PositionY then
		  role:SetPosition(role.PositionX, y, role.PositionZ)
		-- end
		game_visual:SetRoleMoveDestX(role, x)
		game_visual:SetRoleMoveDestY(role, y)
		game_visual:SetRoleMoveDestZ(role, z)
		game_visual:SetRoleMoveDistance(role, 50)
		game_visual:SetRoleMaxMoveDistance(role, 1)
		game_visual:SwitchPlayerState(role, 1, 103)
		nx_pause(2)
	end
end


han_mang_kiem_tran()
