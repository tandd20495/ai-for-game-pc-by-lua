require("const_define")
require("util_gui")
require("util_move") -- Xac dinh toa do distance3d
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_customscan"
local FORM_SETTING = "admin_yBreaker\\yBreaker_form_customscan_set"
local auto_is_running = false

function on_form_main_init(form_main)
	form_main.Fixed = false
	form_main.is_minimize = false
end

function on_form_setting_init(form_setting)
	form_setting.Fixed = false
	form_setting.player = false
	form_setting.guild = false
	form_setting.npc = false
	form_setting.checkbufplayer = false
end

function on_setting_open(form_setting)
end
function on_setting_close(form_setting)
end

function on_main_form_open(form_main)
	change_form_size()
	auto_is_running = false
end
function on_main_form_close(form_main)
	auto_is_running = false
	nx_destroy(form_main)
end
function on_btn_close_click(btn)
	local form_main = nx_value(THIS_FORM)
	if not nx_is_valid(form_main) then
		return
	end
	on_main_form_close(form_main)
end

function on_btn_control_click(btn)
	local form_main = btn.ParentForm
	if not nx_is_valid(form_main) then
		return
	end
	if auto_is_running then
		auto_is_running = false
		btn.Text = nx_function("ext_utf8_to_widestr", "Bắt đầu")
	else
		auto_is_running = true
		btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
		auto_run()
	end
end

function change_form_size()
	local form_main = nx_value(THIS_FORM)
	if not nx_is_valid(form_main) then
		return
	end
	--local gui = nx_value("gui")
	form_main.Left = 100
	--form.Top = (gui.Height - form.Height) / 2
	form_main.Top = 140
end

function get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end

function show_hide_form_custom()
	util_auto_show_hide_form(THIS_FORM)
end

function show_form_custom_set()
	util_auto_show_hide_form(FORM_SETTING)
end

function on_btncheck_player(cbtn)
	local form_setting = util_get_form(FORM_SETTING, true)
	form_setting.player = cbtn.Checked
end

function on_btncheck_guild(cbtn)
	local form_setting = util_get_form(FORM_SETTING, true)
	form_setting.guild = cbtn.Checked
end

function on_btncheck_npc(cbtn)
	local form_setting = util_get_form(FORM_SETTING, true)
	form_setting.npc = cbtn.Checked
end

function on_btncheck_checkbufplayer(cbtn)
	local form_setting = util_get_form(FORM_SETTING, true)
	form_setting.checkbufplayer = cbtn.Checked
end

function auto_run()
	local form_setting = util_get_form(FORM_SETTING, true)
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
		
		local form_main = nx_value(THIS_FORM)
		if not nx_is_valid(form_main) then
			is_vaild_data = false
		end
		if is_vaild_data == true then
			local game_scence_objs = game_scence:GetSceneObjList()
			local num_objs = table.getn(game_scence_objs)
			form_main.mltbox_content:Clear()
			for i = 1, num_objs do
				local obj_type = 0
				if game_scence_objs[i]:FindProp("Type") then
					obj_type = game_scence_objs[i]:QueryProp("Type")
				end
				-- Type == 2: người
				-- player
				if form_setting.player and nx_string(form_setting.Edit_box_1.Text) == "all" then
					if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") ~= 1 then
						local player_dan_name = game_scence_objs[i]:QueryProp("Name")
						local player_dan_ident = game_scence_objs[i].Ident
						local player_dan_bang = game_scence_objs[i]:QueryProp("GuildName")
						local player_target = game_visual:GetSceneObj(player_dan_ident)
						if nx_is_valid(player_target) then
							local display_player_posX = string.format("%.0f", player_target.PositionX)
							local display_player_posZ = string.format("%.0f", player_target.PositionZ)
							
							local pathX = player_target.PositionX
							local pathY = player_target.PositionY
							local pathZ = player_target.PositionZ

							form_main.mltbox_content:AddHtmlText(nx_value("gui").TextManager:GetFormatText(nx_string("<font color=\"#00a8ff\">{@0:name}</font> (<a href=\"findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}\" style=\"HLStype1\">{@1:x},{@2:z}</a>) <font color=\"#EA2027\">{@8:bang}</font>"), nx_widestr(player_dan_name), nx_widestr(display_player_posX), nx_widestr(display_player_posZ), nx_widestr(get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(player_dan_ident), player_dan_bang), -1)
						end
					end
				end
				if form_setting.player or form_setting.guild or form_setting.checkbufplayer then
					if obj_type == 2 and (nx_widestr(game_scence_objs[i]:QueryProp("Name")) == nx_widestr(form_setting.Edit_box_1.Text) or nx_widestr(game_scence_objs[i]:QueryProp("GuildName")) == nx_widestr(form_setting.Edit_box_2.Text) or nx_function("find_buffer", game_scence_objs[i], nx_string(form_setting.Edit_box_4.Text))) and game_scence_objs[i]:QueryProp("OffLineState") ~= 1 then
						local player_dan_name = game_scence_objs[i]:QueryProp("Name")
						local player_dan_ident = game_scence_objs[i].Ident
						local player_dan_bang = game_scence_objs[i]:QueryProp("GuildName")
						
						local player_target = game_visual:GetSceneObj(player_dan_ident)
						if nx_is_valid(player_target) then
							local display_player_posX = string.format("%.0f", player_target.PositionX)
							local display_player_posZ = string.format("%.0f", player_target.PositionZ)
							
							local pathX = player_target.PositionX
							local pathY = player_target.PositionY
							local pathZ = player_target.PositionZ

							if form_setting.player and nx_widestr(game_scence_objs[i]:QueryProp("Name")) == nx_widestr(form_setting.Edit_box_1.Text) then
								form_main.mltbox_content:AddHtmlText(nx_value("gui").TextManager:GetFormatText(nx_string("<font color=\"#00a8ff\">{@0:name}</font> (<a href=\"findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}\" style=\"HLStype1\">{@1:x},{@2:z}</a>) <font color=\"#EA2027\">{@8:bang}</font>"), nx_widestr(player_dan_name), nx_widestr(display_player_posX), nx_widestr(display_player_posZ), nx_widestr(get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(player_dan_ident), player_dan_bang), -1)
							elseif form_setting.checkbufplayer and nx_function("find_buffer", game_scence_objs[i], nx_string(form_setting.Edit_box_4.Text)) then
								form_main.mltbox_content:AddHtmlText(nx_value("gui").TextManager:GetFormatText(nx_string("<font color=\"#f6b93b\">{@0:name}</font> (<a href=\"findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}\" style=\"HLStype1\">{@1:x},{@2:z}</a>) <font color=\"#EA2027\">{@8:bang}</font>"), nx_widestr(player_dan_name), nx_widestr(display_player_posX), nx_widestr(display_player_posZ), nx_widestr(get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(player_dan_ident), player_dan_bang), -1)
							elseif form_setting.guild and nx_widestr(game_scence_objs[i]:QueryProp("GuildName")) == nx_widestr(form_setting.Edit_box_2.Text) then
								form_main.mltbox_content:AddHtmlText(nx_value("gui").TextManager:GetFormatText(nx_string("<font color=\"#4cd137\">{@0:name}</font> (<a href=\"findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}\" style=\"HLStype1\">{@1:x},{@2:z}</a>) <font color=\"#EA2027\">{@8:bang}</font>"), nx_widestr(player_dan_name), nx_widestr(display_player_posX), nx_widestr(display_player_posZ), nx_widestr(get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(player_dan_ident), player_dan_bang), -1)
							end
						end
					end
				end
				-- npc
				if form_setting.npc then
					if obj_type == 4 and string.find(nx_string(game_scence_objs[i]:QueryProp("ConfigID")), nx_string(form_setting.Edit_box_3.Text)) ~= nil then
						local npc_name = util_text(game_scence_objs[i]:QueryProp("ConfigID"))
						local npc_ident = game_scence_objs[i].Ident
						local map = nx_value("form_stage_main\\form_map\\form_map_scene").current_map

						local npc_target = game_visual:GetSceneObj(npc_ident)
						if nx_is_valid(npc_target) then
							local npc_posX = string.format("%.0f", npc_target.PositionX)
							local npc_posZ = string.format("%.0f", npc_target.PositionZ)
		
							local pathX = game_scence_objs[i].DestX
							local pathY = game_scence_objs[i].DestY
							local pathZ = game_scence_objs[i].DestZ
		
							form_main.mltbox_content:AddHtmlText(nx_value("gui").TextManager:GetFormatText(nx_string("<font color=\"#ff2bdf\">{@0:name}</font> (<a href=\"findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}\" style=\"HLStype1\">{@1:x},{@2:z}</a>)"), nx_widestr(npc_name), nx_widestr(npc_posX), nx_widestr(npc_posZ), nx_widestr(get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(npc_ident), map), -1)
						end
					end
				end
			end
		end
		nx_pause(1)
	end
end