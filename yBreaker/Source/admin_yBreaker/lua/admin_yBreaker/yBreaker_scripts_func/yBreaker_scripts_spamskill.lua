require("const_define")
require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")


 local isRunning=false
 
 function spam_Skill()
 local FORM_SHORTCUT = "form_stage_main\\form_main\\form_main_shortcut"
 local game_shortcut = nx_value("GameShortcut")
 local form = nx_value(FORM_SHORTCUT)
 local grid = form.grid_shortcut_main
 	if not isRunning then
		isRunning = true
		
		yBreaker_show_WstrText(util_text("Start"))
			while isRunning == true do
				local isBuff = yBreaker_get_buff_id_info("buf_CS_jl_shuangci07")
				if (isBuff == nil or isBuff < 5) then
				-- Buff ôn thần còn 5s thì nộ ( phím số 5 )
					game_shortcut:on_main_shortcut_useitem(grid, 4, true)
					nx_pause(0.1)
				end
				-- Nhấn 1234 liên tục
					game_shortcut:on_main_shortcut_useitem(grid, 0, true)
					game_shortcut:on_main_shortcut_useitem(grid, 1, true)
					game_shortcut:on_main_shortcut_useitem(grid, 2, true)
					game_shortcut:on_main_shortcut_useitem(grid, 3, true)
					nx_pause(0.1)
			end
	else
		isRunning = false
		yBreaker_show_WstrText(util_text("Stop"))
	end
end