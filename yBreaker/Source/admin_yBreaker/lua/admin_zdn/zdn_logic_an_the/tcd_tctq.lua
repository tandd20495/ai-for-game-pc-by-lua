require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_an_the")

local NPC_MAP = "school21"
local NPC_CONFIG_ID = "newmp_sjy_gujhuodong001"
local NPC_TALK_FUNC_ID = 841009374
local TimerReceiveQuest = 0
QUEST_ID = "tcd_tctq"

function loopAnThe()
    if TimerDiff(TimerReceiveQuest) < 2 then
        return
    end
    if IsMapLoading() then
        return
    end
    if GetCurMap() ~= NPC_MAP then
        TeleToSchoolHomePoint()
        return
    end
    local formStr = "form_stage_main\\form_small_game\\form_game_sjy_army"
    local form = nx_value(formStr)
    if nx_is_valid(form) and form.Visible then
        if form.btn_start.Enabled then
            nx_execute(formStr, "on_btn_start_click", form.btn_start)
            TimerReceiveQuest = TimerInit()
        end
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
    if not TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID) then
        TalkToNpcByMenuId(npc, 600000000)
        onTaskDone()
        return
    end
    nx_execute("admin_zdn\\zdn_listener", "addListen", nx_current(), "tips_sjyagm_1", "onTaskDone", 10)
    TalkToNpcByMenuId(npc, NPC_TALK_FUNC_ID)
    TalkToNpc(npc, 0)
    TimerReceiveQuest = TimerInit()
end

function isQuestNpc(obj)
    return obj:QueryProp("ConfigID") == NPC_CONFIG_ID
end
