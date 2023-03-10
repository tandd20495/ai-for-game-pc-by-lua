require("util_functions")
require("auto_tools\\tool_libs")

local auto_is_running = false
local num_repeated = 0

function auto_init()
	if not auto_is_running then	
		auto_is_running = true
		num_repeated = 0
		tools_show_notice(util_text("tool_auto_relivenear_start"))
		
		while auto_is_running == true do
			local is_vaild_data = true
			local game_client
			local player_client
			
			game_client = nx_value("game_client")
			if not nx_is_valid(game_client) then
				is_vaild_data = false
			end
			if is_vaild_data == true then
				player_client = game_client:GetPlayer()
				if not nx_is_valid(player_client) then
					is_vaild_data = false
				end
			end

			if is_vaild_data == true then
				-- Nếu bị chết thì phải bắt đầu lại từ đầu
				if player_client:QueryProp("LogicState") == 120 then
					nx_execute("custom_sender", "custom_relive", 2, 0)
					nx_pause(15)
				else
					num_repeated = num_repeated + 1
					if num_repeated >= 10 then
						num_repeated = 0
						tools_show_notice(util_text("tool_auto_relivenear_running"))
					end
				end
			end
			nx_pause(1)
		end
	else
		auto_is_running = false
		tools_show_notice(util_text("tool_auto_relivenear_end"))
	end
end