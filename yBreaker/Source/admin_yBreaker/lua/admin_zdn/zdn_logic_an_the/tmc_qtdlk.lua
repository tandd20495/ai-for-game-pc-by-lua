require("util_functions")
require("form_stage_main\\form_task\\task_define")
require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")

local Running = false
local QUEST_ID = "tmc_qtdlk"
local NPC_MAP = "school23"
local NPC_CONFIG_ID = "npcmp_lzy_xmg_drrc_001"
local NPC_HUA_BAN_THOI_CONFIG_ID = "npcmp_lzy_xmg_drrc_004"
local NPC_HUA_BAN_THOI2_CONFIG_ID = "npcmp_lzy_xmg_drrc_004_a"
local TASK_INDEX = 74250
local QUAN_TINH_DAO_TELE_POINT = "GotoDoorxmg_jch01"
local TINH_MIEU_CAC_TELE_POINT = "GotoDoorxmg_jch02"
local ITEMTYPE_WEAPON_SSWORD = 105
local TimerStartThiLuyen = 0
local TimerCheckWeapon = 0
local TimerSpecialSkill = 0
local TimerQuanTinhDao = 0
local TimerLeaveQuanTinhDao = 0

function IsRunning()
    return Running
end

function CanRun()
    local resetTimeStr = IniReadUserConfig("AnThe", "ResetTime", "")
    if resetTimeStr ~= "" then
        local resetTime = util_split_string(nx_string(resetTimeStr), ";")
        for _, record in pairs(resetTime) do
            local prop = util_split_string(nx_string(record), ",")
            if prop[1] == nx_string(QUEST_ID) then
                return nx_execute("admin_zdn\\zdn_logic_base", "GetCurrentDayStartTimestamp") >= nx_number(prop[2])
            end
        end
    end
    return true
end

function Start()
    if Running then
        return
    end
    if not CanRun() then
        Stop()
        return
    end
    Running = true
    while Running do
        loopAnThe()
        nx_pause(0.2)
    end
end

function Stop()
    Running = false
    StopFindPath()
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

-- private
function onTaskDone()
    local newResetTimeStr = QUEST_ID .. "," .. nx_execute("admin_zdn\\zdn_logic_base", "GetNextDayStartTimestamp")
    local resetTimeStr = IniReadUserConfig("AnThe", "ResetTime", "")
    if resetTimeStr ~= "" then
        local resetTime = util_split_string(nx_string(resetTimeStr), ";")
        for _, record in pairs(resetTime) do
            local prop = util_split_string(nx_string(record), ",")
            if prop[1] ~= nx_string(QUEST_ID) then
                newResetTimeStr = nx_string(newResetTimeStr) .. ";"
                newResetTimeStr =
                    nx_string(newResetTimeStr) .. nx_string(prop[1]) .. nx_string(",") .. nx_string(prop[2])
            end
        end
    end
    IniWriteUserConfig("AnThe", "ResetTime", newResetTimeStr)
    Stop()
end

function loopAnThe()
    if IsMapLoading() then
        return
    end

    if GetCurMap() ~= NPC_MAP then
        TeleToSchoolHomePoint()
        return
    end

    if isReceiveQuest() then
        doQuest()
        return
    elseif isOnQuanTinhDao() then
        leaveQuanTinhDao()
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end

    -- trang thai npc:5 nhan Q
    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(5) then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        if not TalkIsFuncIdAvailable(npc, 100074250) then
            TalkToNpcByMenuId(npc, 600000000)
            onTaskDone()
            return
        end
        TalkToNpcByMenuId(npc, 100074250)
        TalkToNpc(npc, 0)
        return
    end

    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(0) then
        nx_pause(3)
        if not nx_is_valid(npc) then
            return
        end
        if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(0) then
            onTaskDone()
            return
        end
    end
end

function isQuestNpc(obj)
    return obj:QueryProp("ConfigID") == NPC_CONFIG_ID
end

function isReceiveQuest()
    local ord = getTaskOrder()
    return nx_int(ord) == nx_int(1)
end

function getTaskOrder()
    return nx_execute("admin_zdn\\zdn_logic_base", "GetTaskInfoById", TASK_INDEX, task_rec_order)
end

function doQuest()
    if not isOnQuanTinhDao() then
        goToQuanTinhDao()
        return
    end
    doQuanTinhDao()
end

function isOnQuanTinhDao()
    local x, _, z = GetPlayerPosition()
    if nx_number(z) >= 470 and nx_number(x) >= -468 then
        return true
    end
    return false
end

function doQuanTinhDao()
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isHuaBanThoi")
    local npc2 = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isHuaBanThoi2")
    if not nx_is_valid(npc) and not nx_is_valid(npc2) and TimerDiff(TimerStartThiLuyen) >= 6 then
        GoToNpc(NPC_MAP, NPC_HUA_BAN_THOI_CONFIG_ID)
        return
    end

    -- continue Q
    if nx_is_valid(npc) then
        if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(3) then
            if GetDistanceToObj(npc) > 3 then
                GoToObj(npc)
                return
            end
            TalkToNpc(npc, 0)
            TimerStartThiLuyen = TimerInit()
            return
        end

        if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(2) then
            if GetDistanceToObj(npc) > 3 then
                GoToObj(npc)
                return
            end
            TalkToNpc(npc, 0)
            TalkToNpc(npc, 0)
            return
        end
    end
    checkWeapon()
    if nx_is_valid(npc2) then
        doThiLuyen(npc2)
    end
end

function doThiLuyen(npc2)
    local skillId = getHuaBanThoiSkillId(npc2:QueryProp("CurSkillID"))
    if not isSkillExists(skillId) then
        skillId = getHuaBanThoiSpecialSkill(npc2)
    end

    if isSkillExists(skillId) then
        local fight = nx_value("fight")
        if not nx_is_valid(fight) then
            return
        end
        fight:TraceUseSkill(skillId, false, false)
    end
end

function getHuaBanThoiSpecialSkill(npc)
    if TimerDiff(TimerSpecialSkill) < 6 then
        return "0"
    end
    if nx_execute("admin_zdn\\zdn_logic_skill", "ObjHaveBuff", npc, "buf_CS_xmg_pyj02") then
        TimerSpecialSkill = TimerInit()
        return "CS_xmg_pyj02"
    end
    return "0"
end

function getHuaBanThoiSkillId(skillId)
    if nx_string(skillId) == "CS_lzy_xmgrc_gxtlj01" then
        return "CS_xmg_pyj01"
    end
    if nx_string(skillId) == "CS_lzy_xmgrc_gxtlj02" then
        return "CS_xmg_pyj06"
    end
    if nx_string(skillId) == "CS_lzy_xmgrc_gxtlj03" then
        return "CS_xmg_pyj07"
    end
    if nx_string(skillId) == "Npc_xmg_pyj01" then
        return "CS_xmg_pyj01"
    end
    if nx_string(skillId) == "Npc_xmg_pyj02" then
        return "CS_xmg_pyj02"
    end
    if nx_string(skillId) == "Npc_xmg_pyj03" then
        return "CS_xmg_pyj03"
    end
    if nx_string(skillId) == "Npc_xmg_pyj04" then
        return "CS_xmg_pyj04"
    end
    if nx_string(skillId) == "Npc_xmg_pyj05" then
        return "CS_xmg_pyj05"
    end
    if nx_string(skillId) == "Npc_xmg_pyj06" then
        return "CS_xmg_pyj06"
    end
    if nx_string(skillId) == "Npc_xmg_pyj07" then
        return "CS_xmg_pyj07"
    end
    if nx_string(skillId) == "Npc_xmg_pyj08" then
        return "CS_xmg_pyj08"
    end
    return "0"
end

function isHuaBanThoi(obj)
    return obj:QueryProp("ConfigID") == NPC_HUA_BAN_THOI_CONFIG_ID
end

function isHuaBanThoi2(obj)
    return obj:QueryProp("ConfigID") == NPC_HUA_BAN_THOI2_CONFIG_ID
end

function isQuanTinhDaoTelepoint(obj)
    return obj:QueryProp("ConfigID") == QUAN_TINH_DAO_TELE_POINT
end

function isSkillExists(config)
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
        return false
    end
    return nx_is_valid(fight:FindSkill(config))
end

function checkWeapon()
    if TimerDiff(TimerCheckWeapon) < 3 then
        return
    end
    TimerCheckWeapon = TimerInit()
    local currentWeapon = nx_execute("admin_zdn\\zdn_logic_vat_pham", "GetCurrentWeapon")
    if not nx_is_valid(currentWeapon) or nx_number(currentWeapon:QueryProp("ItemType")) ~= ITEMTYPE_WEAPON_SSWORD then
        local i = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindFirstBoundItemIndexByItemType", 121, ITEMTYPE_WEAPON_SSWORD)
        nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseWeapon", i)
    end
end

function leaveQuanTinhDao()
    if TimerDiff(TimerLeaveQuanTinhDao) < 11 then
        return
    end
    if TimerDiff(TimerLeaveQuanTinhDao) >= 11 and TimerDiff(TimerLeaveQuanTinhDao) < 13 then
        local role = nx_value("role")
        if nx_is_valid(role) and role.state == "static" then
            nx_call("player_state\\state_input", "emit_player_input", role, 9)
        end
        return
    end
    local x, y, z = GetNpcPostion(NPC_MAP, TINH_MIEU_CAC_TELE_POINT)
    if GetDistance(x, y, z) <= 1 then
        TimerLeaveQuanTinhDao = TimerInit()
        return
    end
    GoToNpc(NPC_MAP, TINH_MIEU_CAC_TELE_POINT)
end

function goToQuanTinhDao()
    if TimerDiff(TimerQuanTinhDao) < 7 then
        return
    end
    local x, y, z = GetNpcPostion(NPC_MAP, QUAN_TINH_DAO_TELE_POINT)
    if GetDistance(x, y, z) <= 1 then
        TimerQuanTinhDao = TimerInit()
        return
    end
    GoToNpc(NPC_MAP, QUAN_TINH_DAO_TELE_POINT)
end
