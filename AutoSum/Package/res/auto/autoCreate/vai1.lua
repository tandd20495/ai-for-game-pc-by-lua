nx_execute("custom_sender", "custom_set_second_word", "123321", "123321")
nx_pause(0.5)
nx_execute("custom_sender", "check_second_word", nx_widestr("123321"))
nx_pause(1)
-- util_show_form("form_stage_main\\form_bag", true)
		-- nx_pause(0.5)
		-- local form = util_get_form("form_stage_main\\form_bag", true)
		-- nx_pause(0.5)
		-- form.rbtn_tool.Checked = true
		-- nx_pause(0.5)
		-- nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		-- nx_pause(0.5)
-- nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "box_wnhd_dllb01")
		-- nx_pause(5)
		-- nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "bind_money_5")
		-- nx_pause(5)
auto_is_running_delmail = true
    while auto_is_running_delmail == true do
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

        
        if is_vaild_data == true then
            nx_execute("form_stage_main\\form_mail\\form_mail", "open_form", 1)
            local form = nx_value("form_stage_main\\form_mail\\form_mail")
            if not nx_is_valid(form) then
                return false
            end
            nx_execute("form_stage_main\\form_mail\\form_mail", "system_on_click", form.system)
            local form = nx_value("form_stage_main\\form_mail\\form_mail_accept")
            if not nx_is_valid(form) then
                return false
            end
            local sysnum = nx_execute("form_stage_main\\form_mail\\form_mail_accept", "get_system_num")
            if sysnum > 0 then
                form.select_all.Checked = true
                nx_execute("form_stage_main\\form_mail\\form_mail_accept", "on_select_all_click", form.select_all)
                nx_execute("custom_sender", "custom_del_letter", 0, form.mail_type)
                nx_pause(0.5)
                local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_confirm", false, false)
                if nx_is_valid(dialog) then
                    nx_execute("form_common\\form_confirm", "ok_btn_click", dialog.ok_btn)
                end
			else
				auto_is_running_delmail = false
            end
        end

        nx_pause(0.5)
    end


function send_homepoint_msg_to_server(...)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return
    end
    game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SET_HOMEPOINT), unpack(arg))
end
local HOMEPOINT_INI_FILE = "share\\Rule\\HomePoint.ini"
function get_type_homepoint(type_name)
    local ini = nx_execute("util_functions", "get_ini", HOMEPOINT_INI_FILE)
    if not nx_is_valid(ini) then
        return "", ""
    end
    local index = ini:FindSectionIndex(nx_string(type_name))
    if index < 0 then
        return "", ""
    end
    local hp = ini:ReadString(index, "Type", "")
    local htext = ini:ReadString(index, "Name", "")
    return hp, htext
end

local game_client = nx_value("game_client")
local client_player = game_client:GetPlayer()
send_homepoint_msg_to_server(5)
local Max1 = client_player:QueryProp("JiangHuHomePointCount")
            if Max1 < 2 then
                tools_show_notice(nx_function("ext_utf8_to_widestr", "Hãy mở tối thiểu hai điểm dừng chân giang hồ mới có thể sử dụng chức năng này"), 2)
                IsBusy = false
                return false
            end
            local Max2 = client_player:QueryProp("SchoolHomePointCount")
            local Max = Max1 + Max2
            -- Xác định điểm dừng chân giang hồ cuối cùng
            local LastHomePoint = ""
            local LastHomePointText = nx_widestr("")
            local CountJiangHuHomePoint = 0
            for i = 0, Max do
                local _hp = client_player:QueryRecord("HomePointList", i, 0)
                if _hp == 0 then
                    break
                end
                local typename, htext = get_type_homepoint(_hp)
                if typename == "0" or typename == "1" then
                    LastHomePoint = _hp
                    LastHomePointText = util_text(nx_string(htext))
                    CountJiangHuHomePoint = CountJiangHuHomePoint + 1
                end
            end
            -- Xóa cái điểm dừng chân cuối cùng đi
            if CountJiangHuHomePoint > 1 and LastHomePoint ~= "" then
                tools_show_notice(nx_function("ext_utf8_to_widestr", "Xóa điểm dừng chân: ") .. LastHomePointText)
                send_homepoint_msg_to_server(3, LastHomePoint) -- 3: Xóa điểm dừng chân
                nx_pause(0.5)
            end
				nx_execute("form_stage_main\\form_homepoint\\home_point_data", "send_homepoint_msg_to_server", 2, "HomePointcity02E", 0)
	nx_execute("form_stage_main\\form_homepoint\\home_point_data", "send_homepoint_msg_to_server", 1, "HomePointcity02E", 0)
	
	nx_pause(12)
return 1
