require("util_functions")
require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")

local KyNgoList = {}
local Running = true
local loaded = false
local lastNpcId = ""

function OnReceiveKyNgo(npcId)
    if not loaded then
        LoadConfig()
    end
    Console("Nhận kỳ ngộ: " .. nx_string(npcId))
    if needAcceptKyNgo(npcId) then
        acceptKyNgo(npcId)
    end
end

function LoadConfig()
    KyNgoList = {}
    local kyNgoData = IniLoadAllData(nx_resource_path() .. "yBreaker\\data\\kyngo.ini")
    local changeList = {}
    local str = nx_string(IniReadUserConfig("KyNgo", "ChangeList", ""))
    if str ~= "" then
        local clst = util_split_string(str, ";")
        local cnt = #clst
        for i = 1, cnt do
            table.insert(changeList, clst[i])
        end
    end
    for id, detail in pairs(kyNgoData) do
        local cnt = #changeList
        local changeFlg = false
        for i = 1, cnt do
            if detail.NpcID == changeList[i] then
                changeFlg = true
                break
            end
        end
        addToKyNgoList(detail, changeFlg)
    end
    loaded = true
end

-- private
function addToKyNgoList(detail, changeFlg)
    local flg = detail.Default == "1" and true or false
    if changeFlg then
        flg = not flg
    end
    if flg then
        table.insert(KyNgoList, detail.NpcID)
    end
end

function needAcceptKyNgo(npcId)
    local cnt = #KyNgoList
    for i = 1, cnt do
        if util_text(KyNgoList[i]) == util_text(npcId) then
            return true
        end
    end
    return false
end

function acceptKyNgo(npcId)
    nx_execute("admin_zdn\\zdn_logic_task_manager", "StopGlobalTask")
    IniWriteUserConfig("KyNgo", "Z" .. nx_execute("admin_zdn\\zdn_logic_base", "GetCurrentFullDayHuman"), util_text(npcId))
    doAcceptKyNgo(npcId)
    nx_execute("admin_zdn\\zdn_logic_task_manager", "ContinueGlobalTask")
end

function doAcceptKyNgo(npcId)
    if npcId == "sz352_qy1" then
        return
    end
    local timeOut = TimerInit()
    while Running and TimerDiff(timeOut) < 180 do
        if doAcceptByMail(npcId) then
            return
        end
        if doAcceptByTalk(npcId) then
            return
        end
        nx_pause(1)
    end
end

function doAcceptByMail(npcId)
    local form = nx_value("form_stage_main\\form_give_item")
    if not nx_is_valid(form) or not form.Visible then
        return false
    end
    local npc_id = form.npc
    nx_execute("custom_sender", "custom_give_item", 2, -1, form.npc)
    form:Close()
    return util_text(npc_id) == util_text(npcId)
end

function doAcceptByTalk(npcId)
    lastNpcId = npcId
    local npc = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isLastConfigId", "isTargetingPlayer")
    if nx_is_valid(npc) then
        return doTalkToNpc(npc)
    end
    return false
end

function doTalkToNpc(obj)
    local lst = GetMovieTalkList(obj.Ident)
    if #lst > 0 then
        if lst[1].func_id == 898000023 or lst[1].func_id == 898000000 or lst[1].func_id == 898000024 then
            TalkToNpcByMenuId(obj, 600000000)
            return true
        end
        TalkToNpcByMenuId(obj, lst[1].func_id)
        return false
    end
    if GetDistanceToObj(obj) > 1.8 then
        GoToObj(obj)
    else
        if not nx_is_valid(obj) then
            return false
        end
        nx_execute("custom_sender", "custom_select", obj.Ident)
    end
    return false
end

function isLastConfigId(obj)
    if util_text(obj:QueryProp("ConfigID")) == util_text(lastNpcId) then
        local fight = nx_value("fight")
        if not nx_is_valid(fight) then
            return false
        end
        local client = nx_value("game_client")
        if not nx_is_valid(client) then
            return false
        end
        local player = client:GetPlayer()
        if not nx_is_valid(player) then
            return false
        end
        return not fight:CanAttackNpc(player, obj)
    end
    return false
end

function isTargetingPlayer(obj)
    return true
end
