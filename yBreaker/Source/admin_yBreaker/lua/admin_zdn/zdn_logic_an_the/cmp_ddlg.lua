require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_an_the")

QUEST_ID = "cmp_ddlg"
local NPC_MAP = "school14"
local NPC_CONFIG_ID = "newmp_gumu_yswc_001"
local TASK_INDEX = 20609
local NPC_TALK_FUNC_ID = 100020609
local TimerClick = 0

function loopAnThe()
    if TimerDiff(TimerClick) < 1 then
        return
    end
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

    local form = nx_value("form_stage_main\\form_small_game\\form_game_rope_swing")
    if nx_is_valid(form) and form.Visible then
        nx_execute("form_stage_main\\form_small_game\\form_game_rope_swing", "on_btn_close_click", form.btn_close)
        TimerClick = TimerInit()
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
    local form = nx_value("form_stage_main\\form_small_game\\form_game_rope_swing")
    if nx_is_valid(form) and form.Visible then
        playGame(form)
        return
    end
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end

    -- start q
    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(1) then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        TalkToNpc(npc, 0)
        return
    end

    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(3) then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        TalkToNpc(npc, 0)
        TalkToNpc(npc, 0)
        return
    end
end

function playGame(form)
    local btn = form.btn_skill
    if nx_is_valid(btn) and btn.Visible then
        nx_execute("form_stage_main\\form_small_game\\form_game_rope_swing", "on_btn_skill_click", btn)
        TimerClick = TimerInit()
        return
    end
    
    btn = form.btn_start
    if nx_is_valid(btn) and btn.Visible then
        nx_execute("form_stage_main\\form_small_game\\form_game_rope_swing", "on_btn_start_click", btn)
        TimerClick = TimerInit()
        return
    end
end
