require("util_gui")
require("util_static_data")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_blink"

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
    local findPathBusy = false

end

function on_main_form_close(form)
    findPathBusy = false
    nx_destroy(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    form.Left = (gui.Width / 3)
    form.Top = (gui.Height / 2)
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function on_btn_blink_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
    if findPathBusy then
		-- Stop status
		--btn.Text = nx_function("ext_utf8_to_widestr", "Start")
        findPathBusy = false   

    else
		--btn.Text = nx_function("ext_utf8_to_widestr", "Stop")
		-- Check có người xung quanh không?
		if not confirm_blink_nearPlayer(btn) then		
			local FORM_MAP_SCENE = nx_value("form_stage_main\\form_map\\form_map_scene")
			if nx_is_valid(FORM_MAP_SCENE) then
				if FORM_MAP_SCENE.Visible then
					local btn_trace = FORM_MAP_SCENE.btn_trace
					if btn_trace.scene_id == map_id() and btn_trace.Visible then
						local vi_tri_da_chon_x = btn_trace.x
						local vi_tri_da_chon_y = btn_trace.y
						local vi_tri_da_chon_z = btn_trace.z
						jump_to_pos_new(vi_tri_da_chon_x, vi_tri_da_chon_y, vi_tri_da_chon_z, map_id())
					end
				end
			end 
		end
    end
end

-- Show hide form blink
function show_hide_form_blink()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_blink")
end

function jump_to_pos_new(x, y, z, map, fixedY, dissMisscheck)
    local lastArrivePos = {x, y, z}
    -- Xác định tọa độ Y của điểm đến cuối cùng
    local walkHeight, maxHeight, waterHeight = getInfoHeightOfPos(lastArrivePos[1], lastArrivePos[3])
    lastArrivePos[2] = walkHeight
    if waterHeight == walkHeight then
        lastArrivePos[2] = lastArrivePos[2] + 5
    end
    if fixedY ~= nil then
        -- Cố định Y điểm cuối
        lastArrivePos[2] = y
    end

    -- Khoảng cách mỗi bước nhảy
    local stepDistance = 90
    -- Tính toán trước khi nhảy thật
    local isPreCalculate = true
    -- Giả lập tọa độ điểm đến khi tính toán
    local virtualCalcPos = nil

    -- Nếu đến rồi thì dừng
    findPathBusy = true

    -- Tính khoảng cách 2D bởi lẽ cùng x,z mà thay đổi y thì là tự tử
    while not tools_move_isArrived2D(lastArrivePos[1], lastArrivePos[2], lastArrivePos[3], 0.5) and findPathBusy do
	tools_show_notice(nx_function("ext_utf8_to_widestr", "Đang tính toán để blink"), 2)
        local currentPos = nil
        if isPreCalculate then
            if virtualCalcPos == nil then
                -- Khi tính toán thì bước đầu tiên lấy tọa độ nhân vật
                currentPos = get_current_player_pos()
            else
                -- Các bước tiếp theo lấy từ điểm đến
                currentPos = virtualCalcPos
            end
        else
            -- Tọa độ của nhân vật đang đứng
            currentPos = get_current_player_pos()
        end
        if currentPos == nil then
            tools_show_notice(nx_function("ext_utf8_to_widestr", "Lỗi dữ liệu"), 2)
            findPathBusy = false
            return false
        end
        -- Điểm đến tiếp theo
        local nextPos = nil
        -- Điểm đến tiếp theo là điểm cuối cùng
        local isFinalPos = false

        -- Cách nhau stepDistance mét thì là điểm cuối
        if tools_move_isArrived(lastArrivePos[1], lastArrivePos[2], lastArrivePos[3], stepDistance, currentPos) then
            nextPos = lastArrivePos
            isFinalPos = true
        else
            -- Tìm ra điểm tiếp theo
            -- Cách mỗi 10 mét lấy 1 điểm, tối đa stepDistance mét
            -- Nếu tại điểm nào

            local currentDst = 5
            local setPos = nil
            local radian = getAngleForward(currentPos[1], currentPos[3], lastArrivePos[1], lastArrivePos[3])
            local angle = radian_to_degree(radian)
            while 1 do
                local xx = currentPos[1]
                local zz = currentPos[3]
                -- Trước mặt
                if angle <= 90 then
                    zz = zz + math.abs(math.sin(math.pi / 2 - radian) * currentDst)
                    xx = xx + math.abs(math.cos(math.pi / 2 - radian) * currentDst)
                elseif angle > 90 and angle <= 180 then
                    zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * currentDst)
                    xx = xx + math.abs(math.cos(math.pi * 3 / 2 - radian) * currentDst)
                elseif angle > 180 and angle <= 270 then
                    zz = zz - math.abs(math.sin(math.pi * 3 / 2 - radian) * currentDst)
                    xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * currentDst)
                elseif angle > 270 then
                    zz = zz + math.abs(math.sin(math.pi * 3 / 2 - radian) * currentDst)
                    xx = xx - math.abs(math.cos(math.pi * 3 / 2 - radian) * currentDst)
                end
                local posTmp = {xx, -10000, zz}
                -- Xác định chiều cao của pos này
                local walkHeight, maxHeight = getInfoHeightOfPos(posTmp[1], posTmp[3])
                posTmp[2] = maxHeight + 20
                -- Nếu không vượt quá nhân vật stepDistance mét thì lấy điểm đó
                if tools_move_isArrived(posTmp[1], posTmp[2], posTmp[3], stepDistance, currentPos) then
                    setPos = posTmp
                else
                    break
                end
                currentDst = currentDst + 5
                if currentDst > stepDistance then
                    break
                end
            end
            if setPos == nil then
                tools_show_notice(nx_function("ext_utf8_to_widestr", "Địa hình này không thể di chuyển giữa hai điểm, thử chọn điểm đến khác"), 2)
                findPathBusy = false
                return false
            end
            nextPos = setPos
        end
        if nextPos ~= nil then
            if isPreCalculate then
                -- Xử lý khi tính toán
                if isFinalPos then
                    -- Step cuối cùng thì kết thúc tính
                    isPreCalculate = false
                else
                    -- Chưa step cuối thì giả lập điểm đến
                    virtualCalcPos = nextPos
                end
            else
                -- Sau khi tính toán thì thực hiện
                -- Dừng mỗi bước nhảy (giây)
                local stepPause = 5
                if isFinalPos then
                    -- Lần cuối cùng thì không dừng nữa
                    stepPause = 0
                end
                jump_to(nextPos, stepDistance, stepPause, dissMisscheck)
            end
        end
        nx_pause(0.5)
    end

    findPathBusy = false
    tools_show_notice(nx_function("ext_utf8_to_widestr", "Đã đến nơi"))
end

-- Xác nhận vẫn blink khi có người ở gần
function confirm_blink_nearPlayer(btn)
	
	local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
	if isHaveNearPlayer() then
		local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_confirm", true, false)
		if nx_is_valid(dialog) then
			dialog.mltbox_info.HtmlText = nx_function("ext_utf8_to_widestr", "<font color=\"#FF7700\">Có người ở gần! Bạn có muốn thực hiện không?</font>")
			dialog:ShowModal()
			local res = nx_wait_event(100000000, dialog, "confirm_return")
			if res ~= "ok" then
				findPathBusy = true
				return true
			else
				findPathBusy = false
				return false
			end
		else
			return false
		end
	end
end

function isHaveNearPlayer()
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return true
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return true
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return true
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return true
    end
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return true
    end

    -- Quét các đối tượng
    local game_scence_objs = game_scence:GetSceneObjList()
    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
		if nx_is_valid(obj) and obj:QueryProp("Type") == 2 and player_client:QueryProp("Name") ~= obj:QueryProp("Name") and obj:QueryProp("OffLineState") == 0 then
			return true
		end
    end
    return false
end
function map_id()
	local client = nx_value("game_client")
	if not nx_is_valid(client) then
		return
	end
	local scene = client:GetScene()
	if not nx_is_valid(scene) then
		return
	end
	return scene:QueryProp("Resource")
end
function tools_show_notice(info, noticetype)
    if noticetype == nil then
        noticetype = 3
    end
    local SystemCenterInfo = nx_value("SystemCenterInfo")
    if not nx_is_valid(SystemCenterInfo) then
        return false
    end
    SystemCenterInfo:ShowSystemCenterInfo(info, noticetype)
end
function tools_move_isArrived(x, y, z, offset, fixedComparePos)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    if offset == nil then
        offset = 1
    end

    local px, py, pz
    if fixedComparePos == nil then
        px = string.format("%.3f", game_player.PositionX)
        py = string.format("%.3f", game_player.PositionY)
        pz = string.format("%.3f", game_player.PositionZ)
    else
        px = string.format("%.3f", fixedComparePos[1])
        py = string.format("%.3f", fixedComparePos[2])
        pz = string.format("%.3f", fixedComparePos[3])
    end

    local pxd = px - x
    local pyd = py - y
    local pzd = pz - z

    local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)

    if offset >= distance then
        return true
    end
    return false
end
-- Xác định AngleY giữa hai điểm
function getAngleForward(myposx, myposz, toposx, toposz)
    -- x tương ứng trục y. z tương ứng trục x trong mặt phẳng tọa độ
    local x1 = myposz
    local x2 = toposz
    local y1 = myposx
    local y2 = toposx
    if x2 == x1 then
        return 0
    end
    local tana = math.abs(y2 - y1) / math.abs(x2 - x1)
    local radian = math.atan(tana)
    if x2 > x1 and y2 > y1 then
        radian = radian
    elseif x2 < x1 and y2 > y1 then
        radian = math.pi - radian
    elseif x2 < x1 and y2 < y1 then
        radian = math.pi + radian
    elseif x2 > x1 and y2 < y1 then
        radian = (2 * math.pi) - radian
    end
    return radian
end
-- Hàm phụ tính Radian thành độ
function radian_to_degree(radian)
  return math.floor(normalize_angle(radian) * 3600 / (math.pi * 2)) * 0.1
end
--------------------------------
-- Xác định chiều cao của điểm trên MAP
-- trả về 1 là chiều cao đứng
-- 2 là chiều cao cao nhất
--
function getInfoHeightOfPos(x, z)
    local scene = nx_value("game_scene")
    if not nx_is_valid(scene) then
        return nil
    end
    local terrain = scene.terrain
    if not nx_is_valid(terrain) then
        return nil
    end
    -- Chiều cao thực tế tại một điểm
    local posY = terrain:GetPosiY(x, z)
    -- Chiều cao nhân vật sẽ đứng trên mặt đất tại một điểm
    local walkHeight = terrain:GetWalkHeight(x, z)
    -- Chiều cao tối đa tại một điểm
    local maxHeight = walkHeight
    local floorHeightTable = {}
    local floor_count = terrain:GetFloorCount(x, z)
    for i = floor_count - 1, 0, -1 do
        local floor_height = terrain:GetFloorHeight(x, z, i)
        if floor_height ~= posY then
            table.insert(floorHeightTable, floor_height)
        end
        if floor_height > maxHeight then
            maxHeight = floor_height
        end
    end
    -- Kiểm tra chiều cao mặt nước
    local waterHeight = -10000
    if terrain:GetWalkWaterExists(x, z) then
        waterHeight = terrain:GetWalkWaterHeight(x, z)
    end
    -- Nếu chiều cao của nước hơn chiều cao lầu thì trả về chiều cao nước
    if waterHeight > maxHeight then
        maxHeight = waterHeight
    end
    -- Nếu chiều cao của nước hơn chiều cao đứng thì trả về chiều cao nước
    if waterHeight > walkHeight then
        walkHeight = waterHeight
    end
    return walkHeight, maxHeight, waterHeight
end
-- Lấy tọa độ hiện tại của nhân vật
function get_current_player_pos()
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return nil
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return nil
    end
    return {game_player.PositionX, game_player.PositionY, game_player.PositionZ}
end
-- Nhảy 1 phát đến tọa độ nào đó
-- Khoảng cách nhảy không quá lớn
-- dissMisscheck => Nil thì sẽ check điểm đến, không thì chỉ nhảy
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
function tools_move_isArrived2D(x, y, z, offset, fixedComparePos)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    if offset == nil then
        offset = 1
    end

    local px, py, pz
    if fixedComparePos == nil then
        px = string.format("%.3f", game_player.PositionX)
        py = string.format("%.3f", game_player.PositionY)
        pz = string.format("%.3f", game_player.PositionZ)
    else
        px = string.format("%.3f", fixedComparePos[1])
        py = string.format("%.3f", fixedComparePos[2])
        pz = string.format("%.3f", fixedComparePos[3])
    end

    local pxd = px - x
    local pyd = py - y
    local pzd = pz - z

    local distance = math.sqrt(pxd * pxd + pzd * pzd)

    if offset >= distance then
        return true
    end
    return false
end