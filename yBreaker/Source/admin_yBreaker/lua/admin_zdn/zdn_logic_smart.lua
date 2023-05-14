require("util_functions")
require("util_static_data")
require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")

local Running = false

function Start()
    if Running then
        return
    end
    Running = true

    while Running do
        loopswapweapon()
		loopswapbook()
        nx_pause(0.1)
    end
end

function Stop()
    Running = false
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

function IsRunning()
    return Running
end

function loopswapweapon()
-- Do something
ShowText("Đang đổi vũ khí")
end

function loopswapbook()
-- Do something
ShowText("Đang đổi bình thư")
end

