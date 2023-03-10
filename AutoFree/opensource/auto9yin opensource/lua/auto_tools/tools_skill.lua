require("const_define")
require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("auto_tools\\tool_libs")
require("auto\\tiguan")
require("auto\\lib2")
local auto_is_running=false
 function auto_init()
 local FORM_SHORTCUT = "form_stage_main\\form_main\\form_main_shortcut"
 local game_client = nx_value("game_client")
local client_player = game_client:GetPlayer()
 local game_shortcut = nx_value("GameShortcut")
 local form = nx_value(FORM_SHORTCUT)
 local grid = form.grid_shortcut_main
 	if not auto_is_running then
		auto_is_running = true
		tools_show_notice(util_text("tool_auto_skill_label"))
			while auto_is_running == true do
			  local select_target_ident = client_player:QueryProp("LastObject")
			  local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
				local cur_state = client_player:QueryProp("FacultyState") -- cho thanh niên nào dùng ăn dịch cân đan
				if nx_int(cur_state) == nx_int(0) then
					nx_execute("custom_sender", "custom_send_faculty_msg", 11) -- nhấn tiếp tục nội tu khi lên lvl
				end
				local buffNC = get_buff_info("buf_CS_jl_shuangci07")
				if (buffNC == nil or buffNC < 5) then
				-- buff ôn thần còn 5s thì nộ ( phím số 5 )
					game_shortcut:on_main_shortcut_useitem(grid, 4, true)
					nx_pause(0.1)
				end
				if select_target ~= nil and nx_function("find_buffer", select_target, "BuffInParry") then
					game_shortcut:on_main_shortcut_useitem(grid, 0, true) -- boss deff thì bấm phím 1
					else
					if client_player:QueryProp("SP") >= 50 then -- nộ phím số 0 ()
						nx_execute("custom_sender", "custom_active_parry", 1, 1) -- đỡ đòn
                        game_shortcut:on_main_shortcut_useitem(grid, 9, true)
                    end
				-- nhấn 234 liên tục
					game_shortcut:on_main_shortcut_useitem(grid, 1, true)
					game_shortcut:on_main_shortcut_useitem(grid, 2, true)
					game_shortcut:on_main_shortcut_useitem(grid, 3, true)
					nx_execute("custom_sender", "custom_active_parry", 1, 1) -- đỡ đòn
					nx_pause(0.1)
				end
			end
	else
		auto_is_running = false
		tools_show_notice(util_text("tool_stop"))
	end
end
