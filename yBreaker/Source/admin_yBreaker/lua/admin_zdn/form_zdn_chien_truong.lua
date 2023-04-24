require("util_functions")
require("admin_zdn\\zdn_form_common")

local Logic = "admin_zdn\\zdn_logic_chien_truong"

function onFormOpen(form)
	loadConfig()
	nx_execute("admin_zdn\\zdn_event_manager", "Subscribe", Logic, "on-done-turn", nx_current(), "updateFinishTurn")
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

function loadConfig()
	Form.cbtn_by_turn.Checked = nx_string(IniReadUserConfig("ChienTruong", "ByTurn", "0")) == "1"
	Form.max_turn.Text = IniReadUserConfig("ChienTruong", "MaxTurn", nx_widestr("20"))
	updateFinishTurn()
end

function saveConfig()
	local flg = Form.cbtn_by_turn.Checked and "1" or "0"
	IniWriteUserConfig("ChienTruong", "ByTurn", flg)
	IniWriteUserConfig("ChienTruong", "MaxTurn", Form.max_turn.Text)
end

function updateFinishTurn()
	local str = nx_string(IniReadUserConfig("ChienTruong", "Turn", ""))
	local turn = 0
	if str ~= "" then
		local prop = util_split_string(str, ",")
		if nx_number(prop[1]) == nx_execute("admin_zdn\\zdn_logic_base", "GetCurrentDayStartTimestamp") then
			turn = nx_number(prop[2])
		end
	end
	Form.finish_turn.Text = nx_widestr(turn)
end
