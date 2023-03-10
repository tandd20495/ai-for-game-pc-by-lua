require("const_define")
require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("auto_tools\\tool_libs")
local auto_is_running = false
local THIS_FORM = "auto_tools\\tools_stall"
local FORM_STALL_MAIN = "form_stage_main\\form_stall\\form_stall_main" -- form bày hàng
function auto_stallonline()
	--tools_show_notice(util_text("tool_message_start_autostall"))
	local chat = nx_value(THIS_FORM)
	name = chat.tab_1_input.Text
	local test = nx_function("ext_ws_replace", nx_widestr(name), nx_widestr("<font face=\"font_title_tasktrace\" color=\"#ffffff\" >"), nx_widestr(""))
	local test2 = nx_function("ext_ws_replace", nx_widestr(test), nx_widestr("</font><b"), nx_widestr(""))
	local test3 = nx_function("ext_ws_replace", nx_widestr(test2), nx_widestr("r/>"), nx_widestr(""))
	while auto_is_running == true do
		--local FORM_STALL_MAIN = "form_stage_main\\form_stall\\form_stall_main" -- form bày hàng
		local FORM_CONFIRM = "form_common\\form_confirm" -- xác nhận
		local form = nx_value(FORM_STALL_MAIN)
		local bayhang = util_get_form(FORM_STALL_MAIN)
		open_stall()
			if nx_is_valid(bayhang) and nx_find_custom(form, "lbl_stall_pos") then
				local gui = nx_value("gui")
				if form.lbl_stall_pos.Text == gui.TextManager:GetText("@ui_stall_null") then
					-- Sẵn sàng bày hàng
					if test3 ~= nx_widestr("") then 
					form.ipt_name.Text = test3
					end
					tools_show_notice(util_text("ui_stall_null")) -- có thể bày hàng
					local btn = form.btn_online_stall
					nx_execute(FORM_STALL_MAIN, "on_btn_online_stall_click", btn)
					nx_pause(1)
					local form = nx_value(FORM_CONFIRM)
					if nx_is_valid(form) then
						local btn = form.ok_btn
						nx_execute(FORM_CONFIRM, "ok_btn_click", btn)
					end
				elseif form.lbl_stall_pos.Text == gui.TextManager:GetText("@ui_stall_out") then
					-- Khu không bày hàng
					tools_show_notice(util_text("ui_stall_out"))
				else
					-- Đang bày hàng
					tools_show_notice(util_text("ui_stall_baitanzhong"))
				end
				--tools_show_notice(util_text("tool_message_running_autostall"))
				nx_pause(5)
	end
	nx_pause(1)
	
end
		
end
function tools_show_form()
util_auto_show_hide_form("auto_tools\\tools_stall")
open_stall()
end
function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	change_form_size()
	form.is_minimize = false
	open_stall()
	--control_this_form(form)
end
function on_main_form_close(form)
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
	end
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = (gui.Width - form.Width) / 2
	--form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
end
function on_btn_control_click(btn)
	local form = btn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	if auto_is_running then
		--auto_is_running = false
		btn.Text = util_text("tool_start")
		stop_stall()
	else
		auto_is_running = true
		btn.Text = util_text("tool_stop")
		auto_stallonline()
	end
end

function stop_stall()
  local gui = nx_value("gui")
  local form = util_get_form(THIS_FORM)
    local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_confirm", true, false)
    local text = nx_widestr(util_text("ui_Stall_Is_JieSu"))
    nx_execute("form_common\\form_confirm", "show_common_text", dialog, text)
    dialog.Left = (gui.Width - dialog.Width) / 2
    dialog.Top = (gui.Height - dialog.Height) / 2
    dialog:ShowModal()
    local res = nx_wait_event(100000000, dialog, "confirm_return")
    if res == "ok" then
		auto_is_running = false
		nx_execute("custom_sender", "custom_stall_return_ready")
		tools_show_notice(util_text("tool_message_stop_autostall"))
		if  nx_is_valid(form)  then
			nx_destroy(form)
		end	
    end

 end
function open_stall()
local bayhang = util_get_form(FORM_STALL_MAIN)
local form = nx_value(FORM_STALL_MAIN)
if not nx_is_valid(bayhang)  then
	util_auto_show_hide_form(FORM_STALL_MAIN)
end	
local status = util_get_form(THIS_FORM)
if  nx_is_valid(status) and auto_is_running  then
		status.btn_control.Text = util_text("@tool_stop")
--		nx_pause(0.1)
end
end