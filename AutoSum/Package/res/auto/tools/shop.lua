function auto_shop_set_price()
  nx_pause(2)
  local sellItems = nx_create("StringList")
  local file = GetAutoConfigFile(CONFIG_FILE_TYPES.SELL_ITEMS)
  if not sellItems:LoadFromFile(file) then
    add_chat_info("Khong the load file sell items")
    return false
  end
  auto_shop_set_price_for_items(sellItems, CLIENT_CUSTOMMSG_ADD_OFFLINE_SELL_ITEM)
  nx_pause(2)
  local buyItems = nx_create("StringList")
  local file = GetAutoConfigFile(CONFIG_FILE_TYPES.BUY_ITEMS)
  if not buyItems:LoadFromFile(file) then
    add_chat_info("Khong the load file buy items")
    return false
  end
  auto_shop_set_price_for_items(buyItems, CLIENT_CUSTOMMSG_OFFLINE_SET_PURCHASE_ITEM)

  return true
end

function auto_shop_set_price_for_items(items, type)
  local sell_num = items:GetStringCount()
  local dest_pos = 1
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return 0
  end
  
  for i = 0, sell_num - 1 do
    if not _is_auto_shop then
      return
    end
    local sell_item = items:GetStringByIndex(i)
    if sell_item ~= "" then
      local parts = util_split_string(sell_item, ",")
      local id = parts[1]
      if id ~= "--" then
        local name = parts[2]
        local viewId = parts[3]
        local amount = parts[4]
        local price = parts[5] * 1000

        local item_pos = tim_item_pos(id, viewId)
        local actual_amount = get_item_amount(id, viewId)
        --if actual_amount > 0 then
          local sell_amount = amount
          if actual_amount < nx_number(amount) then
            sell_amount = actual_amount
          end
          if actual_amount > 0 and type == CLIENT_CUSTOMMSG_ADD_OFFLINE_SELL_ITEM then
            game_visual:CustomSend(nx_int(type), nx_int(viewId), nx_int(item_pos), nx_int(dest_pos), nx_int64(price), nx_int(sell_amount))
            dest_pos = dest_pos + 1
          elseif type == CLIENT_CUSTOMMSG_OFFLINE_SET_PURCHASE_ITEM then
            game_visual:CustomSend(nx_int(type), nx_int(dest_pos), nx_string(id), nx_int(amount), nx_int64(price))
            dest_pos = dest_pos + 1
          end
          
        --end
      end
    end
  end
end

if not _is_auto_shop then
  _is_auto_shop = true
  local visual = nx_value("game_visual")
  if not nx_is_valid(visual) then
    return false
  end
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return false
  end
  local scene = client:GetScene()
  if not nx_is_valid(scene) then
    return false
  end
  local client_player = client:GetPlayer()
  if not nx_is_valid(client_player) then
    return false
  end
  add_chat_info("Start Auto Shop")
  pw2()
  while _is_auto_shop do
    nx_pause(1)
    local logic_state = client_player:QueryProp("LogicState")
    if nx_int(logic_state) ~= nx_int(101) then
      local form = nx_value("form_stage_main\\form_stall\\form_stall_main")
      if util_get_form("form_stage_main\\form_stall\\form_stall_main", true).Visible == true then
        if auto_shop_set_price() then
          nx_execute("form_stage_main\\form_stall\\form_stall_main", "custom_begin_stall", form, 0)
        end
      else
        util_auto_show_hide_form("form_stage_main\\form_stall\\form_stall_main")
      end
      if nx_is_valid(nx_value("form_common\\form_confirm")) == true then
        nx_execute("form_common\\form_confirm", "ok_btn_click", nx_value("form_common\\form_confirm"))
      end
    end
  end
else
  add_chat_info("Ket thuc Auto Shop")
  _is_auto_shop = false
end