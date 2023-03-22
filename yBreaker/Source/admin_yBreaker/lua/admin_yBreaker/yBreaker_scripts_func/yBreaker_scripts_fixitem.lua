require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

-- Funciton to get fix item index
function get_fix_item_index()
    local i = find_item_index_from_VatPham("fixitem_004")
    if i > 0 then
        return i
    end
    i = find_item_index_from_VatPham("fixitem_003")
    if i > 0 then
        return i
    end
    return find_item_index_from_VatPham("fixitem_002")
end

-- Function fix equipped item
local timer_fix_equipped_item = 0
function fix_equipped_item_hardiness()
    if TimerDiff(timer_fix_equipped_item) < 5 then
        yBreaker_show_WstrText(util_text("Slow down"))
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
	
    local timer_fix_equipped_item = TimerInit()
    for i = 1, 100 do
        local item = equip:GetViewObj(nx_string(i))
        if nx_is_valid(item) and nx_number(item:QueryProp("Hardiness")) <= threshhold then
            local fix_item_index = get_fix_item_index()
            if fix_item_index == 0 then
                return
            end
            nx_execute("custom_sender", "custom_use_item_on_item", 2, fix_item_index, 1, i)
            nx_pause(0.05)
        end
    end
end