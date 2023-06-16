require("util_functions")
require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")

local Running = false
local ThuNghiepMap = "city04"
local ThuNghiepNpc = "SMSY_School10"
local RunAllTheWayFlg = false

function IsRunning()
    return Running
end

function CanRun()
    return not IsTaskDone() and isInTaskTime()
end

function IsTaskDone()
    loadConfig()
    if RunAllTheWayFlg then
        return false
    end
    local client = nx_value("game_client")
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return false
    end
    local progress = player:QueryProp("SchoolDanceDayScore")
    if nx_int(progress) == nx_int(60) then
        local form = nx_value("form_stage_main\\form_school_dance\\form_school_dance_member")
        if not nx_is_valid(form) or not form.Visible then
            return true
        end
    end
    return false
end

function Start()
    if Running then
        return
    end
    Running = true
    while Running do
        loopThuNghiep()
        nx_pause(1)
    end
end

function Stop()
    Running = false
    StopFindPath()
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

function talkToNpc()
    XuongNgua()
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return {}
    end
    local scene = client:GetScene()
    if not nx_is_valid(scene) then
        return {}
    end
    local objList = scene:GetSceneObjList()
    local npcObj = nx_null()
    local num = #objList
    for i = 1, num do
        local obj = objList[i]
        if nx_number(obj:QueryProp("NpcType")) ~= 0 and nx_string(obj:QueryProp("ConfigID")) == ThuNghiepNpc then
            npcObj = obj
        end
    end
    if not nx_is_valid(npcObj) then
        return false
    end
    TalkToNpc(npcObj, 0)
end

function loopThuNghiep()
    if IsMapLoading() then
        return
    end
    if not CanRun() then
        Stop()
        return
    end
    local form = nx_value("form_stage_main\\form_school_dance\\form_school_dance_member")
    if nx_is_valid(form) and form.Visible then
        return
    end
    if ThuNghiepMap == "" then
        return
    end
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-interrupt")
    if not Running then
        return
    end
    if GetCurMap() ~= ThuNghiepMap then
        GoToMapByPublicHomePoint(ThuNghiepMap)
        return
    end
    if GoToNpc(ThuNghiepMap, ThuNghiepNpc) then
        talkToNpc()
    end
end

function isInTaskTime()
    local hour = nx_execute("admin_zdn\\zdn_logic_base", "GetCurrentHour")
    if 7.5 < hour and hour < 9 then
        return true
    elseif 13.5 < hour and hour < 15 then
        return true
    elseif 19.5 < hour and hour < 21 then
        return true
    elseif 22 < hour and hour < 23.5 then
        return true
    else
        return false
    end
end

function loadConfig()
    RunAllTheWayFlg = nx_string(IniReadUserConfig("ThuNghiep", "RunAllTheWay", "0")) == "1"
end
