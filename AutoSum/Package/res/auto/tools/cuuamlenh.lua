local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\multiple.lua"))
multiple = file()

function ___cuu_am_lenh_isStarted()
  return cuu_am_lenh_bool
end

if not ___cuu_am_lenh_isStarted() then
  cuu_am_lenh_bool = true
  add_chat_info("Bat dau nhan qua cuu am lenh")
  
  local file = assert(loadfile(nx_resource_path() .. "auto\\accounts\\tl.lua"))
  local accounts = file()
  accounts = table.slice(accounts, 152, 200)

  local htt = "box_fc_hss_010"
  local mml = "box_fc_mml_010"
  local kiem = "item_exchange_xm_mark_01"
  local hnp = "box_fc_bdxuanyufen"

  function mo_hop_cuu_am_lenh(item_id, view_id)
    local has_cal = has_item(item_id, view_id)
    while ___cuu_am_lenh_isStarted() and has_cal do
      dung_het_vat_pham(___cuu_am_lenh_isStarted, item_id, view_id, 0, {1})
      has_cal = has_item(item_id, view_id)
    end

  end

  function rut_het_thu_cal(item_id, view_id)
    while ___cuu_am_lenh_isStarted() do
      nx_pause(0)
      local available = check_bag_available(view_id)
      if available > 0 then
        local has_mail = rut_va_xoa_mail(item_id)
        if not has_mail then break end
      else
        break
      end
    end
    mo_hop_cuu_am_lenh(item_id, view_id)
  end

  -- temp func de run trong luc nhan qua
  function __temp_f()
    nhan_danh_phan(3311) --nu
    nx_pause(1)
    nhan_thuong_danh_phan(3311)
    nx_pause(1)
    dung_vat_pham("nianluoba01", 121, 0)
  end

  function run_story()
    nx_pause(10)
    dung_vat_pham("noop", 0, 0)
    xoa_tan_thu_items()
    -- __temp_f()
    local tu_linh_dan = "zhenqi_activity_001_2"
    local amount = get_item_amount(tu_linh_dan, 2)
    while ___cuu_am_lenh_isStarted() and amount > 0 do
      nx_pause(0)
      delete_item_by_id(tu_linh_dan, 2, amount)
      amount = get_item_amount(tu_linh_dan, 2)
    end

    xoa_thu_rong()
    rut_het_qua_trong_thu(___cuu_am_lenh_isStarted, true)

    local serial_htt = get_mail_by_item(htt)
    local serial_mml = get_mail_by_item(mml)
    local serial_kiem = get_mail_by_item(kiem)
    local serial_hnp = nil--get_mail_by_item(hnp)

    mo_hop_cuu_am_lenh(htt, 2)
    mo_hop_cuu_am_lenh(mml, 2)
    while ___cuu_am_lenh_isStarted()
      and (serial_htt ~= nil or serial_mml ~= nil or serial_hnp ~= nil or serial_kiem ~= nil)
    do
      nx_pause(0)
      rut_xoa_thu_by_serial(serial_kiem)

      rut_het_thu_cal(htt, 2)
      rut_het_thu_cal(mml, 2)
      --rut_het_thu(hnp, 2)

      serial_htt = get_mail_by_item(htt)
      serial_mml = get_mail_by_item(mml)
      serial_kiem = get_mail_by_item(kiem)
      --serial_hnp = get_mail_by_item(hnp)
    end
    xoa_thu_rong()
  end
  --run_story()
  multiple(run_story, accounts, ___cuu_am_lenh_isStarted)
  cuu_am_lenh_bool = false
  add_chat_info("Xong nhan qua cuu am lenh")
else 
  cuu_am_lenh_bool = false
  add_chat_info("Dung nhan qua cuu am lenh")
end