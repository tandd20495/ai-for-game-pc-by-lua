require("util_functions")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_util")

local Running = false
local TimerUseItem = 0
local NoiTuItemList = {}

function IsRunning()
    return Running
end

function CanRun()
    return findCanUseNoiTuItemIndex() > 0
end

function IsTaskDone()
    return false
end

function Start()
    if Running then
        return
    end
    Running = true
    StopFindPath()
    while Running do
        loopNoiTu()
        nx_pause(0.1)
    end
end

function Stop()
    Running = false
    nx_execute("admin_zdn\\zdn_logic_skill", "StopAutoAttack")
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

function LoadConfig()
    NoiTuItemList = {}
    local itemStr = IniReadUserConfig("VatPham", "List", "")
    if itemStr ~= "" then
        local itemList = util_split_string(nx_string(itemStr), ";")
        for _, item in pairs(itemList) do
            local prop = util_split_string(item, ",")
            if prop[1] == "1" then
                local item = {}
                item.itemId = prop[2]
                item.buffId = prop[3]
                if prop[3] == prop[4] then
                    table.insert(NoiTuItemList, item)
                end
            end
        end
    end
end

-- private
function loopNoiTu()
    if IsCurseLoading() then
        return
    end
    if TimerDiff(TimerUseItem) < 1 then
        return
    end
    local obj =
        nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isNotDead", "isAttackingMeObj", "isAttackable")
    if nx_is_valid(obj) then
        nx_execute("admin_zdn\\zdn_logic_skill", "FlexAttackObj", obj)
        return
    end
    local i = findCanUseNoiTuItemIndex()
    if i <= 0 then
        Stop()
        return
    end
    XuongNgua()
    nx_execute("admin_zdn\\zdn_logic_vat_pham", "UseItem", 2, i)
    TimerUseItem = TimerInit()
end

function findCanUseNoiTuItemIndex()
    if #NoiTuItemList == 0 then
        return 0
    end
    local cnt = #NoiTuItemList
    for i = 1, cnt do
        local item = NoiTuItemList[i]
        local idx = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindItemIndexFromVatPham", item.itemId)
        if idx > 0 then
            if
                not nx_execute("admin_zdn\\zdn_logic_skill", "HaveBuff", item.buffId) and
                    nx_execute("admin_zdn\\zdn_logic_vat_pham", "CanUseNoiTuItem", item.buffId)
             then
                return idx
            end
        end
    end
    return 0
end

function isAttackingMeObj(obj)
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return false
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return false
    end
    if nx_number(obj:QueryProp("Dead")) == 1 then
        return false
    end
    return nx_string(obj:QueryProp("LastObject")) == nx_string(player.Ident)
end

function isAttackable(obj)
    local fight = nx_value("fight")
    local client = nx_value("game_client")
    local player = client:GetPlayer()
    if not nx_is_valid(fight) or not nx_is_valid(player) then
        return false
    end
    return fight:CanAttackTarget(player, obj)
end

function isNotDead(obj)
    return nx_number(obj:QueryProp("Dead")) ~= 1
end
