require("util_gui")
require("util_static_data")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_tamma"

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
    local isRunning = false
	form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Chạy")
	form.btn_control.ForeColor = "255,255,255,255"

end

function on_main_form_close(form)
    isRunning = false
    nx_destroy(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    form.Left = 100
    form.Top = (gui.Height / 2)
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function on_btn_tamma_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
    if isRunning then
		-- Stop status
		btn.Text = nx_function("ext_utf8_to_widestr", "Chạy")
		btn.ForeColor = "255,255,255,255"
        --isRunning = false   
		stop_tamma()

    else
		btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
		btn.ForeColor = "255,220,20,60"
		--isRunning = true   
		start_tamma()
		
    end
end

-- Show hide form blink
function show_hide_form_blink()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_tamma")
end

function start_tamma()

    if not isRunning then
		isRunning = true
		while isRunning do
			loop_dienvo()
			nx_pause(0.1)
		end
	else
		isRunning = false
	end
end

function stop_tamma()
    isRunning = false
    nx_execute("custom_sender", "custom_send_faculty_msg", 23)
    nx_execute(nx_current(), "TriggerEvent", nx_current(), "on-task-stop")
    --nx_execute(nx_current(), "removeListen", nx_current(), "300144", "goToTamMaScene")
end

function loop_dienvo()
    local form = nx_value("form_stage_main\\form_wuxue\\form_wuxue_act")
    if not nx_is_valid(form) or not form.Visible then
        nx_execute("custom_sender", "custom_send_faculty_msg", 21)
        return
    end
    nx_execute("custom_sender", "custom_send_faculty_msg", 23, nx_int(3), nx_int(1))
end


local ListenList = {}
function addListen(file, msg, call, sleep, ...)
	refresh()
	local listen = {
		["File"] = file,
		["Msg"] = msg,
		["Time"] = TimerInit(),
		["Call"] = call,
		["Sleep"] = sleep,
		["Param"] = arg
	}

	if isListenExists(listen) then
		return
	end
	table.insert(ListenList, listen)
end

function removeListen(file, msg, call)
	for i, l in pairs(ListenList) do
		if file == l.File and msg == l.Msg and call == l.Call then
			table.remove(ListenList, i)
			return
		end
	end
end

function isListenExists(listen)
	for i, l in pairs(ListenList) do
		if listen.File == l.File and listen.Msg == l.Msg and listen.Call == l.Call then
			return true
		end
	end
	return false
end

function getVisualObj(obj)
	if not nx_is_valid(obj) then
		return
	end
	return nx_value("game_visual"):GetSceneObj(obj.Ident)
end

function GetDistanceToObj(obj)
	local vObj = getVisualObj(obj)
	if not nx_is_valid(vObj) then
		return 9999999999
	end
	return GetDistance(vObj.PositionX, vObj.PositionY, vObj.PositionZ)
end

function GetNearestObj(...)
    local client = nx_value("game_client")
    local scene = client:GetScene()
    if not nx_is_valid(scene) then
        return nil
    end
    local target = 0
    local shortestDistance = 200
    local objList = scene:GetSceneObjList()
    local argCnt = 0
    for _, obj in pairs(objList) do
        if nx_is_valid(obj) then
            local validTarget = true
            if argCnt > 1 then
                for i = 2, argCnt do
                    if not nx_execute(nx_string(arg[1]), nx_string(arg[i]), obj) then
                        validTarget = false
                        i = cnt
                    end
                end
            end
            if validTarget then
                local d = GetDistanceToObj(obj)
                if d < shortestDistance then
                    shortestDistance = d
                    target = obj
                end
            end
        end
    end
    return target
end

local SubscriberList = {}
function TriggerEvent(source, event)
    for i, sub in pairs(SubscriberList) do
        if source == sub.Source and event == sub.Event then
            nx_execute(sub.Subscriber, sub.Callback, sub.Source, unpack(sub.Param))
        end
    end
end

function refresh()
	for i, listen in pairs(ListenList) do
		if listen.Sleep ~= -1 and TimerDiff(listen.Time) > listen.Sleep then
			table.remove(ListenList, i)
		end
	end
end

function TimerInit()
    return os.clock()
end

function TimerDiff(t)
    if t == 0 or t == nil then
      return 999999
    end
    return os.clock() - t
end

