require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_an_the")

QUEST_ID = "tcd_kklt"
local NPC_MAP = "school21"
local NPC_CONFIG_ID = "newmp_sjy_lzy_rcrw001"
local NPC_CONG_TON_THANH = "newmp_sjy_lzy_rcrw002"
local NPC_TUI_LUONG_THAO = "newmp_sjy_lzy_rcrw008"
local TASK_INDEX = 73400
local NPC_TALK_FUNC_ID = 100073400
local task_rec_trackinfo = 8

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

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end

    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(5) then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
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
            GoToObj(npc)
            return
        end
        TalkToNpc(npc, 0)
        TalkToNpc(npc, 0)
        return
    end

    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(0) then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
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
    return nx_execute("admin_zdn\\zdn_logic_base", "GetTaskInfoById", TASK_INDEX, 0) == TASK_INDEX
end

function doQuest()
    if nx_execute("admin_zdn\\zdn_logic_skill", "HaveBuff" , "buff_lzy_qdlc001") then
        GoToPosition(-246.03297424316, 16.000638961792, -82.147857666016)
        return
    end

    local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isTuiLuongThao")
    if not nx_is_valid(obj) then
        goToCongTonThanh()
        return
    end

    if GetDistanceToObj(obj) > 3 then
        GoToObj(obj)
        return
    end

    TalkToNpc(obj,0)
end

function goToCongTonThanh()
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isCongTonThanh")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONG_TON_THANH)
        return
    end

    if GetDistanceToObj(npc) > 3 then
        GoToObj(npc)
        return
    end
    TalkToNpc(npc, 0)
    TalkToNpc(npc, 0)
end

function isCongTonThanh(obj)
    return obj:QueryProp("ConfigID") == NPC_CONG_TON_THANH
end

function isTuiLuongThao(obj)
    return obj:QueryProp("ConfigID") == NPC_TUI_LUONG_THAO
end
