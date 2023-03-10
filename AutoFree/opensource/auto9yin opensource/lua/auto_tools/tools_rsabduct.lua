require("const_define")
require("util_gui")
require("util_move") -- Xac dinh toa do distance3d
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("auto_tools\\tool_libs")

local auto_is_running = false
local max_distance_selectauto = 6
local last_table_coc = {}
local sound_before = nil -- Am thanh truoc
local volume_before = nil -- Am luong truoc
local used_abduct_item = false

function auto_init()
	-- Xac dinh cau hinh am thanh ban dau
	if sound_before == nil then
		local game_config = nx_value("game_config")
		sound_before = game_config.music_enable
		volume_before = game_config.music_volume
	end

	-- Click 1 cai thi chay, click cai nua thi dung
	if not auto_is_running then
		-- nx_execute("auto_tools\\tools_doabduct", "direct_endauto")
		auto_is_running = true
		tools_show_notice(util_text("tool_auto_rsabduct_start"))
		
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
				local select_object = 0
				local trigger_music = false
				local current_table_coc = {}
				
				for i = 1, table.getn(game_scence_objs) do
					local obj_type = 0
					if game_scence_objs[i]:FindProp("Type") then
						obj_type = game_scence_objs[i]:QueryProp("Type")
					end
					local distance = string.format("%.0f", distance3d(game_player.PositionX, game_player.PositionY, game_player.PositionZ, game_scence_objs[i].PosiX, game_scence_objs[i].PosiY, game_scence_objs[i].PosiZ))
					
					if obj_type == 4 and game_scence_objs[i]:QueryProp("ConfigID") == "OffAbductNpc_0" and used_abduct_item and tonumber(distance) <= max_distance_selectauto then --- NPC
						nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
						nx_pause(0.2)
						nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
						nx_pause(0.2)
						nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
						nx_pause(0.2)
						nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
						nx_pause(10)
						used_abduct_item = false
						break
					elseif obj_type == 2 then -- Người chơi
						if game_scence_objs[i]:QueryProp("IsAbducted") == 0 and game_scence_objs[i]:QueryProp("OffLineState") == 1 and not game_scence_objs[i]:FindProp("OfflineTypeTvT") then
							if tonumber(distance) <= max_distance_selectauto then
								select_object = i
							end
							
							local coc_name = game_scence_objs[i]:QueryProp("Name")
							local coc_ident = game_scence_objs[i]:QueryProp("Ident")
							local coc_posX = string.format("%.0f", game_scence_objs[i].PosiX)
							local coc_posZ = string.format("%.0f", game_scence_objs[i].PosiZ)
							
							local pathX = game_scence_objs[i].DestX
							local pathY = game_scence_objs[i].DestY
							local pathZ = game_scence_objs[i].DestZ
							
							table.insert(current_table_coc, coc_name)
							
							if not in_array(coc_name, last_table_coc) then
								trigger_music = true
								-- Chat hệ thống thông số cóc
								local textchat = nx_value("gui").TextManager:GetFormatText(nx_string("tool_auto_rsabduct_info"), nx_widestr(coc_name), nx_widestr(coc_posX), nx_widestr(coc_posZ), nx_widestr(get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(coc_ident))
								nx_value("form_main_chat"):AddChatInfoEx(textchat, CHATTYPE_SYSTEM, false)
							end
						end
					end
				end
				
				last_table_coc = current_table_coc
				
				if select_object ~= 0 then
					nx_execute("custom_sender", "custom_select", game_scence_objs[select_object].Ident)
					local form_bag = nx_value("form_stage_main\\form_bag")
					if nx_is_valid(form_bag) then
						form_bag.rbtn_tool.Checked = true
					end
					nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "offitem_miyao10")
					used_abduct_item = true
				end
				
				if trigger_music then
					local timer = nx_value(GAME_TIMER)
					if nx_is_valid(timer) then
						timer:UnRegister(nx_current(), "tools_resume_scene_music", nx_value("game_config"))
					end
					nx_function("ext_flash_window")
					tools_play_sound()
				end
			end
			
			-- Dừng một lát trước khi chạy lại
			nx_pause(0.3)
		end
	else
		auto_is_running = false
		last_table_coc = {}
		tools_show_notice(util_text("tool_auto_rsabduct_end"))
	end
end
function direct_endauto()
	auto_is_running = false
	last_table_coc = {}
	tools_show_notice(util_text("tool_auto_rsabduct_end"))
end
function tools_play_sound()
	local role = nx_value("role")
	if not nx_is_valid(role) then
		return
	end
	local scene = role.scene
	if not nx_is_valid(scene) then
		return
	end
	local game_config = nx_value("game_config")
	game_config.music_enable = true
	game_config.music_volume = 1
	nx_execute("form_stage_main\\form_system\\form_system_music_setting", "set_music_enable", game_config.music_enable)
	nx_execute("util_functions", "play_music", scene, "scene", "life_game_win", 0, 0, 0, 1, false)
	
	local timer = nx_value(GAME_TIMER)
	if nx_is_valid(timer) then
		timer:Register(20000, -1, nx_current(), "tools_resume_scene_music", game_config, -1, -1)
	end			
end
function tools_resume_scene_music(cfg)
	local role = nx_value("role")
	if not nx_is_valid(role) then
		return
	end
	local scene = role.scene
	if not nx_is_valid(scene) then
		return
	end
	local game_config = nx_value("game_config")
	local timer = nx_value(GAME_TIMER)
	if nx_is_valid(timer) then
		timer:UnRegister(nx_current(), "tools_resume_scene_music", game_config)
	end			
	game_config.music_enable = sound_before
	game_config.music_volume = 1
	sound_before = nil
	volume_before = nil
	nx_execute("form_stage_main\\form_system\\form_system_music_setting", "set_music_enable", game_config.music_enable)
	local game_client = nx_value("game_client")
	local client_scene = game_client:GetScene()
	if not nx_is_valid(client_scene) then
		return
	end
	local scene_music = client_scene:QueryProp("Resource")
	nx_execute("util_functions", "play_scene_random_music", scene, "scene", scene_music)	
end
function get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end
