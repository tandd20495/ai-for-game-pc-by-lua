require("util_functions")
require("admin_zdn\\zdn_util")

local function zdnAdd247Btn(form)
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return
    end
    local btn = gui:Create("Button")
    form:Add(btn)
    form.btn_zdn_247 = btn

    btn.NormalImage = "gui\\common\\button\\btn_normal2_out.png"
    btn.FocusImage = "gui\\common\\button\\btn_normal2_on.png"
    btn.PushImage = "gui\\common\\button\\btn_normal2_down.png"
    btn.Font = "font_btn"
    btn.Left = 173
    btn.Top = 585
    btn.Width = 110
    btn.Height = 29
    btn.TabStop = "true"
    btn.AutoSize = "true"
    btn.DrawMode = "ExpandH"
    if nx_execute("admin_zdn\\zdn_logic_shop", "IsRunning") then
        btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
        btn.ForeColor = "255,220,20,60"
    else
        btn.Text = nx_function("ext_utf8_to_widestr", "Bày hàng 24/7")
        btn.ForeColor = "255,255,255,255"
    end
    nx_bind_script(btn, "admin_zdn\\zdn_logic_shop")
    nx_callback(btn, "on_click", "OnZdnSwitchShopping247")
end

local function zdnCreateBtn(left, top, txt)
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return
    end
    local btn = gui:Create("Button")
    btn.NormalImage = "gui\\common\\button\\btn_normal2_out.png"
    btn.FocusImage = "gui\\common\\button\\btn_normal2_on.png"
    btn.PushImage = "gui\\common\\button\\btn_normal2_down.png"
    btn.Font = "font_btn"
    btn.Left = left
    btn.Top = top
    btn.Width = 90
    btn.Height = 25
    btn.TabStop = "true"
    btn.AutoSize = "true"
    btn.DrawMode = "ExpandH"
    btn.Text = nx_function("ext_utf8_to_widestr", txt)
    btn.ForeColor = "255,255,255,255"
    return btn
end

local function zdnAddSaveLoadBtn(form)
    local btn = zdnCreateBtn(270, 245, "Lưu")
    form:Add(btn)
    form.zdn_save_config_btn = btn
    nx_bind_script(btn, "admin_zdn\\zdn_logic_shop")
    nx_callback(btn, "on_click", "OnSaveShopConfig")

    btn = zdnCreateBtn(380, 245, "Tải")
    form:Add(btn)
    form.zdn_load_config_btn = btn
    nx_bind_script(btn, "admin_zdn\\zdn_logic_shop")
    nx_callback(btn, "on_click", "OnLoadShopConfig")
end

local function zdnAddInput(form)
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return
    end
    if not nx_is_valid(form) or not form.Visible then
        return
    end
    local map = nx_string(IniReadUserConfig("BayBan", "Map", "city05"))
    local input = gui:Create("Edit")
    form:Add(input)
    form.zdn_map_input = input

    input.Left = 70
    input.Top = 588
    input.Width = 100
    input.Height = 25
    input.DragStep = "1.000000"
    input.ChangedEvent = true
    input.TextOffsetX = "2"
    input.Align = "Center"
    input.SelectBackColor = "190,190,190,190"
    input.Caret = "Default"
    input.ForeColor = "255,255,255,255"
    input.ShadowColor = "0,0,0,0"
    input.Font = "font_main"
    input.Cursor = "WIN_IBEAM"
    input.TabStop = "true"
    input.DrawMode = "ExpandH"
    input.BackImage = "gui\\common\\form_line\\ibox_1.png"
    input.Text = util_text(map)
end

local function zdnAddLabel(form)
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return
    end
    if not nx_is_valid(form) or not form.Visible then
        return
    end
    local lbl = gui:Create("Label")
    form:Add(lbl)

    lbl.RefCursor = "WIN_HELP"
    lbl.Left = 37
    lbl.Top = 594
    lbl.Width = 40
    lbl.Height = 13
    lbl.ForeColor = "255,128,101,74"
    lbl.ShadowColor = "0,255,0,0"
    lbl.Text = Utf8ToWstr("Map:")
    lbl.Font = "font_text"
end

function on_main_form_open(form)
    if not Stall_Fortunetell_Mutual(form, 0) then
        return
    end
    update_form_pos(form)
    if not on_init_info(form) then
        return
    end
    custom_request_stall(form)
    form.rbtn_shougou.Checked = true
    form.rbtn_chushou.Checked = true
    form.Visible = true
    local dialog = nx_execute("util_gui", "util_get_form", "form_stage_main\\form_stall\\form_stall_tip", false, false)
    if nx_is_valid(dialog) then
        dialog:Close()
    end
    local databinder = nx_value("data_binder")
    if nx_is_valid(databinder) then
        databinder:AddViewBind(
            VIEWPORT_OFFLINE_SELL_BOX,
            form,
            "form_stage_main\\form_stall\\form_stall_main",
            "on_sellbox_viewport_change"
        )
    end
    zdnAddSaveLoadBtn(form)
    zdnAddLabel(form)
    zdnAddInput(form)
    zdnAdd247Btn(form)
    return 1
end
