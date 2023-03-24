local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\core.lua"))
file()

local Ext_HomePoint = 5
local Query_TimeDown = 0
local Use_HomePoint = 1
local Add_HomePoint = 2
local Del_HomePoint = 3
require("form_stage_main\\form_homepoint\\home_point_data")

function thanhanh_remove_hp_by_id(id)
	send_homepoint_msg_to_server(Del_HomePoint, id) --TODO
end

function thanhanh_add_hp_by_id(id)
	send_homepoint_msg_to_server(Add_HomePoint, id) --TODO
end

function thanhanh_get_removable_hp()
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	local hpCount = client_player:GetRecordRows("HomePointList")
	if hpCount < 6 then -- neu < 6 la con trong than hanh, co the them moi
		return nil
	end
	for row = 1, hpCount - 1 do
		local hp_id = client_player:QueryRecord("HomePointList", row, 0)
		local hp_type = client_player:QueryRecord("HomePointList", row, 1)
		if hp_type ~= 2 then -- khac school point
			return hp_id
		end
	end
	return nil
end
local TeleTimer = 0
function thanhanh_to_hp_by_id(id)
	local form = nx_value("form_stage_main\\form_main\\form_main_curseloading")
	if nx_is_valid(form) and form.Visible then
		TeleTimer = timerInit() --TODO
		return
	end
	if timerDiff(TeleTimer) < 2 then --TODO
		return
	end
	local is_exits_point = nx_execute("form_stage_main\\form_homepoint\\home_point_data", "IsExistRecordHomePoint", id)
	if not is_exits_point then			
		local last_hp = thanhanh_get_removable_hp()
		if last_hp ~= nil then
			add_chat_info("Xóa Điểm Dừng Chân")
			add_chat_info_raw(text("ui_"..last_hp))
			thanhanh_remove_hp_by_id(last_hp)
		end
		nx_pause(0.5)
		thanhanh_add_hp_by_id(id)
		nx_pause(0.5)
	end
	add_chat_info("Đang Tele đến")
	add_chat_info_raw(text("ui_"..id))
	send_homepoint_msg_to_server(Use_HomePoint, id)
end

function thanhanh_bay_ben(dest, stepDistance, isStarted)
	local cur = currentPos() --TODO
	if cur == nil then
		return
	end
	local desty = dest[2]
	local dx = dest[1] - cur[1]
	local dz = dest[3] - cur[3]
	local a = dz/dx
	local b = dest[3] - a*dest[1]
	local distance = math.sqrt(dx * dx + dz * dz)
	local steps = math.ceil(distance / stepDistance)
	local dxStepDistance = dx/steps
	local current_step = 1
	local scene = nx_value("game_scene")
	local terrain = scene.terrain
	local role = nx_value("role")
	while isStarted() and current_step <= steps and not nx_value("loading") do
		nx_pause(0)
		SendNotice("Step: " ..current_step .."/" ..steps, 3)
		local x = cur[1] + dxStepDistance*current_step
		local z = a*x + b
		-- function check_y()
			-- y, floor_index = thanhanh_check_y(terrain, x, z)
		-- end
		-- local y, floor_index = thanhanh_check_y(terrain, x, z)
		-- if current_step == steps then
			-- if desty ~= nil and desty ~= 0.000 then
				-- y = desty
			-- end
		-- else
			-- pcall(check_y)
		-- end
		-- local index = "["..nx_string(current_step) .."]["..nx_string(floor_index) .."]"
		-- local pos = {x,y,z}
		-- if not arrived(pos, 3) then
			-- jump_to_arrived(pos, isStarted, index) --TODO
			--terrain:RelocateVisual(role, nx_float(x), nx_float(y), nx_float(z))
		-- else
			-- current_step = current_step + 1
		-- end
		local y, floor_index = thanhanh_check_y(terrain, x, z)
		if current_step == steps then
			x = dest[1]
			z = dest[3]
			y = y - 5
			floor_index = nil
		end
		local index = "["..nx_string(current_step) .."]["..nx_string(floor_index) .."]"
		local pos = {x,y,z}
		-- if not arrived(pos) then
			jump_to_arrived(pos, isStarted, index)
			--terrain:RelocateVisual(role, nx_float(x), nx_float(y), nx_float(z))
		-- else
			current_step = current_step + 1
		-- end
	end
end

function thanhanh_bay_den(dest, stepDistance, isStarted)
	local cur = currentPos() --TODO
	if cur == nil then
		return
	end
	local desty = dest[2]
	local dx = dest[1] - cur[1]
	local dz = dest[3] - cur[3]
	local a = dz/dx
	local b = dest[3] - a*dest[1]
	local distance = math.sqrt(dx * dx + dz * dz)
	local steps = math.ceil(distance / stepDistance)
	local dxStepDistance = dx/steps
	local current_step = 1
	local scene = nx_value("game_scene")
	local terrain = scene.terrain
	local role = nx_value("role")
	while isStarted and current_step <= steps and not nx_value("loading") do
		nx_pause(0)
		SendNotice("Step: " ..current_step .."/" ..steps, 3)
		local x = cur[1] + dxStepDistance*current_step
		local z = a*x + b
		-- function check_y()
			-- y, floor_index = thanhanh_check_y(terrain, x, z)
		-- end
		-- local y, floor_index = thanhanh_check_y(terrain, x, z)
		-- if current_step == steps then
			-- if desty ~= nil and desty ~= 0.000 then
				-- y = desty
			-- end
		-- else
			-- pcall(check_y)
		-- end
		-- local index = "["..nx_string(current_step) .."]["..nx_string(floor_index) .."]"
		-- local pos = {x,y,z}
		-- if not arrived(pos, 3) then
			-- jump_to_arrived(pos, isStarted, index) --TODO
			--terrain:RelocateVisual(role, nx_float(x), nx_float(y), nx_float(z))
		-- else
			-- current_step = current_step + 1
		-- end
		local y, floor_index = thanhanh_check_y(terrain, x, z)
		if current_step == steps then
			x = dest[1]
			z = dest[3]
			y = y - 5
			floor_index = nil
		end
		local index = "["..nx_string(current_step) .."]["..nx_string(floor_index) .."]"
		local pos = {x,y,z}
		-- if not arrived(pos) then
			jump_to_arrived(pos, isStarted, index)
			--terrain:RelocateVisual(role, nx_float(x), nx_float(y), nx_float(z))
		-- else
			current_step = current_step + 1
		-- end
	end
end

function thanhanh_check_y(terrain, x, z)
	local floor_index = 0
	local y = terrain:GetPosiY(x, z)
	if terrain:GetWalkWaterExists(x, z) and y < terrain:GetWalkWaterHeight(x, z) then
		y = terrain:GetWalkWaterHeight(x, z) + 15
	else
		local floor, floor_y = get_pos_floor_index(terrain, x, y, z)
		if floor > -1 then
			y = floor_y
			floor_index = floor
		end
	end
	return y + 5, floor_index
end

function get_pos_floor_index(terrain, x, y, z)
  local floor_num = terrain:GetFloorCount(x, z)
  local higher_floor = -1
  local higher_floor_y = 1000
  local lower_floor = -1
  local lower_floor_y = -1000
  for i = floor_num - 1, 0, -1 do
    if terrain:GetFloorExists(x, z, i) then
      local floor_y = terrain:GetFloorHeight(x, z, i)
      if y < floor_y and higher_floor_y > floor_y then
        higher_floor = i
        higher_floor_y = floor_y
      end
      if y >= floor_y and lower_floor_y < floor_y then
        lower_floor = i
        lower_floor_y = floor_y
      end
    end
  end
  local min_distance = 1000
  if higher_floor > -1 then
    min_distance = higher_floor_y - y
  end
  if lower_floor > -1 then
    if min_distance > y - lower_floor_y then
      min_distance = y - lower_floor_y
      return lower_floor, lower_floor_y
    else
      return higher_floor, higher_floor_y
    end
  end
  return higher_floor, higher_floor_y
end

function mo_than_hanh()
	send_homepoint_msg_to_server(Ext_HomePoint)
end

function setGlobalHomePointList()
	local HOME_POINT_FILE = nx_resource_path() .. "auto\\data\\homepoint.ini"
	local map = nx_string(IniRead(HOME_POINT_FILE, "school", "map", "0"))
	local mapList = util_split_string(map, ";")
	GLOBAL_HOME_POINT_LIST = {}
	for i = 1, #mapList do
		local mapInfo = util_split_string(mapList[i], ",")
		GLOBAL_HOME_POINT_LIST[i] = {
			mapId = mapInfo[1],
			mapPoint = mapInfo[2]
		}
	end
end

function getHomePoint(mapId)
	if GLOBAL_HOME_POINT_LIST == nil or #GLOBAL_HOME_POINT_LIST == 0 then
		setGlobalHomePointList()
	end
	for i, map in pairs(GLOBAL_HOME_POINT_LIST) do
		if nx_string(map.mapId) == nx_string(mapId) then
			return map.mapPoint
		end
	end
	return "0"	
end

function tele_ve_map(mapId)
  if mapId == "school13" then
    tele_HuyetDaoMon()
  else
    thanhanh_to_hp_by_id(getHomePoint(mapId))
  end  
end

function tele_HuyetDaoMon()
	local TIET_KINH_NHUC = {
		name = "Tiết Kính Nhục",
		pos = nil,
		menu = {0,0,0},
		dclick = 9,
		mapId = "born02"
	}
	talk_to(TIET_KINH_NHUC, TIET_KINH_NHUC.menu)
end

function jump_to(pos, stepDistance, stepPause, dissMisscheck)
    if stepDistance == nil then
        stepDistance = 50
    end
    if stepPause == nil then
        stepPause = 2
    end
    if not tools_move_isArrived(pos[1], pos[2], pos[3], 0.5) then
        local x = nx_float(pos[1])
        local y = nx_float(pos[2])
        local z = nx_float(pos[3])
        local px = string.format("%.3f", nx_string(x))
        local py = string.format("%.3f", nx_string(y))
        local pz = string.format("%.3f", nx_string(z))

        local game_visual = nx_value("game_visual")
        if not nx_is_valid(game_visual) then
            return false
        end
        local game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            return false
        end
        local role = nx_value("role")
        if not nx_is_valid(role) then
            return false
        end
        local scene_obj = nx_value("scene_obj")
        if not nx_is_valid(scene_obj) then
            return false
        end
        local game_player = game_visual:GetPlayer()
        if not nx_is_valid(game_player) then
            return false
        end
        local player_client = game_client:GetPlayer()
        if not nx_is_valid(player_client) then
            return false
        end

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
        game_visual:SetRoleMoveDistance(role, stepDistance)
        game_visual:SetRoleMaxMoveDistance(role, 1)
        game_visual:SwitchPlayerState(role, 1, 103)
        if stepPause > 0 then
            nx_pause(stepPause)
            --if dissMisscheck == nil then
                --local scene = nx_value("game_scene")
                --while (nx_is_valid(scene) and not scene.terrain.LoadFinish) or ((nx_is_valid(player_client) and nx_is_valid(game_player)) and not tools_move_isArrived2D(player_client.DestX, player_client.DestY, player_client.DestZ, 1, {game_player.PositionX, game_player.PositionY, game_player.PositionZ})) do
                --    nx_pause(0)
                --end
            --end
        end
    end
end