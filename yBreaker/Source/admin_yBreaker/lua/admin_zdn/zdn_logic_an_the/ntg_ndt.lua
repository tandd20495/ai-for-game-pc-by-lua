require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_an_the")

QUEST_ID = "ntg_ndt"
local NPC_MAP = "school12"
local NPC_CONFIG_ID = "newmp_wxj_04"
local TASK_INDEX = {30039, 30038, 30037}
local NPC_TALK_FUNC_ID = {100030039, 100030038, 100030037}
local NPC_DOC_THAO_DO = "Gather_wxj_dg_04"
local NPC_COC = "Attack_wxj_duwu003"
local TimerCurseLoading = 0

function loopAnThe()
    if IsMapLoading() then
        return
    end

    if GetCurMap() ~= NPC_MAP then
        TeleToSchoolHomePoint()
        return
    end

    if not canSubmit() and isReceiveQuest() then
        doQuest()
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end

    -- nhan q
    if
        nx_find_custom(npc, "Head_Effect_Flag") and
            (nx_string(npc.Head_Effect_Flag) == nx_string(5) or nx_string(npc.Head_Effect_Flag) == nx_string(4))
     then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        local step = getTalkStep(npc)
        if step == 0 then
            TalkToNpcByMenuId(npc, 600000000)
            onTaskDone()
            return
        end
        TalkToNpcByMenuId(npc, NPC_TALK_FUNC_ID[step])
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
        if getQuestStep() < 3 then
            TalkToNpc(npc, 0)
            TalkToNpc(npc, 0)
        end
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
    local s = getQuestStep()
    return s > 0
end

function doQuest()
    if isCurseLoading() then
        return
    end
    local s = getQuestStep()
    if s == 1 then
        local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isDocThaoDo")
        if not nx_is_valid(obj) or GetDistanceToObj(obj) > 3 then
            GoToNpc(NPC_MAP, NPC_DOC_THAO_DO)
            return
        end
        nx_execute("custom_sender", "custom_select", obj.Ident)
        nx_pause(0.2)
        return
    end

    if s == 2 then
        local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isCoc")
        if not nx_is_valid(obj) or GetDistanceToObj(obj) > 3 then
            GoToNpc(NPC_MAP, NPC_COC)
            return
        end
        nx_execute("admin_zdn\\zdn_logic_base", "SelectTarget", obj)
        nx_pause(0.15)
        local i = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromNhiemVu", "item_wxj_dg_003")
        if i > 0 then
            StopFindPath()
            nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseItem", 125, i)
            return
        end
        return
    end

    if s == 3 then
        local i = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromNhiemVu", "item_feedinsect_005a")
        if i > 0 then
            StopFindPath()
            nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseItem", 125, i)
            return
        end
    end
end

function getQuestStep()
    for i = 1, #TASK_INDEX do
        if nx_execute("admin_zdn\\zdn_logic_base", "GetTaskInfoById", TASK_INDEX[i], 0) == TASK_INDEX[i] then
            return i
        end
    end
    return 0
end

function isDocThaoDo(obj)
    return obj:QueryProp("ConfigID") == NPC_DOC_THAO_DO
end

function isCurseLoading()
    local load = nx_value("form_stage_main\\form_main\\form_main_curseloading")
    if nx_is_valid(load) and load.Visible then
        TimerCurseLoading = TimerInit()
    end
    return TimerDiff(TimerCurseLoading) < 0.5
end

function isQuestTalkAvailable(npc)
    return TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID) or TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID2) or
        TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_I3)
end

function getTalkStep(npc)
    if TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID[1]) then
        return 1
    end
    if TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID[2]) then
        return 2
    end
    if TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID[3]) then
        return 3
    end
    return 0
end

function canSubmit()
    return nx_execute("admin_zdn\\zdn_logic_base", "CanTaskSubmit", TASK_INDEX[1]) or
        nx_execute("admin_zdn\\zdn_logic_base", "CanTaskSubmit", TASK_INDEX[2]) or
        nx_execute("admin_zdn\\zdn_logic_base", "CanTaskSubmit", TASK_INDEX[3])
end

function isCoc(obj)
    return obj:QueryProp("ConfigID") == NPC_COC
end
