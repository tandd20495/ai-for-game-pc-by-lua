require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_config"

local pvpTaoluText = {
    ["hsd"] = "Huyết Sát Đao Pháp",
    ["cuchi"] = "Cù Chi Kiếm Pháp",
    ["tuyettrai"] = "Tuyết Trai Kiếm Pháp",
    ["cuucung"] = "Cửu Cung Kiếm Pháp",
	["thc"] = "Tham Hợp Chỉ",
    ["ptc"] = "Phật Tâm Chưởng",
    ["ltt"] = "Long Trảo Thủ (Cổ)"
}
local pvpbinhthuText = {
    [""] = "Không dùng",
    ["ng_ss_5_3"] = "Tiên Thiên Nhất Dương Bút Ý (1%)",
    ["ng_ss_5_2"] = "Thánh Hỏa Minh Tôn Bút Ý (Phong chiêu)",
    ["ng_ss_5_1"] = "Nhật Nguyệt Ma Đế Bút Ý (Hút)",
    ["zs_hs_5_1"] = "Xích Huyết Thần Chiếu Họa Cảnh (15% dame)"
}

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	form.btn_testfile.Visible = false
	form.combobox_testfile.Visible = false
	form.btn_jingmai_in.Text = nx_function("ext_utf8_to_widestr", "Mạch Nội")
	form.btn_jingmai_out.Text = nx_function("ext_utf8_to_widestr", "Mạch Ngoại")
	form.btn_jingmai_inboss.Text = nx_function("ext_utf8_to_widestr", "Mạch Thủ")
	form.btn_jingmai_outboss.Text = nx_function("ext_utf8_to_widestr", "Mạch Né")
    reload_form()
end

function on_main_form_close(form)
    if not nx_is_valid(form) then
        return
    end
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
    --local gui = nx_value("gui")
    --form.Left = (gui.Width - form.Width) / 2
    --form.Top = (gui.Height - form.Height) / 2
    form.Left = 325
    form.Top = 140
end

-----------------------------
-- Load lại hết form
--
function reload_form()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
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
    local jingmais_inboss = {}
    local jingmais_outboss = {}
    local max_neigong = ""
    local testfile = "code.lua"
    local pvptaolu = ""
    local pvpbinhthu = ""
    if ini:LoadFromFile() then
        -- Đọc mạch nội
        for i = 1, 8 do
            local jm = ini:ReadString(nx_string("jingmai_in"), nx_string("jingmai" .. i), "")
            if jm ~= "" then
                table.insert(jingmais_in, jm)
            end
        end
        -- Đọc mạch ngoại
        for i = 1, 8 do
            local jm = ini:ReadString(nx_string("jingmai_out"), nx_string("jingmai" .. i), "")
            if jm ~= "" then
                table.insert(jingmais_out, jm)
            end
        end
        -- Đọc mạch nội boss
        for i = 1, 8 do
            local jm = ini:ReadString(nx_string("jingmai_inboss"), nx_string("jingmai" .. i), "")
            if jm ~= "" then
                table.insert(jingmais_inboss, jm)
            end
        end
        -- Đọc mạch ngoại boss
        for i = 1, 8 do
            local jm = ini:ReadString(nx_string("jingmai_outboss"), nx_string("jingmai" .. i), "")
            if jm ~= "" then
                table.insert(jingmais_outboss, jm)
            end
        end
        -- Đọc nội công
        max_neigong = ini:ReadString(nx_string("neigong"), nx_string("max"), "")
        -- Đọc file test
        testfile = ini:ReadString(nx_string("testfile"), nx_string("path"), "code.lua")
        -- Đọc bộ võ PVP
        pvptaolu = ini:ReadString(nx_string("pvp"), nx_string("taolu"), "")
        -- Đọc bình thư PVP
        pvpbinhthu = ini:ReadString(nx_string("pvp"), nx_string("binhthu"), "")
    end
    nx_destroy(ini)
    if table.getn(jingmais_in) <= 0 then
        -- Chưa thiết lập mạch nội
        form.lbl_jingmai_in.Text = nx_function("ext_utf8_to_widestr", "   Chưa thiết lập")
        form.lbl_jingmai_in.HintText = nx_widestr("")
    else
        -- Đã thiết lập mạch nội
        form.lbl_jingmai_in.Text = nx_widestr("   ") .. nx_widestr(table.getn(jingmais_in)) .. nx_function("ext_utf8_to_widestr", " mạch. Để chuột vào để xem chi tiết")
        local text = nx_widestr("")
        for i = 1, table.getn(jingmais_in) do
            text = text .. nx_widestr("<s>- ") .. util_text(nx_string(jingmais_in[i])) .. nx_widestr("<br>")
        end
        form.lbl_jingmai_in.HintText = text
    end
    if table.getn(jingmais_out) <= 0 then
        -- Chưa thiết lập mạch ngoại
        form.lbl_jingmai_out.Text = nx_function("ext_utf8_to_widestr", "   Chưa thiết lập")
        form.lbl_jingmai_out.HintText = nx_widestr("")
    else
        -- Đã thiết lập mạch ngoại
        form.lbl_jingmai_out.Text = nx_widestr("   ") .. nx_widestr(table.getn(jingmais_out)) .. nx_function("ext_utf8_to_widestr", " mạch. Để chuột vào để xem chi tiết")
        local text = nx_widestr("")
        for i = 1, table.getn(jingmais_out) do
            text = text .. nx_widestr("<s>- ") .. util_text(nx_string(jingmais_out[i])) .. nx_widestr("<br>")
        end
        form.lbl_jingmai_out.HintText = text
    end
    if table.getn(jingmais_inboss) <= 0 then
        -- Chưa thiết lập mạch nội boss
        form.lbl_jingmai_inboss.Text = nx_function("ext_utf8_to_widestr", "   Chưa thiết lập")
        form.lbl_jingmai_inboss.HintText = nx_widestr("")
    else
        -- Đã thiết lập mạch nội boss
        form.lbl_jingmai_inboss.Text = nx_widestr("   ") .. nx_widestr(table.getn(jingmais_inboss)) .. nx_function("ext_utf8_to_widestr", " mạch. Để chuột vào để xem chi tiết")
        local text = nx_widestr("")
        for i = 1, table.getn(jingmais_inboss) do
            text = text .. nx_widestr("<s>- ") .. util_text(nx_string(jingmais_inboss[i])) .. nx_widestr("<br>")
        end
        form.lbl_jingmai_inboss.HintText = text
    end
    if table.getn(jingmais_outboss) <= 0 then
        -- Chưa thiết lập mạch ngoại
        form.lbl_jingmai_outboss.Text = nx_function("ext_utf8_to_widestr", "   Chưa thiết lập")
        form.lbl_jingmai_outboss.HintText = nx_widestr("")
    else
        -- Đã thiết lập mạch ngoại
        form.lbl_jingmai_outboss.Text = nx_widestr("   ") .. nx_widestr(table.getn(jingmais_outboss)) .. nx_function("ext_utf8_to_widestr", " mạch. Để chuột vào để xem chi tiết")
        local text = nx_widestr("")
        for i = 1, table.getn(jingmais_outboss) do
            text = text .. nx_widestr("<s>- ") .. util_text(nx_string(jingmais_outboss[i])) .. nx_widestr("<br>")
        end
        form.lbl_jingmai_outboss.HintText = text
    end
    if max_neigong == "" or max_neigong == 0 then
        -- Chưa thiết lập nội công
        form.lbl_neigong.Text = nx_function("ext_utf8_to_widestr", "   Chưa thiết lập")
        form.lbl_neigong.HintText = nx_widestr("")
    else
        -- Đã thiết lập nội công
        form.lbl_neigong.Text = nx_widestr("   ") .. util_text(nx_string(max_neigong))
        form.lbl_neigong.HintText = nx_widestr("")
    end
    -- Xuất các file test
    local combobox_testfile = form.combobox_testfile
    combobox_testfile.DropListBox:ClearString()
    if combobox_testfile.DroppedDown then
        combobox_testfile.DroppedDown = false
    end
    local path = "D:\\yGame\\yCuuAmChanKinh2\\";
    local ext = "*.lua"
    local fs = nx_create("FileSearch")
    fs:SearchFile(path, ext)
    local num_file = fs:GetFileCount()
    local file_table = fs:GetFileList()
    for i = 1, num_file do
        local file_split = util_split_string(file_table[i], "_")
        if not in_array("pri.lua", file_split) and not in_array("libs.lua", file_split) then
            combobox_testfile.DropListBox:AddString(nx_widestr(file_table[i]))
        end
    end
    combobox_testfile.Text = nx_widestr(testfile)
    nx_destroy(fs)
    -- List các bộ võ PVP
    local combobox_pvptaolu = form.combobox_pvptaolu
    combobox_pvptaolu.DropListBox:ClearString()
    if combobox_pvptaolu.DroppedDown then
        combobox_pvptaolu.DroppedDown = false
    end
    --combobox_pvptaolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpTaoluText["hsd"]))
    --combobox_pvptaolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpTaoluText["cuchi"]))
    --combobox_pvptaolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpTaoluText["tuyettrai"]))
    --combobox_pvptaolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpTaoluText["cuucung"]))
	combobox_pvptaolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpTaoluText["thc"]))
    combobox_pvptaolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpTaoluText["ptc"]))
    combobox_pvptaolu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpTaoluText["ltt"]))
    if pvptaolu == "" then
        combobox_pvptaolu.Text = nx_widestr(nx_function("ext_utf8_to_widestr", "----"))
    else
        combobox_pvptaolu.Text = nx_widestr(nx_function("ext_utf8_to_widestr", pvpTaoluText[pvptaolu]))
    end
    -- List bình thư PvP trạng thái phòng thủ
    local combobox_pvpbinhthu = form.combobox_pvpbinhthu
    combobox_pvpbinhthu.DropListBox:ClearString()
    if combobox_pvpbinhthu.DroppedDown then
        combobox_pvpbinhthu.DroppedDown = false
    end
    combobox_pvpbinhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpbinhthuText[""]))
    combobox_pvpbinhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpbinhthuText["ng_ss_5_3"]))
    combobox_pvpbinhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpbinhthuText["ng_ss_5_2"]))
    combobox_pvpbinhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpbinhthuText["ng_ss_5_1"]))
    combobox_pvpbinhthu.DropListBox:AddString(nx_function("ext_utf8_to_widestr", pvpbinhthuText["zs_hs_5_1"]))
    if pvpbinhthu == "" then
        combobox_pvpbinhthu.Text = nx_widestr(nx_function("ext_utf8_to_widestr", pvpbinhthuText[""]))
    else
        combobox_pvpbinhthu.Text = nx_widestr(nx_function("ext_utf8_to_widestr", pvpbinhthuText[pvpbinhthu]))
    end
end

function on_combobox_testfile_selected(combobox)
    local form = combobox.ParentForm
    if not nx_is_valid(form) then
        return
    end
    on_btn_testfile_click(form.btn_testfile)
end

function on_combobox_pvptaolu_selected(combobox)
    local form = combobox.ParentForm
    if not nx_is_valid(form) then
        return
    end
    on_btn_pvptaolu_click(form.btn_pvptaolu)
end

function on_combobox_pvpbinhthu_selected(combobox)
    local form = combobox.ParentForm
    if not nx_is_valid(form) then
        return
    end
    on_btn_pvpbinhthu_click(form.btn_pvpbinhthu)
end

-- Lưu nội công
function on_btn_neigong_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(ini) then
        return
    end
    local section_config = "neigong"
    ini.FileName = account .. "\\yBreaker_config.ini"
    ini:LoadFromFile()
    -- Xóa cấu hình trước
    ini:DeleteSection(nx_string(section_config))
    ini:AddSection(nx_string(section_config))
    ini:WriteString(nx_string(section_config), "max", player_client:QueryProp("CurNeiGong"))
    ini:SaveToFile()
    nx_destroy(ini)
    reload_form()
    --tools_show_notice(nx_function("ext_utf8_to_widestr", "Nội công đã được lưu lại"))
end

-- Lưu mạch nội
function on_btn_jingmai_in_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    save_jingmai_config("jingmai_in")
    reload_form()
    --tools_show_notice(nx_function("ext_utf8_to_widestr", "Mạch nội đã được lưu lại"))
end

-- Lưu mạch ngoại
function on_btn_jingmai_out_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    save_jingmai_config("jingmai_out")
    reload_form()
    --tools_show_notice(nx_function("ext_utf8_to_widestr", "Mạch ngoại đã được lưu lại"))
end

-- Lưu mạch nội boss
function on_btn_jingmai_inboss_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    save_jingmai_config("jingmai_inboss")
    reload_form()
    --tools_show_notice(nx_function("ext_utf8_to_widestr", "Mạch thủ đã được lưu lại"))
end

-- Lưu mạch ngoại boss
function on_btn_jingmai_outboss_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    save_jingmai_config("jingmai_outboss")
    reload_form()
    --tools_show_notice(nx_function("ext_utf8_to_widestr", "Mạch né đã được lưu lại"))
end

-- Lưu file test
function on_btn_testfile_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(ini) then
        return
    end
    local section_config = "testfile"
    ini.FileName = account .. "\\yBreaker_config.ini"
    ini:LoadFromFile()
    -- Xóa cấu hình trước
    ini:DeleteSection(nx_string(section_config))
    ini:AddSection(nx_string(section_config))
    ini:WriteString(nx_string(section_config), "path", nx_function("ext_widestr_to_utf8", form.combobox_testfile.Text))
    ini:SaveToFile()
    nx_destroy(ini)
    reload_form()
    nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "stopAllTestFile")
    nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "tools_reload_cache")
    tools_show_notice(nx_function("ext_utf8_to_widestr", "File chạy code đã được lưu lại"))
    nx_pause(0.2)
    --on_main_form_close(form)
end

-- Lưu bộ võ pvp
function on_btn_pvptaolu_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(ini) then
        return
    end
    local section_config = "pvp"
    local taolu = ""
    ini.FileName = account .. "\\yBreaker_config.ini"
    ini:LoadFromFile()
    -- Thêm cấu hình nếu chưa có
    if not ini:FindSection(nx_string(section_config)) then
        ini:AddSection(nx_string(section_config))
    end

    -- Xác định ra key bộ võ
    if nx_widestr(form.combobox_pvptaolu.Text) == nx_function("ext_utf8_to_widestr", pvpTaoluText["hsd"]) then
        taolu = "hsd"
    --elseif nx_widestr(form.combobox_pvptaolu.Text) == nx_function("ext_utf8_to_widestr", pvpTaoluText["cuchi"]) then
    --    taolu = "cuchi"
    --elseif nx_widestr(form.combobox_pvptaolu.Text) == nx_function("ext_utf8_to_widestr", pvpTaoluText["tuyettrai"]) then
    --    taolu = "tuyettrai"
    --elseif nx_widestr(form.combobox_pvptaolu.Text) == nx_function("ext_utf8_to_widestr", pvpTaoluText["cuucung"]) then
    --    taolu = "cuucung"
	elseif nx_widestr(form.combobox_pvptaolu.Text) == nx_function("ext_utf8_to_widestr", pvpTaoluText["thc"]) then
        taolu = "thc"
    elseif nx_widestr(form.combobox_pvptaolu.Text) == nx_function("ext_utf8_to_widestr", pvpTaoluText["ptc"]) then
        taolu = "ptc"
    elseif nx_widestr(form.combobox_pvptaolu.Text) == nx_function("ext_utf8_to_widestr", pvpTaoluText["ltt"]) then
        taolu = "ltt"
    end

    ini:WriteString(nx_string(section_config), "taolu", taolu)
    ini:SaveToFile()
    nx_destroy(ini)
    reload_form()
    nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "stopAllTestFile")
    nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "tools_reload_cache")
    nx_execute("admin_yBreaker\\yBreaker_events_gui\\yBreaker_form_pvp", "resetTaolu", taolu)
    tools_show_notice(nx_function("ext_utf8_to_widestr", "Bộ võ PvP đã được lưu lại"))
    nx_pause(0.2)
    --on_main_form_close(form)
end

-- Lưu bình thư PVP
function on_btn_pvpbinhthu_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(ini) then
        return
    end
    local section_config = "pvp"
    local binhthu = ""
    ini.FileName = account .. "\\yBreaker_config.ini"
    ini:LoadFromFile()
    -- Thêm cấu hình nếu chưa có
    if not ini:FindSection(nx_string(section_config)) then
        ini:AddSection(nx_string(section_config))
    end

    -- Xác định ra key bình thư
    if nx_widestr(form.combobox_pvpbinhthu.Text) == nx_function("ext_utf8_to_widestr", pvpbinhthuText["ng_ss_5_3"]) then
        binhthu = "ng_ss_5_3"
    elseif nx_widestr(form.combobox_pvpbinhthu.Text) == nx_function("ext_utf8_to_widestr", pvpbinhthuText["ng_ss_5_2"]) then
        binhthu = "ng_ss_5_2"
    elseif nx_widestr(form.combobox_pvpbinhthu.Text) == nx_function("ext_utf8_to_widestr", pvpbinhthuText["ng_ss_5_1"]) then
        binhthu = "ng_ss_5_1"
    elseif nx_widestr(form.combobox_pvpbinhthu.Text) == nx_function("ext_utf8_to_widestr", pvpbinhthuText["zs_hs_5_1"]) then
        binhthu = "zs_hs_5_1"
    end

    ini:WriteString(nx_string(section_config), "binhthu", binhthu)
    ini:SaveToFile()
    nx_destroy(ini)
    reload_form()
    nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "stopAllTestFile")
    nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "tools_reload_cache")
    -- nx_execute("admin_yBreaker\\yBreaker_events_gui\\yBreaker_form_pvp", "resetBinhThu", binhthu)
    tools_show_notice(nx_function("ext_utf8_to_widestr", "Bình thư PvP ở dạng phòng ngự đã được lưu lại"))
    nx_pause(0.2)
    --on_main_form_close(form)
end

-- Xóa cache
function on_btn_reload_cache_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
    nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs", "tools_reload_cache")
    tools_show_notice(nx_function("ext_utf8_to_widestr", "Cache đã được xóa. Dữ liệu sẽ được đọc lại từ tập tin cấu hình"))
end

-----------------------------------
-- Lưu lại mạch nội hay mạch ngoại đánh người đánh boss
-- type: jingmai_in, jingmai_out
function save_jingmai_config(type)
    local game_config = nx_value("game_config")
    local account = game_config.login_account
    local ini = nx_create("IniDocument")
    local game_client = nx_value("game_client")
    local player_client = game_client:GetPlayer()
    if not nx_is_valid(ini) then
        return
    end
    ini.FileName = account .. "\\yBreaker_config.ini"
    ini:LoadFromFile()
    -- Xóa cấu hình trước
    ini:DeleteSection(nx_string(type))
    ini:AddSection(nx_string(type))
    -- Ghi dữ liệu
    local total = player_client:GetRecordRows("active_jingmai_rec")
    if total > 0 then
        for i = 1, total do
            local jingmai = player_client:QueryRecord("active_jingmai_rec", i - 1, "")
            if jingmai ~= "" then
                ini:WriteString(nx_string(type), "jingmai" .. i, jingmai)
            end
        end
    end
    ini:SaveToFile()
    nx_destroy(ini)
end

function show_hide_form_config()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_config")
end
