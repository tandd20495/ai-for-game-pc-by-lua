require("util_functions")
require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_lib_jump")

local Running = false
local QUEST_ID = "tdbv"
local NPC_MAP = "city04"
local NPC_CONFIG_ID = "npc_6n_mxm08"
local PRIZE_FORM_PATH = "form_stage_main\\form_xmqy_detail"
local FACULTY_BACK_FORM_PATH = "form_stage_main\\form_wuxue\\form_faculty_back"
local SavePointPos = {1404.9117431641, 23.476224899292, 183.39108276367}
local FinalSavePointPos = {1509.7288818359, 23.44215965271, 154.16381835938}
local TimerNhanQua = 0
local TimerPhienBai = 0
local TimerFollowMacVoTinh = 0
local TimerGoToFinalBoss = 0
local TimerGoToFirstBoss = 0

local SAFETY_POS = {
    {1443.5673828125, 30.925001144409, 204.02493286133},
    {1443.3485107422, 27.187314987183, 181.95574951172},
    {1428.6369628906, 31.460000991821, 162.85015869141},
    {1441.0502929688, 28.452001571655, 147.04806518555},
    {1423.5316162109, 31.358001708984, 125.34007263184},
    {1455.7016601563, 30.824090957642, 104.04970550537},
    {1470.6245117188, 30.826002120972, 106.49224853516},
    {1487.5562744141, 31.153451919556, 120.25}
}

function IsRunning()
    return Running
end

function CanRun()
    local resetTimeStr = IniReadUserConfig("NhiemVuNoi6", "ResetTime", "")
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
        loopNoi6()
        nx_pause(0.1)
    end
end

function Stop()
    Running = false
    nx_execute("admin_zdn\\zdn_logic_skill", "StopAutoAttack")
    StopFindPath()
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

-- private
function loopNoi6()
    if IsMapLoading() then
        return
    end
    if isInQuestScene() then
        doScene()
    else
        startQuest()
    end
end

function isInQuestScene()
    return GetCurMap() == nx_string("adv040a")
end

function startQuest()
    if GetCurMap() ~= NPC_MAP then
        GoToMapByPublicHomePoint(NPC_MAP)
        return
    end

    -- tim npc
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isFirstQuestNpc")
    if not nx_is_valid(npc) then
        GoToNpc(NPC_MAP, NPC_CONFIG_ID)
        return
    end

    if GetDistanceToObj(npc) > 2 then
        GoToObj(npc)
        return
    end

    if GetDistanceToObj(npc) > 3 then
        GoToObj(npc)
        return
    end
    XuongNgua()
    TalkToNpc(npc, 0)
    return
end

function isFirstQuestNpc(obj)
    return obj:QueryProp("ConfigID") == NPC_CONFIG_ID
end

function isSceneNpc(obj)
    return obj:QueryProp("ConfigID") == "home_mj_leave"
end

function onTaskDone()
    local newResetTimeStr = QUEST_ID .. "," .. nx_execute("admin_zdn\\zdn_logic_base", "GetNextDayStartTimestamp")
    local resetTimeStr = IniReadUserConfig("NhiemVuNoi6", "ResetTime", "")
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
    IniWriteUserConfig("NhiemVuNoi6", "ResetTime", newResetTimeStr)
    Stop()
end

function doScene()
    if processPrizeForm() then
        nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
        return
    end
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isTransferOutNpc")
    if nx_is_valid(npc) then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        TalkToNpc(npc, 0)
        onTaskDone()
        return
    end
    local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isTrongChuy")
    if nx_is_valid(obj) then
        pickupTrongChuy(obj)
        return
    end
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isFirstSceneNpc")
    if not nx_is_valid(npc) then
        processScene()
        return
    end
    if nx_string(npc:QueryProp("CursorShape")) == "2" then
        if GetDistanceToObj(npc) > 3 then
            GoToObj(npc)
            return
        end
        TalkToNpc(npc, 0)
    end
end

function isFirstSceneNpc(obj)
    return obj:QueryProp("ConfigID") == "npc_qyby_01"
end

function isMacVoTinh(obj)
    return obj:QueryProp("ConfigID") == "npc_qyby_02"
end

function isFirstBossMacVoTinh(obj)
    return obj:QueryProp("ConfigID") == "npc_qyby_03"
end

function isThanhBiMacVoTinh(obj)
    local c = obj:QueryProp("ConfigID")
    return c == "npc_qyby_05" or c == "npc_qyby_04"
end

function isThanhBi(obj)
    return obj:QueryProp("ConfigID") == "boss_qyby_03"
end

function isFinalBossThanhBiNpc(obj)
    return obj:QueryProp("ConfigID") == "boss_qyby_04"
end

function processScene()
    local mvt = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isMacVoTinh")
    if nx_is_valid(mvt) then
        TimerFollowMacVoTinh = TimerInit()
        followMacVoTinh(mvt)
        return
    end
    if TimerDiff(TimerFollowMacVoTinh) < 3 then
        return
    end

    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isThanhBi")
    if nx_is_valid(npc) then
        stepNemKiem(npc)
        return
    end

    npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isThanhBiMacVoTinh")
    if nx_is_valid(npc) then
        -- cho thanh bi
        return
    end

    npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isFirstBossMacVoTinh")
    if nx_is_valid(npc) then
        stepFirstBoss(npc)
        return
    end

    local finalBoss = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isNotDead", "isFinalBoss")
    if nx_is_valid(finalBoss) then
        local d = GetDistanceToObj(finalBoss)
        if d <= 90 and d >= 35 then
            FlyToObj(finalBoss)
            return
        end
        attackObj(finalBoss)
        return
    end

    if
        GetDistance(FinalSavePointPos[1], FinalSavePointPos[2], FinalSavePointPos[3]) > 15 and
            TimerDiff(TimerGoToFirstBoss) >= 25
     then
        goToFinalBoss()
        TimerGoToFinalBoss = TimerInit()
    elseif GetDistance(SavePointPos[1], SavePointPos[2], SavePointPos[3]) > 15 and TimerDiff(TimerGoToFinalBoss) >= 25 then
        goToFirstBoss()
        TimerGoToFirstBoss = TimerInit()
    end
end

function followMacVoTinh(npc)
    nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
    if GetDistanceToObj(npc) > 3 then
        GoToObj(npc)
        return
    end
end

function isNotDead(obj)
    return nx_number(obj:QueryProp("Dead")) ~= 1
end

function isAttackable(obj)
    if isMacVoTinh(obj) then
        return false
    end
    if obj:QueryProp("ConfigID") == "brokennpc002018" then
        return false
    end
    if isThanhBi(obj) then
        return false
    end
    local fight = nx_value("fight")
    local client = nx_value("game_client")
    local player = client:GetPlayer()
    if not nx_is_valid(fight) or not nx_is_valid(player) then
        return false
    end
    return fight:CanAttackTarget(player, obj)
end

function attackObj(obj)
    if not nx_is_valid(obj) then
        return
    end
    nx_execute("admin_zdn\\zdn_logic_skill", "FlexAttackObj", obj)
end

function stepNemKiem(thanhBi)
    nx_execute("admin_zdn\\zdn_logic_skill", "StopNgoiThien")
    nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")

    local cnt = #SAFETY_POS
    local x, y, z = GetPlayerPosition()
    for i = 1, cnt do
        local p = SAFETY_POS[i]
        local d = GetDistanceObjToPosition(thanhBi, p[1], p[2], p[3])
        if d <= 19 then
            if GetDistance(p[1], p[2], p[3]) > 2 then
                WalkToPosInstantly(p[1], p[2], p[3])
            end
            break
        end
    end

    if not isPhiTinhOnCooldown() and GetDistanceToObj(thanhBi) <= 19 then
        usePhiTinh(thanhBi)
    end
end

function usePhiTinh(obj)
    nx_execute("admin_zdn\\zdn_logic_base", "SelectTarget", obj)
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
    local sk = nx_string(p:QueryProp("CurSkillID"))
    if sk ~= "" and sk ~= "0" and string.len(sk) < 2 then
        return
    end
    if nx_string(obj.Ident) == nx_string(p:QueryProp("LastObject")) then
        fight:TraceUseSkill("skill_qyby_qp02", false, false)
    end
end

function isPhiTinhOnCooldown()
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return true
    end
    local s = nx_execute("admin_zdn\\zdn_logic_skill", "GetSkillCoolDownType", "skill_qyby_qp02")
    return gui.CoolManager:IsCooling(nx_int(s), nx_int(-1))
end

function isReadyToFight()
    local client = nx_value("game_client")
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return false
    end
    local hpRatio = nx_number(player:QueryProp("HPRatio"))
    local mpRatio = nx_number(player:QueryProp("MPRatio"))
    if
        ((hpRatio >= 74 and nx_execute("admin_zdn\\zdn_logic_skill", "HaveBuff", "buf_baosd_01")) or hpRatio >= 95) and
            mpRatio >= 90
     then
        return true
    end
    return false
end

function pickupTrongChuy(obj)
    if GetDistanceToObj(obj) > 2 then
        GoToObj(obj)
        return
    end
    TalkToNpc(obj, 0)
end

function isTrongChuy(obj)
    return obj:QueryProp("ConfigID") == "npc_qyby_chuizi"
end

function processPrizeForm()
    if TimerDiff(TimerNhanQua) < 2 or TimerDiff(TimerPhienBai) < 2 then
        return true
    end
    local prizeForm = nx_execute("admin_zdn\\zdn_logic_base", "GetChildForm", PRIZE_FORM_PATH)
    if nx_is_valid(prizeForm) and prizeForm.Visible then
        if (not nhanQua()) and (not phienBai()) then
            gainAllPrize(prizeForm)
        end
        return true
    end
    return false
end

function isTransferOutNpc(obj)
    return obj:QueryProp("ConfigID") == "npc_qyby_08"
end

function isAttackingMeObj(obj)
    if obj:QueryProp("ConfigID") == "boss_qyby_02" then
        return true
    end
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return false
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return false
    end
    return nx_string(obj:QueryProp("LastObject")) == nx_string(player.Ident)
end

function gainAllPrize(prizeForm)
    nx_execute(PRIZE_FORM_PATH, "on_btn_gain_all_click", prizeForm.btn_gain)
    nx_pause(2)
    if nx_is_valid(prizeForm) then
        nx_destroy(prizeForm)
    end
    local backForm = nx_execute("admin_zdn\\zdn_logic_base", "GetChildForm", FACULTY_BACK_FORM_PATH)
    if nx_is_valid(backForm) then
        nx_destroy(backForm)
    end
    nx_pause(3)
end

function nhanQua()
    local form = nx_value(PRIZE_FORM_PATH)
    local btn_gain = form:Find("btn_gain_2")
    if not nx_is_valid(btn_gain) or not btn_gain.Visible then
        return false
    end
    TimerNhanQua = TimerInit()
    nx_execute(PRIZE_FORM_PATH, "on_btn_gain_click", btn_gain)
    return true
end

function phienBai()
    local form = nx_value(PRIZE_FORM_PATH)
    local btn_remove = form:Find("btn_remove_2")
    if not nx_is_valid(btn_remove) or not btn_remove.Visible then
        return false
    end
    TimerPhienBai = TimerInit()
    nx_execute(PRIZE_FORM_PATH, "on_btn_remove_click", btn_remove)
    return true
end

function isFinalBoss(obj)
    return obj:QueryProp("ConfigID") == "boss_qyby_02"
end

function goToFinalBoss()
    local d = GetDistance(FinalSavePointPos[1], FinalSavePointPos[2], FinalSavePointPos[3])
    if d <= 90 and d >= 35 then
        FlyToPos(FinalSavePointPos[1], FinalSavePointPos[2], FinalSavePointPos[3])
        return
    end
    GoToPosition(FinalSavePointPos[1], FinalSavePointPos[2], FinalSavePointPos[3])
end

function goToFirstBoss()
    local d = GetDistance(SavePointPos[1], SavePointPos[2], SavePointPos[3])
    if d <= 90 and d >= 35 then
        FlyToPos(SavePointPos[1], SavePointPos[2], SavePointPos[3])
        return
    end
    GoToPosition(SavePointPos[1], SavePointPos[2], SavePointPos[3])
end

function stepFirstBoss(mvt)
    local target = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isNotDead", "isAttackable")
    if nx_is_valid(target) then
        attackObj(target)
        return
    end
    nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
    if not isReadyToFight() then
        nx_execute("admin_zdn\\zdn_logic_skill", "NgoiThien")
        return
    end
    nx_execute("admin_zdn\\zdn_logic_skill", "StopNgoiThien")
    if GetDistanceToObj(mvt) > 3 then
        GoToObj(mvt)
        return
    end
    TalkToNpc(mvt, 0)
end
