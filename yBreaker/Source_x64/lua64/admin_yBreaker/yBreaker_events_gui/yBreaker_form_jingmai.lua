require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_jingmai"
local SUB_CLIENT_ACTIVE_JINGMAI = 1
local SUB_CLIENT_CLOSE_JINGMAI = 2

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	form.lbl_title.Text = ""
    reload_form()
end

function on_main_form_close(form)
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
	form.Left = 1289
	form.Top = 543
    --form.Top = (gui.Height / 2) + 199
end

-----------------------------
-- Load lại hết form
--
function reload_form()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
    -- Đọc danh sách mạch đang kích của acc
    local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
    local total = player_client:GetRecordRows("active_jingmai_rec")
    local cur_actived_jingmai = {}
    if total > 0 then
        for i = 1, total do
            local jingmai = player_client:QueryRecord("active_jingmai_rec", i - 1, "")
            if jingmai ~= "" then
                table.insert(cur_actived_jingmai, jingmai)
            end
        end
    end
    -- Đọc cấu hình
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = account .. "\\yBreaker_config.ini"
    local jingmais_in = {}
    local jingmais_out = {}
    local matched_jingmai_in = 0
    local matched_jingmai_out = 0
    local jingmais_inboss = {}
    local jingmais_outboss = {}
    local matched_jingmai_inboss = 0
    local matched_jingmai_outboss = 0
    if ini:LoadFromFile() then
        -- Đọc mạch nội
        for i = 1, 8 do
            local jm = ini:ReadString(nx_string("jingmai_in"), nx_string("jingmai" .. i), "")
            if jm ~= "" then
                table.insert(jingmais_in, jm)
                if in_array(jm, cur_actived_jingmai) then
                    matched_jingmai_in = matched_jingmai_in + 1
                end
            end
        end
        -- Đọc mạch ngoại
        for i = 1, 8 do
            local jm = ini:ReadString(nx_string("jingmai_out"), nx_string("jingmai" .. i), "")
            if jm ~= "" then
                table.insert(jingmais_out, jm)
                if in_array(jm, cur_actived_jingmai) then
                    matched_jingmai_out = matched_jingmai_out + 1
                end
            end
        end
        -- Đọc mạch nội boss
        for i = 1, 8 do
            local jm = ini:ReadString(nx_string("jingmai_inboss"), nx_string("jingmai" .. i), "")
            if jm ~= "" then
                table.insert(jingmais_inboss, jm)
                if in_array(jm, cur_actived_jingmai) then
                    matched_jingmai_inboss = matched_jingmai_inboss + 1
                end
            end
        end
        -- Đọc mạch ngoại boss
        for i = 1, 8 do
            local jm = ini:ReadString(nx_string("jingmai_outboss"), nx_string("jingmai" .. i), "")
            if jm ~= "" then
                table.insert(jingmais_outboss, jm)
                if in_array(jm, cur_actived_jingmai) then
                    matched_jingmai_outboss = matched_jingmai_outboss + 1
                end
            end
        end
    end
    nx_destroy(ini)
    -- Xử lý nút tắt hết mạch
    -- if table.getn(cur_actived_jingmai) <= 0 then
    --     --form.btn_jingmai_close.Text = nx_function("ext_utf8_to_widestr", "Đã tắt mạch")
	-- 	--form.btn_jingmai_close.ForeColor = "255,220,20,60"
    --     form.btn_jingmai_close.Enable = false
    -- else
    --     --form.btn_jingmai_close.Text = nx_function("ext_utf8_to_widestr", "Tắt Mạch")
    --     form.btn_jingmai_close.Enable = true
    -- end
    -- -- Xử lý nút kích mạch nội
    -- if matched_jingmai_in == table.getn(jingmais_in) then
    --     --form.btn_jingmai_in.Text = nx_function("ext_utf8_to_widestr", "Đã kích Nội")
    --     form.btn_jingmai_in.Enable = false
    -- else
    --     --form.btn_jingmai_in.Text = nx_function("ext_utf8_to_widestr", "Nội")
    --     form.btn_jingmai_in.Enable = true
    -- end
    -- -- Xử lý nút kích mạch ngoại
    -- if matched_jingmai_out == table.getn(jingmais_out) then
    --     --form.btn_jingmai_out.Text = nx_function("ext_utf8_to_widestr", "Đã kích Ngoại")
    --     form.btn_jingmai_out.Enable = false
    -- else
    --     --form.btn_jingmai_out.Text = nx_function("ext_utf8_to_widestr", "Ngoại")
    --     form.btn_jingmai_out.Enable = true
    -- end
    -- -- Xử lý nút kích mạch Thủ
    -- if matched_jingmai_inboss == table.getn(jingmais_inboss) then
    --     --form.btn_jingmai_inboss.Text = nx_function("ext_utf8_to_widestr", "Đã kích Thủ")
    --     form.btn_jingmai_inboss.Enable = false
    -- else
    --     --form.btn_jingmai_inboss.Text = nx_function("ext_utf8_to_widestr", "Thủ")
    --     form.btn_jingmai_inboss.Enable = true
    -- end
    -- -- Xử lý nút kích mạch Né
    -- if matched_jingmai_outboss == table.getn(jingmais_outboss) then
    --     --form.btn_jingmai_outboss.Text = nx_function("ext_utf8_to_widestr", "Đã kích Né")
    --     form.btn_jingmai_outboss.Enable = false
    -- else
    --     --form.btn_jingmai_outboss.Text = nx_function("ext_utf8_to_widestr", "Né")
    --     form.btn_jingmai_outboss.Enable = true
    -- end
end

-- Kích mạch nội
function on_btn_jingmai_in_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    active_jingmai("jingmai_in")
    --on_main_form_close(form)
end

-- Kích mạch ngoại
function on_btn_jingmai_out_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    active_jingmai("jingmai_out")
    --on_main_form_close(form)
end

-- Kích mạch nội boss
function on_btn_jingmai_inboss_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    active_jingmai("jingmai_inboss")
    --on_main_form_close(form)
end

-- Kích mạch ngoại boss
function on_btn_jingmai_outboss_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    active_jingmai("jingmai_outboss")
    --on_main_form_close(form)
end

-- Tắt hết mạch
function on_btn_jingmai_close_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    close_all_jingmai()
    --on_main_form_close(form)
end

-- Tắt nội công
function on_btn_neigong_close_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return
    end
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(player_client) then
        return
    end
    local minNeigongID, maxNeigongID = nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "getMinAndMaxNeigong")
    if minNeigongID ~= "" and player_client:QueryProp("CurNeiGong") ~= minNeigongID then
        nx_execute("custom_sender", "custom_use_neigong", nx_string(minNeigongID))
    end
	--btn.ForeColor = "255,220,20,60"
    --on_main_form_close(form)
end

-------------------------
-- Tắt hết mạch
--
function close_all_jingmai()
    local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
    local total = player_client:GetRecordRows("active_jingmai_rec")
    if total > 0 then
        for i = 1, total do
            local jingmai = player_client:QueryRecord("active_jingmai_rec", i - 1, "")
            if jingmai ~= "" then
                nx_execute("custom_sender", "custom_jingmai_msg", SUB_CLIENT_CLOSE_JINGMAI, nx_string(jingmai))
            end
        end
    end
end

--------------------------------
-- Kích hoạt mạch nội hoặc ngoại đánh boss hoặc đánh người
-- type: jingmai_in, jingmai_out, jingmai_inboss, jingmai_outboss
function active_jingmai(type)
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = account .. "\\yBreaker_config.ini"
    local jingmais = {}
    if ini:LoadFromFile() then
        for i = 1, 8 do
            local jm = ini:ReadString(nx_string(type), nx_string("jingmai" .. i), "")
            if jm ~= "" then
                table.insert(jingmais, jm)
            end
        end
    end
    nx_destroy(ini)
    -- Không có mạch thì kết thúc
    if table.getn(jingmais) <= 0 then
        tools_show_notice(nx_function("ext_utf8_to_widestr", "Chưa thiết lập mạch nội, ngoại. Vui lòng thiết lập trước ở mục Thiết lập theo acc"), 2)
        return
    end
    -- Tắt hết mạch
    close_all_jingmai()
    -- Bật lại mạch
    for i = 1, table.getn(jingmais) do
        nx_execute("custom_sender", "custom_jingmai_msg", SUB_CLIENT_ACTIVE_JINGMAI, nx_string(jingmais[i]))
    end
end

function show_hide_form_jingmai()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_jingmai")
end
