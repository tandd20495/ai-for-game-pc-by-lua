require("util_gui")
require("util_functions")
require("admin_zdn\\zdn_util")
require("admin_zdn\\zdn_lib_moving")

local Running = false
local TimerOpenForm = 0
local FORM_PATH = "form_stage_main\\form_stall\\form_stall_main"
local Map = ""
local POS = {
    ["city05"] = {768.79962158203, 23.008995056152, 664.23419189453}, -- thanh do
    ["city02"] = {435.81137084961, 0.62966793775558, 654.34759521484} -- to chau
}

function OnZdnSwitchShopping247()
    Running = not Running
    if Running then
        saveAndSetMap()
        start()
    else
        stop()
    end
end

function IsRunning()
    return Running
end

function OnSaveShopConfig(btn)
    local form = btn.Parent
    if not nx_is_valid(form) or not form.Visible then
        return
    end
    local grid = form.page_sell.sell_grid
    local str = getStrConfig(grid, 110)
    if str ~= "" then
        IniWriteUserConfig("BayBan", "Sell", str)
    end
    grid = form.page_buy.buy_grid
    str = getStrConfig(grid, 108)
    IniWriteUserConfig("BayBan", "Buy", str)
end

function OnLoadShopConfig(btn)
    local form = btn.Parent
    if not nx_is_valid(form) or not form.Visible then
        return
    end

    -- sell
    local str = nx_string(IniReadUserConfig("BayBan", "Sell", ""))
    if str == "" then
        return
    end
    local itemList = util_split_string(str, ";")
    local cnt = #itemList
    for i = 1, cnt do
        local item = util_split_string(itemList[i], ",")
        if not hasItemInStall(110, item[1]) then
            local viewPort = getViewPortFromViewId(item[2])
            local idx = nx_execute("admin_zdn\\zdn_logic_vat_pham", "FindNotBoundItemIndexFromViewPort", viewPort, item[1])
            if idx ~= 0 then
                local obj = nx_execute("admin_zdn\\zdn_logic_vat_pham", "GetItemFromViewportById", viewPort, idx)
                if nx_is_valid(obj) then
                    local emptyIdx = getEmptyIndex(form.page_sell.sell_grid)
                    if emptyIdx > 0 then
                        nx_execute(
                            "form_stage_main\\form_stall\\form_stall_sell",
                            "custom_offline_sell_add_item",
                            viewPort,
                            idx,
                            emptyIdx,
                            item[3],
                            getAmount(obj, nx_number(item[4])),
                            obj
                        )
                    end
                end
            end
        end
    end

    -- buy
    str = nx_string(IniReadUserConfig("BayBan", "Buy", ""))
    if str == "" then
        return
    end
    itemList = util_split_string(str, ";")
    cnt = #itemList
    for i = 1, cnt do
        local item = util_split_string(itemList[i], ",")
        if not hasItemInStall(108, item[1]) then
            local emptyIdx = getEmptyIndex(form.page_buy.buy_grid)
            if emptyIdx > 0 then
                nx_execute(
                    "form_stage_main\\form_stall\\form_stall_buy",
                    "custom_set_purchase_item",
                    emptyIdx,
                    item[1],
                    item[4],
                    item[3]
                )
            end
        end
    end
end

-- private
function updateView(rng)
    local form = nx_value(FORM_PATH)
    if rng then
        if nx_is_valid(form) and form.Visible then
            form.btn_zdn_247.Text = Utf8ToWstr("Dừng")
            form.btn_zdn_247.ForeColor = "255,220,20,60"
        end
    else
        if nx_is_valid(form) and form.Visible then
            form.btn_zdn_247.Text = Utf8ToWstr("Bày hàng 24/7")
            form.btn_zdn_247.ForeColor = "255,255,255,255"
        end
    end
end

function start()
    local form = nx_value(FORM_PATH)
    if nx_is_valid(form) and form.Visible and form.btn_online_stall.Enabled then
        OnSaveShopConfig(form.zdn_save_config_btn)
    end
    updateView(true)
    while Running do
        loopShopping()
        nx_pause(2)
    end
end

function stop()
    updateView(false)
    Running = false
end

function loopShopping()
    if IsMapLoading() then
        return
    end
    if Map ~= "" and GetCurMap() ~= Map then
        GoToMapByPublicHomePoint(Map)
        return
    end

    local cF = nx_value("form_common\\form_confirm")
    if nx_is_valid(cF) and cF.Visible then
        nx_execute("form_common\\form_confirm", "ok_btn_click", cF.ok_btn)
        return
    end
    if TimerDiff(TimerOpenForm) < 2 then
        return
    end
    local form = nx_value(FORM_PATH)
    if TimerDiff(TimerOpenForm) < 3 then
        if nx_is_valid(form) and form.Visible and form.btn_online_stall.Enabled then
            OnLoadShopConfig(form.zdn_load_config_btn)
            TimerOpenForm = 0
            return
        end
    end
    thuVuKhi()
    if not nx_is_valid(form) or not form.Visible then
        TimerOpenForm = TimerInit()
        util_show_form(FORM_PATH, true)
        return
    end

    if Map ~= "" then
        if needGoToPos(form) then
            GoToPosition(POS[Map][1], POS[Map][2], POS[Map][3])
            return
        else
            StopFindPath()
        end
    end

    if not nx_is_valid(form) then
        return
    end
    if nx_find_custom(form, "btn_online_stall") and form.btn_online_stall.Enabled then
        nx_execute(FORM_PATH, "on_btn_online_stall_click", form.btn_online_stall)
    end
end

function getStrConfig(grid, viewPort)
    local client = nx_value("game_client")
    local view = client:GetView(nx_string(viewPort))
    if not nx_is_valid(view) then
        return
    end
    local str = ""
    for i = 1, 70 do
        local obj = view:GetViewObj(nx_string(i))
        if nx_is_valid(obj) then
            local price = obj:QueryProp("StallPrice1")
            local cnt = obj:QueryProp("SellCount")
            if viewPort == 108 then
                price = obj:QueryProp("PurchasePrice1")
                cnt = obj:QueryProp("BuyCountAll")
            end
            if str ~= "" then
                str = str .. ";"
            end
            str =
                str ..
                obj:QueryProp("ConfigID") ..
                    "," .. nx_string(obj:QueryProp("ViewID")) .. "," .. nx_string(price) .. "," .. nx_string(cnt)
        end
    end
    return str
end

function hasItemInStall(viewPort, configId)
    local client = nx_value("game_client")
    local view = client:GetView(nx_string(viewPort))
    if not nx_is_valid(view) then
        return false
    end
    local str = ""
    for i = 1, 70 do
        local obj = view:GetViewObj(nx_string(i))
        if nx_is_valid(obj) and obj:QueryProp("ConfigID") == configId then
            return true
        end
    end
    return false
end

function getViewPortFromViewId(viewId)
    if nx_number(viewId) == 2 then
        return 121
    end
    if nx_number(viewId) == 1 then
        return 2
    end
    if nx_number(viewId) == 3 then
        return 123
    end
    if nx_number(viewId) == 4 then
        return 125
    end
    return 2
end

function getEmptyIndex(grid)
    for i = 1, 100 do
        if not grid:IsEmpty(i) then
            return i
        end
    end
    return 0
end

function getAmount(obj, cnt)
    local c = obj:QueryProp("Amount")
    if c < cnt then
        return c
    end
    return cnt
end

function saveAndSetMap()
    local form = nx_value(FORM_PATH)
    if not nx_is_valid(form) then
        return
    end
    local mapTxt = form.zdn_map_input.Text
    if mapTxt == Utf8ToWstr("Thành Đô") then
        IniWriteUserConfig("BayBan", "Map", "city05")
        Map = "city05"
    elseif mapTxt == Utf8ToWstr("Tô Châu") then
        IniWriteUserConfig("BayBan", "Map", "city02")
        Map = "city02"
    else
        Map = ""
        ShowText("Map không khả dụng. Hiện chỉ hỗ trợ Thành Đô và Tô Châu")
        ShowText("Bắt đầu Bày hàng 24/7 tại vị trí hiện tại")
    end
end

function needGoToPos(form)
    if not nx_is_valid(form) then
        return true
    end
    if nx_string(form.lbl_stall_pos.Text) == "@ui_stall_out" then
        form:Close()
        return true
    end
    return false
end

function thuVuKhi()
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return
    end
    local player = client:GetPlayer()
    if not nx_is_valid(player) then
        return
    end
    local LS_WARNING = 2
    if nx_number(player:QueryProp("LogicState")) == LS_WARNING then
        nx_execute("admin_zdn\\zdn_logic_skill", "NgoiThien")
    else
        nx_execute("admin_zdn\\zdn_logic_skill", "StopNgoiThien")
    end
end
