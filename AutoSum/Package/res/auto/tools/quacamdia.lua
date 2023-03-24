
function ___qua_cam_dia_isStarted()
  return qua_cam_dia_bool
end

if not ___qua_cam_dia_isStarted() then
  qua_cam_dia_bool = true
  add_chat_info("Bat dau nhan qua cam dia")

  function mo_hop_qua_cam_dia(item_id, view_id)
    if string.find(item_id, "box_") then
      add_chat_info("IS BOX " ..item_id)
      local has_cal = has_item(item_id, view_id)
      while ___qua_cam_dia_isStarted() and has_cal do
        dung_het_vat_pham(___qua_cam_dia_isStarted, item_id, view_id, 0, {1,2,3,4,5,6})
        has_cal = has_item(item_id, view_id)
      end
    else
      add_chat_info("not box " ..item_id)
    end
  end

  function rut_het_thu(item_id, view_id)
    while ___qua_cam_dia_isStarted() do
      nx_pause(0)
      local available = check_bag_available(view_id)
      if available > 0 then
        local has_mail = rut_va_xoa_mail(item_id)
        if not has_mail then break end
      else
        break
      end
    end
    mo_hop_qua_cam_dia(item_id, view_id)
  end


  function run_story()
    xoa_thu_rong()
    local items = util_split_string(PICK_UP_LIST, ",")
    for i = 1, table.getn(items) do
      if not ___qua_cam_dia_isStarted() then
        return
      end
      local item = items[i]
      local serial = get_mail_by_item(item)
      local view_id = get_bag_id_by_config_id(item)
      if view_id then
        add_chat_info(item ..":"..view_id)
        mo_hop_qua_cam_dia(item, view_id)
        while ___qua_cam_dia_isStarted() and serial ~= nil do
          nx_pause(0)
          add_chat_info("rut thu")
          rut_het_thu(item, view_id)
          serial = get_mail_by_item(item)
        end
      end
    end
    xoa_thu_rong()
  end

  while ___qua_cam_dia_isStarted() do
    nx_pause(0)
    run_story()
  end
  qua_cam_dia_bool = false
  add_chat_info("Xong nhan qua cam dia")
else 
  qua_cam_dia_bool = false
  add_chat_info("Dung nhan qua cam dia")
end