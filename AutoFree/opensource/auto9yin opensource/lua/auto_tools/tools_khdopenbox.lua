require("const_define")
require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("auto_tools\\tool_libs")

-- boxnpc_khd_bx001 -> boxnpc_khd_bx012
local auto_is_running = false
local num_repeated = 0

function auto_init()
	-- Click 1 cai thi chay, click cai nua thi dung
	if not auto_is_running then
		auto_is_running = true
		num_repeated = 0
		tools_show_notice(util_text("tool_auto_khdopenbox_start"))
		
		while auto_is_running == true do
			-- Kiểm tra dữ liệu hợp chuẩn
			local is_vaild_data = true
			local game_client
			local game_visual
			local game_player
			local game_scence
			
			game_client = nx_value("game_client")
			if not nx_is_valid(game_client) then
				is_vaild_data = false
			end
			game_visual = nx_value("game_visual")
			if not nx_is_valid(game_visual) then
				is_vaild_data = false
			end
			
			if is_vaild_data == true then
				game_player = game_visual:GetPlayer()
				if not nx_is_valid(game_player) then
					is_vaild_data = false
				end
				game_scence = game_client:GetScene()
				if not nx_is_valid(game_scence) then
					is_vaild_data = false
				end
			end
			
			-- Nếu dữ liệu ok hết
			if is_vaild_data == true then
				local form_bag = nx_value("form_stage_main\\form_bag")
				if nx_is_valid(form_bag) then
					form_bag.rbtn_task.Checked = true
				end
				nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "item_khd_ratrace_01")
				
				num_repeated = num_repeated + 1
				if num_repeated >= 10 then
					num_repeated = 0
					tools_show_notice(util_text("tool_auto_khdopenbox_running"))
				end
			end
			nx_pause(1)
		end
	else
		auto_is_running = false
		tools_show_notice(util_text("tool_auto_khdopenbox_end"))
	end
end