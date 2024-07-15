-- Dùng thư viện
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")
------------------------------------

-- Buff đầy máu và mana ngay lập tức
function buff_full_hpmp()
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return false
    end
    -- Lãm Tước Vĩ Cổ
    --local skill_id = "CS_wd_tjq07" -- Cổ
	local skill_id = "CS_wdzp_tjq07" -- Thường
    local skill = fight:FindSkill(skill_id)
    if not nx_is_valid(skill) then
        tools_show_notice(nx_function("ext_utf8_to_widestr", "Chưa học Lãm Tước Vĩ chưa xài được chức năng này"), 2)
        return
    end
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return false
    end
    -- Xem skill đang xài hay không
    local cool_type = skill_static_query_by_id(skill_id, "CoolDownCategory")
    local cool_team = skill_static_query_by_id(skill_id, "CoolDownTeam")
    local target_type = skill_static_query_by_id(skill_id, "TargetType")
    if cool_type < 0 or gui.CoolManager:IsCooling(nx_int(cool_type), nx_int(cool_team)) then
        tools_show_notice(nx_function("ext_utf8_to_widestr", "Lãm Tước Vĩ (cổ) đang hồi, vui lòng đợi"), 2)
        return
    end

    -- Xài skill
    fight:TraceUseSkill(skill_id, false, false)
    nx_pause(2)

    -- Buff mana
    --if nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "isAdmRights") and nx_is_valid(game_player) and get_buff_info("buf_CS_wd_tjq07") ~= nil then -- Buff cổ
	if nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "isAdmRights") and nx_is_valid(game_player) and get_buff_info("buf_CS_wdzp_tjq07") ~= nil then -- Buff thường
        local x = nx_float(game_player.PositionX)
        local y = nx_float(game_player.PositionY)
        local z = nx_float(game_player.PositionZ)
        local game_visual = nx_value("game_visual")
        local role = nx_value("role")
        local scene_obj = nx_value("scene_obj")
        scene_obj:SceneObjAdjustAngle(role, x, z)
        role.move_dest_orient = role.AngleY
        role.server_pos_can_accept = true
        game_visual:SwitchPlayerState(role, 1, 5)
        game_visual:SwitchPlayerState(role, 1, 6)
        game_visual:SwitchPlayerState(role, 1, 7)
	
        role:SetPosition(role.PositionX, y, role.PositionZ)
        game_visual:SetRoleMoveDestX(role, x)
        game_visual:SetRoleMoveDestY(role, y)
        game_visual:SetRoleMoveDestZ(role, z)
        game_visual:SetRoleMoveDistance(role, 1)
        game_visual:SetRoleMaxMoveDistance(role, 1)
        game_visual:SwitchPlayerState(role, 1, 103)
    end
end

-- Run function
buff_full_hpmp()

