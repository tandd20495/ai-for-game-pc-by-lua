local SELECT_FORM = "form_stage_main\\form_home\\form_building_select"
local CLIENT_SUB_BUILDING_SELECT = 52

local Running = false

function IsRunning()
    return Running
end

function Start()
    if Running then
        return
    end
    Running = true
    while Running do
        loopLuyenCongBinh()
        nx_pause(2)
    end
end

function Stop()
    Running = false
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

function loopLuyenCongBinh()
    local form = nx_value(SELECT_FORM)
    local obj = getTargetObj()
    if not nx_is_valid(obj) then
        return
    end
    if not nx_is_valid(form) then
        nx_execute("custom_sender", "custom_select", obj.Ident)
        return
    end
    nx_execute(
        "custom_sender",
        "custom_home",
        nx_int(CLIENT_SUB_BUILDING_SELECT),
        nx_string(form.building_id),
        nx_int(2) - 1
    )
end

function getTargetObj()
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return
    end
    return client:GetSceneObj(nx_string(player:QueryProp("LastObject")))
end
