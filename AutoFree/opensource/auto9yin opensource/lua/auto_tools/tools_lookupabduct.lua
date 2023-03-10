require("const_define")
require("util_gui")
require("util_move") -- Xac dinh toa do distance3d
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("auto_tools\\tool_libs")

local THIS_FORM = "auto_tools\\tools_lookupabduct"
local auto_is_running = false

function auto_run()
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
		        if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 1 and not game_scence_objs[i]:FindProp("OfflineTypeTvT") then
					local coc_name = game_scence_objs[i]:QueryProp("Name")
					local coc_ident = game_scence_objs[i]:QueryProp("Ident")
					local coc_posX = string.format("%.0f", game_scence_objs[i].PosiX)
					local coc_posZ = string.format("%.0f", game_scence_objs[i].PosiZ)

					local pathX = game_scence_objs[i].DestX
					local pathY = game_scence_objs[i].DestY
					local pathZ = game_scence_objs[i].DestZ

					if game_scence_objs[i]:QueryProp("IsAbducted") == 1 then
						for j = 1, 20 do
			                if game_scence_objs[i]:FindProp(nx_string("BufferInfo") .. nx_string(j)) and nx_string(util_split_string(game_scence_objs[i]:QueryProp(nx_string("BufferInfo") .. nx_string(j)), ",")[1]) == "buf_abducted" then
			                    local MessageDelay = nx_value("MessageDelay")
			                    if not nx_is_valid(MessageDelay) then
			                      return 0
			                    end
			                    local buff_info = util_split_string(game_scence_objs[i]:QueryProp(nx_string("BufferInfo") .. nx_string(j)), ",")
			                    local buff_time = buff_info[4]

								local server_now_time = MessageDelay:GetServerNowTime()
								local buff_diff_time = nx_int((buff_time - server_now_time) / 1000) -- Unit timesamp
								local buff_remain_h = nx_int(buff_diff_time / 3600) -- Giờ
								local buff_remain_m = nx_int((buff_diff_time - (buff_remain_h * 3600)) / 60) -- Phút
								local buff_remain_s = nx_int(buff_diff_time - (buff_remain_h * 3600) - (buff_remain_m * 60)) -- Giây

								form.mltbox_content:AddHtmlText(nx_value("gui").TextManager:GetFormatText(nx_string("tool_auto_lookupabduct_info"), nx_widestr(coc_name), nx_widestr(coc_posX), nx_widestr(coc_posZ), nx_widestr(get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(coc_ident), buff_remain_h, buff_remain_m, buff_remain_s), -1)
								break
			                end
			            end
					else
						form.mltbox_content:AddHtmlText(nx_value("gui").TextManager:GetFormatText(nx_string("tool_auto_lookupabduct_info1"), nx_widestr(coc_name), nx_widestr(coc_posX), nx_widestr(coc_posZ), nx_widestr(get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(coc_ident)), -1)
					end
		        end
		    end
		end
		nx_pause(1)
	end
end

function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	change_form_size()
	form.is_minimize = false
	auto_is_running = false
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
		btn.Text = util_text("tool_start")
	else
		auto_is_running = true
		btn.Text = util_text("tool_stop")
		auto_run()
	end
end
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = (gui.Width - form.Width) / 2
	--form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
end
function get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end
function tools_show_form()
util_auto_show_hide_form("auto_tools\\tools_lookupabduct")
end
