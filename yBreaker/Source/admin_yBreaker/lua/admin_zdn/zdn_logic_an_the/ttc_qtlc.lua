require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_jump")
require("admin_zdn\\zdn_lib_an_the")

QUEST_ID = "ttc_qtlc"
local NPC_MAP = "school19"
local NPC_CONFIG_ID = "newmp_shenshui_008"
local TASK_INDEX = 21403
local NPC_TALK_FUNC_ID = 100021403
local NPC_DEM_THIEN = "Gather_ssgrc_001"
local JUMP_POS = {2495.806640625, 140.74490356445, -1281.1968994141}
local JUMP_BACK_POS = {2500.1437988281, 136.36352539063, -1278.6468505859}
local TimerClick = 0

function loopAnThe()
    if IsMapLoading() then
        return
    end

    if GetCurMap() ~= NPC_MAP then
        TeleToSchoolHomePoint()
        return
    end

    if not nx_execute("admin_zdn\\zdn_logic_base", "CanTaskSubmit", TASK_INDEX) and isReceiveQuest() then
        doQuest()
        return
    end

    if isInBoDoanArea() then
        if GetDistance(JUMP_BACK_POS[1], JUMP_BACK_POS[2], JUMP_BACK_POS[3]) > 2 then
            GoToPosition(JUMP_BACK_POS[1], JUMP_BACK_POS[2], JUMP_BACK_POS[3])
            return
        end
        HighJumpToPos(2492.9619140625, 140.88188171387, -1283.0405273438)
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        goToMainlandNpc(NPC_CONFIG_ID)
        return
    end

    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(5) then
        if GetDistanceToObj(npc) > 3 then
            goToMainlandNpc(NPC_CONFIG_ID)
            return
        end
        if not TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID) then
            TalkToNpcByMenuId(npc, 600000000)
            onTaskDone()
            return
        end
        TalkToNpcByMenuId(npc, NPC_TALK_FUNC_ID)
        TalkToNpc(npc, 0)
        return
    end

    -- tra Q
    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(2) then
        if GetDistanceToObj(npc) > 3 then
            goToMainlandNpc(NPC_CONFIG_ID)
            return
        end
        TalkToNpc(npc, 0)
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

function isNhuocLamNpc(obj)
    return obj:QueryProp("ConfigID") == "Transschool19C"
end

function isNhuocKyNpc(obj)
    return obj:QueryProp("ConfigID") == "Transschool19A"
end

function goToMainlandNpc(configId)
    local role = nx_value("role")
    if nx_is_valid(role) and role.state == "trans" then
        return
    end
    if isInLeftInsland() then
        local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isNhuocLamNpc")
        if not nx_is_valid(npc) or GetDistanceToObj(npc) > 3 then
            GoToNpc(NPC_MAP, "Transschool19C")
            return
        end
        TalkToNpc(npc, 0)
        TalkToNpc(npc, 0)
        return
    end

    local x, _, z = GetNpcPostion(NPC_MAP, configId)
    if x > 2388 and x < 2421 and z > -1384 and z < -1347 then
        if not isInThienNhatCac() and GetDistance(2409.150390625, 156.38922119141, -1329.1750488281) > 20 then
            GoToPosition(2409.150390625, 156.38922119141, -1329.1750488281)
            return
        end
    end
    GoToNpc(NPC_MAP, configId)
end

function goToLeftInslandNpc(configId)
    local role = nx_value("role")
    if nx_is_valid(role) and role.state == "trans" then
        return
    end
    if not isInLeftInsland() then
        local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isNhuocKyNpc")
        if not nx_is_valid(npc) or GetDistanceToObj(npc) > 3 then
            GoToNpc(NPC_MAP, "Transschool19A")
            return
        end
        TalkToNpc(npc, 0)
        TalkToNpc(npc, 2)
        return
    end

    GoToNpc(NPC_MAP, configId)
end

function isInLeftInsland()
    local x, _, z = GetPlayerPosition()
    if x > 2480 and x < 2578 and z > -1236 and z < -1111 then
        return true
    end
    if x >= 2578 and x < 2808 and z > -1427 and z < -1111 then
        return true
    end
    return false
end

function isInThienNhatCac()
    local x, _, z = GetPlayerPosition()
    return x > 2388 and x < 2421 and z > -1384 and z < -1347
end

function isQuestNpc(obj)
    return obj:QueryProp("ConfigID") == NPC_CONFIG_ID
end

function isReceiveQuest()
    return nx_execute("admin_zdn\\zdn_logic_base", "GetTaskInfoById", TASK_INDEX, 0) == TASK_INDEX
end

--
function doQuest()
    if TimerDiff(TimerClick) < 2 then
        return
    end
    if isCurseLoading() then
        return
    end

    if not isInBoDoanArea() then
        if GetDistance(JUMP_POS[1], JUMP_POS[2], JUMP_POS[3]) > 3 then
            GoToPosition(JUMP_POS[1], JUMP_POS[2], JUMP_POS[3])
            return
        end
        SlowJumpToPos(JUMP_BACK_POS[1], JUMP_BACK_POS[2], JUMP_BACK_POS[3])
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isDemThienNpc")
    if not nx_is_valid(npc) then
        return
    end

    if GetDistanceToObj(npc) > 2 then
        GoToObj(npc)
        return
    end

    nx_execute("custom_sender", "custom_select", npc.Ident)
    TimerClick = TimerInit()
end

function isInBoDoanArea()
    local x, _, z = GetPlayerPosition()
    return x > 2494 and x < 2523 and z > -1288 and z < -1263
end

function isCurseLoading()
    local load = nx_value("form_stage_main\\form_main\\form_main_curseloading")
    if nx_is_valid(load) and load.Visible then
        TimerCurseLoading = TimerInit()
    end
    return TimerDiff(TimerCurseLoading) < 0.5
end

function isDemThienNpc(obj)
    return obj:QueryProp("ConfigID") == NPC_DEM_THIEN
end
