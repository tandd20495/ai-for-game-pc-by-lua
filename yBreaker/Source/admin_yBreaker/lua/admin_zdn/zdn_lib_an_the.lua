require("util_functions")
local Running = false

function IsRunning()
    return Running
end

function CanRun()
    local resetTimeStr = IniReadUserConfig("AnThe", "ResetTime", "")
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
        loopAnThe()
        nx_pause(0.2)
    end
end

function Stop()
    Running = false
    StopFindPath()
    nx_execute("admin_zdn\\zdn_logic_skill", "StopAutoAttack")
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

-- private
function onTaskDone()
    local newResetTimeStr = QUEST_ID .. "," .. nx_execute("admin_zdn\\zdn_logic_base", "GetNextDayStartTimestamp")
    local resetTimeStr = IniReadUserConfig("AnThe", "ResetTime", "")
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
    IniWriteUserConfig("AnThe", "ResetTime", newResetTimeStr)
    Stop()
end