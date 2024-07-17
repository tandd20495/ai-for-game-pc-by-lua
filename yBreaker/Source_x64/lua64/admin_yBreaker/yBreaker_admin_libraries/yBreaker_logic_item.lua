require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_util")
require("util_functions")

local ItemList = {}
local Running = false
local TimerCurseLoading = 0
local FORM_DROPPICK_PATH = "form_stage_main\\form_pick\\form_droppick"
local FORM_CLONE_AWARDS_PATH = "form_stage_main\\form_clone_awards"
local FORM_DICE = "form_stage_main\\form_dice"
local PickItemData = {}
local TimerFixEquippedItem = 0
local TimerDeleteItem = 0
local TimerDice = 0
local PickMode = 0
local Processing = false

function Start()
    if not loadConfig() then
        return
    end
    Running = true
    Processing = false
    while Running do
        loopVatPham()
        nx_pause(0.1)
    end
end

function IsRunning()
    return Running
end

function CanRun()
	return UseItem()
end

function IsTaskDone()
    return not CanRun()
end

function Stop()
    Running = false
    Processing = false
    nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_event_manager", "TriggerEvent", nx_current(), "on-task-stop")
end

function IsDroppickShowed()
    local form = nx_value(FORM_DROPPICK_PATH)
    if nx_is_valid(form) and form.Visible then
        return true
    end
    local l = getDiceFormList()
    return #l > 0
end

function IsCloneAwardsShowed()
    local form = nx_value(FORM_CLONE_AWARDS_PATH)
    return nx_is_valid(form) and form.Visible
end

function PickItemFromPickItemDataClone()
    if not IsCloneAwardsShowed() then
        return
    end
    local l = getDiceFormList()
    if #l > 0 then
        diceItem(l)
        return
    end
    local form = nx_value(FORM_CLONE_AWARDS_PATH)
    local cnt = form.nMaxIndexCount
    local timeOut = TimerInit()
    while cnt == 0 and TimerDiff(timeOut) < 1.5 do
        if not nx_is_valid(form) or not form.Visible or not nx_find_custom(form, "nMaxIndexCount") then
            break
        end
        cnt = form.nMaxIndexCount
        nx_pause(0)
    end
    timeOut = TimerInit()
    while nx_is_valid(form) and form.Visible and TimerDiff(timeOut) < 1.5 do
        cnt = form.nMaxIndexCount
        if cnt == 0 then
            break
        end
        local l = getCanPickItemIndexList(127)
        local cnt = #l
        if cnt == 0 then
            break
        end
        for i = 1, cnt do
            nx_execute("custom_sender", "custom_pickup_cloneitem", l[i])
        end
        nx_pause(0)
    end
    if nx_is_valid(form) and form.Visible then
        nx_execute(FORM_CLONE_AWARDS_PATH, "on_btn_min_click", form.btn_min)
    end
end

function PickAllDropItem()
    if not IsDroppickShowed() then
        return
    end
    local l = getDiceFormList()
    if #l > 0 then
        diceItem(l)
        return
    end
    local form = nx_value(FORM_DROPPICK_PATH)
    local cnt = form.nMaxIndexCount
    local timeOut = TimerInit()
    while cnt == 0 and TimerDiff(timeOut) < 1.5 do
        if not nx_is_valid(form) or not form.Visible or not nx_find_custom(form, "nMaxIndexCount") then
            break
        end
        cnt = form.nMaxIndexCount
        nx_pause(0)
    end
    for i = 1, cnt do
        nx_execute("custom_sender", "custom_pickup_single_item", i)
    end
    timeOut = TimerInit()
    while nx_is_valid(form) and form.Visible and cnt > 0 and TimerDiff(timeOut) < 1.5 do
        cnt = form.nMaxIndexCount
        nx_pause(0)
    end
    nx_execute("custom_sender", "custom_close_drop_box")
end

function PickItemFromPickItemData()
    if not IsDroppickShowed() then
        return
    end
    local l = getDiceFormList()
    if #l > 0 then
        diceItem(l)
        return
    end
    local form = nx_value(FORM_DROPPICK_PATH)
    if not nx_is_valid(form) or not form.Visible then
        return
    end
    local cnt = form.nMaxIndexCount
    local timeOut = TimerInit()
    while cnt == 0 and TimerDiff(timeOut) < 1.5 do
        if not nx_is_valid(form) or not form.Visible or not nx_find_custom(form, "nMaxIndexCount") then
            break
        end
        cnt = form.nMaxIndexCount
        nx_pause(0)
    end
    timeOut = TimerInit()
    while nx_is_valid(form) and form.Visible and TimerDiff(timeOut) < 1.5 do
        cnt = form.nMaxIndexCount
        if cnt == 0 then
            break
        end
        local l = getCanPickItemIndexList(80)
        local cnt = #l
        if cnt == 0 then
            break
        end
        for i = 1, cnt do
            nx_execute("custom_sender", "custom_pickup_single_item", l[i])
        end
        nx_pause(0)
    end
    nx_execute("custom_sender", "custom_close_drop_box")
end

function PickAllDropItemWithExclude()
    if not IsDroppickShowed() then
        return
    end
    local l = getDiceFormList()
    if #l > 0 then
        diceItem(l)
        return
    end
    local form = nx_value(FORM_DROPPICK_PATH)
    if not nx_is_valid(form) or not form.Visible then
        return
    end
    local cnt = form.nMaxIndexCount
    local timeOut = TimerInit()
    while cnt == 0 and TimerDiff(timeOut) < 1.5 do
        if not nx_is_valid(form) or not form.Visible or not nx_find_custom(form, "nMaxIndexCount") then
            break
        end
        cnt = form.nMaxIndexCount
        nx_pause(0)
    end
    timeOut = TimerInit()
    while nx_is_valid(form) and form.Visible and TimerDiff(timeOut) < 1.5 do
        cnt = form.nMaxIndexCount
        if cnt == 0 then
            break
        end
        local l = getCanPickItemIndexList(80)
        local cnt = #l
        if cnt == 0 then
            break
        end
        for i = 1, cnt do
            nx_execute("custom_sender", "custom_pickup_single_item", l[i])
        end
        nx_pause(0)
    end
    nx_execute("custom_sender", "custom_close_drop_box")
end

function FindItemIndexFromVatPham(configId)
    return FindItemIndexFromViewPort(2, configId)
end

function FindItemIndexFromNhiemVu(configId)
    return FindItemIndexFromViewPort(125, configId)
end

function UseItem(viewPort, index)
    if index ~= 0 and not isCurseLoading() then
        nx_execute("custom_sender", "custom_use_item", viewPort, index)
        return true
    end
    return false
end

function UseWeapon(index)
    if index ~= 0 then
        local grid = nx_value("GoodsGrid")
        if not nx_is_valid(grid) then
            return
        end
        grid:ViewUseItem(121, index, "", "")
    end
end

function FindFirstBoundItemIndexByItemType(viewPort, itemType)
    local client = nx_value("game_client")
    local view = client:GetView(nx_string(viewPort))
    if not nx_is_valid(view) then
        return 0
    end
    for i = 1, 100 do
        local obj = view:GetViewObj(nx_string(i))
        if
            nx_is_valid(obj) and nx_string(obj:QueryProp("BindStatus")) == "1" and
                nx_number(obj:QueryProp("ItemType")) == nx_number(itemType)
         then
            return i
        end
    end
    return 0
end

function FindFirstBoundItemIndexByConfigId(viewPort, configId)
    local client = nx_value("game_client")
    local view = client:GetView(nx_string(viewPort))
    if not nx_is_valid(view) then
        return 0
    end
    for i = 1, 100 do
        local obj = view:GetViewObj(nx_string(i))
        if
            nx_is_valid(obj) and nx_string(obj:QueryProp("BindStatus")) == "1" and
                nx_string(obj:QueryProp("ConfigID")) == nx_string(configId)
         then
            return i
        end
    end
    return 0
end

function GetCurrentWeapon()
    local client = nx_value("game_client")
    if not nx_is_valid(client) then
        return
    end
    local equip = client:GetView("1")
    if not nx_is_valid(equip) then
        return
    end
    return equip:GetViewObj("22")
end

function LoadPickItemData()
    PickMode = nx_number(IniReadUserConfig("VatPham", "Mode", 0))
    local key = "Pick"
    if PickMode == 1 then
        key = "Exclude"
    end
    PickItemData = {}
    local itemStr = IniReadUserConfig("VatPham", key, "")
    if itemStr ~= "" then
        local itemList = util_split_string(nx_string(itemStr), ";")
        for _, item in pairs(itemList) do
            local prop = util_split_string(item, ",")
            if prop[1] == "1" then
                table.insert(PickItemData, util_text(prop[2]))
            end
        end
    end
end

function FixEquippedItemHardiness()
    if TimerDiff(TimerFixEquippedItem) < 5 then
        ShowText("Đại hiệp xin dừng tay trong ít phút!")
        return
    end
    local client = nx_value("game_client")
    local threshhold = 50
    if not nx_is_valid(client) then
        return
    end
    local equip = client:GetView("1")
    if not nx_is_valid(equip) then
        return
    end
    TimerFixEquippedItem = TimerInit()
    for i = 1, 100 do
        local item = equip:GetViewObj(nx_string(i))
        if nx_is_valid(item) and nx_number(item:QueryProp("Hardiness")) <= threshhold then
            local fixItemIndex = getFixItemIndex()
            if fixItemIndex == 0 then
                return
            end
            nx_execute("custom_sender", "custom_use_item_on_item", 2, fixItemIndex, 1, i)
            nx_pause(0.05)
        end
    end
end

function GetItemPhoto(itemId)
    local toolItemIni = nx_execute("util_functions", "get_ini", "share\\item\\tool_item.ini")
    if not nx_is_valid(toolItemIni) then
        return ""
    end
    local sectionIndexNumber = toolItemIni:FindSectionIndex(itemId)
    if sectionIndexNumber < 0 then
        return ""
    end
    return toolItemIni:ReadString(sectionIndexNumber, "Photo", "")
end

function FlexPickItem()
    if Processing then
        return
    end
    Processing = true
    if PickMode == 0 then
        PickItemFromPickItemData()
    else
        PickAllDropItemWithExclude()
    end
    Processing = false
end

function CanUseNoiTuItem(buffId)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
        return true
    end
    local client_player = game_client:GetPlayer()
    if not nx_is_valid(client_player) then
        return true
    end
    local buffer_effect = nx_value("BufferEffect")
    if not nx_is_valid(buffer_effect) then
        return true
    end
    if not client_player:FindRecord("AddWuXueFacultyBufferRec") then
        return true
    end
    local v = 0
    local rownum = client_player:GetRecordRows("AddWuXueFacultyBufferRec")
    for i = 0, rownum - 1 do
        local index = client_player:QueryRecord("AddWuXueFacultyBufferRec", i, 0)
        local b = buffer_effect:GetBufferDescIDByIndex(1, index)
        local l = util_split_wstring(util_text(b), nx_widestr(" "))
        for i = 1, #l do
            v = v + nx_number(l[i])
        end
    end
    local l2 = util_split_wstring(util_text(buffId), nx_widestr(" "))
    for i = 1, #l2 do
        v = v + nx_number(l2[i])
    end
    return v <= 1000
end

function GetItemFromViewportById(viewPort, id)
    local client = nx_value("game_client")
    local view = client:GetView(nx_string(viewPort))
    if not nx_is_valid(view) then
        return
    end
    return view:GetViewObj(nx_string(id))
end

function FindItemIndexFromViewPort(viewPort, configId)
    local client = nx_value("game_client")
    local view = client:GetView(nx_string(viewPort))
    if not nx_is_valid(view) then
        return 0
    end
    for i = 1, 100 do
        local obj = view:GetViewObj(nx_string(i))
        if nx_is_valid(obj) then
            if nx_string(obj:QueryProp("ConfigID")) == configId then
                return i
            end
        end
    end
    return 0
end

function FindNotBoundItemIndexFromViewPort(viewPort, configId)
    local client = nx_value("game_client")
    local view = client:GetView(nx_string(viewPort))
    if not nx_is_valid(view) then
        return 0
    end
    for i = 1, 100 do
        local obj = view:GetViewObj(nx_string(i))
        if nx_is_valid(obj) then
            if nx_string(obj:QueryProp("ConfigID")) == configId and nx_string(obj:QueryProp("BindStatus")) ~= "1" then
                return i
            end
        end
    end
    return 0
end

-- private
function loopVatPham()
    if IsDroppickShowed() then
        PickAllDropItem()
        return
    end

    for _, item in pairs(ItemList) do
        if IsDroppickShowed() then
            PickAllDropItem()
        end
        local flg = true
        if item.itemId == "item_wqlk_01" then
            local hr = nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_logic_base", "GetCurrentHour")
            if hr < 21 or hr > 22 then
                flg = false
            end
        end
        if flg and not nx_execute("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_logic_skill", "HaveBuff", item.buffId) then
            if not item.noiTuFlg or CanUseNoiTuItem(item.buffId) then
                local index = FindItemIndexFromVatPham(item.itemId)
                if UseItem(2, index) then
                    nx_pause(0.1)
                end
            end
        end
    end
end

function loadConfig()
    ItemList = {}
    local loaded = false
    local itemStr = IniReadUserConfig("VatPham", "List", "")
    if itemStr ~= "" then
        local itemList = util_split_string(nx_string(itemStr), ";")
        for _, item in pairs(itemList) do
            local prop = util_split_string(item, ",")
            if prop[1] == "1" then
                local item = {}
                item.itemId = prop[2]
                item.buffId = prop[3]
                item.noiTuFlg = false
                if item.buffId == prop[4] then
                    item.noiTuFlg = true
                end
                table.insert(ItemList, item)
                loaded = true
            end
        end
    end
    return loaded
end

function isCurseLoading()
    local load = nx_value("form_stage_main\\form_main\\form_main_curseloading")
    if nx_is_valid(load) and load.Visible then
        TimerCurseLoading = TimerInit()
    end
    return TimerDiff(TimerCurseLoading) < 0.5
end

function getCanPickItemIndexList(viewPort)
    local lst = {}
    for i = 1, 100 do
        local obj = GetItemFromViewportById(viewPort, i)
        if nx_is_valid(obj) then
            if PickMode == 0 and isItemInPickItemData(obj) then
                table.insert(lst, i)
            end
            if PickMode == 1 and not isItemInPickItemData(obj) then
                table.insert(lst, i)
            end
        end
    end
    return lst
end

function isItemInPickItemData(obj)
    if not nx_is_valid(obj) then
        return false
    end
    local cnt = #PickItemData
    for i = 1, cnt do
        if util_text(nx_string(obj:QueryProp("ConfigID"))) == PickItemData[i] then
            return true
        end
        if PickItemData[i] == util_text("item_vo_hoc") and nx_string(obj:QueryProp("ItemType")) == "23" then
            return true
        end
    end
    return false
end

function getFixItemIndex()
    local i = FindItemIndexFromVatPham("fixitem_004")
    if i > 0 then
        return i
    end
    i = FindItemIndexFromVatPham("fixitem_003")
    if i > 0 then
        return i
    end
    return FindItemIndexFromVatPham("fixitem_002")
end

-- hien k dung
function deleteExcludeItem()
    TimerDeleteItem = TimerInit()
    local cnt = #PickItemData
    -- trang bi
    for i = 1, cnt do
        local client = nx_value("game_client")
        local view = client:GetView(nx_string(121))
        if not nx_is_valid(view) then
            return 0
        end
        for i = 1, 100 do
            local obj = view:GetViewObj(nx_string(i))
            if nx_is_valid(obj) and isItemInPickItemData(obj:QueryProp("ConfigID")) then
                nx_execute("custom_sender", "custom_delete_item", 123, i, 100)
            end
        end
    end
    -- vp
    for i = 1, cnt do
        local client = nx_value("game_client")
        local view = client:GetView(nx_string(2))
        if not nx_is_valid(view) then
            return 0
        end
        for i = 1, 100 do
            local obj = view:GetViewObj(nx_string(i))
            if nx_is_valid(obj) and isItemInPickItemData(obj:QueryProp("ConfigID")) then
                nx_execute("custom_sender", "custom_delete_item", 2, i, 100)
            end
        end
    end
    -- nguyen lieu
    for i = 1, cnt do
        local client = nx_value("game_client")
        local view = client:GetView(nx_string(123))
        if not nx_is_valid(view) then
            return 0
        end
        for i = 1, 100 do
            local obj = view:GetViewObj(nx_string(i))
            if nx_is_valid(obj) and isItemInPickItemData(obj:QueryProp("ConfigID")) then
                nx_execute("custom_sender", "custom_delete_item", 123, i, 100)
            end
        end
    end
end

function getDiceFormList()
    local list = {}
    local gui = nx_value("gui")
    if not nx_is_valid(gui) then
        return
    end
    local childlist = gui.Desktop:GetChildControlList()
    for i = 1, #childlist do
        local control = childlist[i]
        if nx_is_valid(control) and nx_script_name(control) == "form_stage_main\\form_dice" then
            table.insert(list, control)
        end
    end
    return list
end

function diceItem(l)
    if TimerDiff(TimerDice) < 1 then
        return
    end
    for i = 1, #l do
        local form = l[i]
        local cId = nx_custom(form.item_array_data, "ConfigID")
        if PickMode == 0 and isItemInPickItemData(cId) then
            nx_execute(FORM_DICE, "return_choice", form, 1)
        elseif PickMode == 1 and not isItemInPickItemData(cId) then
            nx_execute(FORM_DICE, "return_choice", form, 1)
        else
            nx_execute(FORM_DICE, "return_choice", form, 0)
        end
    end
end
