require("admin_zdn\\zdn_form_common")
require("util_functions")
require("util_gui")

local Logic = "admin_zdn\\zdn_logic_tdc"

function onFormOpen()
	updateView()
	local cbtn = nx_string(IniReadUserConfig("TDC", "Follow", "0"))
	Form.cbtn_follow.Checked = cbtn == "1"
	nx_execute("admin_zdn\\zdn_event_manager", "Subscribe", Logic, "on-done-turn", nx_current(), "updateView")
	if nx_execute(Logic, "IsRunning") then
		nx_execute("admin_zdn\\zdn_event_manager", "Subscribe", Logic, "on-task-stop", nx_current(), "onTaskStop")
		updateBtnSubmitState(true)
	else
		updateBtnSubmitState(false)
	end
end

function onBtnSubmitClick()
	if not nx_execute(Logic, "IsRunning") then
		saveConfig()
		updateBtnSubmitState(true)
		nx_execute("admin_zdn\\zdn_event_manager", "Subscribe", Logic, "on-task-stop", nx_current(), "onTaskStop")
		nx_execute(Logic, "Start")
	else
		nx_execute(Logic, "Stop")
		updateBtnSubmitState(false)
	end
end

function onTaskStop()
	updateBtnSubmitState(false)
end

function onFormClose()
	nx_execute("admin_zdn\\zdn_event_manager", "Unsubscribe", Logic, "on-task-stop", nx_current())
	nx_execute("admin_zdn\\zdn_event_manager", "Unsubscribe", Logic, "on-done-turn", nx_current())
end

function saveConfig()
	local turn = nx_number(Form.max_turn.Text)
	if turn < 0 then
		turn = 1
	elseif turn > 99 then
		turn = 99
	end
	IniWriteUserConfig("TDC", "MaxTurn", turn)
end

function updateView()
	local str = nx_string(IniReadUserConfig("TDC", "FinishTurn", "0,0"))
	local prop = util_split_string(str, ",")
	local cT = nx_execute("admin_zdn\\zdn_logic_base", "GetCurrentWeekStartTimestamp")
	local t = nx_number(prop[1])
	local turn = 0
	if t == cT then
		turn = nx_number(prop[2])
	end
	Form.lbl_turn.Text = nx_widestr(turn) .. nx_widestr("/")
	Form.max_turn.Text = IniReadUserConfig("TDC", "MaxTurn", nx_widestr("1"))
end

function onCbtnFollowChanged(btn)
	IniWriteUserConfig("TDC", "Follow", btn.Checked and "1" or "0")
end

function show_hide_form_tdc()
	util_auto_show_hide_form("admin_zdn\\form_zdn_tdc")
end
