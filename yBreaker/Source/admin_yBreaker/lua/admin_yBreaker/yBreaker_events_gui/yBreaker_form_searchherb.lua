require("const_define")
require("util_gui")
require("util_move") -- Detected here position distance 3D
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_searchherb"
local auto_is_running = false
--REM: PLAY SOUND
-- local sound_before = nil -- Am thanh truoc
-- local volume_before = nil -- Am luong truoc

function auto_run()
	if sound_before == nil then
		local game_config = nx_value("game_config")
		-- sound_before = game_config.music_enable
		-- volume_before = game_config.music_volume
	end
	
	-- Trigger of music default is False
	local trigger_music = false
	
	while auto_is_running == true do
		local is_vaild_data = true
		local game_client
		local game_visual
		local game_player
		local player_client
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
			player_client = game_client:GetPlayer()
			if not nx_is_valid(player_client) then
				is_vaild_data = false
			end
			game_scence = game_client:GetScene()
			if not nx_is_valid(game_scence) then
				is_vaild_data = false
			end
		end
		local form = nx_value(THIS_FORM)
		if not nx_is_valid(form) then
			is_vaild_data = false
		end

		if is_vaild_data == true then
			local game_scence_objs = game_scence:GetSceneObjList()
		    local num_objs = table.getn(game_scence_objs)
			form.mltbox_content:Clear()
		    for i = 1, num_objs do
		        local obj_type = 0
		        if game_scence_objs[i]:FindProp("Type") then
		            obj_type = game_scence_objs[i]:QueryProp("Type")
		        end
		        if obj_type == 4 and not isempty(string.find(game_scence_objs[i]:QueryProp("ConfigID"), "Box_jzsj")) then
					local herb_ident = game_scence_objs[i]:QueryProp("Ident")
					local herb_tl = util_text(yBreaker_get_powerlevel(game_scence_objs[i]:QueryProp("PowerLevel")))
					local herb_posX = string.format("%.0f", game_scence_objs[i].PosiX)
					local herb_posZ = string.format("%.0f", game_scence_objs[i].PosiZ)

					local pathX = game_scence_objs[i].DestX
					local pathY = game_scence_objs[i].DestY
					local pathZ = game_scence_objs[i].DestZ
					form.mltbox_content:AddHtmlText(nx_value("gui").TextManager:GetFormatText(nx_string('<font color="#EE0606">{@0:name}</font>(<a href="findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}" style="HLStype1">{@1:x},{@2:z}</a>) - {@8:text}'), util_text(game_scence_objs[i]:QueryProp("ConfigID")), nx_widestr(herb_posX), nx_widestr(herb_posZ), nx_widestr(yBreaker_get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(herb_ident), nx_widestr(nx_function("ext_utf8_to_widestr","Lụm lúa!"))), -1)
					-- Turn on flag of effect
					trigger_music = true
		        end
		    end
			
			-- True is play music
			if trigger_music then
			-- 	local timer = nx_value(GAME_TIMER)
			-- 	if nx_is_valid(timer) then
			-- 		timer:UnRegister(nx_current(), "tools_resume_scene_music", nx_value("game_config"))
			-- 	end
			
			-- Flash game window
			nx_function("ext_flash_window")
			
			-- 	tools_play_sound()
				
			-- Turn off music
			trigger_music = false
			end
		end
		nx_pause(1)
	end
end
function isempty(s)
  return s == nil or s == ""
end

function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	change_form_size()
	form.is_minimize = false
	auto_is_running = false
	local map = yBreaker_get_current_map()
	form.lbl_2.Text = util_text(map)
	form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Bắt Đầu")
	-- Change Text color green of button
	--form.btn_control.ForeColor = "255,0,255,0"
end
function on_main_form_close(form)
	auto_is_running = false
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_btn_control_click(btn)
	local form = btn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	if auto_is_running then
		auto_is_running = false
		form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Bắt Đầu")
		form.mltbox_content:Clear()
		--form.btn_control.ForeColor = "255,0,255,0"
	else
		auto_is_running = true
		form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Kết Thúc")
		-- Change Text color red of button
		--form.btn_control.ForeColor = "255,255,0,0"
		auto_run()
	end
end
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = (gui.Width - form.Width) / 4
	--form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
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

function show_hide_search_herb()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_searchherb")
end
