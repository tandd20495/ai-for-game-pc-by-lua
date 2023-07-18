require("util_functions")
require("admin_zdn\\zdn_lib_moving")
require("admin_zdn\\zdn_util")

local Running = false
local PositionList = {}
local nextPos = 1
local TimerObjNotValid = 0
local TimerCurseLoading = 0
local LastConfigId = ""

function IsRunning()
    return Running
end

function CanRun()
    return true
end

function IsTaskDone()
    return not CanRun()
end

function Start()
    if Running then
        return
    end
    Running = true
    loadConfig()

    while Running do
		buyTool()
        loopThuThap()
        nx_pause(0.2)
    end
end

function Stop()
    Running = false
    nx_execute("admin_zdn\\zdn_logic_skill", "StopAutoAttack")
    StopFindPath()
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

-- private
function loopThuThap()
    if IsMapLoading() then
        return
    end
    if nx_execute("admin_zdn\\zdn_logic_vat_pham", "IsDroppickShowed") then
        nx_execute("admin_zdn\\zdn_logic_vat_pham", "PickAllDropItem")
        return
    end

    if nextPos > #PositionList then
        nextPos = 1
    end

    local p = PositionList[nextPos]
    if GetCurMap() ~= p.map then
        GoToMapByPublicHomePoint(p.map)
        return
    end

    if isCurseLoading() then
        if p.shape == "0" then
            setCurrentObjIsCollected()
        end
        return
    end

    -- cau ca
    if p.shape == "8" then
        processCauCa(p)
        return
    end

    if p.shape == "0" then
        processThoSan(p)
        return
    end

    if GetDistance(p.x, p.y, p.z) > 100 then
        GoToPosition(p.x, p.y, p.z)
        return
    end

    local obj = getObjByConfigId(p.configId)

    if not nx_is_valid(obj) then
        if GetDistance(p.x, p.y, p.z) > 30 then
            GoToPosition(p.x, p.y, p.z)
        else
            waitTimeOut()
        end
        return
    end
    XuongNgua()
    if GetDistanceToObj(obj) >= 2.8 then
        if p.shape == "14" then
            GoToPosition(p.x, p.y, p.z)
        else
            GoToObj(obj)
        end
        return
    end
    if not nx_execute("admin_zdn\\zdn_logic_vat_pham", "IsDroppickShowed") then
        nx_execute("custom_sender", "custom_select", obj.Ident)
        TimerObjNotValid = TimerInit()
    end
end

function waitTimeOut()
    if TimerDiff(TimerObjNotValid) < 7 then
        return
    end
    if TimerDiff(TimerObjNotValid) < 8 then
        nextPos = nextPos + 1
    end
    TimerObjNotValid = TimerInit()
end

function getObjByConfigId(configId)
    local client = nx_value("game_client")
    local scene = client:GetScene()
    if not nx_is_valid(scene) then
        return
    end
    local objList = scene:GetSceneObjList()
    for _, obj in pairs(objList) do
        if nx_is_valid(obj) and nx_string(obj:QueryProp("ConfigID")) == configId then
            return obj
        end
    end
end

function loadConfig()
    PositionList = {}
    local posStr = IniReadUserConfig("ThuThap", "P", "")
    if posStr ~= "" then
        local posList = util_split_string(nx_string(posStr), ";")
        for _, pos in pairs(posList) do
            local prop = util_split_string(pos, ",")
            if nx_string(prop[1]) == "1" then
                local p = {
                    ["configId"] = prop[2],
                    ["shape"] = prop[3],
                    ["map"] = prop[4],
                    ["x"] = nx_number(prop[5]),
                    ["y"] = nx_number(prop[6]),
                    ["z"] = nx_number(prop[7])
                }
                table.insert(PositionList, p)
            end
        end
        nextPos = 1
    else
        Stop()
    end
end

function isCurseLoading()
    local load = nx_value("form_stage_main\\form_main\\form_main_curseloading")
    if nx_is_valid(load) and load.Visible then
        TimerCurseLoading = TimerInit()
    end
    return TimerDiff(TimerCurseLoading) < 1.5
end

function processCauCa(p)
    if TimerDiff(TimerObjNotValid) < 1 then
        return
    end
    if GetDistance(p.x, p.y, p.z) >= 1.5 then
        if GetDistance(p.x, p.y, p.z) < 10 then
            XuongNgua()
        end
        GoToPosition(p.x, p.y, p.z)
        return
    end
    local obj = getObjByConfigId(p.configId)
    if nx_is_valid(obj) and GetDistanceToObj(obj) <= 17 then
        if not isFishing() then
            nx_execute("custom_sender", "custom_select", obj.Ident)
            nx_execute("custom_sender", "custom_begin_fishing", 0)
            TimerObjNotValid = TimerInit()
            return
        end
        doCauCa()
    else
        waitTimeOut()
    end
end

function isFishing()
    local state = nx_execute("admin_zdn\\zdn_logic_base", "GetRoleState")
    return nx_string(state) == "fishing"
end

function doCauCa()
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return
    end
    local s = nx_number(player:QueryProp("FishingState"))
    if s == 2 then
        nx_execute("custom_sender", "custom_op_fishing")
    end
end

function processThoSan(p)
    if nx_execute("admin_zdn\\zdn_logic_hao_kiet", "IsInBossScene") then
        nx_execute("admin_zdn\\zdn_logic_hao_kiet", "QuitBossScene")
        return
    end
    if GetDistance(p.x, p.y, p.z) > 50 then
        GoToPosition(p.x, p.y, p.z)
        return
    end
    LastConfigId = p.configId
    local obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isAttackingMeObj")
    if nx_is_valid(obj) then
        nx_execute("admin_zdn\\zdn_logic_skill", "FlexAttackObj", obj)
        return
    end
    if not isEnoughMana() then
        nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
        nx_execute("admin_zdn\\zdn_logic_skill", "NgoiThien")
        return
    end
    nx_execute("admin_zdn\\zdn_logic_skill", "StopNgoiThien")

    obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isLastConfigIdObj", "canLotDaObj")
    if nx_is_valid(obj) then
        doLotDa(obj)
        return
    end

    obj = nx_execute("admin_zdn\\zdn_logic_base", "GetNearestObj", nx_current(), "isLastConfigIdObj", "isNotDead")
    if nx_is_valid(obj) then
        nx_execute("admin_zdn\\zdn_logic_skill", "FlexAttackObj", obj)
        return
    end
    nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
    waitTimeOut()
end

function isLastConfigIdObj(obj)
    return obj:QueryProp("ConfigID") == LastConfigId
end

function canLotDaObj(obj)
    local dead = nx_number(obj:QueryProp("Dead")) == 1
    if not dead then
        return false
    end
    return not nx_find_custom(obj, "ZdnIsCollected") and canPick(obj)
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
    return nx_string(obj:QueryProp("LastObject")) == nx_string(player.Ident)
end


function isEnoughMana()
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return true
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return true
    end
    local mp = nx_number(player:QueryProp("MPRatio"))
    return mp > 50
end

function isInPickMember(pick_member, member)
    local list = util_split_wstring(pick_member, ",")
    for i, name in pairs(list) do
        if name == member then
            return true
        end
    end
    return false
end

function canPick(obj)
    local pick_member = nx_widestr(obj:QueryProp("PickMember"))
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return false
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return false
    end
    return isInPickMember(pick_member, player:QueryProp("Name"))
end

function doLotDa(obj)
    nx_execute("admin_zdn\\zdn_logic_skill", "PauseAttack")
    if TimerDiff(TimerObjNotValid) < 1 then
        return
    end
    if GetDistanceToObj(obj) > 2 then
        GoToObj(obj)
        return
    end
    XuongNgua()
    nx_execute("custom_sender", "custom_select", obj.Ident)
    TimerObjNotValid = TimerInit()
end

function setCurrentObjIsCollected()
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return
    end
    local obj = client:GetSceneObj(nx_string(player:QueryProp("LastObject")))
    if nx_is_valid(obj) then
        obj.ZdnIsCollected = 1
    end
end

function isNotDead(obj)
    local dead = nx_number(obj:QueryProp("Dead")) == 1
    return not dead
end

function buyTool()
	-- Check dụng cụ thu thập
	local goods_grid = nx_value("GoodsGrid")	
	if goods_grid:GetItemCount("tool_cai_01") == 0 then
	
		-- Check pass rương và tự mua dụng cụ thu thập
		local game_client=nx_value("game_client")
		local player_client=game_client:GetPlayer()
		if not player_client:FindProp("IsCheckPass") or player_client:QueryProp("IsCheckPass") ~= 1 then
			ShowText("Mở khóa rương để tự mua dụng cụ")
			return 
		else 		
			-- Mua dụng cụ trong Tạp Hóa ------------- Shop Giang hồ ---- 1: Công Cụ, 18: số thứ tự dụng cụ thu thập, 1: Mua (Tương tự vậy thì 1,1,1: Tab Công Cụ, Mua Liệp Thú Đoản Kiếm)
			nx_execute("custom_sender", "custom_open_mount_shop", 1)
			nx_execute("custom_sender", "custom_buy_item", "Shop_zahuo_00102", 1,18,1)
			nx_execute("custom_sender", "custom_open_mount_shop", 0)
		end 
	end	
end
