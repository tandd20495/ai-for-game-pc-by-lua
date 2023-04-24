require("admin_zdn\\zdn_form_common")

local Logic = "admin_zdn\\zdn_logic_chat_loop"

function onBtnSubmitClick()
	nx_execute(Logic, "Stop")
	onBtnCloseClick()
end
