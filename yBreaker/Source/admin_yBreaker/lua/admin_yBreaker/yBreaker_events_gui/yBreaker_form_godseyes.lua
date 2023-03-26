require("const_define")
require("define\\sysinfo_define")
require("define\\request_type")
require("define\\object_type_define")
require("util_gui")
require("util_move")
require("util_static_data")
require("util_functions")
require("share\\server_custom_define")
require("share\\chat_define")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")
require("share\\client_custom_define")
require("share\\view_define")
require("form_stage_main\\form_tvt\\define")
require("form_stage_main\\form_task\\task_define")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_godseyes"
local WINEXEC_PATH = "autodata\\tools.exe"

local auto_is_running = false -- Quét cóc
local auto_is_running_rsabduct = false -- Quét, thổi cóc
local auto_is_running_player = false -- Quét người chơi

local isAdmRights = true


----------------------------------------------------
-- Phát hiện cóc RS, chat cóc, thổi cóc
-- Quét luôn người chơi đang ôm cóc
function auto_run_rsabduct()
    local max_distance_selectauto = 6
    local last_table_coc = {}
    local sound_before = nil -- Am thanh truoc
    local volume_before = nil -- Am luong truoc
    local used_abduct_item = false

    -- Xac dinh cau hinh am thanh ban dau
    if sound_before == nil then
        local game_config = nx_value("game_config")
        sound_before = game_config.music_enable
        volume_before = game_config.music_volume
    end

    while auto_is_running_rsabduct == true do
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
        local form = nx_value(THIS_FORM)
        if not nx_is_valid(form) then
            is_vaild_data = false
        end

        -- Nếu dữ liệu ok hết
        if is_vaild_data == true then
            local game_scence_objs = game_scence:GetSceneObjList()
            local select_object = 0
            local trigger_music = false
            local current_table_coc = {}
            form.mltbox_content:Clear()

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
                elseif obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 1 and not game_scence_objs[i]:FindProp("OfflineTypeTvT") then
                    local coc_name = game_scence_objs[i]:QueryProp("Name")
                    local coc_ident = game_scence_objs[i]:QueryProp("Ident")
                    local coc_posX = string.format("%.0f", game_scence_objs[i].PosiX)
                    local coc_posZ = string.format("%.0f", game_scence_objs[i].PosiZ)

                    local pathX = game_scence_objs[i].DestX
                    local pathY = game_scence_objs[i].DestY
                    local pathZ = game_scence_objs[i].DestZ

                    if game_scence_objs[i]:QueryProp("IsAbducted") == 0 then
                        if tonumber(distance) <= max_distance_selectauto then
                            select_object = i
                        end

                        table.insert(current_table_coc, coc_name)

                        if not in_array(coc_name, last_table_coc) then
                            trigger_music = true
                            -- Chat hệ thống thông số cóc
                            local text = nx_function("ext_utf8_to_widestr", "Tên:")
                            text = text .. nx_widestr(coc_name)
                            text = text .. nx_function("ext_utf8_to_widestr", " - Tọa độ:<a href=\"findpath,")
                            text = text .. nx_widestr(get_current_map())
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(pathX)
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(pathY)
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(pathZ)
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(coc_ident)
                            text = text .. nx_widestr("\" style=\"HLStype1\">")
                            text = text .. nx_widestr(coc_posX)
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(coc_posZ)
                            text = text .. nx_widestr("</a>")
                            nx_value("form_main_chat"):AddChatInfoEx(text, CHATTYPE_SYSTEM, false)
                        end
                    end

                    -- Ghi lên hệ thống
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

                                local text = nx_widestr(coc_name)
                                text = text .. nx_widestr(" (<a href=\"findpath,")
                                text = text .. nx_widestr(get_current_map())
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(pathX)
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(pathY)
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(pathZ)
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(coc_ident)
                                text = text .. nx_widestr("\" style=\"HLStype1\">")
                                text = text .. nx_widestr(coc_posX)
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(coc_posZ)
                                text = text .. nx_widestr("</a>) ")
                                text = text .. nx_widestr(buff_remain_h)
                                text = text .. nx_widestr(":")
                                text = text .. nx_widestr(buff_remain_m)
                                text = text .. nx_widestr(":")
                                text = text .. nx_widestr(buff_remain_s)
                                form.mltbox_content:AddHtmlText(text, -1)
                                break
                            end
                        end
                    else
                        local text = nx_widestr("<font color=\"#B71D41\">")
                        text = text .. nx_widestr(coc_name)
                        text = text .. nx_widestr("</font> (<a href=\"findpath,")
                        text = text .. nx_widestr(get_current_map())
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(pathX)
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(pathY)
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(pathZ)
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(coc_ident)
                        text = text .. nx_widestr("\" style=\"HLStype1\">")
                        text = text .. nx_widestr(coc_posX)
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(coc_posZ)
                        text = text .. nx_widestr("</a>)")
                        form.mltbox_content:AddHtmlText(text, -1)
                    end
                end

                -- Quét, chat người ôm cóc, không tính cho mình
                local obj = game_scence_objs[i]
                if obj_type == 2 and nx_is_valid(obj) and getPlayerPropWideStr("Name") ~= nx_widestr(obj:QueryProp("Name")) then
                    local buff_abductor = get_buff_info("buf_abductor", obj)
                    if buff_abductor ~= nil then
                        local coc_name = obj:QueryProp("Name")
                        local coc_ident = obj:QueryProp("Ident")
                        local coc_posX = string.format("%.0f", obj.PosiX)
                        local coc_posZ = string.format("%.0f", obj.PosiZ)

                        local pathX = obj.DestX
                        local pathY = obj.DestY
                        local pathZ = obj.DestZ

                        table.insert(current_table_coc, coc_name)

                        if not in_array(coc_name, last_table_coc) then
                            trigger_music = true
                            -- Chat hệ thống người ôm cóc
                            local text = nx_function("ext_utf8_to_widestr", "Ôm cóc: <font color=\"#FF00B2\">")
                            text = text .. nx_widestr(coc_name)
                            text = text .. nx_function("ext_utf8_to_widestr", "</font> - Tọa độ:<a href=\"findpath,")
                            text = text .. nx_widestr(get_current_map())
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(pathX)
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(pathY)
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(pathZ)
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(coc_ident)
                            text = text .. nx_widestr("\" style=\"HLStype1\">")
                            text = text .. nx_widestr(coc_posX)
                            text = text .. nx_widestr(",")
                            text = text .. nx_widestr(coc_posZ)
                            text = text .. nx_widestr("</a>")
                            nx_value("form_main_chat"):AddChatInfoEx(text, CHATTYPE_SYSTEM, false)
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
end

-----------------------------------------
-- Quét cóc
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

                                local text = nx_widestr(coc_name)
                                text = text .. nx_widestr(" (<a href=\"findpath,")
                                text = text .. nx_widestr(get_current_map())
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(pathX)
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(pathY)
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(pathZ)
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(coc_ident)
                                text = text .. nx_widestr("\" style=\"HLStype1\">")
                                text = text .. nx_widestr(coc_posX)
                                text = text .. nx_widestr(",")
                                text = text .. nx_widestr(coc_posZ)
                                text = text .. nx_widestr("</a>) ")
                                text = text .. nx_widestr(buff_remain_h)
                                text = text .. nx_widestr(":")
                                text = text .. nx_widestr(buff_remain_m)
                                text = text .. nx_widestr(":")
                                text = text .. nx_widestr(buff_remain_s)
                                form.mltbox_content:AddHtmlText(text, -1)
                                break
                            end
                        end
                    else
                        local text = nx_widestr("<font color=\"#B71D41\">")
                        text = text .. nx_widestr(coc_name)
                        text = text .. nx_widestr("</font> (<a href=\"findpath,")
                        text = text .. nx_widestr(get_current_map())
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(pathX)
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(pathY)
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(pathZ)
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(coc_ident)
                        text = text .. nx_widestr("\" style=\"HLStype1\">")
                        text = text .. nx_widestr(coc_posX)
                        text = text .. nx_widestr(",")
                        text = text .. nx_widestr(coc_posZ)
                        text = text .. nx_widestr("</a>)")
                        form.mltbox_content:AddHtmlText(text, -1)
                    end
                end
            end
        end
        nx_pause(1)
    end
end

function auto_run_buff()
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
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        is_vaild_data = false
    end

    if is_vaild_data == true then
        form.mltbox_content:Clear()
        -- Xóa cái group nếu tồn tại
        local custom_groupbox = form:Find("groupbox_buff")
        if nx_is_valid(custom_groupbox) then
            form:Remove(custom_groupbox)
        end
        local groupbox_compose = gui:Create("GroupBox")

        form:Add(groupbox_compose)

        groupbox_compose.Name = "groupbox_buff"
        groupbox_compose.BackColor = "0,0,0,0"
        groupbox_compose.DrawMode = "ExpandV"
        groupbox_compose.Left = 230
        groupbox_compose.Top = 40
        groupbox_compose.Width = 320
        groupbox_compose.Height = 360
        groupbox_compose.curindex = nil
        groupbox_compose.selected = nil
        groupbox_compose.BackImage = "gui\\common\\form_line\\mibox_1.png"

        local groupbox_buff_list = gui:Create("GroupScrollableBox")

        groupbox_compose:Add(groupbox_buff_list)

        groupbox_buff_list.Name = "groupbox_buff_list"
        groupbox_buff_list.BackColor = "0,0,0,0"
        groupbox_buff_list.DrawMode = "FitWindow"
        groupbox_buff_list.NoFrame = true
        groupbox_buff_list.Left = 0
        groupbox_buff_list.Top = 0
        groupbox_buff_list.Width = 320
        groupbox_buff_list.Height = 360
        groupbox_buff_list:DeleteAll()

        local group_top = 0

        local select_target_ident = player_client:QueryProp("LastObject")
        local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
        if not nx_is_valid(select_target) then
            select_target = player_client
        end
        if nx_is_valid(select_target) then
            for j = 1, 25 do
                local buff = select_target:QueryProp("BufferInfo" .. tostring(j))
                if buff ~= 0 then
                    local buff_info = util_split_string(buff, ",")
                    local buff_name = nx_string(buff_info[1])
                    if buff_name ~= nil and buff_name ~= nx_string("") and buff_name ~= nx_string("nil") then
                        local photo_path = buff_static_query(buff_name, "Photo")

                        local groupbox = gui:Create("GroupBox")
                        groupbox_buff_list:Add(groupbox)
                        groupbox.AutoSize = false
                        groupbox.Name = "groupbox_buff_item_" .. j
                        groupbox.BackColor = "0,0,0,0"
                        groupbox.DrawMode = "FitWindow"
                        groupbox.BackImage = "gui\\common\\form_back\\bg_menu.png"
                        groupbox.NoFrame = true
                        groupbox.Left = 0
                        groupbox.Top = group_top
                        groupbox.Width = 305
                        groupbox.Height = 55
                        groupbox.index = j

                        local imagegrid = gui:Create("ImageControlGrid")
                        groupbox:Add(imagegrid)
                        imagegrid.AutoSize = false
                        imagegrid.Name = "groupbox_buff_item_" .. j .. "_photo"
                        imagegrid.DrawGridBack = "gui\\common\\imagegrid\\icon_item2.png"
                        imagegrid.DrawMode = "Expand"
                        imagegrid.NoFrame = true
                        imagegrid.HasVScroll = false
                        imagegrid.Width = 39
                        imagegrid.Height = 39
                        imagegrid.Left = 15
                        imagegrid.Top = 10
                        imagegrid.RowNum = 1
                        imagegrid.ClomnNum = 1
                        imagegrid.GridWidth = 36
                        imagegrid.GridHeight = 36
                        imagegrid.RoundGrid = false
                        imagegrid.GridBackOffsetX = -4
                        imagegrid.GridBackOffsetY = -3
                        imagegrid.DrawMouseIn = "xuanzekuang"
                        imagegrid.BackColor = "0,0,0,0"
                        imagegrid.SelectColor = "0,0,0,0"
                        imagegrid.MouseInColor = "0,0,0,0"
                        imagegrid.CoverColor = "0,0,0,0"
                        nx_bind_script(imagegrid, nx_current())
                        nx_callback(imagegrid, "on_mousein_grid", "on_buff_imagegrid_mousein_grid")
                        nx_callback(imagegrid, "on_mouseout_grid", "on_buff_imagegrid_mouseout_grid")
                        imagegrid.HasMultiTextBox = true
                        imagegrid.MultiTextBoxCount = 2
                        imagegrid.MultiTextBox1.NoFrame = true
                        imagegrid.MultiTextBox1.Width = 200
                        imagegrid.MultiTextBox1.Height = 58
                        imagegrid.MultiTextBox1.LineHeight = 20
                        imagegrid.MultiTextBox1.ViewRect = "0,0,200,58"
                        imagegrid.MultiTextBox1.TextColor = "255,255,255,255"
                        imagegrid.Font = "FZHKJT20"
                        imagegrid.MultiTextBoxPos = "60,-4"
                        imagegrid.ViewRect = "0,0,67,67"
                        imagegrid:AddItem(0, photo_path, "", 1, -1)
                        imagegrid:SetItemAddInfo(nx_int(0), nx_int(1), nx_widestr(buff_name))

                        -- Hiển thị buff name
                        local buff_name_text = util_text(buff_name)
                        if buff_name_text == nx_widestr("") or buff_name_text == nx_widestr("<s>") or buff_name_text == nx_widestr(buff_name) then
                            buff_name_text = nx_function("ext_utf8_to_widestr", "Buff chưa có tên")
                        end
                        local lbl_buff_name = gui:Create("Label")
                        groupbox:Add(lbl_buff_name)
                        lbl_buff_name.Left = 60
                        lbl_buff_name.Top = 10
                        if nx_is_valid(lbl_buff_name) then
                            local show_name = nx_widestr(buff_name_text)
                            if nx_ws_length(show_name) > 40 then
                                lbl_buff_name.HintText = nx_widestr(buff_name_text)
                                lbl_buff_name.Transparent = false
                                lbl_buff_name.ClickEvent = false
                                show_name = nx_function("ext_ws_substr", show_name, 0, 40) .. nx_widestr("...")
                            else
                                lbl_buff_name.HintText = nx_widestr("")
                            end
                            lbl_buff_name.Text = show_name
                        end
                        lbl_buff_name.ForeColor = "255,255,195,0"
                        lbl_buff_name.Font = "font_treeview"
                        lbl_buff_name.ShadowColor = "0,255,255,255"

                        -- Hiển thị thời gian buff
                        local MessageDelay = nx_value("MessageDelay")
                        if not nx_is_valid(MessageDelay) then
                            return 0
                        end
                        local buff_time = buff_info[4]
                        local server_now_time = MessageDelay:GetServerNowTime()
                        local buff_diff_time = nx_int((buff_time - server_now_time) / 1000) -- Unit timesamp
                        local buff_remain_h = nx_int(buff_diff_time / 3600) -- Giờ
                        local buff_remain_m = nx_int((buff_diff_time - (buff_remain_h * 3600)) / 60) -- Phút
                        local buff_remain_s = nx_int(buff_diff_time - (buff_remain_h * 3600) - (buff_remain_m * 60)) -- Giây

                        local buff_time_text = nx_function("ext_utf8_to_widestr", "Còn lại: ")

                        if tonumber(buff_time) > 0 then
                            buff_time_text = buff_time_text .. nx_widestr(nx_string(buff_remain_h)) .. nx_widestr(":")
                            buff_time_text = buff_time_text .. nx_widestr(nx_string(buff_remain_m)) .. nx_widestr(":")
                            buff_time_text = buff_time_text .. nx_widestr(nx_string(buff_remain_s))
                        else
                            buff_time_text = buff_time_text .. nx_function("ext_utf8_to_widestr", "Không")
                        end

                        local lbl_buff_time = gui:Create("Label")
                        groupbox:Add(lbl_buff_time)
                        lbl_buff_time.Left = 60
                        lbl_buff_time.Top = 30
                        lbl_buff_time.Text = buff_time_text
                        lbl_buff_time.ForeColor = "255,255,240,191"
                        lbl_buff_time.Font = "font_treeview"
                        lbl_buff_time.ShadowColor = "0,255,255,255"

                        -- Hiển thị xếp chồng buff
                        local buff_count = buff_info[5]
                        local buff_count_info = util_split_string(buff_count, "|")
                        local buff_count_text = nx_function("ext_utf8_to_widestr", "Xếp chồng: ")

                        if buff_count_info ~= nil then
                            buff_count_info = buff_count_info[1]
                            if buff_count_info ~= nil and tonumber(buff_count_info) > 0 then
                                buff_count_text = buff_count_text .. nx_widestr(tostring(buff_count_info))
                            else
                                buff_count_text = buff_count_text .. nx_function("ext_utf8_to_widestr", "Không")
                            end
                        end

                        local lbl_buff_count = gui:Create("Label")
                        groupbox:Add(lbl_buff_count)
                        lbl_buff_count.Left = 160
                        lbl_buff_count.Top = 30
                        lbl_buff_count.Text = buff_count_text
                        lbl_buff_count.ForeColor = "255,255,240,191"
                        lbl_buff_count.Font = "font_treeview"
                        lbl_buff_count.ShadowColor = "0,255,255,255"

                        group_top = group_top + 55
                    end
                end
            end
        else
            tools_show_notice(nx_function("ext_utf8_to_widestr", "Hãy nhấp chọn đối tượng cần soi buff trước"))
        end

        groupbox_buff_list.IsEditMode = false
        groupbox_buff_list.HasVScroll = true
        groupbox_buff_list.ScrollSize = 15
        groupbox_buff_list.AlwaysVScroll = true
        groupbox_buff_list.VScrollBar.Value = 0--groupbox_buff_list.VScrollBar.Maximum
        groupbox_buff_list.VScrollBar.BackImage = "gui\\common\\scrollbar\\bg_scrollbar2.png"
        groupbox_buff_list.VScrollBar.DrawMode = "Expand"
        groupbox_buff_list.VScrollBar.DecButton.NormalImage = "gui\\common\\scrollbar\\button_2\\btn_up_out.png"
        groupbox_buff_list.VScrollBar.DecButton.FocusImage = "gui\\common\\scrollbar\\button_2\\btn_up_on.png"
        groupbox_buff_list.VScrollBar.DecButton.PushImage = "gui\\common\\scrollbar\\button_2\\btn_up_down.png"
        groupbox_buff_list.VScrollBar.IncButton.NormalImage = "gui\\common\\scrollbar\\button_2\\btn_down_out.png"
        groupbox_buff_list.VScrollBar.IncButton.FocusImage = "gui\\common\\scrollbar\\button_2\\btn_down_on.png"
        groupbox_buff_list.VScrollBar.IncButton.PushImage = "gui\\common\\scrollbar\\button_2\\btn_down_down.png"
        groupbox_buff_list.VScrollBar.TrackButton.NormalImage = "gui\\common\\scrollbar\\button_2\\btn_trace_out.png"
        groupbox_buff_list.VScrollBar.TrackButton.FocusImage = "gui\\common\\scrollbar\\button_2\\btn_trace_on.png"
        groupbox_buff_list.VScrollBar.TrackButton.PushImage = "gui\\common\\scrollbar\\button_2\\btn_trace_on.png"
        groupbox_buff_list.VScrollBar.TrackButton.DrawMode = "ExpandV"
        groupbox_buff_list.VScrollBar.TrackButton.Width = 15
    end
end

-- Quét người chơi
function auto_run_player()
    while auto_is_running_player == true do
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
                if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then
                    local coc_name = game_scence_objs[i]:QueryProp("Name")
                    local color = "FDFFA0"
                    if player_client:QueryProp("Name") == coc_name then
                        -- Chính mình
                        color = "09C600"
                    elseif nx_string(player_client:QueryProp("LastObject")) == nx_string(game_scence_objs[i].Ident) then
                        -- Mục tiêu
                        color = "C60000"
                    end
                    local text = nx_widestr("<font color=\"#" .. color .. "\">")
                    text = text .. nx_widestr(coc_name)
                    text = text .. nx_widestr("</font>")
                    form.mltbox_content:AddHtmlText(text, -1)
                end
            end
        end
        nx_pause(1)
    end
end

-- Auto giải cứu cóc
function auto_run_offfree()
    local total_coc_free = 0
    local total_money_used = nx_int64(0)
    local array_coc_fred = {}

    while auto_is_running_offfree == true do
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
            for i = 1, table.getn(game_scence_objs) do
                local obj = game_scence_objs[i]
                local coc_name = obj:QueryProp("Name")
                local coc_ident = obj.Ident
                if not in_array(coc_name, array_coc_fred) then
                    -- Xác định Visual mới chính xác tọa độ
                    local visualobj = game_visual:GetSceneObj(nx_string(coc_ident))
                    if nx_is_valid(visualobj) then
                        local distance = nx_float(string.format("%.0f", distance3d(game_player.PositionX, game_player.PositionY, game_player.PositionZ, visualobj.PositionX, visualobj.PositionY, visualobj.PositionZ)))

                        if distance < nx_float(6) and obj:QueryProp("Type") == 2 and obj:QueryProp("OffLineState") == 1 and not obj:FindProp("OfflineTypeTvT") and obj:QueryProp("IsAbducted") == 1 then
                            local money = nx_execute("form_stage_main\\form_offline\\offline_util", "get_setfree_money_by_level", obj)
                            if nx_int64(money) < nx_int64(500) then
                                -- Nhấp chọn con cóc
                                nx_execute("custom_sender", "custom_select", coc_ident)
                                nx_pause(0.1)

                                -- Đợi một lát sau đó kiểm tra từ server last obj
                                local select_target_ident = player_client:QueryProp("LastObject")
                                local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
                                if nx_is_valid(select_target) and nx_string(coc_ident) == nx_string(select_target_ident) then
                                    table.insert(array_coc_fred, coc_name)
                                    total_coc_free = total_coc_free + 1
                                    total_money_used = total_money_used + nx_int64(money)
                                    nx_execute("custom_sender", "custom_offline_setfree", nx_int(1))
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
        -- Xuất thông báo
        form.mltbox_content:Clear()
        form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", "Đi khắp các nơi, tìm cóc, tiến lại gần nó để tự giải cứu"), -1)
        local text_money = nx_execute("util_functions", "trans_capital_string", total_money_used)
        local text1 = nx_function("ext_utf8_to_widestr", "Số cóc giải cứu: <font color=\"#ff0061\">") .. nx_widestr(total_coc_free) .. nx_widestr("</font>")
        form.mltbox_content:AddHtmlText(text1, -1)
        local text2 = nx_function("ext_utf8_to_widestr", "Bạc vụn tốn: <font color=\"#ff0061\">") .. nx_widestr(text_money) .. nx_widestr("</font>")
        form.mltbox_content:AddHtmlText(text2, -1)
        nx_pause(0.2)
    end
end


function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
end

function on_main_form_close(form)
    auto_is_running = false
    auto_is_running_rsabduct = false
    auto_is_running_player = false
    auto_is_running_offfree = false
    nx_destroy(form)
end

function on_btn_close_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    on_main_form_close(form)
end

-- Show hide form godseyes
function show_hide_form_godseyes()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_godseyes")
end

function on_btn_control_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running then
        reset_all_btns("----")
    else
        reset_all_btns("")
        auto_is_running = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run()
    end
end

function on_btn_control_rsabduct_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_rsabduct then
        reset_all_btns("----")
    else
        reset_all_btns("rsabduct")
        auto_is_running_rsabduct = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_rsabduct()
    end
end

function on_btn_control_khd_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_khd then
        reset_all_btns("----")
    else
        reset_all_btns("khd")
        auto_is_running_khd = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_khd()
    end
end

-- Click vào nút soi buff
function on_btn_control_buff_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    reset_all_btns("buff")
    auto_run_buff()
end

function on_btn_control_player_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_player then
        reset_all_btns("----")
    else
        reset_all_btns("player")
        auto_is_running_player = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_player()
    end
end

function reset_all_btns(skip)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    if skip ~= "" then
        auto_is_running = false
        form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Quét cóc")
    end
    if skip ~= "rsabduct" then
        auto_is_running_rsabduct = false
        form.btn_control_rsabduct.Text = nx_function("ext_utf8_to_widestr", "Thổi cóc")
    end

    -- Hủy soi buff
    if skip ~= "buff" then
        local custom_groupbox = form:Find("groupbox_buff")
        if nx_is_valid(custom_groupbox) then
            form:Remove(custom_groupbox)
        end
    end
    if skip ~= "player" then
        auto_is_running_player = false
        form.btn_control_player.Text = nx_function("ext_utf8_to_widestr", "Quét Player")
    end
    if skip ~= "offfree" then
        auto_is_running_offfree = false
        form.btn_control_offfree.Text = nx_function("ext_utf8_to_widestr", "Quét Hết")
    end
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    local gui = nx_value("gui")
    --form.Left = (gui.Width - form.Width) / 2
    --form.Top = (gui.Height - form.Height) / 2
    form.Left = 100
    form.Top = 140
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

-- Để chuột vào icon buff khi quét buff
function on_buff_imagegrid_mousein_grid(grid, index)
    local buff_configID = nx_string(grid:GetItemAddText(index, nx_int(1)))
    local gui = nx_value("gui")
    if buff_configID == nil or nx_string(buff_configID) == "" then
        return
    end
    local text_tips = nx_widestr("")
    local des_info = gui.TextManager:GetText("desc_" .. nx_string(buff_configID) .. "_0")
    if des_info ~= nx_widestr("desc_" .. nx_string(buff_configID) .. "_0") and des_info ~= nx_widestr("") and des_info ~= nx_widestr("<s>") then
        text_tips = des_info
    end
    local des_info1 = gui.TextManager:GetText("desc_" .. nx_string(buff_configID) .. "_1")
    if text_tips == nx_widestr("") and des_info1 ~= nx_widestr("desc_" .. nx_string(buff_configID) .. "_1") and des_info1 ~= nx_widestr("") and des_info1 ~= nx_widestr("<s>") then
        text_tips = des_info1
    end
    if text_tips ~= nx_widestr("") then
        nx_execute("tips_game", "show_text_tip", text_tips, grid:GetMouseInItemLeft() + 5, grid:GetMouseInItemTop() + 5, 0, grid.ParentForm)
    end
end

-- Đưa chuột ra khỏi icon buff khi quét buff
function on_buff_imagegrid_mouseout_grid(grid, index)
    nx_execute("tips_game", "hide_tip", grid.ParentForm)
end

function startMoveForward()
    nx_function("ext_win_exec", nx_work_path() .. WINEXEC_PATH .. " STARTFORWARD")
end

function stopMoveForward()
    nx_function("ext_win_exec", nx_work_path() .. WINEXEC_PATH .. " STOPFORWARD")
end

function getSpyState()
    return spyState
end
