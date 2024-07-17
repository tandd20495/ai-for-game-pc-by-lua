require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

-- Funciton to get fix item index
function get_fixitem_index()
    local i = yBreaker_find_item_index_from_ItemBag("fixitem_004")
    if i > 0 then
        return i
    end
    i = yBreaker_find_item_index_from_ItemBag("fixitem_003")
    if i > 0 then
        return i
    end
    return yBreaker_find_item_index_from_ItemBag("fixitem_002")
end

-- Function fix equipped 
local timer_fix_equipped_item = 0
function fix_equipped_items_durability()
    if yBreaker_time_diff(timer_fix_equipped_item) < 5 then
        yBreaker_show_Utf8Text("Đại hiệp thong thả một chút!")
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
	
    local timer_fix_equipped_item = yBreaker_time_init()
    for i = 1, 100 do
        local item = equip:GetViewObj(nx_string(i))
        if nx_is_valid(item) and nx_number(item:QueryProp("Hardiness")) <= threshhold then
            local fixitem_index = get_fixitem_index()
            if fixitem_index == 0 then
                return
            end
            nx_execute("custom_sender", "custom_use_item_on_item", 2, fixitem_index, 1, i)
            nx_pause(0.05)
        end
    end
	yBreaker_show_Utf8Text("Không còn trang bị nào trên người cần sửa!")
end