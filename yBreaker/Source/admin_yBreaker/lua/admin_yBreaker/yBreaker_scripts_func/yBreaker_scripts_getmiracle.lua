require("const_define")
require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local auto_is_running = false
local num_repeated = 0

function get_miracle()
	-- Click 1 cai thi chay, click cai nua thi dung
	if not auto_is_running then
		auto_is_running = true
		num_repeated = 0
		tools_show_notice(nx_function("ext_utf8_to_widestr", "Bắt đầu nhận kỳ ngộ"))
		
		while auto_is_running == true do
			auto_capture_qt()
			
			num_repeated = num_repeated + 1
			if num_repeated >= 12 then
				num_repeated = 0
				--tools_show_notice(nx_function("ext_utf8_to_widestr", "Auto tự nhận kỳ ngộ đang chạy!"))
			end
			nx_pause(2)
		end
	else
		auto_is_running = false
		tools_show_notice(nx_function("ext_utf8_to_widestr", "Kết thúc nhận kỳ ngộ!"))
	end
end

function set_get_miracle(status)
	if status == nx_string("ON") then
		auto_is_running = true
		num_repeated = 0
		--tools_show_notice(nx_function("ext_utf8_to_widestr", "Mở nhận kỳ ngộ"))
		
		while auto_is_running == true do
		auto_capture_qt()
		
		num_repeated = num_repeated + 1
		if num_repeated >= 12 then
			num_repeated = 0
		end
		nx_pause(2)
	end
	else
		auto_is_running = false
		--tools_show_notice(nx_function("ext_utf8_to_widestr", "Tắt nhận kỳ kgộ"))
	end
end