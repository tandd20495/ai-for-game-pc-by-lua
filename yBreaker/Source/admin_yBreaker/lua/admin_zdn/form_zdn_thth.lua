require("admin_zdn\\zdn_form_common")

local Logic = "admin_zdn\\zdn_logic_thth"

function onFormOpen()
	if nx_execute(Logic, "IsRunning") then
		nx_execute("admin_zdn\\zdn_event_manager", "Subscribe", Logic, "on-task-stop", nx_current(), "onTaskStop")
		updateBtnSubmitState(true)
	else
		updateBtnSubmitState(false)
	end
	loadConfig()
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

function onOpenBoxChanged(btn)
	IniWriteUserConfig("Thth", "OpenBox", btn.Checked and "1" or "0")
end

function onFastRunChanged(btn)
	IniWriteUserConfig("Thth", "FastRun", btn.Checked and "1" or "0")
end

function loadConfig()
	local checked = nx_string(IniReadUserConfig("Thth", "OpenBox", "0"))
	Form.cbtn_open_box.Checked = (checked == "1")
	checked = nx_string(IniReadUserConfig("Thth", "FastRun", "0"))
	Form.cbtn_fast_run.Checked = (checked == "1")
end
