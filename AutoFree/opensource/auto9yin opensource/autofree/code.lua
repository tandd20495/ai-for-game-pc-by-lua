 -- auto bấm phím
 local FORM_SHORTCUT = "form_stage_main\\form_main\\form_main_shortcut"
 local game_shortcut = nx_value("GameShortcut")
 local form = nx_value(FORM_SHORTCUT)
 local grid = form.grid_shortcut_main
 auto_is_running=false
 function auto_init()
 	if not auto_is_running then
		auto_is_running = true
		tools_show_notice(util_text("Tu dong nhan phim"))
			while auto_is_running == true do
				local actions = get_obj_actions_full(bossID)
				if in_array("parrying_up", actions) then
					game_shortcut:on_main_shortcut_useitem(grid, 0, true)
				end
				local buffNC = get_buff_info("buf_CS_jl_shuangci07")
				if (buffNC == nil or buffNC < 5) and not in_array("hurtdown", actions) then
					game_shortcut:on_main_shortcut_useitem(grid, 3, true)
					nx_pause(1)
				end
					game_shortcut:on_main_shortcut_useitem(grid, 1, true)
					game_shortcut:on_main_shortcut_useitem(grid, 2, true)
			end
	else
		auto_is_running = false
		tools_show_notice(util_text("Ket thuc"))
	end
end
