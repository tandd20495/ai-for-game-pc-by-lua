require("admin_zdn\\zdn_form_common")

local Logic = "admin_zdn\\zdn_logic_luyen_cong"

function onFormOpen()
	local cbtn = nx_string(IniReadUserConfig("LuyenCong", "CurrentPos", "0"))
	Form.cbtn_current_pos.Checked = cbtn == "1"
	if nx_execute(Logic, "IsRunning") then
		nx_execute("admin_zdn\\zdn_event_manager", "Subscribe", Logic, "on-task-stop", nx_current(), "onTaskStop")
		updateBtnSubmitState(true)
	else
		updateBtnSubmitState(false)
	end
end

function onBtnSubmitClick()
	if not nx_execute(Logic, "IsRunning") then
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
end

function onCbtnCurrentPosChanged(btn)
	IniWriteUserConfig("LuyenCong", "CurrentPos", btn.Checked and "1" or "0")
end
