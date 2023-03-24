local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\multiple.lua"))
multiple = file()

function ____auto_gui_thu_started()
  return ____auto_gui_thu_started_bool
end

function ____do_auto_gui_thu(item, bagType, title, nguoi_nhan_thu)
  local bag = util_get_form("form_stage_main\\form_bag", true, false)
  local items = util_split_string(item, ",")
  pw2()
  arrange_bag(bagType, 9999)
  while ____auto_gui_thu_started() and table.getn(items) > 0 do
    nx_pause(0)
    local item = items[1]
    local hasItem, id =  has_item(item, bagType, 0)
    if hasItem then
      gui_item_di(nguoi_nhan_thu, id, bagType)
      nx_execute("form_stage_main\\form_mail\\form_mail", "auto_show_mail_form")
    else
      table.remove(items, 1)
    end
  end
end

if not ____auto_gui_thu_started_bool then
  add_chat_info("Bat dau gui thu: ")
  ____auto_gui_thu_started_bool = true

  local file = assert(loadfile(nx_resource_path() .. "auto\\accounts\\dmp.lua"))
  local accounts = file()
  accounts = table.slice(accounts, 101,200)--, 150)
  local count = 1
  function _run()
    --item_wgm_,item_jzsj_sh_,caiyao10030
    --"tiguan_ward_item_01", 2,  "hiep khach lenh"
    --"item_hsp_exchange01", 125,  "hoa son lenh"
    --"Item_xdm_exchange01", 125,  "huyet dao lenh"
    --"item_nlb_exchange01", 2,  "da ngu sac"
    --"item_dmp_ptz", 125,  "bo de tu"
    ____do_auto_gui_thu("item_dmp_ptz", 125,  "bo de tu", "conhon1") --"Võ.Phong"
    count = count + 1
  end
  --_run()
  multiple(_run, accounts, ____auto_gui_thu_started)

  add_chat_info("Xong gui thu")
  ____auto_gui_thu_started_bool = false
else
  add_chat_info("Dung gui thu")
  ____auto_gui_thu_started_bool = false
end