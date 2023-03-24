-- giam pk xuc sac trong tu`
game_visual:CustomSend(nx_int(280), nx_int(1), nx_int(1))

-- file thong tin nhiem vu an the E:\Program Files (x86)\CACK982017\autocack\unpack\share.package.files\res\share\newschool\newschoolui\newschoolplay.ini

-- get item info
local ItemQuery = nx_value("ItemQuery")
  if not nx_is_valid(ItemQuery) then
    return
  end
  local bExist = ItemQuery:FindItemByConfigID(nx_string(item_config))
  if bExist == false then
    return
  end
  local item_MaxAmount = ItemQuery:GetItemPropByConfigID(nx_string(item_config), nx_string("MaxAmount"))