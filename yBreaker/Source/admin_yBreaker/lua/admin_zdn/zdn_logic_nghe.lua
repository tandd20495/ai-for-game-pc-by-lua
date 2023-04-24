require("admin_zdn\\zdn_util")

local Running = false
local FormulaId = ""
local Profession = ""
local MaxTurn = 1
local TimerStartGame = 0
local TimerStartCompose = 0

function IsRunning()
    return Running
end

function Start(profession, formulaId, num)
    if Running then
        return
    end
    Profession = profession
    FormulaId = formulaId
    MaxTurn = num
    Running = true
    while Running do
        loopNghe()
        nx_pause(0.1)
    end
end

function Stop()
    Running = false
    nx_execute("admin_zdn\\zdn_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

-- private
function loopNghe()
    if isCurseLoading() then
        return
    end
    local form = nx_value("form_stage_main\\form_small_game\\form_game_handwriting")
    if nx_is_valid(form) and form.Visible then
        processGame(form, "form_stage_main\\form_small_game\\form_game_handwriting")
        return
    end
    form = nx_value("form_stage_main\\form_small_game\\form_game_picture")
    if nx_is_valid(form) and form.Visible then
        processGame(form, "form_stage_main\\form_small_game\\form_game_picture")
        return
    end
    if TimerDiff(TimerStartCompose) <= 1 then
        return
    end
    nx_execute("custom_sender", "custom_send_compose", nx_string(FormulaId), nx_int(1), 0, 0)
    TimerStartCompose = TimerInit()
end

function isCurseLoading()
    local load = nx_value("form_stage_main\\form_main\\form_main_curseloading")
    if nx_is_valid(load) and load.Visible then
        TimerCurseLoading = TimerInit()
    end
    return TimerDiff(TimerCurseLoading) < 0.5
end

function processGame(form, formStr)
    if nx_is_valid(form.btn_start) and form.btn_start.Visible then
        if TimerDiff(TimerStartGame) <= 1 then
            return
        end
        nx_execute(formStr, "on_btn_start_click", form.btn_start)
        MaxTurn = MaxTurn - 1
        TimerStartGame = TimerInit()
    end
    if MaxTurn <= 0 then
        Stop()
    end
end
