require("const_define")
require("util_gui")
require("util_move") -- Xac dinh toa do distance3d
require("util_functions")
require("util_static_data")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("share\\view_define")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_luyencong"
local FORM_MAIN_FACE_CHAT = "form_stage_main\\form_main\\form_main_face_chat"
local FORM_MAIN_FACE = "form_stage_main\\form_main\\form_main_face"

local SUB_CLIENT_OPEN = 1
local SUB_CLIENT_EXIT = 4
local MAX_MEMBER = 10
local FORM_FACULTY_TEAM = "form_stage_main\\form_wuxue\\form_team_faculty_member"
local FORM_MAIN_REQUEST = "form_stage_main\\form_main\\form_main_request"

-- Tạo độ LC TGT	
local x = 659.054
local y = 28.942
local z = 319.883

local auto_is_running = false
local last_chat = 0
-- Chat Full khi mở luyện nhóm
local is_full_chat = false
local isTele = false

function show_hide_form_luyencong()
	util_auto_show_hide_form(THIS_FORM)
end

-- Người mở luyện nhóm
function run_auto_leader()
    local is_started_dance = false
    while auto_is_running == true do
		-- Nhân vật chết thì dừng lại
		if nx_execute("admin_zdn\\zdn_logic_skill", "IsPlayerDead") then
			return
		end
		
        local is_vaild_data = true
        local game_client
        local game_visual
        local game_player
        local game_scence
        local player_client
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
            player_client = game_client:GetPlayer()
            if not nx_is_valid(player_client) then
                is_vaild_data = false
            end
        end
        local form = nx_value(THIS_FORM)
        if not nx_is_valid(form) then
            is_vaild_data = false
        end

        -- Nếu dữ liệu ok hết
        if is_vaild_data == true then
            -- Các thiết lập
            local cfg_start_condition = nx_int(form.combobox_start_condition.Text)
            local cfg_stop_umiss = nx_int(form.combobox_stop1.Text)
            local cfg_stop_uturn = nx_int(form.combobox_stop2.Text)
			
			-- Tele qua map thành đô và chạy tới vị trí mở
			--move_city_map_lc()

            -- Cho cái form lên đầu tiên
            local gui = nx_value("gui")
            form.Visible = true
            gui.Desktop:ToFront(form)

            local view = game_client:GetView(nx_string(VIEWPORT_TEAM_FACULTY))
            local is_accepted_join = false
            if not nx_is_valid(view) then
                -- Trước khi mở thì xuống ngựa cái đã
                if get_buff_info("buf_riding_01") ~= nil then
                    nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
                    nx_pause(0.2)
                else
                    -- Nếu chưa mở luyện nhóm thì bắt đầu mở
                    nx_execute("custom_sender", "custom_team_faculty", SUB_CLIENT_OPEN, nx_string("xl_team_004"))
                    nx_pause(0.2)
                end
            else
                local cur_state = view:QueryProp("CurState")
                local cur_turn = view:QueryProp("CurTurn") -- 0 là turn đầu tiên
                local total_turn = view:QueryProp("TotalTurn")
                local queuepoint = view:QueryProp("QueuePoint")
                local totalscore = view:QueryProp("TotalScore") / 100
                local leader = view:QueryProp("LeaderName")
                local row_count = view:GetRecordRows("team_faculty_rec")

                if cur_state == 1 then
                    -- Đang mở luyện công

                    -- Mở luyện công thì reset thông tin chat full
                    is_full_chat = false

                    -- Nếu số người vào chưa đủ 10 người thì rao và chấp nhận lời mời
                    if nx_int(row_count) < cfg_start_condition then
                        is_accepted_join = true
                        -- Rao luyện nhóm
                        if tools_difftime(last_chat) > 60 then
                            local chat_content = form.txt_content.Text
                            chat_content = nx_function("ext_ws_replace", nx_widestr(chat_content), nx_widestr("<font face=\"font_title_tasktrace\" color=\"#ffffff\" >"), nx_widestr(""))
                            chat_content = nx_function("ext_ws_replace", nx_widestr(chat_content), nx_widestr("</font>"), nx_widestr(""))
                            chat_content = nx_function("ext_ws_replace", nx_widestr(chat_content), nx_widestr("xxx"), nx_widestr(MAX_MEMBER - row_count))
                            chat_content = nx_function("ext_ws_replace", nx_widestr(chat_content), nx_widestr("yyy"), nx_widestr(row_count))
                            nx_execute("custom_sender", "custom_chat", nx_int(CHATTYPE_SCENE), nx_widestr(chat_content))
                            last_chat = os.time()
                        end
                    elseif tools_difftime(last_chat) > 4 then
                        -- Bắt đầu nhấn nút luyện nhóm
                        local formtmp = nx_value(FORM_FACULTY_TEAM)
                        if nx_is_valid(formtmp) then
                            nx_execute(FORM_FACULTY_TEAM, "on_btn_begin_click", formtmp.btn_begin)
                        end
                        is_started_dance = true
                    end
                else
                    -- Đang luyện công
                    if not is_full_chat and tools_difftime(last_chat) > 11 then
                        -- Đủ 10 người thì chat kênh MAP là đủ
                        local chat_content = "Full!!!"
                        nx_execute("custom_sender", "custom_chat", nx_int(CHATTYPE_SCENE), nx_widestr(chat_content))
                        last_chat = os.time()
                        is_full_chat = true
                    end

                    local is_stop_dance = false
                    -- Số người đã out luyện công
                    local num_out = nx_int(cfg_start_condition - nx_int(row_count))
                    -- Tính số lượt miss
                    local num_miss = nx_int(cur_turn - totalscore)
                    -- Nếu có số người out nhiều hơn hoặc out khi nhảy ít hơn
                    if num_out > cfg_stop_umiss or (num_out > nx_int(0) and nx_int(cur_turn) < cfg_stop_uturn) then
                        is_stop_dance = true
                    end
                    -- Nếu sô người miss
                    if num_miss > cfg_stop_umiss or (num_miss > nx_int(0) and nx_int(cur_turn) < cfg_stop_uturn) then
                        is_stop_dance = true
                    end
                    if is_stop_dance then
                        nx_execute("custom_sender", "custom_team_faculty", SUB_CLIENT_EXIT)
                        nx_pause(0.5)
                    end
                end
            end
            -- Chấp nhận lời mời luyện nhóm
            if is_accepted_join then
                local num_request = nx_execute(FORM_MAIN_REQUEST, "get_num_request")
                if num_request > 0 then
                    for i = 1, num_request do
                        local request_type = nx_execute(FORM_MAIN_REQUEST, "get_request_type", i)
                        local request_player = nx_execute(FORM_MAIN_REQUEST, "get_request_player", i)
                        if request_type == REQUESTTYPE_JOIN_FACULTY then
                            nx_execute("custom_sender", "custom_request_answer", request_type, request_player, 1)
                        end
                    end
                    nx_execute(FORM_MAIN_REQUEST, "clear_request")
                end
            end
        end
        if is_started_dance and get_player_tired() >= nx_int(90) then
            on_main_form_close(form)
        end
        nx_pause(0.5)
    end
end

function run_auto_jonner()
    local dissmiss_player = {}
    local last_request = 0
    local is_danced = false
    while auto_is_running == true do
        local is_vaild_data = true
        local game_client
        local game_visual
        local game_player
        local game_scence
        local player_client
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
            player_client = game_client:GetPlayer()
            if not nx_is_valid(player_client) then
                is_vaild_data = false
            end
        end
        local form = nx_value(THIS_FORM)
        if not nx_is_valid(form) then
            is_vaild_data = false
        end

        -- Nếu dữ liệu ok hết
        if is_vaild_data == true then
			-- Tele qua map thành đô và chạy tới vị trí mở
			--if form.cbtn_tele.Checked = true then 
			--	move_city_map_lc()
			--end
			
            -- Cho cái form lên đầu tiên
            local gui = nx_value("gui")
            form.Visible = true
            gui.Desktop:ToFront(form)

            -- Xuống ngựa trước mới luyện nhóm được
            if get_buff_info("buf_riding_01") ~= nil then
                nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
                nx_pause(0.2)
            else
                local view = game_client:GetView(nx_string(VIEWPORT_TEAM_FACULTY))
                if not nx_is_valid(view) then
                    if tools_difftime(last_request) > 30 then
                        local game_scence_objs = game_scence:GetSceneObjList()
                        for i = 1, table.getn(game_scence_objs) do
                            local obj = game_scence_objs[i]
                            if nx_is_valid(obj) then
                                local visualObj = game_visual:GetSceneObj(obj.Ident)
                                if nx_is_valid(visualObj) then
                                    if obj:QueryProp("TeamFacultyState") == 1 and get_buff_info("buf_xiulian_wait", obj) ~= nil then
                                        nx_execute("custom_sender", "custom_request", REQUESTTYPE_JOIN_FACULTY, obj:QueryProp("Name"))
                                        last_request = os.time()
                                        break
                                    end
                                end
                            end
                        end
                    end
                else
                    is_danced = true
                end
            end
        end
        if is_danced and get_player_tired() >= nx_int(90) then
            on_main_form_close(form)
        end
        nx_pause(0.5)
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

    form.btn_leader.Visible = true
    form.btn_jonner.Visible = true
	form.cbtn_tele.Checked = true

    local combobox = form.combobox_start_condition
    combobox.DropListBox:ClearString()
    if combobox.DroppedDown then
        combobox.DroppedDown = false
    end
    for i = 1, 10 do
        combobox.DropListBox:AddString(nx_widestr(11 - i))
    end
    combobox.Text = nx_widestr(10)

    local combobox = form.combobox_stop1
    combobox.DropListBox:ClearString()
    if combobox.DroppedDown then
        combobox.DroppedDown = false
    end
    for i = 1, 3 do
        combobox.DropListBox:AddString(nx_widestr(i))
    end
    combobox.Text = nx_widestr(1)

    local combobox = form.combobox_stop2
    combobox.DropListBox:ClearString()
    if combobox.DroppedDown then
        combobox.DroppedDown = false
    end
    for i = 1, 25 do
        combobox.DropListBox:AddString(nx_widestr(i))
    end
    combobox.Text = nx_widestr(3)

    local html = nx_function("ext_utf8_to_widestr", "LC 25 TGT nhanh nào m.n ơi!")
    form.txt_content:Append(html, -1)
end

function on_main_form_close(form)
    auto_is_running = false
	isTele = false
    nx_destroy(form)
end

function on_btn_close_click(btn)
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    on_main_form_close(form)
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

function on_btn_icon_face_click(btn)
  local gui = nx_value("gui")
  local form = btn.ParentForm
  gui.Focused = form.txt_content
  local face_form = nx_value(FORM_MAIN_FACE_CHAT)
  if nx_is_valid(face_form) then
    nx_gen_event(face_form, "selectface_return", "cancel", "")
  else
    local form_main_face = nx_execute("util_gui", "util_get_form", FORM_MAIN_FACE, true, false, "", true)
    nx_set_value(FORM_MAIN_FACE_CHAT, form_main_face)
    form_main_face.AbsLeft = btn.AbsLeft + btn.Width
    form_main_face.AbsTop = btn.AbsTop
    form_main_face.type = 1
    form_main_face.vip_face_type = 2
    form_main_face.Visible = true
    form_main_face:Show()
    local res, html = nx_wait_event(100000000, form_main_face, "selectface_return")
    local form_auto_chat = nx_value(THIS_FORM)
    if res == "ok" and nx_is_valid(form_auto_chat) then
      add_item_to_chatedit(form, html)
    end
    form_main_face:Close()
  end
  nx_set_value(FORM_MAIN_FACE_CHAT, nil)
end

function add_item_to_chatedit(form, html)
  form.txt_content:Append(html, -1)
  local gui = nx_value("gui")
  gui.Focused = form.txt_content
end

function on_txt_content_get_focus(redit)
  local gui = nx_value("gui")
  gui.hyperfocused = redit
end

function on_txt_content_enter(redit)
  local form = redit.ParentForm
end

function on_btn_leader_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    if auto_is_running then
        auto_is_running = false
		isTele = false
        btn.Text = nx_function("ext_utf8_to_widestr", "Tự mở luyện nhóm")
		btn.ForeColor = "255,255,255,255"
        form.btn_jonner.Visible = true		
    else
        auto_is_running = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng mở luyện nhóm")
		btn.ForeColor = "255,220,20,60"
        form.btn_jonner.Visible = false
        last_chat = os.time() - 16
		
		-- Tự sang map TĐ và di chuyển tới vị trí chỉ định
		if form.cbtn_tele.Checked then 
			isTele = true
			move_city_map_lc()
		end
		
		isTele = false
		run_auto_leader()

    end
end

function on_btn_jonner_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    if auto_is_running then
        auto_is_running = false
		isTele = false
        btn.Text = nx_function("ext_utf8_to_widestr", "Xin luyện nhóm")
		btn.ForeColor = "255,255,255,255"
        form.btn_leader.Visible = true
    else
        auto_is_running = true
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng luyện nhóm")
		btn.ForeColor = "255,220,20,60"
        form.btn_leader.Visible = false
		
		-- Tự sang map TĐ và di chuyển tới vị trí chỉ định
		if form.cbtn_tele.Checked then 
			isTele = true
			move_city_map_lc()

		end
		
		isTele = false
		run_auto_jonner()

    end
end

-- Lấy độ mệt mỏi
function get_player_tired()
    local game_client = nx_value("game_client")
    local client_player = game_client:GetPlayer()
    local cur_team_value = client_player:QueryProp("TeamFacultyValue")
    local ini = nx_execute("util_functions", "get_ini", "share\\Faculty\\faculty_team_action.ini")
    if not nx_is_valid(ini) then
        return nx_int(0)
    end
    local sec_index = ini:FindSectionIndex(nx_string("setting"))
    if sec_index < 0 then
        return nx_int(100)
    end
    local total_team_value = ini:ReadInteger(sec_index, "TeamValue", 0)
    if nx_int(total_team_value) <= nx_int(0) then
        return nx_int(0)
    end
    local cur_team_value = client_player:QueryProp("TeamFacultyValue")
    local tire = nx_int((total_team_value - cur_team_value) * 100 / total_team_value)
    return tire
end

-- Tự động dịch chuyển tới thành đô và chạy tới vị trí LC
function move_city_map_lc()
	
	while isTele do 
		nx_pause(0.2)
		local city = map_id()		
	
		if city == "city05" then
			if not tools_move_isArrived( x, y, z) and not nx_is_valid(view)  then
				tools_move(city, x,y, z, direct_run)
				nx_pause(5)
				tools_show_notice(nx_function("ext_utf8_to_widestr", "Đang chạy tới TGT ..."))
				direct_run = false
			end
			if  tools_move_isArrived( x, y, z) then
				
				tools_show_notice(nx_function("ext_utf8_to_widestr", "Đã tới TGT"))
				isTele = false
				
				nx_pause(0.2)
			end
		else
			tools_show_notice(nx_function("ext_utf8_to_widestr", "Về Thành Đô luyện công ..."))
			tele("HomePointcity05C")
			nx_pause(11)
			isTele = true
		end
	end
	
end