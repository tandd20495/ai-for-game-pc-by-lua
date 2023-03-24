local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\multiple.lua"))
multiple = file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()





local hs_map_id = "school17"
function weekhs_isStarted()
	return true
end
send_homepoint_msg_to_server = function(...)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return
    end
    game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SET_HOMEPOINT), unpack(arg))
end

function X_GetHomeSchool()
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return nil
	end
	local client_player = game_client:GetPlayer()
	local home_tele_id = nil
	local maxhp = GetRecordHomePointCount()
	for index = maxhp-1, 0, -1 do
		if nx_is_valid(client_player) then
			local home_tele_index = client_player:QueryRecord(HomePointList, index, 1)
			if nx_string(home_tele_index) == "2" then
				home_tele_id = nx_string(client_player:QueryRecord(HomePointList, index, 0))
				break
			end
		end
	end
	return home_tele_id
end
function han_mang_kiem_tran()
	local step = 0
	local diem_ban = {1671.523,142.249,762.728,-0.945}
	local bach_thao_duong = "Reliveschool17A"
	while weekhs_isStarted do
		nx_pause(0.1)
		local scene = nx_value("form_stage_main\\form_map\\form_map_scene")
		if nx_is_valid(scene) then
			currentMap = LayMapHienTai()
		else
			currentMap = ""
		end
		if step == 0 then
			if currentMap == hs_map_id then
				
				step = 2
			elseif currentMap ~= "" then
				thanhanh_to_hp_by_id("HomePointschool17A") -- Hoa Son
				step = 1
			end
		elseif step == 1 then
			if currentMap == hs_map_id then
		
				step = 2 
			end
		elseif step == 2 then
			add_chat_info("Den cho nhan Quest", 3)
			local pos = {1648.378,142.341,742.440,2.666}
			local npcId = "npc_hsp_wxjz_lh_04"
			den_pos(pos, weekhs_isStarted)
			talk(npcId, {0, 0}, weekhs_isStarted)
			step = 3
		elseif step == 3 then
			local tran_nhan_id = "npc_hsp_wxjz_lh_01"
			add_chat_info("Dang cho tran nhan xuat hien", 3)
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

han_mang_kiem_tran()