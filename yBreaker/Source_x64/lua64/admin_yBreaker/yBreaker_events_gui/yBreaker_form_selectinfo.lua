require("util_gui")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_selectinfo"

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	form.lbl_title.Text = ""
	scan_info_player()

end

function on_main_form_close(form)
    nx_destroy(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    form.Left = 640
    form.Top = 0
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	is_scan_info_player = false
	on_main_form_close(form)
end

function show_hide_form_selectinfo()
	util_auto_show_hide_form(THIS_FORM)
end

function getRage()
    local player = nx_value("game_client"):GetPlayer()
    if not nx_is_valid(player) then
        return 0
    end
    local sp = player:QueryProp("SP")
    return tonumber(sp)
end

function scan_info_player()
	is_scan_info_player = true
    while is_scan_info_player == true do
        local is_vaild_data = true
        local game_client
        local game_visual
        local game_player
        local player_client
        local game_scence

        game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            is_vaild_data = false
			return
        end
        game_visual = nx_value("game_visual")
        if not nx_is_valid(game_visual) then
            is_vaild_data = false
			return
        end
        if is_vaild_data == true then
            game_player = game_visual:GetPlayer()
            if not nx_is_valid(game_player) then
                is_vaild_data = false
				return
            end
            player_client = game_client:GetPlayer()
            if not nx_is_valid(player_client) then
                is_vaild_data = false
				return
            end
            game_scence = game_client:GetScene()
            if not nx_is_valid(game_scence) then
                is_vaild_data = false
				return
            end
        end
        local form = nx_value(THIS_FORM)
        if not nx_is_valid(form) then
            is_vaild_data = false
			return
        end
		
        if is_vaild_data == true then   
			local game_scence_objs = game_scence:GetSceneObjList()
			local num_objs = table.getn(game_scence_objs)
            for i = 1, num_objs do
                local obj_type = 0
                if game_scence_objs[i]:FindProp("Type") then
                    obj_type = game_scence_objs[i]:QueryProp("Type")
                end
                if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then
					-- Get infor player is selected
					local name_player = game_scence_objs[i]:QueryProp("Name")
					local hp_player = game_scence_objs[i]:QueryProp("HPRatio")
					local mp_player = game_scence_objs[i]:QueryProp("MPRatio")
					local sp_player = game_scence_objs[i]:QueryProp("SP")
					local keypt_player = game_scence_objs[i]:QueryProp("TeamCaptain")
					local cntpt_player = game_scence_objs[i]:QueryProp("TeamMemberCount")
					-- Người đang target
                    if nx_string(player_client:QueryProp("LastObject")) == nx_string(game_scence_objs[i].Ident) then
                        
						--Lấy khoảng cách từ nhân vật tới mục tiêu đang chọn
						local visualObj = game_visual:GetSceneObj(game_scence_objs[i].Ident)
						local dist_player = getDistanceWithObj({game_player.PositionX, game_player.PositionY, game_player.PositionZ}, visualObj)
						
						-- Lấy nộ bản thân
						local sp_self = getRage()
						
						-- Set giá trị cho Name
						form.lbl_title.Text = nx_widestr(name_player)
						
						-- Set giá trị cho HP
						form.t_hp_txt.Text = nx_widestr(hp_player)
						
						-- Set giá trị cho MP
						form.t_mp_txt.Text = nx_widestr(mp_player)

						-- Set giá trị khoảng cách
						form.t_dis_txt.Text = nx_widestr(nx_int(dist_player))

						-- Set giá trị Nộ
						form.t_sp_txt.Text = nx_widestr(sp_player)

						-- Tên người chơi cầm Key PT
						form.t_team_txt.Text = nx_widestr(keypt_player)

						-- Số thành viên của PT
						form.t_team_num_txt.Text = nx_widestr(cntpt_player)
						
						-- Nộ của bản thân
						form.t_sp_self_txt.Text = nx_widestr(sp_self)

                    end
                end
            end
			nx_pause(1)
		end
    end

end