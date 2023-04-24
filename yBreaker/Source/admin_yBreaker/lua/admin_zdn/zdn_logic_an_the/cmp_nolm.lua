require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_an_the")

QUEST_ID = "cmp_nolm"
local NPC_MAP = "school14"
local NPC_CONFIG_ID = "newmp_gumu_005"
local TASK_INDEX = 20605
local TASK_INDEX2 = 20606
local TASK_INDEX3 = 20607
local NPC_TALK_FUNC_ID = 100020605
local NPC_HOA = "gmp_flowers"
local TimerClick = 0
local HOA_POS = {849.59942626953, 381.88388061523, -833.68695068359}

function loopAnThe()
    if TimerDiff(TimerClick) < 2 then
        return
    end
    if IsMapLoading() then
        return
    end

    if nx_execute("admin_zdn\\zdn_logic_base", "CanTaskSubmit", TASK_INDEX2) then
        finishQuest()
        return
    end

    if nx_execute("admin_zdn\\zdn_logic_base", "CanTaskSubmit", TASK_INDEX3) then
        finishLastQuest()
        return
    end

    if isReceiveQuest() then
        doQuest()
        return
    end

    if GetCurMap() ~= NPC_MAP then
        TeleToSchoolHomePoint()
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end

    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(3) then
        local form = nx_value("form_stage_main\\form_small_game\\form_forgegame")
        if nx_is_valid(form) and form.Visible then
            return
        end
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        TalkToNpc(npc, 0)
        TalkToNpc(npc, 0)
        return
    end

    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(5) then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        if not TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID) then
            TalkToNpcByMenuId(npc, 600000000)
            return
        end
        TalkToNpcByMenuId(npc, NPC_TALK_FUNC_ID)
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
    if nx_execute("admin_zdn\\zdn_logic_base", "GetTaskInfoById", TASK_INDEX, 0) == TASK_INDEX then
        return true
    end
    return nx_execute("admin_zdn\\zdn_logic_base", "GetTaskInfoById", TASK_INDEX2, 0) == TASK_INDEX2
end

function doQuest()
    if isInScene() then
        tuoiHoa()
        return
    end
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end
    if GetDistanceToObj(npc) > 3 then
        GoToObj(npc)
        return
    end
    TalkToNpc(npc, 0)
    TalkToNpc(npc, 0)
    TimerClick = TimerInit()
end

function isHoa(obj)
    return obj:QueryProp("ConfigID") == NPC_HOA
end

function tuoiHoa()
    local i = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromNhiemVu", "itm_gmp_shuitong")
    if i <= 0 then
        layMat()
        return
    end
    if GetDistance(HOA_POS[1], HOA_POS[2], HOA_POS[3]) >= 2 then
        GoToPosition(HOA_POS[1], HOA_POS[2], HOA_POS[3])
        return
    end
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isHoa")
    if nx_is_valid(npc) then
        if GetDistanceToObj(npc) > 2 then
            GoToObj(npc)
            return
        end
        local i = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromNhiemVu", "itm_gmp_shuitong")
        nx_execute("admin_zdn\\zdn_logic_base", "SelectTarget", npc)
        if i > 0 then
            StopFindPath()
            nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseItem", 125, i)
        end
    end
end

function isThungNuoiOng(obj)
    return obj:QueryProp("ConfigID") == "gmp_beebox"
end

function layMat()
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isThungNuoiOng")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, "gmp_beebox")
        return
    end
    if GetDistanceToObj(npc) >= 3 then
        GoToObj(npc)
        return
    end
    nx_execute("custom_sender", "custom_select", npc.Ident)
end

function finishQuest()
    if isInScene() then
        GoToPosition(966.513, 371.966003, -788.713013)
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) or GetDistanceToObj(npc) > 3 then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end
    TalkToNpc(npc, 0)
    TalkToNpc(npc, 0)
end

function isInScene()
    local _, __, z = GetPlayerPosition()
    return z <= -780
end

function finishLastQuest()
    local form = nx_value("form_stage_main\\form_small_game\\form_forgegame")
    if nx_is_valid(form) and form.Visible then
        nx_execute("form_stage_main\\form_small_game\\form_forgegame", "on_btn_close_click", form.btn_close)
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) or GetDistanceToObj(npc) > 3 then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end
    TalkToNpc(npc, 0)
    TalkToNpc(npc, 0)
    onTaskDone()
end
