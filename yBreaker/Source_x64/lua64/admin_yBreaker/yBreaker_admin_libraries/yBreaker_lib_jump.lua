require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_util")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_lib_moving")
--private
local function distance3d(bx, by, bz, dx, dy, dz)
    return math.sqrt((dx - bx) * (dx - bx) + (dy - by) * (dy - by) + (dz - bz) * (dz - bz))
end

local function setAngle(x, y, z)
    local role = nx_value("role")
    local scene_obj = nx_value("scene_obj")
    if not nx_is_valid(role) or not nx_is_valid(scene_obj) then
        return
    end
    scene_obj:SceneObjAdjustAngle(role, x, z)
end

local function isFlying(...)
    local target_role = nx_value("role")
    local link_role = target_role:GetLinkObject("actor_role")
    if nx_is_valid(link_role) then
        target_role = link_role
    end
    local action_list = target_role:GetActionBlendList()
    for i, action in pairs(action_list) do
        if string.find(action, "jump") ~= nil then
            return true
        end
    end
    return false
end

local function flyToPos(cur_x, cur_y, cur_z, x, y, z)
    local role = nx_value("role")
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(role) or not nx_is_valid(game_visual) then
        return
    end
    local dis = distance3d(role.PositionX, role.PositionY, role.PositionZ, cur_x, cur_y, cur_z)
    if not (cur_x == 0 and cur_y == 0 and cur_z == 0) and dis > 6 then
        return
    end

    StopFindPath()
    nx_call("player_state\\state_input", "emit_player_input", role, 9)
    nx_pause(0.5)
    y = y + 0.1
    setAngle(x, y, z)
    local temp_angle = role.AngleY
    nx_call("player_state\\state_input", "emit_player_input", role, 21, 36, x, y, z, 0, 3)
    nx_pause(2.8)

    role.state = "jump"
    role.move_dest_orient = temp_angle
    role.server_pos_can_accept = true
    role:SetPosition(role.PositionX, y, role.PositionZ)
    game_visual:SetRoleMoveDestX(role, x)
    game_visual:SetRoleMoveDestY(role, y)
    game_visual:SetRoleMoveDestZ(role, z)
    game_visual:SetRoleMoveDistance(role, 1)
    game_visual:SetRoleMaxMoveDistance(role, 1)
    game_visual:SwitchPlayerState(role, 1, 103)
    role.state = "jump"

    local timeOut = TimerInit()
    while TimerDiff(timeOut) < 3 do
        nx_pause(0.1)
        if not isFlying() then
            return
        end
    end
end

local function getVisualObj(obj)
    if not nx_is_valid(obj) then
        return
    end
    return nx_value("game_visual"):GetSceneObj(obj.Ident)
end

function FlyToObj(obj)
    local pX, pY, pZ = GetPlayerPosition()
    local vObj = getVisualObj(obj)
    if not nx_is_valid(vObj) then
        return
    end
    local posX = vObj.PositionX
    local posY = vObj.PositionY
    local posZ = vObj.PositionZ
    flyToPos(pX, pY, pZ, posX, posY, posZ)
end

function FlyToPos(posX, posY, posZ)
    local role = nx_value("role")
    if not nx_is_valid(role) or role.state == "locked" then
        return
    end
    local pX, pY, pZ = GetPlayerPosition()
    if distance3d(pX, pY, pZ, posX, posY, posZ) <= 2 then
        return
    end
    flyToPos(pX, pY, pZ, posX, posY, posZ)
end

function HighJumpToPos(x, y, z)
    local role = nx_value("role")
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(role) or not nx_is_valid(game_visual) then
        return
    end
    setAngle(x, y, z)
    nx_call("player_state\\state_input", "emit_player_input", role, 9)
    setAngle(x, y, z)
    nx_pause(0.5)
    nx_call("player_state\\state_input", "emit_player_input", role, 9)
    nx_pause(0.5)
    nx_call("player_state\\state_input", "emit_player_input", role, 9)
    nx_pause(1)
    setAngle(x, y, z)
    role.move_dest_orient = role.AngleY
    role.server_pos_can_accept = true
    role:SetPosition(role.PositionX, y, role.PositionZ)
    game_visual:SetRoleMoveDestX(role, x)
    game_visual:SetRoleMoveDestY(role, y)
    game_visual:SetRoleMoveDestZ(role, z)
    game_visual:SetRoleMoveDistance(role, 1)
    game_visual:SetRoleMaxMoveDistance(role, 1)
    game_visual:SwitchPlayerState(role, 1, 103)
end

function SlowJumpToPos(x, y, z)
    local role = nx_value("role")
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(role) or not nx_is_valid(game_visual) then
        return
    end
    setAngle(x, y, z)
    nx_call("player_state\\state_input", "emit_player_input", role, 9)
    setAngle(x, y, z)
    nx_pause(0.5)
    nx_call("player_state\\state_input", "emit_player_input", role, 9)
    nx_pause(2)
    setAngle(x, y, z)
    role.move_dest_orient = role.AngleY
    role.server_pos_can_accept = true
    role:SetPosition(role.PositionX, y, role.PositionZ)
    game_visual:SetRoleMoveDestX(role, x)
    game_visual:SetRoleMoveDestY(role, y)
    game_visual:SetRoleMoveDestZ(role, z)
    game_visual:SetRoleMoveDistance(role, 1)
    game_visual:SetRoleMaxMoveDistance(role, 1)
    game_visual:SwitchPlayerState(role, 1, 103)
end
