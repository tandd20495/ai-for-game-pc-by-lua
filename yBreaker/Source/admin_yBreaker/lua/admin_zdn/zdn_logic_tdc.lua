require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_jump")
require("util_functions")

local Running = false
local CLONE_SAVE_REC = "clone_rec_save"
local BOSS_LIST = {
    {"boss_clone035_bshw", 1468.8354492188, 24.177389144897, 258.96395874023},
    {"boss_clone035_dlxw", 1404.1009521484, 23.656002044678, 184.57182312012},
    {"boss_clone035_myfr", 1513.7033691406, 23.47924041748, 154.87759399414}
}
local FOLLOW_POS_LIS = {
    {1447.6704101563, 35.958553314209, 295.60794067383},
    -- {1429.162109375, 31.595001220703, 162.93255615234},
    {1443.8868408203, 27.509447097778, 182.16865539551},
    {1487.052734375, 29.38990020752, 173.97309875488}
}
local FollowFlg = false
local NEED_OPEN_ITEM = {
    "box_fc_mml_001", -- ma mon lenh
    "box_fc_mml_002", -- ma mon lenh
    "box_fc_hss_001", -- hoang thu thach
    "box_fc_hss_002", -- hoang thu thach
    "box_xmp_fc_01" -- long van cam thach
}
local BUFFER_BOSS_JUMP = {
    {1462.1048583984, 28.933506011963, 217.05558776855},
    {1466.9127197266, 31.283208847046, 148.8816986084},
    {1468.6665039063, 24.344289779663, 264.31848144531}
}

local SAFETY_POS = {
    {{1477.5596923828, 24.186737060547, 255.86683654785}, {1450.8690185547, 24.090394973755, 266.58248901367}},
    {{1411.0574951172, 23.200632095337, 201.29350280762}, {1405.1953125, 23.200632095337, 167.31872558594}},
    {{1537.5716552734, 23.353530883789, 149.6643371582}, {1507.9750976563, 23.473001480103, 159.42253112793}}
}
local BOSS_BOX_PREFIX = "BossBox_Clone035"
local CloneMap = "clone035"
local TimerEnterClone = 0
local TimerCurseLoading = 0
local TimerOpenReward = 0
local TimerMinClick = 0
local TimerNgoiThien = 0
local FinishTurn = 0
local MaxTurn = 1
local PickAllFlg = false

function IsRunning()
    return Running
end

function Start()
    if Running then
        return
    end
    Running = true
    loadConfig()
    if FinishTurn >= MaxTurn then
        Stop()
        return
    end
    if not FollowFlg then
        createTeam()
    end
    while Running do
        loopTdc()
        nx_pause(0.1)
    end
end

function Stop()
    Running = false
    nx_execute("admin_zdn\\zdn_logic_dan", "Stop")
    nx_execute("admin_zdn\\zdn_logic_skill", "StopAutoAttack")
    StopFindPath()
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

-- private
function loopTdc()
    if IsMapLoading() then
        return
    end
    if isCurseLoading() then
        return
    end
    if not isInClone() then
        local formMin = "form_stage_main\\form_clone_awards_min"
        local mF = nx_value(formMin)
        if nx_is_valid(mF) and mF.Visible and TimerDiff(TimerMinClick) > 1 then
            nx_execute(formMin, "on_btn_1_click", mF.btn_1)
            TimerMinClick = TimerInit()
            return
        end

        if TimerDiff(TimerEnterClone) > 5 then
            TimerEnterClone = TimerInit()
            local form = nx_value("form_stage_main\\form_clone\\form_clone_guide")
			if nx_is_valid(form) and form.Visible then
				nx_execute("form_stage_main\\form_clone\\form_clone_guide", "on_btn_reset_clone_click", form.btn_reset_clone)
				
				-- Đóng form sau khi reset
				nx_execute("form_stage_main\\form_clone\\form_clone_guide", "on_btn_close_click", form.btn_close)
				
				return
			end
            nx_execute("admin_zdn\\zdn_listener", "addListen", nx_current(), "15906", "resetClone", 10)
            nx_execute("custom_sender", "custom_random_clone", nx_int(4), "ini\\scene\\clone035", nx_int(1))
        end
        return
    end
    doClone()
end

function isInClone()
    return GetCurMap() == CloneMap
end

function isCurseLoading()
    local load = nx_value("form_stage_main\\form_main\\form_main_curseloading")
    if nx_is_valid(load) and load.Visible then
        TimerCurseLoading = TimerInit()
    end
    return TimerDiff(TimerCurseLoading) < 0.5
end

function doClone()
    if nx_execute("admin_zdn\\zdn_logic_skill", "IsPlayerDead") then
        nx_execute("custom_sender", "custom_relive", 2)
        return
    end
    if needPickDropItem() then
        return
    end
    if needOpenRewardOrChess() then
        nx_execute("admin_zdn\\zdn_logic_dan", "Stop")
        PickAllFlg = false
        nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
        nx_execute("admin_zdn\\zdn_logic_skill", "StopParry")
        return
    end
    if needOpenItem() then
        nx_execute("admin_zdn\\zdn_logic_dan", "Stop")
        PickAllFlg = true
        return
    end
    local step = getStep()
    if step > #BOSS_LIST then
        onDoneTurn()
        return
    end
    if FollowFlg then
        doFollow()
        return
    end

    if isReadyToNextBoss() then
        nx_execute("admin_zdn\\zdn_logic_skill", "StopNgoiThien")
        if TimerDiff(TimerNgoiThien) <= 2 then
            return
        end
    elseif nx_execute("admin_zdn\\zdn_logic_base", "GetLogicState") ~= 1 then
        nx_execute("admin_zdn\\zdn_logic_skill", "NgoiThien")
        return
    end
    local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isCurrentStepBoss")
    if not nx_is_valid(obj) or GetDistanceToObj(obj) > 40 then
        nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
        goToCurrentBoss()
        return
    end
    attackBoss(obj)
end

function isCurrentStepBoss(obj)
    local step = getStep()
    if step == 0 then
        return false
    end
    if step > #BOSS_LIST then
        return false
    end
    if nx_number(obj:QueryProp("Dead")) == 1 then
        return false
    end
    return obj:QueryProp("ConfigID") == BOSS_LIST[step][1]
end

function goToCurrentBoss()
    local step = getStep()
    if step == 0 then
        return
    end
    if step > #BOSS_LIST then
        step = #BOSS_LIST
    end
    local boss = BOSS_LIST[step]
    local bossDistance = GetDistance(boss[2], boss[3], boss[4])
    if bossDistance > 8 and bossDistance < 93 then
        FlyToPos(boss[2], boss[3], boss[4])
        return
    end
    local cnt = #BUFFER_BOSS_JUMP
    for i = 1, cnt do
        local p = BUFFER_BOSS_JUMP[i]
        local pD = GetDistance(p[1], p[2], p[3])
        if pD > 8 and pD < 93 and distance3d(boss[2], boss[3], boss[4], p[1], p[2], p[3]) < bossDistance then
            FlyToPos(p[1], p[2], p[3])
            return
        end
    end
end

function attackObj(obj)
    nx_execute("admin_zdn\\zdn_logic_skill", "FlexAttackObj", obj)
end

function needGoToSafetyPos(obj)
    local skillId = nx_string(obj:QueryProp("CurSkillID"))
    if skillId == "skill_clone035_myfr_02" then
        return false
    end
    if skillId ~= nx_string("") and skillId ~= nx_string("0") and skillId ~= nx_string("default_normal_skill") then
        return true
    end
    return false
end

function createTeam()
    local TEAM_REC = "team_rec"
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        Stop()
        return
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        Stop()
        return
    end
    local cn = nx_widestr(player:QueryProp("TeamCaptain"))
    if cn == nx_widestr("0") or cn == nx_widestr("") then
        nx_execute("custom_sender", "custom_team_create")
        nx_pause(2)
    end
    cn = nx_widestr(player:QueryProp("TeamCaptain"))
    if cn == nx_widestr(player:QueryProp("Name")) then
        nx_execute("custom_sender", "custom_set_team_allot_mode", 0)
    end
end

function needOpenRewardOrChess()
    if TimerDiff(TimerOpenReward) < 3 then
        return true
    end
    if TimerDiff(TimerOpenReward) >= 3 and TimerDiff(TimerOpenReward) <= 4 then
        local form = nx_value("form_stage_main\\form_clone_col_awards")
        if nx_is_valid(form) and nx_find_custom(form, "btn_close") then
            nx_execute("form_stage_main\\form_clone_col_awards", "on_btn_close_click", form.btn_close)
            return true
        end
    end
    local form = nx_value("form_stage_main\\form_clone_col_awards")
    if nx_is_valid(form) then
        nx_execute("custom_sender", "custom_clone_request_open_col_award")
        TimerOpenReward = TimerInit()
        return true
    end
    if FollowFlg then
        return false
    end
    local bossChess = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isBossChess")
    if not nx_is_valid(bossChess) then
        return false
    end
    local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isAttackingMeObj")
    if nx_is_valid(obj) then
        attackObj(obj)
        return true
    end
    if GetDistanceToObj(bossChess) > 2.8 then
        nx_execute("admin_zdn\\zdn_logic_base", "SelectTarget", bossChess)
        GoToObj(bossChess)
        return true
    end
    nx_execute("custom_sender", "custom_select", bossChess.Ident)
    TimerOpenReward = TimerInit()
    return true
end

function isBossChess(obj)
    local isClicked = nx_number(obj:QueryProp("Dead")) == 1
    local npcType = nx_number(obj:QueryProp("NpcType"))
    local isBossChess = nx_string(obj:QueryProp("RotatePara")) == "0"
    return (not isClicked) and npcType == 161 and isBossChess and obj:FindProp("OpenRange")
end

function isAttackingMeObj(obj)
    if isCurrentStepBoss(obj) then
        return false
    end
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return false
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return false
    end
    if nx_number(obj:QueryProp("Dead")) == 1 then
        return false
    end
    return nx_string(obj:QueryProp("LastObject")) == nx_string(player.Ident)
end

function onDoneTurn()
    if TimerDiff(TimerDoneTurn) < 3 then
        return
    end
    FinishTurn = FinishTurn + 1
    IniWriteUserConfig(
        "TDC",
        "FinishTurn",
        nx_string(nx_execute("admin_zdn\\zdn_logic_base", "GetCurrentWeekStartTimestamp")) .. "," .. nx_string(FinishTurn)
    )
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-done-turn")
    local CLIENT_SUBMSG_REQUEST_OUT_CLONE = 5
    nx_execute("custom_sender", "custom_random_clone", nx_int(CLIENT_SUBMSG_REQUEST_OUT_CLONE))
    if FinishTurn >= MaxTurn then
        Stop()
    end
    TimerDoneTurn = TimerInit()
end

function isReadyToNextBoss()
    local client = nx_value("game_client")
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        TimerNgoiThien = TimerInit()
        return false
    end
    local hpRatio = nx_number(player:QueryProp("HPRatio"))
    local mpRatio = nx_number(player:QueryProp("MPRatio"))
    if
        ((hpRatio >= 74 and nx_execute("admin_zdn\\zdn_logic_skill", "HaveBuff", "buf_baosd_01")) or hpRatio >= 95) and
            mpRatio >= 90
     then
        return true
    end
    TimerNgoiThien = TimerInit()
    return false
end

function needOpenItem()
    for i = 1, #NEED_OPEN_ITEM do
        local idx = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromVatPham", NEED_OPEN_ITEM[i])
        if idx ~= 0 then
            nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseItem", 2, idx)
            PickAllFlg = true
            return true
        end
    end
    return false
end

function resetClone()
    nx_execute("custom_sender", "captain_reset_save_clone", "ini\\scene\\clone035", nx_int(1))
end

function getSafetyPos(obj)
    local step = getStep()
    if step == 0 then
        return 0, 0, 0
    end
    local s1 = SAFETY_POS[step][1]
    local s2 = SAFETY_POS[step][2]

    if GetDistanceObjToPosition(obj, s1[1], s1[2], s1[3]) > GetDistanceObjToPosition(obj, s2[1], s2[2], s2[3]) then
        return s1[1], s1[2], s1[3]
    else
        return s2[1], s2[2], s2[3]
    end
end

function loadConfig()
    nx_execute("admin_zdn\\zdn_logic_vat_pham", "LoadPickItemData")
    MaxTurn = nx_number(IniReadUserConfig("TDC", "MaxTurn", 1))

    local str = nx_string(IniReadUserConfig("TDC", "FinishTurn", ""))
    local cT = nx_execute("admin_zdn\\zdn_logic_base", "GetCurrentWeekStartTimestamp")
    FinishTurn = 0
    if str ~= "" then
        local prop = util_split_string(str, ",")
        local t = nx_number(prop[1])
        if t == cT then
            FinishTurn = nx_number(prop[2])
        end
    end
    FollowFlg = nx_string(IniReadUserConfig("TDC", "Follow", "0")) == "1"
end

function needPickDropItem()
    if nx_execute("admin_zdn\\zdn_logic_vat_pham", "IsDroppickShowed") then
        if PickAllFlg then
            nx_execute("admin_zdn\\zdn_logic_vat_pham", "PickAllDropItem")
        else
            nx_execute("admin_zdn\\zdn_logic_vat_pham", "FlexPickItem")
        end
        return true
    end
    if nx_execute("admin_zdn\\zdn_logic_vat_pham", "IsCloneAwardsShowed") then
        nx_execute("admin_zdn\\zdn_logic_vat_pham", "PickItemFromPickItemDataClone")
        return true
    end
    return false
end

function getStep()
    local form =
        nx_execute("util_gui", "util_get_form", "form_stage_main\\form_common_notice", false, false, "CommonNoteForm4")
    if not nx_is_valid(form) then
        return 0
    end
    if not nx_find_custom(form, "ImageControlGrid1") then
        return 0
    end
    local txt = form.ImageControlGrid1.MultiTextBox1.HtmlText
    if txt == util_text("sys_clone035_002") then
        return 1
    end
    if txt == util_text("sys_clone035_004") then
        return 2
    end
    if txt == util_text("sys_clone035_006") then
        local mF = nx_value("form_stage_main\\form_clone_awards_min")
        if nx_is_valid(mF) and mF.Visible then
            return 4
        end
        return 3
    end
    return 4
end

function distance3d(bx, by, bz, dx, dy, dz)
    return math.sqrt((dx - bx) * (dx - bx) + (dy - by) * (dy - by) + (dz - bz) * (dz - bz))
end

function needParry(obj)
    local skillId = nx_string(obj:QueryProp("CurSkillID"))
    return skillId == "skill_clone035_bshw_03" or skillId == "skill_clone035_myfr_03"
end

function attackBoss(obj)
    local mob = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isAttackingMeObj")
    if needGoToSafetyPos(obj) then
        local x, y, z = getSafetyPos(obj)
        if GetDistance(x, y, z) > 10 then
            nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
            WalkToPosInstantly(x, y, z)
        elseif nx_is_valid(mob) and GetDistanceObjToPosition(mob, x, y, z) < 10 then
            if needParry(obj) then
                nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
                nx_execute("admin_zdn\\zdn_logic_skill", "StartParry")
                return
            end
            attackObj(mob)
        else
            nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
            nx_execute("admin_zdn\\zdn_logic_skill", "StartParry")
        end
        return
    end
    local mob = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isAttackingMeObj")
    if nx_is_valid(mob) and GetDistanceToObj(obj) >= 6 then
        attackObj(mob)
        return
    end
    attackObj(obj)
end

function doFollow()
    local step = getStep()
    if step == 0 then
        return
    end
    if step > #BOSS_LIST then
        step = #BOSS_LIST
    end
    local follow = FOLLOW_POS_LIS[step]
    local followDistance = GetDistance(follow[1], follow[2], follow[3])
    if followDistance < 3 then
        nx_execute("admin_zdn\\zdn_logic_dan", "Start")
        return
    end
    nx_execute("admin_zdn\\zdn_logic_dan", "Stop")
    if followDistance < 93 then
        FlyToPos(follow[1], follow[2], follow[3])
        return
    end
    local cnt = #BUFFER_BOSS_JUMP
    for i = 1, cnt do
        local p = BUFFER_BOSS_JUMP[i]
        local pD = GetDistance(p[1], p[2], p[3])
        if pD > 3 and pD < 93 and distance3d(follow[1], follow[2], follow[3], p[1], p[2], p[3]) < followDistance then
            FlyToPos(p[1], p[2], p[3])
            return
        end
    end
end
