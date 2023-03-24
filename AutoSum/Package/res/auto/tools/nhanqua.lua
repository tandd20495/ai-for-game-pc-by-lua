local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\multiple.lua"))
multiple = file()

function ___nhan_qua_isStarted()
	return auto_nhan_qua_bool
end

function __log_qua()
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return 0
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return 0
  end
  local client_player = client:GetPlayer()
  local view = client:GetView(nx_string(80))
  local view_obj_table = view:GetViewObjList()
  for k = 1, table.getn(view_obj_table) do
    local view_obj = view_obj_table[k]
    local id = view_obj:QueryProp("ConfigID")
    local x = nx_function("ext_widestr_to_utf8", nx_ws_lower(util_text(id)))
    local game_config = nx_value("game_config")
	  local account = game_config.login_account
    local str = account .."|" ..id .."|" ..x
    console(str)
  end
end

function nhan_qua_den_bu_ok(item, nguoi_nhan, send_item)
  local bag_type = 2
  nx_pause(5) -- cho nhan thu
  set_pass_ruong()
  pw2()
  while ___nhan_qua_isStarted() do
    nx_pause(0)
    add_chat_info("xoa item tan thu")
    xoa_tan_thu_items()
    if get_item_amount("ITEMBAG_003", 2) >= 1 then
      add_chat_info("tui mo rong")
      dung_vat_pham("ITEMBAG_003", 1, 2)
    end
    rut_het_qua_trong_thu(___nhan_qua_isStarted)
    arrange_bag(bag_type, 100)
    local has_mail = rut_va_xoa_mail(item, 2)
    if has_mail then
      local qua = get_item_amount(item, bag_type)
      while ___nhan_qua_isStarted() and qua <= 0 do
        nx_pause(0) -- cho qua
      end
    end
    if ___nhan_qua_isStarted() then
      dung_het_vat_pham(___nhan_qua_isStarted, item, bag_type, 5, {1,2,3,4,5})
    end
    break
  end
  arrange_bag(bag_type, 100)
  local ngu_uan = "item_exchange_xm_mark"
  local the_thoi_trang = "haiwai_box_pingzheng_001"
  local hnp = "equip_tihuan_601"
  local goivohoc = "haiwai_Christmas14bag_01"
  local goinc = "haiwai_Christmas14bag_02"
  local goiberen = "haiwai_Christmas14bag_03"
  while ___nhan_qua_isStarted() do
    nx_pause(0)
    if has_item(ngu_uan, 125, 0) then -- ngu uan phuc ma pham
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(ngu_uan)))
      gui_item_di(nguoi_nhan, ngu_uan, 125)
    end
    if has_item(the_thoi_trang, 2, 0) then -- the doi thoi trang
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(the_thoi_trang)))
      gui_item_di(nguoi_nhan, the_thoi_trang, 2)
    end
    if has_item(hnp, 123, 0) then -- huyen ngoc phan
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(hnp)))
      gui_item_di(nguoi_nhan, hnp, 123)
    end
    if has_item(goinc, 2) then -- goi noi cong tan quyen
      add_chat_info("Mở " ..nx_function("ext_widestr_to_utf8", util_text(goinc)))
      dung_vat_pham(goinc, 1, 5, {1,2,3})
      nx_pause(5)
    end
    if has_item(goivohoc, 2) then -- goi vo hoc
      add_chat_info("Mở " ..nx_function("ext_widestr_to_utf8", util_text(goivohoc)))
      dung_vat_pham(goivohoc, 1, 5, {1,2,3})
      nx_pause(5)
    end
    if has_item(goiberen, 2) then -- goi be ren
      add_chat_info("Mở " ..nx_function("ext_widestr_to_utf8", util_text(goiberen)))
      dung_vat_pham(goiberen, 1, 5, {1,2,3})
    end
    arrange_bag(2, 100)
    break
  end
  local has_co_pho, id = has_item("cjbook_CS_", 2, 0)
  local has_tan_quyen, tq_id = has_item("ng_cjbook_jh_", 2, 0)
  local has_vo_hoc, vh_id = has_item("ng_cjbook_jh_", 2, 0)
  while has_co_pho or has_tan_quyen or has_vo_hoc do
    nx_pause(0)
    has_co_pho, id = has_item("cjbook_CS_", 2, 0)
    has_tan_quyen, tq_id = has_item("ng_cjbook_jh_", 2, 0)
    has_vo_hoc, vh_id = has_item("ng_cjbook_jh_", 2, 0)
    
    if has_co_pho then -- co pho
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(id)))
      gui_item_di(nguoi_nhan, id, 2)
    elseif has_tan_quyen then -- tan quyen noi cong
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(tq_id)))
      gui_item_di(nguoi_nhan, tq_id, 2)
    end
  end
  add_chat_info("Done")
end
local khiep_khach_lenh = "tiguan_ward_item_01"
function gui_single_item(item, nguoi_nhan)
  if has_item(item, 2, 0) then
    gui_item_di(nguoi_nhan, item, 2)
  end
  add_chat_info("Done")
  return true
end

function is_send_single_item(item)
  if item == khiep_khach_lenh then
    return true
  end
  return false
end

function nhan_qua_den_bu_acc_moi_tao(item, nguoi_nhan, send_item)
  local bag_type = 2
  local second = 1
  local max = 5
  local has_mail = rut_va_xoa_mail(item, 2)
  while not has_mail do
    if second > max then
      break
    end
    nx_pause(1)
    SendNotice(second)
    second = second + 1
  end
  set_pass_ruong()
  pw2()
  if is_send_single_item(item) then
    return gui_single_item(item, nguoi_nhan)
  end
  while ___nhan_qua_isStarted() do
    nx_pause(0)
    if has_item("box_wnhd_dllb01", 2) then
      dung_vat_pham("box_wnhd_dllb01", 1, 5)
      nx_pause(5)
    end
    if has_item("bind_money_5", 2) then
      dung_vat_pham("bind_money_5", 1, 5)
    end
    add_chat_info("xoa item tan thu")
    xoa_tan_thu_items()
    local has_mail = rut_va_xoa_mail(item, 2)
    if has_mail then
      local qua = get_item_amount(item, bag_type)
      while ___nhan_qua_isStarted() and qua <= 0 do
        nx_pause(0) -- cho qua
      end
    end
    if ___nhan_qua_isStarted() then
      dung_het_vat_pham(___nhan_qua_isStarted, item, bag_type, 5, {1,2,3,4,5})
    end
    break
  end
  arrange_bag(bag_type, 100)
  local ngu_uan = "item_exchange_xm_mark"
  local the_thoi_trang = "haiwai_box_pingzheng_001"
  local hnp = "equip_tihuan_601"
  local goivohoc = "haiwai_Christmas14bag_01"
  local goinc = "haiwai_Christmas14bag_02"
  local goiberen = "haiwai_Christmas14bag_03"

  local has_co_pho, id = has_item("cjbook_CS_", 2, 0)
  local has_tan_quyen, tq_id = has_item("ng_cjbook_jh_", 2, 0)
  local has_ngu_uan, ngu_uan_id = has_item(ngu_uan, 125, 0)
  local has_hnp, hnp_id = has_item(hnp, 123, 0)
  local has_the_thoi_trang, the_thoi_trang_id = has_item(the_thoi_trang, 2, 0)
  local has_goinc, goinc_id = has_item(goinc, 2)
  local has_goivohoc, goivohoc_id = has_item(goivohoc, 2)
  local has_goiberen, goiberen_id = has_item(goiberen, 2)
  local has_the_pvc, the_pvc_id = has_item("tab_card_", 2, 0)
  local has_toa_ky, toa_ky_id = has_item("card_item_", 2, 0)

  local has_hkl, hkl_id = has_item(khiep_khach_lenh, 2, 0)
  while 
    has_co_pho 
    or has_tan_quyen
    or has_ngu_uan
    or has_hnp
    or has_the_thoi_trang
    or has_goinc
    or has_goivohoc
    or has_goiberen
    or has_the_pvc
    or has_toa_ky
  do
    nx_pause(0)
    if has_goinc then -- goi noi cong tan quyen
      add_chat_info("Mở " ..nx_function("ext_widestr_to_utf8", util_text(goinc)))
      dung_vat_pham(goinc, 1, 5, {1,2,3})
      nx_pause(5)
      arrange_bag(2, 100)
    elseif has_goivohoc then -- goi vo hoc
      add_chat_info("Mở " ..nx_function("ext_widestr_to_utf8", util_text(goivohoc)))
      dung_vat_pham(goivohoc, 1, 5, {1,2,3})
      nx_pause(5)
      arrange_bag(2, 100)
    elseif has_goiberen then -- goi be ren
      add_chat_info("Mở " ..nx_function("ext_widestr_to_utf8", util_text(goiberen)))
      dung_vat_pham(goiberen, 1, 5, {1,2,3})
    elseif has_the_pvc then -- the pvc
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(the_pvc_id)))
      gui_item_di(nguoi_nhan, the_pvc_id, 2)
    elseif has_toa_ky then -- pvc toa ky
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(toa_ky_id)))
      gui_item_di(nguoi_nhan, toa_ky_id, 2)
    elseif has_co_pho then -- co pho
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(id)))
      gui_item_di(nguoi_nhan, id, 2)
    elseif has_tan_quyen then -- tan quyen noi cong
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(tq_id)))
      gui_item_di(nguoi_nhan, tq_id, 2)
    elseif has_ngu_uan then -- ngu uan phuc ma pham
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(ngu_uan)))
      gui_item_di(nguoi_nhan, ngu_uan, 125)
    elseif has_the_thoi_trang then -- the doi thoi trang
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(the_thoi_trang)))
      gui_item_di(nguoi_nhan, the_thoi_trang, 2)
    elseif has_hnp then -- huyen ngoc phan
      add_chat_info("Gửi " ..nx_function("ext_widestr_to_utf8", util_text(hnp)))
      gui_item_di(nguoi_nhan, hnp, 123)
    end
    has_co_pho, id = has_item("cjbook_CS_", 2, 0)
    has_tan_quyen, tq_id = has_item("ng_cjbook_jh_", 2, 0)
    has_vo_hoc, vh_id = has_item("ng_cjbook_jh_", 2, 0)
    has_ngu_uan, ngu_uan_id = has_item(ngu_uan, 125, 0)
    has_hnp, hnp_id = has_item(hnp, 123, 0)
    has_the_thoi_trang, the_thoi_trang_id = has_item(the_thoi_trang, 2, 0)
    has_goinc, goinc_id = has_item(goinc, 2)
    has_goivohoc, goivohoc_id = has_item(goivohoc, 2)
    has_goiberen, goiberen_id = has_item(goiberen, 2)
  end
  add_chat_info("Done")
end

function nhan_qua_den_bu(item, nguoi_nhan, send_item)
  local bag_type = 2
  set_pass_ruong()
  pw2()
  local step = 0
  while ___nhan_qua_isStarted() do
    nx_pause(0)
    dung_vat_pham("noop", 2, 1, {1})
    add_chat_info(step)
    -- local i1 = get_item_amount("box_cdjh_001", 2)
    -- local i2 = get_item_amount("box_cdjh_002", 2)
    -- local i3 = get_item_amount("box_cdjh_003", 2)
    -- local i4 = get_item_amount("box_cdjh_004", 2)
    -- add_chat_info("1:" ..nx_string(i1))
    -- add_chat_info("2:" ..nx_string(i2))
    -- add_chat_info("3:" ..nx_string(i3))
    -- add_chat_info("4:" ..nx_string(i4))
    -- add_chat_info("5:" ..nx_string(i5))
    -- add_chat_info("6:" ..nx_string(i6))
    if
      get_item_amount("box_bzjh_001", 2) <= 0 
      and get_item_amount("box_bzjh_002", 2) <= 0 
      and get_item_amount("box_bzjh_003", 2) <= 0 
      and get_item_amount("box_bzjh_004", 2) <= 0
      and get_item_amount("ITEMBAG_003", 2) <= 1
    then
      step = 1
      break
    end
    xoa_tan_thu_items()
    local amount = get_item_amount("faculty_tianti_01", 2)
    if amount > 0 then
      step = 2
      delete_item_by_id("faculty_tianti_01", 2, amount)
    end
    if get_item_amount("additem_0011", 2) > 0 then
      step = 3
      dung_vat_pham("additem_0011", 2, 1, {1})
    elseif get_item_amount("additem_0020", 2) > 0 then
      step = 4
      dung_vat_pham("additem_0020", 2, 1, {1})
    elseif get_item_amount("tbook_CS_jh_cqgf05", 2) > 0 then
      step = 5
      study_book("tbook_CS_jh_cqgf05", 2, 1, {1})
    elseif get_item_amount("tbook_CS_jh_cqgf02", 2) > 0 then
      step = 6
      study_book("tbook_CS_jh_cqgf02", 2, 1, {1})
    elseif get_item_amount("tbook_CS_jh_cqgf03", 2) > 0 then
      step = 7
      study_book("tbook_CS_jh_cqgf03", 2, 1, {1})
    elseif get_item_amount("book_qinggong_4", 2) > 0 then
      step = 8
      study_book("book_qinggong_4", 2, 1, {1})
    elseif get_item_amount("book_hw_normal", 2) > 0 then
      step = 9
      study_book("book_hw_normal", 2, 1, {1})
    elseif get_item_amount("book_zs_default_01", 2) > 0 then
      step = 10
      study_book("book_zs_default_01", 2, 1, {1})
    elseif get_item_amount("item_skipsp_001", 2) > 0 then
      dung_vat_pham("item_skipsp_001", 2, 1, {1})
      step = 11
    elseif get_item_amount("itembag_002_a", 2) > 0 then
      dung_vat_pham("itembag_002_a", 2, 1, {1}) -- tui mo rong
      step = 12
    elseif get_item_amount("bind_money_2", 2) > 0 then
      dung_vat_pham("bind_money_2", 2, 1, {1}) -- bac vun
      step = 13
    elseif get_item_amount("box_active_02", 2) > 0 then
      dung_vat_pham("box_active_02", 2, 1, {1}) -- qua the mon phai 5 lb
      step = 14
    elseif get_item_amount("box_redeem_menpaipaizi", 2) > 0 then
      dung_vat_pham("box_redeem_menpaipaizi", 2, 1, {1}) -- qua the mon phai 5 lb
      step = 15
    elseif get_item_amount("book_qinggong_5", 2) > 0 then
      study_book("book_qinggong_5") -- hoc phu dung bo phap
      step = 16
    elseif get_item_amount("book_qinggong_6", 2) > 0 then
      study_book("book_qinggong_6") -- xuyen van tung
      step = 17
    elseif get_item_amount("ITEMBAG_003", 2) > 1 then
      dung_vat_pham("ITEMBAG_003", 1, 2) -- tui mo rong
      step = 18
    elseif get_item_amount("additem_0010", 2) > 0 then
      dung_vat_pham("additem_0010", 1, 5) -- thien son tuyen lien qua
      step = 19
    elseif get_item_amount("box_active_02", 2) > 0 then
      dung_vat_pham("box_active_02", 2, 6, {1}) -- qua the mon phai 5 lb
      step = 20
    elseif get_item_amount("sa_006", 2) > 0 then
      dung_vat_pham("sa_006", 2, 5) -- the danh vong giang ho
      step = 21
    elseif get_item_amount("additem_0009", 2) > 0 then
      dung_vat_pham("additem_0009", 1, 5) -- bach nien tuyen lien qua
      step = 22
    elseif get_item_amount("box_cdjh_001", 2) > 0 then
      dung_vat_pham("box_cdjh_001", 1, 5) -- qua hanh tau 1
      step = 23
    elseif get_item_amount("box_cdjh_002", 2) > 0 then
      dung_vat_pham("box_cdjh_002", 1, 5) -- qua hanh tau 2
      step = 24
    elseif get_item_amount("box_cdjh_003", 2) > 0 then
      dung_vat_pham("box_cdjh_003", 1, 5) -- qua hanh tau 3
      step = 25
    elseif get_item_amount("box_cdjh_004", 2) > 0 then
      dung_vat_pham("box_cdjh_004", 1, 5) -- qua hanh tau 4
      step = 26
    elseif get_item_amount("wnhd_jianghudaxia_01", 2) > 0 then
      dung_vat_pham("wnhd_jianghudaxia_01", 1, 5)
      step = 27
    elseif get_item_amount("box_bzjh_006", 2) > 0 then
      dung_vat_pham("box_bzjh_006", 1, 5) -- thuong bon tau 6
      step = 28
    elseif get_item_amount("box_bzjh_005", 2) > 0 then
      dung_vat_pham("box_bzjh_005", 1, 5) -- thuong bon tau 5
      step = 29
    elseif get_item_amount("box_bzjh_004", 2) > 0 then
      dung_vat_pham("box_bzjh_004", 1, 5) -- thuong bon tau 4
      step = 30
    elseif get_item_amount("box_bzjh_003", 2) > 0 then
      dung_vat_pham("box_bzjh_003", 1, 5) -- thuong bon tau 3
      step = 31
    elseif get_item_amount("box_bzjh_002", 2) > 0 then
      dung_vat_pham("box_bzjh_002", 1, 5) -- thuong bon tau 2
      step = 32
    end
  end
end

-- /ap tool nhanqua,3,200,qtdc2,haiwai_VNVIPlibao_01,c2conhonqtd1 -- qua den bu
-- /ap tool nhanqua,2,200,clc,tiguan_ward_item_01 -- hiep khach lenh
function ___nhan_qua(params)
	if not ___nhan_qua_isStarted() then
    auto_nhan_qua_bool = true
    local from = params[1]
    local to = params[2]
    local acc = params[3] or "all"
    local item = params[4]
    local nguoi_nhan = params[5] or "Võ.Phong"
    local send_item = params[6]
		local file = assert(loadfile(nx_resource_path() .. "auto\\accounts\\" ..acc ..".lua"))
		local accounts = file()
		accounts = table.slice(accounts, from, to)
    add_chat_info("nhan cho tat ca accounts", 3)
    function run()
      nhan_qua_den_bu_acc_moi_tao(item, nguoi_nhan, send_item)
    end
    --run()
    multiple(run, accounts, ___nhan_qua_isStarted)
    auto_nhan_qua_bool = false
    add_chat_info("da nhan het cho tat ca accounts", 3)
	else 
		auto_nhan_qua_bool = false
		add_chat_info("Ke thuc nhan qua cho tat ca accounts",3)
	end
end

return ___nhan_qua
