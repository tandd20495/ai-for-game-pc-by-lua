require("const_define")
require("define\\sysinfo_define")
require("define\\request_type")
require("define\\object_type_define")
require("util_gui")
require("util_move") -- Xac dinh toa do distance3d
require("util_static_data")
require("util_functions")
require("share\\server_custom_define")
require("share\\chat_define")
require('auto_new\\autocack')
require("share\\client_custom_define")
require("share\\view_define")
require("form_stage_main\\form_tvt\\define")
require("form_stage_main\\form_task\\task_define")

local THIS_FORM = "auto_new\\form_auto_lookup"

local auto_is_running = false -- Quét cóc
local auto_is_running_rsabduct = false -- Quét, thổi cóc
local auto_is_running_khd = false -- Phát hiện rương KHD
local auto_is_running_player = false -- Quét người chơi
local auto_is_running_offfree = false -- Auto giải cứu cóc
local auto_is_running_trace = false -- Auto đi theo đối tượng
local auto_is_running_attack = false -- Auto đánh
-- local auto_is_running_hgbc = false -- Auto Q Hoàng Gia Bí Cảnh
-- local auto_is_running_dddh = false -- Auto Q Dao Đài Đếm Hoa
-- local auto_is_running_ntlm = false -- Auto Q Nhanh Tay Lẹ Mắt
local auto_is_running_delmail = false -- Auto xóa thư hệ thống
local auto_is_running_catchabduct = false -- Thổi cóc, nhặt cóc và nháy màn hình
local auto_is_running_noterequest = false -- Thông báo có Request
local auto_is_running_acceptrequest = false -- Chấp nhận request
-- local auto_is_running_spy = false -- Auto do thám
-- local auto_is_running_vptd = false -- Auto Q vụ phong tầm hiệp
local auto_is_running_capbird = false -- Auto Q bắt chim nội 5

-- local isAdmRights = true

-- Trạng thái do thám:
-- 0: Chưa ấn nút bắt đầu
-- 1: Chưa có Q (có thể chưa nhận hoặc đã trả Q)
-- 2: Đang tiến hành do thám
-- 3: Đã do thám xong
local spyState = 0

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

--------------------------
-- boxnpc_khd_bx001 -> boxnpc_khd_bx012
function auto_run_khd()
    while auto_is_running_khd == true do
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
            form.mltbox_content:Clear()
            local game_scence_objs = game_scence:GetSceneObjList()

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

                    local textchat = box_name
                    textchat = textchat .. nx_widestr(" : <a href=\"findpath,")
                    textchat = textchat .. nx_widestr(get_current_map())
                    textchat = textchat .. nx_widestr(",")
                    textchat = textchat .. nx_widestr(pathX)
                    textchat = textchat .. nx_widestr(",")
                    textchat = textchat .. nx_widestr(pathY)
                    textchat = textchat .. nx_widestr(",")
                    textchat = textchat .. nx_widestr(pathZ)
                    textchat = textchat .. nx_widestr(",")
                    textchat = textchat .. nx_widestr(box_ident)
                    textchat = textchat .. nx_widestr("\" style=\"HLStype1\">")
                    textchat = textchat .. nx_widestr(box_posX)
                    textchat = textchat .. nx_widestr(",")
                    textchat = textchat .. nx_widestr(box_posZ)
                    textchat = textchat .. nx_widestr("</a>")

                    form.mltbox_content:AddHtmlText(textchat, -1)
                end
            end
        end

        nx_pause(2)
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
            showUtf8Text(AUTO_LOG_LOOK_BUFF_OBJ)
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
        form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", AUTO_LOG_RUN_AROUND_FIND_AB), -1)
        local text_money = nx_execute("util_functions", "trans_capital_string", total_money_used)
        local text1 = nx_function("ext_utf8_to_widestr", AUTO_LOG_TOTAL_AB_CL.." <font color=\"#ff0061\">") .. nx_widestr(total_coc_free) .. nx_widestr("</font>")
        form.mltbox_content:AddHtmlText(text1, -1)
        local text2 = nx_function("ext_utf8_to_widestr", AUTO_LOG_SILVER_FREE.."<font color=\"#ff0061\">") .. nx_widestr(text_money) .. nx_widestr("</font>")
        form.mltbox_content:AddHtmlText(text2, -1)
        nx_pause(0.2)
    end
end

-- Auto đi theo
function auto_run_trace()
    while auto_is_running_trace == true do
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
            form.mltbox_content:Clear()
            form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", AUTO_LOG_FIND_MOVE_OBJ), -1)
            nx_execute("form_stage_main\\form_main\\form_main_select", "on_select_photo_box_click")
        end
        nx_pause(1)
    end
end
skillSetData = {
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
    [8] = nil
}

function getSkillData(grid, index)
    local setIndex = index + 1
    if skillSetData[setIndex] ~= nil then
        return skillSetData[setIndex].stype, skillSetData[setIndex].gtype, skillSetData[setIndex].ttype, skillSetData[setIndex].id
    end
    if not nx_is_valid(grid) then
        return -1, -1, 0, ''
    end
    local itemName = grid:GetItemName(index)
    if nx_widestr(itemName) == nx_widestr('') then
        return -1, -1, 0, ''
    end
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
        return -1, -1, 0, ''
    end
    local view = game_client:GetView(nx_string(40))
    if not nx_is_valid(view) then
        return -1, -1, 0, ''
    end
    local viewobj_list = view:GetViewObjList()
    for i = 1, table.getn(viewobj_list) do
        local configID = viewobj_list[i]:QueryProp('ConfigID')
        if util_text(configID) == itemName then
            local cool_type = skill_static_query_by_id(configID, 'CoolDownCategory')
            local cool_team = skill_static_query_by_id(configID, 'CoolDownTeam')
            local target_type = skill_static_query_by_id(configID, 'TargetType')
            skillSetData[setIndex] = {
                stype = cool_type,
                gtype = cool_team,
                ttype = target_type,
                id = configID
            }
            return cool_type, cool_team, target_type, configID
        end
    end
    return -1, -1, 0, ''
end

function resetSkillData()
    skillSetData = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil,
        [6] = nil
    }
end

-- Auto đánh
function auto_run_attack()
    local FORM_SHORTCUT_PATH = "form_stage_main\\form_main\\form_main_shortcut"
    -- Reset lại skill
    resetSkillData()
    while auto_is_running_attack == true do
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
            form.mltbox_content:Clear()

            local select_target_ident = player_client:QueryProp("LastObject")
            local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
            local select_target_visual = game_visual:GetSceneObj(nx_string(select_target_ident))

            -- Ghi trạng thái nhân vật
            form.mltbox_content:AddHtmlText(nx_widestr("State: ") .. nx_widestr(game_player.state), -1)

            if nx_is_valid(select_target) and nx_is_valid(select_target_visual) then
                local obj_type = nx_number(select_target:QueryProp("Type"))

                if obj_type == TYPE_PLAYER then
                    -- Ghi tên đối thủ là người chơi
                    form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", AUTO_LOG_TARGET_ATTACK) .. nx_widestr(select_target:QueryProp("Name")), -1)
                else
                    -- Ghi tên đối thủ là NPC
                    form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", AUTO_LOG_TARGET_ATTACK) .. util_text(select_target:QueryProp("ConfigID")), -1)
                end

                local fight = nx_value("fight")
                if ((obj_type == TYPE_PLAYER and fight:CanAttackPlayer(player_client, select_target)) or (obj_type == TYPE_NPC and fight:CanAttackNpc(player_client, select_target))) and
                    select_target:QueryProp("Dead") == 0 and
                    game_player.state == "static"
                then
                    -- Ghi % HP còn lại
                    form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", "HP: ") .. nx_widestr(select_target:QueryProp("HPRatio")), -1)

                    -- Ghi % MP còn lại
                    form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", "MP: ") .. nx_widestr(select_target:QueryProp("MPRatio")), -1)

                    -- Xử lý đánh
                    local form_shortcut = nx_value(FORM_SHORTCUT_PATH)
                    if nx_is_valid(form_shortcut) then
                        local grid = form_shortcut.grid_shortcut_main
                        local gui = nx_value("gui")
                        if nx_is_valid(grid) and nx_is_valid(gui) and nx_is_valid(select_target) then
                            -- Ô đầu tiên là ô phá def
                            local gindex = 0
                            local readyDestroyParry = false
                            local cool_type, cool_team, target_type, skill_id = getSkillData(grid, gindex)
                            if cool_type > -1 and  not gui.CoolManager:IsCooling(nx_int(cool_type), nx_int(cool_team)) and grid:GetItemCoverImage(gindex) ~= "" then
                                readyDestroyParry = true
                            end
                            if select_target:QueryProp("InParry") ~= 0 and readyDestroyParry then
                                -- Đối thủ đỡ đòn thì phá def
                                fight:TraceUseSkill(skill_id, false, false)
                            else
                                -- Đối thủ không đỡ đòn thì đánh tự do
                                -- Đánh random skill
                                while true do
                                    if not nx_is_valid(grid) or not nx_is_valid(select_target_visual) then
                                        break
                                    else
                                        local gindex = math.random(0, 7)
                                        local cool_type, cool_team, target_type, skill_id = getSkillData(grid, gindex)
                                        if cool_type > -1 and  not gui.CoolManager:IsCooling(nx_int(cool_type), nx_int(cool_team)) and grid:GetItemCoverImage(gindex) ~= "" then
                                            if target_type == 1 then
                                                nx_execute("game_effect", "add_ground_pick_decal", "map\\tex\\Target_area_G.dds", 16, "20")
                                                nx_execute("game_effect", "locate_ground_pick_decal", select_target_visual.PositionX, select_target_visual.PositionY, select_target_visual.PositionZ)
                                                fight:TraceUseSkill(skill_id, false, true)
                                                nx_execute("game_effect", "del_ground_pick_decal")
                                            else
                                                fight:TraceUseSkill(skill_id, false, false)
                                            end
                                            break
                                        end
                                    end
                                    nx_pause(0)
                                end
                            end
                        end
                    end
                else
                    form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", "Đối tượng này không thể đánh"), -1)
                end
            else
                form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", "Mời nhấp chọn đối tượng để đánh"), -1)
            end
        end
        nx_pause(0.05)
    end
end
---------------------------------------
-- Xác định khoảng cách
--
function getDistanceWithObj(pos, vobj)
    if not nx_is_valid(vobj) then
        return 0
    end
    local px = string.format("%.3f", vobj.PositionX)
    local py = string.format("%.3f", vobj.PositionY)
    local pz = string.format("%.3f", vobj.PositionZ)

    local pxd = px - pos[1]
    local pyd = py - pos[2]
    local pzd = pz - pos[3]

    return math.sqrt(pxd * pxd + pzd * pzd)
end

----------------------------------------------------
-- Auto bắt chim nội công 5
--
function auto_run_capbird()
    -- Config ID của con chim
    local birdConfigID = {
        "npc_5n_lzj_bird30",
        "npc_5n_lzj_bird31",
        "npc_5n_lzj_bird32",
        "npc_5n_lzj_bird33",
        "npc_5n_lzj_bird34",
        "npc_5n_lzj_bird35",
        "npc_5n_lzj_bird36",
        "npc_5n_lzj_bird37",
        "npc_5n_lzj_bird38",
        "npc_5n_lzj_bird39",
        "npc_5n_lzj_bird40",
        "npc_5n_lzj_bird41",
        "npc_5n_lzj_bird42",
        "npc_5n_lzj_bird43",
        "npc_5n_lzj_bird44",
        "npc_5n_lzj_bird45",
        "npc_5n_lzj_bird46",
        "npc_5n_lzj_bird47",
        "npc_5n_lzj_bird48",
        "npc_5n_lzj_bird49"
    }
    -- Config của Item bắt được
    local birdCaughtConfigID = "Item_5nei_bird02"

    while auto_is_running_capbird == true do
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
            form.mltbox_content:Clear()

            -- Tính số con chim đã bắt được
            local GoodsGrid = nx_value("GoodsGrid")
            local numBirdCaught = 0
            if nx_is_valid(GoodsGrid) then
                numBirdCaught = GoodsGrid:GetItemCount(birdCaughtConfigID)
            end
            -- Ghi ra số con chim đã bắt
            form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", "Số con chim đã bắt: ") .. nx_widestr(numBirdCaught), -1)

            if numBirdCaught >= 5 then
                auto_is_running = false
                nx_function("ext_flash_window")
                form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", "Đã bắt đủ số chim. Auto kết thúc"), -1)
                reset_all_btns("----")
                return false
            else
                form.mltbox_content:AddHtmlText(nx_function("ext_utf8_to_widestr", "Đang quét chim"), -1)
                local game_scence_objs = game_scence:GetSceneObjList()
                for i = 1, table.getn(game_scence_objs) do
                    local obj = game_scence_objs[i]
                    if nx_is_valid(obj) then
                        local visualObj = game_visual:GetSceneObj(obj.Ident)
                        if nx_is_valid(visualObj) then
                            -- Xác định khoảng cách 3D
                            local pxd = game_player.PositionX - visualObj.PositionX
                            local pyd = game_player.PositionY - visualObj.PositionY
                            local pzd = game_player.PositionZ - visualObj.PositionZ
                            local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
                            local angleY = getAngleForward(game_player.PositionX, game_player.PositionZ, visualObj.PositionX, visualObj.PositionZ)
                            -- Xác định con chim ở gần, ghi ra tọa độ
                            if distance < 8 and obj:QueryProp("Type") == 4 and in_array(obj:QueryProp("ConfigID"), birdConfigID) then
                                local textAngleY = string.format("%.3f", angleY)
                                form.mltbox_content:AddHtmlText(util_text(obj:QueryProp("ConfigID")) .. nx_widestr(" ----> AngleY: ") .. nx_widestr(textAngleY), -1)
                                if angleY > 5.15 and angleY < 5.50 then
                                    local form_shortcut_common = nx_value("form_stage_main\\form_main\\form_main_shortcut_buff_common")
                                    if nx_is_valid(form_shortcut_common) then
                                        local grid = form_shortcut_common.imagegrid_1
                                        if nx_is_valid(grid) then
                                            nx_execute("form_stage_main\\form_main\\form_main_shortcut_buff_common", "on_rightclick_grid", grid, nx_int(1))
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
        nx_pause(0.05)
    end
end

--------------------------------------------------
-- Xóa thư hệ thống
function auto_run_delmail()
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

        -- Nếu dữ liệu ok hết
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
            end
        end

        nx_pause(1)
    end
end

----------------------------------------------------
-- Auto thổi cóc, nhặt lên và thông báo
-- Sau khi thông báo thì thoát luôn cái Form này
function auto_run_catchabduct()
    local max_distance_selectauto = 3
    local used_abduct_item = false

    while auto_is_running_catchabduct == true do
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
            form.mltbox_content:Clear()

            -- Kiểm tra nếu đang ôm con cóc thì kết thúc tốt đẹp
            if get_buff_info("buf_abductor") ~= nil then
                nx_function("ext_flash_window")
                on_main_form_close(form)
                return false
            end

            local game_scence_objs = game_scence:GetSceneObjList()
            local select_object = 0

            for i = 1, table.getn(game_scence_objs) do
                local obj_type = 0
                if game_scence_objs[i]:FindProp("Type") then
                    obj_type = game_scence_objs[i]:QueryProp("Type")
                end
                local distance = string.format("%.0f", distance3d(game_player.PositionX, game_player.PositionY, game_player.PositionZ, game_scence_objs[i].PosiX, game_scence_objs[i].PosiY, game_scence_objs[i].PosiZ))

                -- Nhặt cái bao gai lên
                if obj_type == 4 and game_scence_objs[i]:QueryProp("ConfigID") == "OffAbductNpc_0" and used_abduct_item and tonumber(distance) <= max_distance_selectauto then --- NPC
                    nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
                    nx_pause(0.2)
                    nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
                    nx_pause(0.2)
                    nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
                    nx_pause(0.2)
                    nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
                    nx_pause(9)
                    used_abduct_item = false
                    break
                elseif obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 1 and not game_scence_objs[i]:FindProp("OfflineTypeTvT") then
                    if game_scence_objs[i]:QueryProp("IsAbducted") == 0 then
                        if tonumber(distance) <= max_distance_selectauto then
                            select_object = i
                            break
                        end
                    end
                end
            end

            if select_object ~= 0 then
                nx_execute("custom_sender", "custom_select", game_scence_objs[select_object].Ident)
                local form_bag = nx_value("form_stage_main\\form_bag")
                if nx_is_valid(form_bag) then
                    form_bag.rbtn_tool.Checked = true
                end
                nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "offitem_miyao10")
                used_abduct_item = true
            end
        end

        -- Dừng một lát trước khi chạy lại
        nx_pause(1)
    end
end

----------------------------------------------------
-- Thông báo có Request
-- Sau khi thông báo thì thoát luôn cái Form này
function auto_run_noterequest()
    require("define\\request_type")
    local FORM_MAIN_REQUEST = "form_stage_main\\form_main\\form_main_request"
    while auto_is_running_noterequest == true do
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
            form.mltbox_content:Clear()
            local num_request = nx_execute(FORM_MAIN_REQUEST, "get_num_request")
            local isAccepttedRequest = false
            if num_request > 0 then
                for i = 1, num_request do
                    local request_type = nx_execute(FORM_MAIN_REQUEST, "get_request_type", i)
                    local request_player = nx_execute(FORM_MAIN_REQUEST, "get_request_player", i)
                    if request_type == REQUESTTYPE_INVITETEAM or request_type == REQUESTTYPE_EGWAR then
                        isAccepttedRequest = true
                    end
                end
            end
            if isAccepttedRequest == true then
                nx_function("ext_flash_window")
                on_main_form_close(form)
                return false
            end
        end

        -- Dừng một lát trước khi chạy lại
        nx_pause(1)
    end
end

----------------------------------------------------
-- Auto chấp nhận request
-- Sau khi chấp nhận thì KHÔNG thoát luôn cái Form này
function auto_run_acceptrequest()
    require("define\\request_type")
    require("share\\client_custom_define")
    local FORM_MAIN_REQUEST = "form_stage_main\\form_main\\form_main_request"
    while auto_is_running_acceptrequest == true do
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
            form.mltbox_content:Clear()
            local num_request = nx_execute(FORM_MAIN_REQUEST, "get_num_request")
            local isAccepttedRequest = false
            if num_request > 0 then
                for i = 1, num_request do
                    local request_type = nx_execute(FORM_MAIN_REQUEST, "get_request_type", i)
                    local request_player = nx_execute(FORM_MAIN_REQUEST, "get_request_player", i)
                    if request_type == REQUESTTYPE_INVITETEAM then
                        -- Chấp nhận lời mời tổ đội
                        isAccepttedRequest = true
                        nx_execute("custom_sender", "custom_request_answer", request_type, request_player, 1)
                        break
                    elseif request_type == REQUESTTYPE_EGWAR then
                        -- Chấp nhận lời mời vào thiên thê
                        local egwar = nx_value("EgWarModule")
                        if nx_is_valid(egwar) then
                            isAccepttedRequest = true
                            nx_execute("custom_sender", "custom_egwar_trans", 1, egwar.CrossServerID, egwar.WarName, egwar.RuleIndex, egwar.WarSceneID, egwar.SubRound, egwar.StartTime)
                            break
                        end
                    elseif request_type == REQUESTTYPE_LIFE_JOB_SHARE then
                        -- Chấp nhận yêu cầu nghề nghiệp
                        isAccepttedRequest = true
                        game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_REQUEST_ANSWER), nx_int(request_type), request_player, nx_int(1))
                        nx_pause(0.4)
                        local formtmp = nx_value("form_stage_main\\form_life\\form_job_share_confirm")
                        if nx_is_valid(formtmp) and formtmp.Visible == true then
                            nx_execute("form_stage_main\\form_life\\form_job_share_confirm", "on_btn_ok_click", formtmp.btn_ok)
                        end
                        break
                    end
                end
            end
            if isAccepttedRequest == true then
                nx_execute(FORM_MAIN_REQUEST, "clear_request")
                nx_function("ext_flash_window")
                --on_main_form_close(form)
                --return false
            end
        end

        -- Dừng một lát trước khi chạy lại
        nx_pause(1)
    end
end

----------------------------------------------------
-- Auto do thám DATA
local TVT_TYPE_CITAN = 7
local HOMEPOINT_INI_FILE = "share\\Rule\\HomePoint.ini"

local array_spy_task_title = {
    "title_52001", "title_52002", "title_52003", "title_52004", "title_52005", "title_52006", "title_52007", "title_52008",
    "title_52030", "title_52031", "title_52032", "title_52033", "title_52034", "title_52035", "title_52082",
    "title_52009", -- VMP
    "title_52051", -- HDM
    "title_52052", -- TPTC
    "title_52055", -- Niệm La
    "title_52057", -- Cổ Mộ
    "title_52053", -- Hoa Sơn
    "title_52054", -- Ngũ Tiên
    "title_52056", -- Thần Thủy
    "title_52058" -- Đạt Ma
}
local data_map_spy = {}
data_map_spy["specialinfo_578"] = {"school01", "ini\\scene\\scene_school01"}
data_map_spy["specialinfo_579"] = {"school02", "ini\\scene\\scene_school02"}
data_map_spy["specialinfo_580"] = {"school03", "ini\\scene\\scene_school03"}
data_map_spy["specialinfo_581"] = {"school04", "ini\\scene\\scene_school04"}
data_map_spy["specialinfo_582"] = {"school05", "ini\\scene\\scene_school05"}
data_map_spy["specialinfo_583"] = {"school06", "ini\\scene\\scene_school06"}
data_map_spy["specialinfo_584"] = {"school07", "ini\\scene\\scene_school07"}
data_map_spy["specialinfo_585"] = {"school08", "ini\\scene\\scene_school08"}
--data_map_spy["specialinfo_585"] = {"school20", "ini\\scene\\scene_school08"}

-- Điểm dừng chân phái
local array_homepoint_allowed = {}
array_homepoint_allowed["school_shaolin"] = "HomePointschool08D" -- TL
array_homepoint_allowed["school_wudang"] = "HomePointschool07E" -- VD
array_homepoint_allowed["school_gaibang"] = "HomePointschool02B" -- CB
array_homepoint_allowed["school_tangmen"] = "HomePointschool05A" -- DM
array_homepoint_allowed["school_emei"] = "HomePointschool06C" -- NM
array_homepoint_allowed["school_jinyiwei"] = "HomePointschool01A" -- CYV
array_homepoint_allowed["school_jilegu"] = "HomePointschool04A" -- CLC
array_homepoint_allowed["school_junzitang"] = "HomePointschool03A" -- QTD
array_homepoint_allowed["school_mingjiao"] = "HomePointschool20A" -- MG

array_homepoint_allowed["newschool_shenshui"] = "HomePointschool19A" -- Thần Thủy
array_homepoint_allowed["newschool_wuxian"] = "HomePointschool12A" -- Ngũ Tiên Giáo
array_homepoint_allowed["newschool_nianluo"] = "HomePointschoo15A" -- Niệm La Bá
array_homepoint_allowed["newschool_changfeng"] = "HomePointschoo16A" -- Trường Phong Tiêu Cục

array_homepoint_allowed["force_xujia"] = "HomePointcity05F" -- Từ Gia Trang

-- Điểm thần hành để đi do thám phái
local array_homepoint_spy = {}
array_homepoint_spy["school01"] = "HomePointschool01B" -- TL
array_homepoint_spy["school02"] = "HomePointschool02A" -- CB
array_homepoint_spy["school03"] = "HomePointschool03B" -- QTD
array_homepoint_spy["school04"] = "HomePointschool04B" -- CLC
array_homepoint_spy["school05"] = "HomePointschool05B" -- DM
array_homepoint_spy["school06"] = "HomePointschool06D" -- NM
array_homepoint_spy["school07"] = "HomePointschool07B" -- VD
array_homepoint_spy["school08"] = "HomePointschool08B" -- TL
array_homepoint_spy["school20"] = "HomePointschool20B" -- MG

-- Phái
local array_unique_school = {}
array_unique_school["school_shaolin"] = "school_shaolin" -- TL
array_unique_school["school_wudang"] = "school_wudang" -- VD
array_unique_school["school_gaibang"] = "school_gaibang" -- CB
array_unique_school["school_tangmen"] = "school_tangmen" -- DM
array_unique_school["school_emei"] = "school_emei" -- NM
array_unique_school["school_jinyiwei"] = "school_jinyiwei" -- CYV
array_unique_school["school_jilegu"] = "school_jilegu" -- CLC
array_unique_school["school_junzitang"] = "school_junzitang" -- QTD
array_unique_school["school_mingjiao"] = "school_mingjiao" -- MG

array_unique_school["newschool_gumu"] = "school_wudang" -- Cổ Mộ -> VĐ
array_unique_school["newschool_xuedao"] = "school_jinyiwei" -- Huyết Đao -> CYV
array_unique_school["newschool_huashan"] = "school_junzitang" -- Hoa Sơn -> QTĐ
array_unique_school["newschool_damo"] = "school_shaolin" -- Đạt Ma -> Thiếu Lâm
array_unique_school["newschool_shenshui"] = "school_emei" -- Thần Thủy -> Nga Mi
array_unique_school["newschool_changfeng"] = "school_gaibang" -- Trường Phong -> Cái Bang
array_unique_school["newschool_nianluo"] = "school_tangmen" -- Niệm La -> ĐM
array_unique_school["newschool_wuxian"] = "school_jilegu" -- Ngũ Tiên -> CLC
array_unique_school["newschool_changfeng"] = "school_gaibang" -- Trường Phong Tiêu Cục -> Cái Bang

array_unique_school["force_xujia"] = "force_xujia" -- Từ Gia Trang

-- Map phái, ẩn thế vẫn là map đại phái (Map thực hiện trả Q do thám)
local array_home_map = {}
array_home_map["school_shaolin"] = "school08" -- TL
array_home_map["school_wudang"] = "school07" -- VD
array_home_map["school_gaibang"] = "school02" -- CB
array_home_map["school_tangmen"] = "school05" -- DM
array_home_map["school_emei"] = "school06" -- NM
array_home_map["school_jinyiwei"] = "school01" -- CYV
array_home_map["school_jilegu"] = "school04" -- CLC
array_home_map["school_junzitang"] = "school03" -- QTD
array_home_map["school_mingjiao"] = "school20" -- MG

array_home_map["newschool_gumu"] = "school07" -- Cổ Mộ -> VĐ
array_home_map["newschool_xuedao"] = "school01" -- Huyết Đao -> CYV
array_home_map["newschool_huashan"] = "school03" -- Hoa Sơn -> QTĐ
array_home_map["newschool_damo"] = "school08" -- Đạt Ma -> Thiếu Lâm
array_home_map["newschool_shenshui"] = "school06" -- Thần Thủy -> Nga Mi
array_home_map["newschool_changfeng"] = "school02" -- Trường Phong -> Cái Bang
array_home_map["newschool_nianluo"] = "school05" -- Niệm La -> ĐM
array_home_map["newschool_wuxian"] = "school04" -- Ngũ Tiên -> CLC
array_home_map["newschool_changfeng"] = "school02" -- Trường Phong Tiêu Cục -> Cái Bang

array_home_map["force_xujia"] = "city05" -- Từ Gia Trang -> Thành Đô

-- Map của ẩn thế, đại phái hoặc thế lực
local array_home_unique_map = {}
array_home_unique_map["school_shaolin"] = "school08" -- TL
array_home_unique_map["school_wudang"] = "school07" -- VD
array_home_unique_map["school_gaibang"] = "school02" -- CB
array_home_unique_map["school_tangmen"] = "school05" -- DM
array_home_unique_map["school_emei"] = "school06" -- NM
array_home_unique_map["school_jinyiwei"] = "school01" -- CYV
array_home_unique_map["school_jilegu"] = "school04" -- CLC
array_home_unique_map["school_junzitang"] = "school03" -- QTD
array_home_unique_map["school_mingjiao"] = "school20" -- MG

array_home_unique_map["newschool_gumu"] = "school14" -- Cổ Mộ
array_home_unique_map["newschool_xuedao"] = "school13" -- Huyết Đao
array_home_unique_map["newschool_huashan"] = "school17" -- Hoa Sơn
array_home_unique_map["newschool_damo"] = "school08" -- Đạt Ma
array_home_unique_map["newschool_shenshui"] = "school19" -- Thần Thủy
array_home_unique_map["newschool_changfeng"] = "school02" -- Trường Phong
array_home_unique_map["newschool_nianluo"] = "school15" -- Niệm La
array_home_unique_map["newschool_wuxian"] = "school12" -- Ngũ Tiên
array_home_unique_map["newschool_changfeng"] = "city03" -- Trường Phong Tiêu Cục ở Kim Lăng

array_home_unique_map["force_xujia"] = "city05" --Từ Gia Trang -> Thành Đô

-- Dữ liệu nói chuyện với chưởng môn
local array_data_task = {}
-- CLC
array_data_task["school_jilegu"] = {
    npc = "WorldNpc03816",
    data = {}
}
array_data_task["school_jilegu"]["data"]["school01"] = {841000706, 841003703, 841003704, 840003704} -- CYV
array_data_task["school_jilegu"]["data"]["school02"] = {841000706, 841003703, 841003705, 840003705} -- CB
array_data_task["school_jilegu"]["data"]["school03"] = {841000706, 841003703, 841003706, 840003706} -- QTD
array_data_task["school_jilegu"]["data"]["school05"] = {841000706, 841003703, 841003707, 840003707} -- DM
array_data_task["school_jilegu"]["data"]["school06"] = {841000706, 841003703, 841003708, 840003708} -- NM
array_data_task["school_jilegu"]["data"]["school07"] = {841000706, 841003703, 841003709, 840003709} -- VD
array_data_task["school_jilegu"]["data"]["school08"] = {841000706, 841003703, 841003710, 840003710} -- TL

-- QTD
array_data_task["school_junzitang"] = {
    npc = "WorldNpc03305",
    data = {}
}
array_data_task["school_junzitang"]["data"]["school01"] = {841003744, 841003695, 841003696, 840003696} -- CYV
array_data_task["school_junzitang"]["data"]["school02"] = {841003744, 841003695, 841003697, 840003697} -- CB
array_data_task["school_junzitang"]["data"]["school04"] = {841003744, 841003695, 841003698, 840003698} -- CLC
array_data_task["school_junzitang"]["data"]["school05"] = {841003744, 841003695, 841003699, 840003699} -- DM
array_data_task["school_junzitang"]["data"]["school06"] = {841003744, 841003695, 841003700, 840003700} -- NM
array_data_task["school_junzitang"]["data"]["school07"] = {841003744, 841003695, 841003701, 840003701} -- VD
array_data_task["school_junzitang"]["data"]["school08"] = {841003744, 841003695, 841003702, 840003702} -- TL

-- DM
array_data_task["school_tangmen"] = {
    npc = "WorldNpc02203",
    data = {}
}
array_data_task["school_tangmen"]["data"]["school01"] = {841000941, 841003711, 841003712, 840003712} -- CYV
array_data_task["school_tangmen"]["data"]["school02"] = {841000941, 841003711, 841003713, 840003713} -- CB
array_data_task["school_tangmen"]["data"]["school03"] = {841000941, 841003711, 841003714, 840003714} -- QTD
array_data_task["school_tangmen"]["data"]["school04"] = {841000941, 841003711, 841003715, 840003715} -- CLC
array_data_task["school_tangmen"]["data"]["school06"] = {841000941, 841003711, 841003716, 840003716} -- NM
array_data_task["school_tangmen"]["data"]["school07"] = {841000941, 841003711, 841003717, 840003717} -- VD
array_data_task["school_tangmen"]["data"]["school08"] = {841000941, 841003711, 841003718, 840003718} -- TL

-- CB
array_data_task["school_gaibang"] = {
    npc = "WorldNpc03003",
    data = {}
}
array_data_task["school_gaibang"]["data"]["school01"] = {841002393, 841003687, 841003688, 840003688} -- CYV
array_data_task["school_gaibang"]["data"]["school03"] = {841002393, 841003687, 841003689, 840003689} -- QTD
array_data_task["school_gaibang"]["data"]["school04"] = {841002393, 841003687, 841003690, 840003690} -- CLC
array_data_task["school_gaibang"]["data"]["school05"] = {841002393, 841003687, 841003691, 840003691} -- DM
array_data_task["school_gaibang"]["data"]["school06"] = {841002393, 841003687, 841003692, 840003692} -- NM
array_data_task["school_gaibang"]["data"]["school07"] = {841002393, 841003687, 841003693, 840003693} -- VD
array_data_task["school_gaibang"]["data"]["school08"] = {841002393, 841003687, 841003694, 840003694} -- TL

-- CYV
array_data_task["school_jinyiwei"] = {
    npc = "worldnpc04101",
    data = {}
}
array_data_task["school_jinyiwei"]["data"]["school02"] = {841002210, 841003676, 841003677, 840003677} -- CB
array_data_task["school_jinyiwei"]["data"]["school03"] = {841002210, 841003676, 841003678, 840003678} -- QTD
array_data_task["school_jinyiwei"]["data"]["school04"] = {841002210, 841003676, 841003679, 840003679} -- CLC
array_data_task["school_jinyiwei"]["data"]["school05"] = {841002210, 841003676, 841003680, 840003680} -- DM
array_data_task["school_jinyiwei"]["data"]["school06"] = {841002210, 841003676, 841003681, 840003681} -- NM
array_data_task["school_jinyiwei"]["data"]["school07"] = {841002210, 841003676, 841003682, 840003682} -- VD
array_data_task["school_jinyiwei"]["data"]["school08"] = {841002210, 841003676, 841003683, 840003683} -- TL

-- TL
array_data_task["school_shaolin"] = {
    npc = "WorldNpc00212",
    data = {}
}
array_data_task["school_shaolin"]["data"]["school01"] = {841003369, 841003736, 841003737, 840003737} -- CYV
array_data_task["school_shaolin"]["data"]["school02"] = {841003369, 841003736, 841003738, 840003738} -- CB
array_data_task["school_shaolin"]["data"]["school03"] = {841003369, 841003736, 841003739, 840003739} -- QTD
array_data_task["school_shaolin"]["data"]["school04"] = {841003369, 841003736, 841003740, 840003740} -- CLC
array_data_task["school_shaolin"]["data"]["school05"] = {841003369, 841003736, 841003741, 840003741} -- DM
array_data_task["school_shaolin"]["data"]["school06"] = {841003369, 841003736, 841003742, 840003742} -- NM
array_data_task["school_shaolin"]["data"]["school07"] = {841003369, 841003736, 841003743, 840003743} -- VD

-- MG
array_data_task["school_mingjiao"] = {
    npc = "newmp_mj_001",
    data = {}
}
array_data_task["school_mingjiao"]["data"]["school01"] = {841009273, 841009274, 841009276, 840009276} -- CYV
array_data_task["school_mingjiao"]["data"]["school02"] = {841009273, 841009274, 841009277, 840009277} -- CB
array_data_task["school_mingjiao"]["data"]["school03"] = {841009273, 841009274, 841009278, 840009278} -- QTD
array_data_task["school_mingjiao"]["data"]["school04"] = {841009273, 841009274, 841009279, 840009279} -- CLC
array_data_task["school_mingjiao"]["data"]["school05"] = {841009273, 841009274, 841009280, 840009280} -- DM
array_data_task["school_mingjiao"]["data"]["school06"] = {841009273, 841009274, 841009281, 840009281} -- NM
array_data_task["school_mingjiao"]["data"]["school07"] = {841009273, 841009274, 841009282, 840009282} -- VD
array_data_task["school_mingjiao"]["data"]["school08"] = {841009273, 841009274, 841009283, 840009283} -- TL

-- NM
array_data_task["school_emei"] = {
    npc = "WorldNpc02604",
    data = {}
}
array_data_task["school_emei"]["data"]["school01"] = {841003745, 841003720, 841003721, 840003721} -- CYV
array_data_task["school_emei"]["data"]["school02"] = {841003745, 841003720, 841003722, 840003722} -- CB
array_data_task["school_emei"]["data"]["school03"] = {841003745, 841003720, 841003723, 840003723} -- QTD
array_data_task["school_emei"]["data"]["school04"] = {841003745, 841003720, 841003724, 840003724} -- CLC
array_data_task["school_emei"]["data"]["school05"] = {841003745, 841003720, 841003725, 840003725} -- DM
array_data_task["school_emei"]["data"]["school07"] = {841003745, 841003720, 841003726, 840003726} -- VD
array_data_task["school_emei"]["data"]["school08"] = {841003745, 841003720, 841003727, 840003727} -- TL

-- Từ Gia Trang
array_data_task["force_xujia"] = {
    npc = "WorldNpc09796",
    data = {}
}
array_data_task["force_xujia"]["data"]["school01"] = {841005597, 841005598, 841005599, 840005599} -- CYV
array_data_task["force_xujia"]["data"]["school02"] = {841005597, 841005598, 841005600, 840005600} -- CB
array_data_task["force_xujia"]["data"]["school03"] = {841005597, 841005598, 841005601, 840005601} -- QTD
array_data_task["force_xujia"]["data"]["school04"] = {841005597, 841005598, 841005602, 840005602} -- CLC
array_data_task["force_xujia"]["data"]["school05"] = {841005597, 841005598, 841005603, 840005603} -- DM
array_data_task["force_xujia"]["data"]["school06"] = {841005597, 841005598, 841005604, 840005604} -- NM
array_data_task["force_xujia"]["data"]["school07"] = {841005597, 841005598, 841005605, 840005605} -- VD
array_data_task["force_xujia"]["data"]["school08"] = {841005597, 841005598, 841005606, 840005606} -- TL

-- VD
array_data_task["school_wudang"] = {
    npc = "WorldNpc04401",
    data = {}
}
array_data_task["school_wudang"]["data"]["school01"] = {841003272, 841003728, 841003729, 840003729} -- CYV
array_data_task["school_wudang"]["data"]["school02"] = {841003272, 841003728, 841003730, 840003730} -- CB
array_data_task["school_wudang"]["data"]["school03"] = {841003272, 841003728, 841003731, 840003731} -- QTD
array_data_task["school_wudang"]["data"]["school04"] = {841003272, 841003728, 841003732, 840003732} -- CLC
array_data_task["school_wudang"]["data"]["school05"] = {841003272, 841003728, 841003733, 840003733} -- DM
array_data_task["school_wudang"]["data"]["school06"] = {841003272, 841003728, 841003734, 840003734} -- NM
array_data_task["school_wudang"]["data"]["school08"] = {841003272, 841003728, 841003735, 840003735} -- TL

-- Dữ liệu nói chuyện trả Q
local array_data_complete = {}
-- CLC
array_data_complete["school_jilegu"] = {
    npc = "spynpc_jlg",
    list = {501, 502}
}
-- QTD
array_data_complete["school_junzitang"] = {
    npc = "spynpc_jzt",
    list = {501, 502}
}
-- DM
array_data_complete["school_tangmen"] = {
    npc = "spynpc_tm",
    list = {501, 502}
}
-- CB
array_data_complete["school_gaibang"] = {
    npc = "spynpc_gb",
    list = {501, 502}
}
-- CYV
array_data_complete["school_jinyiwei"] = {
    npc = "spynpc_jyw",
    list = {501, 502}
}
-- TL
array_data_complete["school_shaolin"] = {
    npc = "spynpc_sl",
    list = {501, 502}
}
-- MG
array_data_complete["school_mingjiao"] = {
    npc = "spynpc_mj",
    list = {501, 502}
}
-- NM
array_data_complete["school_emei"] = {
    npc = "spynpc_em",
    list = {501, 502}
}
-- Thần Thủy Cung
array_data_complete["newschool_shenshui"] = {
    npc = "spynpc_ssg",
    list = {501, 502}
}
-- Niệm La Bá
array_data_complete["newschool_nianluo"] = {
    npc = "spynpc_nlb",
    list = {501, 502}
}
-- Ngũ Tiên Giáo
array_data_complete["newschool_wuxian"] = {
    npc = "spynpc_wxj",
    list = {501, 502}
}
-- Trường Phong Tiêu Cục
array_data_complete["newschool_changfeng"] = {
    npc = "spynpc_cfbj",
    list = {501, 502}
}
-- Từ Gia Trang
array_data_complete["force_xujia"] = {
    npc = "spynpc_xjz",
    list = {10022}
}
-- VD
array_data_complete["school_wudang"] = {
    npc = "spynpc_wd",
    list = {501, 502}
}

-- Tọa độ sẽ đi đến để lấy tình báo
local array_pos_spy = {}
array_pos_spy["school01"] = {333, -10000, -61} -- CYV
array_pos_spy["school02"] = {534, -10000, 375} -- CB
array_pos_spy["school03"] = {492, -10000, 487} -- QTD
array_pos_spy["school04"] = {159, -10000, -94} -- CLC
array_pos_spy["school05"] = {1118, -10000, -203} -- DM
array_pos_spy["school06"] = {488, -10000, 194} -- NM
array_pos_spy["school07"] = {479, -10000, 446} -- VD
array_pos_spy["school08"] = {836, -10000, 312} -- TL

-- Dữ liệu nói chuyện để từ ẩn thế về đại phái
local array_data_task_tobaseschool = {}
-- Thần Thủy Cung
array_data_task_tobaseschool["newschool_shenshui"] = {
    npc = "offline_chuansong_ssg01",
    data = {841007890, 840007890}
}
-- Niệm La Bá
array_data_task_tobaseschool["newschool_nianluo"] = {
    npc = "offline_chuansong_nl01",
    data = {841007775, 840007775}
}
-- Ngũ Tiên Giáo
array_data_task_tobaseschool["newschool_wuxian"] = {
    npc = "offline_chuansong_wxj01",
    data = {841007888, 840007888}
}
-- Trường Phong Tiêu Cục
array_data_task_tobaseschool["newschool_changfeng"] = {
    npc = "offline_chuansong_cf01",
    data = {841007773, 840007773}
}

function get_spy_task_id()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return false
    end
    local taskmgr = nx_value("TaskManager")
    if not nx_is_valid(taskmgr) then
        return false
    end

    local task_index = 2 -- Nhiệm vụ hành tẩu giang hồ
    local table_task = taskmgr:GetTaskByType(task_index, 0)
    local total = table.getn(table_task) -- Total này step = 2 tức ra 4 kết quả thì có 2 nhiệm vụ
    local rpt_level = 1
    local rows = client_player:FindRecordRow("Repute_Record", 0, nx_string("repute_jianghu"), 0)
    if rows >= 0 then
        rpt_level = client_player:QueryRecord("Repute_Record", rows, 2)
    end

    for i = 1, total, 2 do
        local task_id = table_task[i]
        local task_line = table_task[i + 1] -- Loại nhiệm vụ ví dụ nhiệm vụ Sư Môn, Phong Vân Giang Hồ...

        local task_row = client_player:FindRecordRow("Task_Accepted", accept_rec_id, nx_int(task_id))
        if task_row < 0 then
            return false
        end
        if nx_number(task_line) == nx_number(task_line_shimen_new) then
            task_line = task_line_wuxue
        end

        -- Trạng thái Q: 0 là đang thực hiện, 2 là có thể trả Q, 1 là thất bại
        local state = nx_execute("form_stage_main\\form_task\\form_task_main", "get_task_complete_state", task_id)
        -- Tiêu đề nhiệm vụ
        local title_id = client_player:QueryRecord("Task_Accepted", task_row, accept_rec_title)

        if in_array(title_id, array_spy_task_title) then
            return {task_id, task_row, state, title_id}
        end
    end
    return false
end

-- Nếu là ẩn thế thì trả về phái ẩn thế không thì trả về đại phái
-- Nếu là thế lực thì trả về thế lực
function get_player_realschool()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return false
    end
    local sh = client_player:QueryProp("NewSchool")
    if sh == 0 then
        local force = client_player:QueryProp("Force")
        if force == 0 then
            return client_player:QueryProp("School")
        end
        return force
    end
    return sh
end

-- Trả về đại phái, nếu ẩn thế thì trả về đại phái liên quan
-- Nếu là thế lực thì trả về thế lực
function get_player_uniqueschool()
    return array_unique_school[get_player_realschool()]
end

-- Có phải ẩn thế hay không
function is_player_hideschool()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return false
    end
    local sh = client_player:QueryProp("NewSchool")
    if sh == 0 then
        return false
    end
    return true
end

-- Hiển thị danh sách các phái cần do thám vào bảng thông tin
function show_spy_task_detail(task_data)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return false
    end
    local taskmgr = nx_value("TaskManager")
    if not nx_is_valid(taskmgr) then
        return false
    end
    local task_id = task_data[1]
    local task_row = task_data[2]
    -- Mục tiêu nhiệm vụ
    local desc_short = client_player:QueryRecord("Task_Accepted", task_row, accept_rec_target)
    local str_schedule = taskmgr:GetTaskScheduleInfo(nx_int(task_id), 0)
    local table_schdule = util_split_string(str_schedule, ";")
    for i, schdule in pairs(table_schdule) do
        local table_para = util_split_string(schdule, "|")
        if table.getn(table_para) == 6 then
            local desc_format = nx_widestr("- ") .. nx_widestr(util_text(table_para[1])) .. nx_widestr(" (") .. nx_widestr(table_para[2]) .. nx_widestr("/") .. nx_widestr(table_para[3]) .. nx_widestr(")")
            form.mltbox_content:AddHtmlText(desc_format, -1)
        end
    end
end

-- Xác định phái tiếp theo cần do thám
function get_map_spy(task_data)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return false
    end
    local taskmgr = nx_value("TaskManager")
    if not nx_is_valid(taskmgr) then
        return false
    end
    local task_id = task_data[1]
    local task_row = task_data[2]
    local str_schedule = taskmgr:GetTaskScheduleInfo(nx_int(task_id), 0)
    local table_schdule = util_split_string(str_schedule, ";")

    for i, schdule in pairs(table_schdule) do
        local table_para = util_split_string(schdule, "|")
        if table.getn(table_para) == 6 then
            if nx_int(table_para[2]) < nx_int(table_para[3]) and data_map_spy[table_para[1]] ~= nil then
                return data_map_spy[table_para[1]]
            end
        end
    end
    return false
end

-- Kiểm tra sắp skill ma khí tung hoành đúng ô
function check_valid_skill_mkth()
    local form = nx_value("form_stage_main\\form_main\\form_main_shortcut")
    local grid = form.grid_shortcut_2
    local gindex = 7
    --grid:SetSelectItemIndex(nx_int(gindex))
    --nx_execute("form_stage_main\\form_main\\form_main_shortcut", "on_main_shortcut_useitem", grid, gindex, true)
    if nx_widestr(grid:GetItemName(gindex)) ~= util_text("cs_jh_tmjt06") then
        return false
    end
    return true
end

-- Kiểm tra hồi thành điều dưỡng ở phái
function check_releave_home()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return false
    end
    local form_home_point = nx_value("form_home_point")
    if not nx_is_valid(form_home_point) then
        return false
    end
    local relive_positon_name = "RelivePositon"
    if form_home_point:IsNewTerritoryType() then
        relive_positon_name = "DongHaiRelivePositon"
    end
    if not client_player:FindProp(relive_positon_name) then
        return false
    end
    local rl_pos_info = client_player:QueryProp(relive_positon_name)
    local relive_lst = nx_function("ext_split_string", rl_pos_info, ",")
    if relive_lst[7] == array_homepoint_allowed[get_player_realschool()] then
        return true
    end
    return false
end

-- Lấy số điểm dừng chân giang hồ đã mở
function get_max_JiangHuHomePoint()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return 0
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return 0
    end
    return client_player:QueryProp("JiangHuHomePointCount")
end

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

function send_homepoint_msg_to_server(...)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return
    end
    game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SET_HOMEPOINT), unpack(arg))
end

-- Thần hành về điểm thần hành XXX
function MoveToMapByHomePoint(hp)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return 0
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return 0
    end
    -- Kiểm tra điểm dừng chân chưa tồn tại thì thêm vào
    local IsExists = false
    local HomePointCount = client_player:GetRecordRows("HomePointList")
    for i = 0, HomePointCount - 1 do
        if hp == client_player:QueryRecord("HomePointList", i, 0) then
            IsExists = true
            break
        end
    end
    if not IsExists then
        -- Xác định số điểm dừng chân đã mở
        local Max1 = client_player:QueryProp("JiangHuHomePointCount")
        if Max1 >= 2 then
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
                send_homepoint_msg_to_server(3, LastHomePoint) -- 3: Xóa điểm dừng chân
                nx_pause(0.5)
            end
            local typename, htext = get_type_homepoint(hp)            
            send_homepoint_msg_to_server(2, hp) -- 2: Thêm điểm dừng chân
            nx_pause(0.5)
        end
    end

    send_homepoint_msg_to_server(1, hp, 4) -- 1: Trở về điểm dừng chân 4: Điểm dừng chân giang hồ
    return os.time()
end

-- Xác định MAP phái của người chơi
-- Nếu là ẩn thế thì sẽ vẫn cho về đại phái
function get_player_home_map()
    return array_home_map[get_player_realschool()]
end

-- Xác định MAP phái của người chơi
-- Nếu là ẩn thế thì trả về MAP ẩn thế
-- Nếu ko là ẩn thế thì về đại phái
function get_player_home_uniquemap()
    return array_home_unique_map[get_player_realschool()]
end

-- Chết
function isPlayerDead()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    if player_client:QueryProp("LogicState") == 120 then
        return true
    end
    return false
end

-- Xác định số tình báo đã lấy được
function get_num_pryed()
    -- Mở túi đồ lên
    local form_bag = nx_value("form_stage_main\\form_bag")
    if not nx_is_valid(form_bag) or form_bag.Visible == false then
        util_auto_show_hide_form("form_stage_main\\form_bag")
        nx_pause(0.1)
        form_bag = nx_value("form_stage_main\\form_bag")
    end
    if not nx_is_valid(form_bag) or not form_bag.Visible then
        return 0
    end
    -- Kích hoạt cái túi nhiệm vụ
    if not form_bag.rbtn_task.Checked then
        form_bag.rbtn_task.Checked = true
    end
    local goods_grid = nx_value("GoodsGrid")
    if not nx_is_valid(goods_grid) then
        return 0
    end
    -- Xác định vị trí Item Tín Vật
    local grid, grid_index = goods_grid:GetToolBoxGridAndPos("pry_item")
    if not nx_is_valid(grid) or grid == nil then
        return 0
    end
    local game_client = nx_value("game_client")
    local toolbox_view = game_client:GetView(nx_string(grid.typeid))
    if not nx_is_valid(toolbox_view) then
        return 0
    end
    local bind_index = grid:GetBindIndex(grid_index)
    local viewobj = toolbox_view:GetViewObj(nx_string(bind_index))
    if not nx_is_valid(viewobj) then
        return 0
    end
    return viewobj:GetRecordRows("InteractList")
end

-- Dữ liệu nói chuyện để đến map spy
function get_data_task()
    return array_data_task[get_player_uniqueschool()]
end

-- Dữ liệu nói chuyện để trả Q
function get_data_complete()
    return array_data_complete[get_player_realschool()]
end

-- Dữ liệu nói chuyện để về Đại Phái từ ẩn thế
function get_data_task_tobaseschool()
    return array_data_task_tobaseschool[get_player_realschool()]
end

-- Xác định MAP phái của người chơi
function get_player_name()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return nx_widestr("")
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return nx_widestr("")
    end
    return nx_widestr(client_player:QueryProp("Name"))
end

-- Di chuyển tới vị trí
-- Nếu trigger di chuyển thì trả về false
-- Nếu không trigger thì trả về true
function tools_move_new(scene, x, y, z, passtest)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return true
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return true
    end
    if passtest ~= nil and passtest == true then
        nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
        return false
    end
    local beforeX = string.format("%.3f", game_player.PositionX)
    local beforeY = string.format("%.3f", game_player.PositionY)
    local beforeZ = string.format("%.3f", game_player.PositionZ)
    nx_pause(0.4)
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return true
    end
    local game_player = game_visual:GetPlayer()
    if not nx_is_valid(game_player) then
        return true
    end
    local afterX = string.format("%.3f", game_player.PositionX)
    local afterY = string.format("%.3f", game_player.PositionY)
    local afterZ = string.format("%.3f", game_player.PositionZ)

    local pxd = beforeX - afterX
    local pyd = beforeY - afterY
    local pzd = beforeZ - afterZ

      local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
      if distance <= 0.6 then
        nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
        return false
      end
    return true
end

local homePointTimeout = 620

-- Thời gian đánh dấu đang load
local last_loading_time = 0
-- Lần sử dụng thần hành cuối
local last_use_homepoint = 0
-- Lần nhận nhiệm vụ do thám cuối
local last_start_spy = 0
-- Số trigger di chuyển từ thời điểm cuối
local start_move_count = 0
-- Tên các con đệ tử tình báo bỏ qua
local ignore_intelligence_npc = {}
-- Thời gian sử dụng skill tình báo cuối
local last_use_skill = 0
-- Đánh dấu tìm thấy NPC mới thì bắt đầu chạy lại
local last_npc_ident = 0

-- Phát hiện con đệ tử tình báo để chạy lại
function detect_intelligence_npc()
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false, false
    end
    local game_scence = game_client:GetScene()
    if not nx_is_valid(game_scence) then
        return false, false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
        return false, false
    end
    local game_scence_objs = game_scence:GetSceneObjList()
    for i = 1, table.getn(game_scence_objs) do
        local obj = game_scence_objs[i]
        if nx_is_valid(obj) then
            local visualObj = game_visual:GetSceneObj(obj.Ident)
            if nx_is_valid(visualObj) then
                if obj:QueryProp("Type") == 2 and obj:QueryProp("OffLineState") == 1 and obj:QueryProp("OfflineTypeTvT") == 5 and not in_array(obj:QueryProp("Name"), ignore_intelligence_npc) then
                    return obj, visualObj
                end
            end
        end
    end
    return false, false
end

-- Lấy tình báo từ NPC
-- Nếu skill đang hồi trả về false
-- Nếu lấy thành công trả về true
function get_spy_from_npc()
    local mgr = nx_value("InteractManager")
    if not nx_is_valid(mgr) then
        return false
    end
    local tvttype = mgr:GetCurrentTvtType()
    local skill = mgr:GetTvtSkill(tvttype, 0)
    local cooltm = mgr:GetTvtSkillCoolTm(tvttype, 0)
    if tools_difftime(last_use_skill) > (cooltm + 2) then
        send_server_msg(g_msg_useskill, tvttype, nx_string(skill))
        return true
    end
    return false
end

-- Nhấp chọn NPC
-- Trả về true nếu đã chọn
-- Trả về false và tự chọn NPC
function control_select_npc(npc)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return false
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return false
    end
    local select_target_ident = player_client:QueryProp("LastObject")
    local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
    if not nx_is_valid(npc) then
        return false
    end
    if nx_is_valid(select_target) and nx_string(npc.Ident) == nx_string(select_target_ident) then
        return true
    end
    nx_execute("custom_sender", "custom_select", npc.Ident)
    return false
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
    auto_is_running_khd = false
    auto_is_running_player = false
    auto_is_running_offfree = false
    auto_is_running_trace = false
    auto_is_running_attack = false
    auto_is_running_delmail = false
    auto_is_running_catchabduct = false
    auto_is_running_noterequest = false
    auto_is_running_acceptrequest = false
    auto_is_running_capbird = false
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

function on_btn_control_findpath_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    local x = nx_int(form.ipt_findpath_x.Text)
    local y = nx_int(form.ipt_findpath_y.Text)
    nx_value("path_finding"):FindPathScene(get_current_map(), x, -10000, y, 0)
end

function on_btn_control_offfree_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_offfree then
        reset_all_btns("----")
    else
        reset_all_btns("offfree")
        auto_is_running_offfree = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_offfree()
    end
end

function on_btn_control_trace_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_trace then
        reset_all_btns("----")
    else
        reset_all_btns("trace")
        auto_is_running_trace = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_trace()
    end
end

function on_btn_control_attack_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_attack then
        reset_all_btns("----")
    else
        reset_all_btns("attack")
        auto_is_running_attack = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_attack()
    end
end


function on_btn_control_delmail_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_delmail then
        reset_all_btns("----")
    else
        local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_confirm", true, false)
        if nx_is_valid(dialog) then
            dialog.mltbox_info.HtmlText = nx_function("ext_utf8_to_widestr", "Chú ý: Hãy kiểm tra lại nếu dùng auto này bạn có thể sẽ mất các thư quan trọng")
            dialog:ShowModal()
            local res = nx_wait_event(100000000, dialog, "confirm_return")
            if res ~= "ok" then
                return
            else
                reset_all_btns("delmail")
                auto_is_running_delmail = true
                btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
                auto_run_delmail()
            end
        end
    end
end

function on_btn_control_catchabduct_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_catchabduct then
        reset_all_btns("----")
    else
        reset_all_btns("catchabduct")
        auto_is_running_catchabduct = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_catchabduct()
    end
end

function on_btn_control_noterequest_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_noterequest then
        reset_all_btns("----")
    else
        reset_all_btns("noterequest")
        auto_is_running_noterequest = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_noterequest()
    end
end

function on_btn_control_acceptrequest_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_acceptrequest then
        reset_all_btns("----")
    else
        reset_all_btns("acceptrequest")
        auto_is_running_acceptrequest = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_acceptrequest()
    end
end



function on_btn_control_capbird_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end

    if auto_is_running_capbird then
        reset_all_btns("----")
    else
        reset_all_btns("capbird")
        auto_is_running_capbird = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        auto_run_capbird()
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
        form.btn_control_rsabduct.Text = nx_function("ext_utf8_to_widestr", "Quét, Thổi cóc")
    end
    if skip ~= "khd" then
        auto_is_running_khd = false
        form.btn_control_khd.Text = nx_function("ext_utf8_to_widestr", "Q.Rương KHĐ")
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
        form.btn_control_player.Text = nx_function("ext_utf8_to_widestr", "Quét Ng.Chơi")
    end
    if skip ~= "offfree" then
        auto_is_running_offfree = false
        form.btn_control_offfree.Text = nx_function("ext_utf8_to_widestr", "Giải cứu cóc")
    end
    if skip ~= "trace" then
        auto_is_running_trace = false
        form.btn_control_trace.Text = nx_function("ext_utf8_to_widestr", "Đi theo")
    end
    if skip ~= "attack" then
        auto_is_running_attack = false
        form.btn_control_attack.Text = nx_function("ext_utf8_to_widestr", "Xuất chiêu")
    end
    if skip ~= "hgbc" then
        auto_is_running_hgbc = false
        form.btn_control_hgbc.Text = nx_function("ext_utf8_to_widestr", "HG Bí Cảnh")
    end
    if skip ~= "dddh" then
        auto_is_running_dddh = false
        form.btn_control_dddh.Text = nx_function("ext_utf8_to_widestr", "DĐ Đếm Hoa")
    end
    if skip ~= "ntlm" then
        auto_is_running_ntlm = false
        form.btn_control_ntlm.Text = nx_function("ext_utf8_to_widestr", "Q N.Tay Lẹ Mắt")
    end
    if skip ~= "delmail" then
        auto_is_running_delmail = false
        form.btn_control_delmail.Text = nx_function("ext_utf8_to_widestr", "Xóa thư H.Thống")
    end
    if skip ~= "catchabduct" then
        auto_is_running_catchabduct = false
        form.btn_control_catchabduct.Text = nx_function("ext_utf8_to_widestr", "Thổi cóc, T.Báo")
    end
    if skip ~= "noterequest" then
        auto_is_running_noterequest = false
        form.btn_control_noterequest.Text = nx_function("ext_utf8_to_widestr", "T.Báo yêu cầu")
    end
    if skip ~= "acceptrequest" then
        auto_is_running_acceptrequest = false
        form.btn_control_acceptrequest.Text = nx_function("ext_utf8_to_widestr", "C.Nhận Y.Cầu")
    end
    if skip ~= "spy" then
        auto_is_running_spy = false
        form.btn_control_spy.Text = nx_function("ext_utf8_to_widestr", "Q Do thám")
    end
    if skip ~= "vptd" then
        auto_is_running_vptd = false
        form.btn_control_vptd.Text = nx_function("ext_utf8_to_widestr", "V.PhongT.Hiệp")
    end
    if skip ~= "capbird" then
        auto_is_running_capbird = false
        form.btn_control_capbird.Text = nx_function("ext_utf8_to_widestr", "Bắt Chim NC5")
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
    spyState = 0
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
function getSpyState()
    return spyState
end
