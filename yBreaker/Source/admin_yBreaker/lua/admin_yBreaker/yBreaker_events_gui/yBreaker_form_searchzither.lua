require("const_define")
require("util_gui")
require("util_move") -- Detected here position distance 3D
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_searchzither"
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
		        if obj_type == 2 and game_scence_objs[i]:FindProp("GameState") and  game_scence_objs[i]:QueryProp("GameState") == "QinGameModule" then
					local zither_name = game_scence_objs[i]:QueryProp("Name") -- Lấy tên của mục tiêu
					local zither_ident = game_scence_objs[i]:QueryProp("Ident") -- Tọa độ
					local zither_bang = game_scence_objs[i]:QueryProp("GuildName") -- Lấy tên Bang của mục tiêu
					local zither_keypt = game_scence_objs[i]:QueryProp("TeamCaptain") -- Lấy tên đội trưởng của mục tiêu
					--local zither_tl = util_text(yBreaker_get_powerlevel(game_scence_objs[i]:QueryProp("PowerLevel"))) -- Tạm thời tìm đàn k cần show thực lực của đàn
					local zither_posX = string.format("%.0f", game_scence_objs[i].PosiX)
					local zither_posZ = string.format("%.0f", game_scence_objs[i].PosiZ)

					local pathX = game_scence_objs[i].DestX
					local pathY = game_scence_objs[i].DestY
					local pathZ = game_scence_objs[i].DestZ
					form.mltbox_content:AddHtmlText(nx_value("gui").TextManager:GetFormatText(nx_string('<font color="#EE0606">{@0:name}</font>(<a href="findpath,{@3:scene},{@4:x},{@5:y},{@6:z},{@7:ident}" style="HLStype1">{@1:x},{@2:z}</a>)<font color="#17FC0B">{@8:guildname}</font> - Key PT: <font color="#17FC0B">{@9:name}</font>'), nx_widestr(zither_name), nx_widestr(zither_posX), nx_widestr(zither_posZ), nx_widestr(yBreaker_get_current_map()), nx_widestr(pathX), nx_widestr(pathY), nx_widestr(pathZ), nx_widestr(zither_ident), nx_widestr(zither_bang), nx_widestr(zither_keypt)), -1)
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
	local map = yBreaker_get_current_map()
	form.lbl_2.Text = util_text(map)
	form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Bắt Đầu")
--	form.btn_control.ForeColor = "255,0,255,0"
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
	form.Left = 100
	form.Top = 140
end

function show_hide_search_zither()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_searchzither")
end
