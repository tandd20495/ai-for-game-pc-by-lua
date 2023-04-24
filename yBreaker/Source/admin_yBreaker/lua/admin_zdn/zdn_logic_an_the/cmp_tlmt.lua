require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_an_the")

QUEST_ID = "cmp_tlmt"
local NPC_MAP = "school14"
local NPC_CONFIG_ID = "newmp_gumu_001"
local NPC_SCENE = "newmp_gumu_hyc_001"
local TASK_INDEX = 20608
local NPC_TALK_FUNC_ID = 100020608
local GATE_POS = {-244.863998, 386.438995, -578.687988}

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

    if nx_execute("admin_zdn\\zdn_logic_base", "CanTaskSubmit", TASK_INDEX) then
        local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isSceneNpc")
        if nx_is_valid(obj) then
            if GetDistanceToObj(obj) > 3 then
                GoToObj(obj)
                return
            end
            TalkToNpc(obj, 0)
            return
        end
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end

    if
        nx_find_custom(npc, "Head_Effect_Flag") and
            (nx_string(npc.Head_Effect_Flag) == nx_string(5) or nx_string(npc.Head_Effect_Flag) == nx_string(4))
     then
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

function isSceneNpc(obj)
    return obj:QueryProp("ConfigID") == NPC_SCENE
end

function isReceiveQuest()
    return nx_execute("admin_zdn\\zdn_logic_base", "GetTaskInfoById", TASK_INDEX, 0) == TASK_INDEX
end

function doQuest()
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isSceneNpc")
    if nx_is_valid(npc) then
        processScene(npc)
        return
    end
    GoToPosition(GATE_POS[1], GATE_POS[2], GATE_POS[3])
end

function processScene(npc)
    if nx_execute("admin_zdn\\zdn_logic_skill", "HaveBuff", "desc_buf_gmp_hyc_ds") then
        return
    end
    if GetDistanceToObj(npc) > 3 then
        GoToObj(npc)
        return
    end
    TalkToNpc(npc, 0)
end
