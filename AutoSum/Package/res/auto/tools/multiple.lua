local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\multiple.lua"))
multiple = file()

function ____auto_multiple_started()
  return ____auto_multiple_started_bool
end

function ____do_auto_multiple()
  nx_pause(5)
  pw2()
  nhan_danh_phan(3801) --origin_3801=Xích Cước Khổ Sĩ
  nx_pause(2)
  nhan_thuong_danh_phan(3801)
  nx_pause(2)
  dung_vat_pham("damo01", 121, 0)
  mac_do_danh_phan()
end

if not ____auto_multiple_started_bool then
  add_chat_info("Bat dau multiple action: ")
  ____auto_multiple_started_bool = true

  local file = assert(loadfile(nx_resource_path() .. "auto\\accounts\\dmp.lua"))
  local accounts = file()
  accounts = table.slice(accounts, 2,100)--, 150)
  local count = 1
  function _run()
    ____do_auto_multiple()
    count = count + 1
  end
  multiple(_run, accounts, ____auto_multiple_started)

  add_chat_info("Xong multiple action")
  ____auto_multiple_started_bool = false
else
  add_chat_info("Dung multiple action")
  ____auto_multiple_started_bool = false
end