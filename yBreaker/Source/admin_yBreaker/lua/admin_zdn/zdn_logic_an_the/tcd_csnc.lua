require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_an_the")

QUEST_ID = "tcd_csnc"
local NPC_MAP = "school21"
local NPC_CONFIG_ID = "newmp_sjy_lzy_rcrw001"
local NPC_NGUON_NUOC = "EventNpc_sjy_lzy_zkjm001"
local TASK_INDEX = 73403
local NPC_TALK_FUNC_ID = 100073403
local NPC_NGUA_CHIEN_CO = "newmp_sjy_lzy_rcrw005"
local TimerCurseLoading = 0

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
    if isCurseLoading() then
        return
    end
    local i = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromNhiemVu", "useitem_lzy_sjyrc003")
    if i > 0 then
        if GetDistance(-72.750030517578, 2.3993489742279, -343.25021362305) > 4 then
            GoToNpc(NPC_MAP, NPC_NGUON_NUOC)
            return
        end
        XuongNgua()
        StopFindPath()
        nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseItem", 125, i)
        return
    end
    doSubTask()
end

function isCurseLoading()
    local load = nx_value("form_stage_main\\form_main\\form_main_curseloading")
    if nx_is_valid(load) and load.Visible then
        TimerCurseLoading = TimerInit()
    end
    return TimerDiff(TimerCurseLoading) < 0.5
end

function doSubTask()
    -- co
    local i = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromNhiemVu", "useitem_lzy_sjyrc002")
    if i > 0 then
        local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isNguaChienCo")
        if not nx_is_valid(obj) or GetDistanceToObj(obj) >= 3 then
            GoToNpc(NPC_MAP, NPC_NGUA_CHIEN_CO)
            return
        end
        XuongNgua()
        if nx_is_valid(obj) then
            nx_execute("admin_zdn\\zdn_logic_base", "SelectTarget", obj)
            StopFindPath()
            nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseItem", 125, i)
        end
    end

    -- ban chai
    local i = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromNhiemVu", "useitem_lzy_sjyrc001")
    if i > 0 then
        local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isNguaChienCo")
        if not nx_is_valid(obj) or GetDistanceToObj(obj) >= 3 then
            GoToNpc(NPC_MAP, NPC_NGUA_CHIEN_CO)
            return
        end
        XuongNgua()
        if nx_is_valid(obj) then
            nx_execute("admin_zdn\\zdn_logic_base", "SelectTarget", obj)
            StopFindPath()
            nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseItem", 125, i)
        end
    end

    -- thung nc day
    local i = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromNhiemVu", "useitem_lzy_sjyrc004")
    if i > 0 then
        local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isNguaChienCo")
        if not nx_is_valid(obj) or GetDistanceToObj(obj) >= 3 then
            GoToNpc(NPC_MAP, NPC_NGUA_CHIEN_CO)
            return
        end
        XuongNgua()
        local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isNguaChienCo")
        if nx_is_valid(obj) then
            nx_execute("admin_zdn\\zdn_logic_base", "SelectTarget", obj)
            StopFindPath()
            nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseItem", 125, i)
        end
    end
end

function isNguaChienCo(obj)
    return obj:QueryProp("ConfigID") == NPC_NGUA_CHIEN_CO
end
