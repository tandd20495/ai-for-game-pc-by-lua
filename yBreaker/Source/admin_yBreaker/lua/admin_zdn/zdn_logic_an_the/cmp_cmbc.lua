require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_an_the")

QUEST_ID = "cmp_cmbc"
local NPC_MAP = "school14"
local NPC_CONFIG_ID = "gmp_NPC_zhouchang_010"
local NPC_SCENE = "gmp_NPC_zhouchang_007"
local TASK_INDEX = 20601
local TASK_INDEX2 = 20602
local NPC_TALK_FUNC_ID = 100020601
local NPC_TALK_FUNC_ID2 = 100020602
local SKILL_LIST = {
    "skill_gumu_buniao001",
    "skill_gumu_buniao002",
    "skill_gumu_buniao003"
}
local BAT_CHIM_POS = {
    {-400.65017700195, 356.26699829102, -310.51696777344},
    {-474.06854248047, 356.34423828125, -308.83807373047}
}
local TimerSetAngle = 0

function CanRun()
    if not isInTaskTime() then
        return false
    end
    return not IsTaskDone()
end

function IsTaskDone()
    local resetTimeStr = IniReadUserConfig("AnThe", "ResetTime", "")
    if resetTimeStr ~= "" then
        local resetTime = util_split_string(nx_string(resetTimeStr), ";")
        for _, record in pairs(resetTime) do
            local prop = util_split_string(nx_string(record), ",")
            if prop[1] == nx_string(QUEST_ID) then
                return nx_execute("admin_zdn\\zdn_logic_base", "GetNextDayStartTimestamp") == nx_number(prop[2])
            end
        end
    end
    return false
end

function loopAnThe()
    if IsMapLoading() then
        return
    end

    if GetCurMap() ~= NPC_MAP then
        TeleToSchoolHomePoint()
        return
    end

    if
        not nx_execute("admin_zdn\\zdn_logic_base", "CanTaskSubmit", TASK_INDEX) and
            not nx_execute("admin_zdn\\zdn_logic_base", "CanTaskSubmit", TASK_INDEX2) and
            isReceiveQuest()
     then
        doQuest()
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isSceneNpc")
    if nx_is_valid(npc) then
        leaveScene(npc)
        return
    end

    npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end

    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(5) then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        if not TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID) and not TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID2) then
            TalkToNpcByMenuId(npc, 600000000)
            onTaskDone()
            return
        end
        if TalkIsFuncIdAvailable(npc, NPC_TALK_FUNC_ID) then
            TalkToNpcByMenuId(npc, NPC_TALK_FUNC_ID)
        else
            TalkToNpcByMenuId(npc, NPC_TALK_FUNC_ID2)
        end
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
    return (nx_execute("admin_zdn\\zdn_logic_base", "GetTaskInfoById", TASK_INDEX, 0) == TASK_INDEX) or
        (nx_execute("admin_zdn\\zdn_logic_base", "GetTaskInfoById", TASK_INDEX2, 0) == TASK_INDEX2)
end

function doQuest()
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isSceneNpc")
    if nx_is_valid(npc) then
        batChim(npc)
        return
    end

    npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end

    if nx_find_custom(npc, "Head_Effect_Flag") and nx_string(npc.Head_Effect_Flag) == nx_string(3) then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        TalkToNpc(npc, 0)
        TalkToNpc(npc, 0)
        TalkToNpc(npc, 0)
        return
    end
end

function isInTaskTime()
    local hour = nx_execute("admin_zdn\\zdn_logic_base", "GetCurrentHour")
    if 13 <= hour and hour <= 20 then
        return true
    end
    return false
end

function isSceneNpc(obj)
    return obj:QueryProp("ConfigID") == NPC_SCENE
end

function isChim(obj)
    return string.find(obj:QueryProp("ConfigID"), "gumu_maque0") ~= nil
end

function batChim(npc)
    local p = BAT_CHIM_POS[1]
    local p2 = BAT_CHIM_POS[2]
    if GetDistance(p[1], p[2], p[3]) > GetDistance(p2[1], p2[2], p2[3]) then
        p = p2
    end
    if GetDistance(p[1], p[2], p[3]) >= 2 then
        GoToPosition(p[1], p[2], p[3])
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isChim")
    if not nx_is_valid(npc) then
        return
    end

    if GetDistanceToObj(npc) <= 4 then
        setAngle(GetObjPosition(npc))
        for i = 1, #SKILL_LIST do
            if not isOnCooldown(SKILL_LIST[i]) then
                useSkill(SKILL_LIST[i])
                return
            end
        end
    end
end

function isOnCooldown(skillId)
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return true
    end
    local s = nx_execute("admin_zdn\\zdn_logic_skill", "GetSkillCoolDownType", skillId)
    return gui.CoolManager:IsCooling(nx_int(s), nx_int(-1))
end

function useSkill(skillId)
    local fight = nx_value("fight")
    if not nx_is_valid(fight) then
        return
    end
    local c = nx_value("game_client")
    if not nx_is_valid(c) then
        return
    end
    local p = c:GetPlayer()
    if not nx_is_valid(p) then
        return
    end
    fight:TraceUseSkill(skillId, false, false)
end

function setAngle(x, y, z)
    if TimerDiff(TimerSetAngle) < 5 then
        return
    end
    local role = nx_value("role")
    local scene_obj = nx_value("scene_obj")
    if not nx_is_valid(role) or not nx_is_valid(scene_obj) then
        return
    end
    scene_obj:SceneObjAdjustAngle(role, x, z)
end

function leaveScene(npc)
    if GetDistanceToObj(npc) > 3 then
        GoToObj(npc)
        return
    end
    TalkToNpc(npc, 0)
end
