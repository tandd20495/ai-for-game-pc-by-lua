require("const_define")
require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local auto_is_running = false
local THIS_FORM = "admin_yBreaker\\yBreaker_form_stallonline"

function run_stall_online()
	-- Click 1 cai thi chay, click cai nua thi dung
	--if not auto_is_running then
	--	auto_is_running = true
	--	tools_show_notice(nx_function("ext_utf8_to_widestr", "Bắt đầu bày hàng online"))

		while auto_is_running == true do
			local FORM_STALL_MAIN = "form_stage_main\\form_stall\\form_stall_main"
			local FORM_CONFIRM = "form_common\\form_confirm"

			-- Mở cái form bày hàng lên
			local form = nx_value(FORM_STALL_MAIN)
            local checkloop = 10
			while not nx_is_valid(form) do
                checkloop = checkloop - 1
                if checkloop < 0 then
                    auto_is_running = false
                    break
                end
				util_auto_show_hide_form(FORM_STALL_MAIN)
                nx_pause(0.05)
				form = nx_value(FORM_STALL_MAIN)
			end
			nx_pause(1)
			if nx_is_valid(form) and nx_find_custom(form, "lbl_stall_pos") then
				local gui = nx_value("gui")
				if form.lbl_stall_pos.Text == gui.TextManager:GetText("@ui_stall_null") then
					-- Sẵn sàng bày hàng
					tools_show_notice(nx_function("ext_utf8_to_widestr", "Sẵn sàng bày hàng"))

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
					tools_show_notice(nx_function("ext_utf8_to_widestr", "Khu không bày hàng"))
				else
					-- Đang bày hàng
					tools_show_notice(nx_function("ext_utf8_to_widestr", "Đang bày hàng"))
				end

				tools_show_notice(nx_function("ext_utf8_to_widestr", "Đang bày hàng online"))

				nx_pause(10)
			else
				nx_pause(0.2)
			end
		end
	--else
		--auto_is_running = false
		--tools_show_notice(nx_function("ext_utf8_to_widestr", "Kết thúc bày hàng online"))
	--end
end

function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end

-- Handle event main form of yBreaker
function on_main_form_open(form)
	change_form_size()
	form.is_minimize = false
end

--
function on_main_form_close(form)
	nx_destroy(form)
end

--
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = 100
	form.Top = (gui.Height - form.Height) / 2
end

--
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
	
	
function show_hide_form_stallonline()
	util_auto_show_hide_form(THIS_FORM)
end

function on_btn_control_click(btn)
	local form = btn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	
	if not auto_is_running then
		auto_is_running = true
		btn.Text = nx_function("ext_utf8_to_widestr", "Kết Thúc")
		run_stall_online()	
	
	else
		auto_is_running = flase
		btn.Text = nx_function("ext_utf8_to_widestr", "Bắt Đầu")		
	end

end