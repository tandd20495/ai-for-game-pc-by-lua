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
local last_table_box = {}
local num_repeated = 0

function auto_init()
	-- Click 1 cai thi chay, click cai nua thi dung
	if not auto_is_running then
		auto_is_running = true
		num_repeated = 0
		tools_show_notice(util_text("tool_auto_khddetect_start"))
		
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
				local game_scence_objs = game_scence:GetSceneObjList()
				local current_table_box = {}
				
				for i = 1, table.getn(game_scence_objs) do
					local obj_cfgprefix = string.sub(nx_string(game_scence_objs[i]:QueryProp("ConfigID")), 0, 13)
					
					if obj_cfgprefix == "boxnpc_khd_bx" then
						local box_name = util_text(game_scence_objs[i]:QueryProp("ConfigID"))
						local box_ident = game_scence_objs[i]:QueryProp("Ident")
						local box_posX = string.format("%.0f", game_scence_objs[i].PosiX)
						local box_posZ = string.format("%.0f", game_scence_objs[i].PosiZ)
						
						local pathX = game_scence_objs[i].DestX
						local pathY = game_scence_objs[i].DestY
						local pathZ = game_scence_objs[i].DestZ
						
						table.insert(current_table_box, box_ident)
						
						if not in_array(box_ident, last_table_box) then
							-- Chat hệ thống thông số BOX
							local textchat = nx_value("gui").TextManager:GetFormatText(nx_string("tool_auto_khddetect_info"), box_name, nx_widestr(box_posX), nx_widestr(box_posZ), nx_widestr(get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(box_ident))
							nx_value("form_main_chat"):AddChatInfoEx(textchat, CHATTYPE_SYSTEM, false)
						end
					end
				end
				
				last_table_box = current_table_box
				
				num_repeated = num_repeated + 1
				if num_repeated >= 10 then
					num_repeated = 0
					tools_show_notice(util_text("tool_auto_khddetect_running"))
				end
			end
			nx_pause(1)
		end
	else
		auto_is_running = false
		last_table_box = {}
		tools_show_notice(util_text("tool_auto_khddetect_end"))
	end
end
function get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end