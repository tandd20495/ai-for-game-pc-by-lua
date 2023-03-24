function dung_qua_hanh_tau_giang_ho(isStarted)
  while isStarted() do
    nx_pause(0)
    if get_item_amount("box_bzjh_002", 2) > 0 then
      dung_vat_pham("box_bzjh_002", 1, 5) -- thuong bon tau 2
    elseif get_item_amount("box_active_02", 2) > 0 then
      dung_het_vat_pham(isStarted, "box_active_02", 2, 1, {1}) -- qua the mon phai 5 lb
    elseif get_item_amount("box_redeem_menpaipaizi", 2) > 0 then
      dung_het_vat_pham(isStarted, "box_redeem_menpaipaizi", 2, 1, {1}) -- qua the mon phai 5 lb
    elseif get_item_amount("book_qinggong_5", 2) > 0 then
      study_book("book_qinggong_5") -- hoc phu dung bo phap
    elseif get_item_amount("box_bzjh_003", 2) > 0 then
      dung_vat_pham("box_bzjh_003", 1, 5) -- thuong bon tau 3
    elseif get_item_amount("book_qinggong_6", 2) > 0 then
      study_book("book_qinggong_6") -- xuyen van tung
    elseif get_item_amount("ITEMBAG_003", 2) > 0 then
      dung_vat_pham("ITEMBAG_003", 1, 2) -- tui mo rong
    elseif get_item_amount("box_bzjh_004", 2) > 0 then
      dung_vat_pham("box_bzjh_004", 1, 5) -- thuong bon tau 4
    elseif get_item_amount("additem_0010", 2) > 0 then
      dung_vat_pham("additem_0010", 1, 5) -- thien son tuyen lien qua
    elseif get_item_amount("box_bzjh_005", 2) > 0 then
      dung_vat_pham("box_bzjh_005", 1, 5) -- thuong bon tau 5
    elseif get_item_amount("box_bzjh_006", 2) > 0 then
      dung_vat_pham("box_bzjh_006", 1, 5) -- thuong bon tau 6
    elseif get_item_amount("box_active_02", 2) > 0 then
      dung_het_vat_pham(isStarted, "box_active_02", 2, 6, {1}) -- qua the mon phai 5 lb
    elseif get_item_amount("sa_006", 2) > 0 then
      dung_vat_pham("sa_006", 2, 5) -- the danh vong giang ho
    elseif get_item_amount("additem_0009", 2) > 0 then
      dung_vat_pham("additem_0009", 1, 5) -- bach nien tuyen lien qua
    elseif get_item_amount("box_cdjh_001", 2) > 0 then
      dung_vat_pham("box_cdjh_001", 1, 5) -- qua hanh tau 1
    elseif get_item_amount("box_cdjh_002", 2) > 0 then
      dung_vat_pham("box_cdjh_002", 1, 5) -- qua hanh tau 2
    elseif get_item_amount("box_cdjh_003", 2) > 0 then
      dung_vat_pham("box_cdjh_003", 1, 5) -- qua hanh tau 3
    elseif get_item_amount("box_cdjh_004", 2) > 0 then
      dung_vat_pham("box_cdjh_004", 1, 5) -- qua hanh tau 4
    elseif get_item_amount("wnhd_jianghudaxia_01", 2) > 0 then
      dung_vat_pham("wnhd_jianghudaxia_01", 1, 5)
    elseif get_item_amount("itembag_002_a", 2) > 0 then
      break
    end
  end
end

function xoa_items()
  -- xoa dai linh dan
  local amount = get_item_amount("yaopin_10500", 2)
  if amount > 0 then
    delete_item_by_id("yaopin_10500", 2, amount)
  end
  -- xoa tuyet lien tu
  local amount = get_item_amount("qizhen_0101_01", 2)
  if amount > 0 then
    delete_item_by_id("qizhen_0101_01", 2, amount)
  end
  -- xoa 5 cai man thau
  local amount = get_item_amount("caiyao20007", 2)
  if amount > 0 then
    delete_item_by_id("caiyao20007", 2, amount)
  end
  -- xoa tu than dan
  local amount = get_item_amount("zhenqi_activity_002", 2)
  if amount > 0 then
    delete_item_by_id("zhenqi_activity_002", 2, amount)
  end
end

function chinh_tu_all_mach(isStarted)
	local mach_nm = "jm_shoutaiyin"
	local mach_clc = "jm_shoushaoyang"
	local mach_cb = "jm_shoutaiyang"
	local mach_vd = "jm_zushaoyin"
	local mach_qtd = "jm_zujueyin"
	local mach_dm  = "jm_zutaiyin"
	local mach_cyv = "jm_zushaoyang"
	local mach_tl = "jm_zuyangming"
	local tu_khi = "jm_dantian"
	local mach = {
		mach_nm,
		mach_clc,
		mach_cb,
		mach_vd,
		mach_qtd,
		mach_dm,
		mach_cyv,
		mach_tl,
		tu_khi
	}
	for i = 1, table.getn(mach) do
		local mach_info = query_mach_info(mach[i])
		chinh_tu_mach(mach[i])
		if mach_info.Level < 9 then
			while isStarted() and mach_info.Level < 9 do
				nx_pause(0)
				if mach[i] == tu_khi and get_item_amount("zhenqi_item_005", 2) > 0 then
					dung_vat_pham("zhenqi_item_005", 1, 0)
				else
					dung_vat_pham("zhenqi_activity_001_2", 1, 0)
				end
				mach_info = query_mach_info(mach[i])
			end
		end
		if not isStarted() then
			break
		end
	end
	-- active mach
	active_mach(mach_dm)
	active_mach(mach_cyv)
	active_mach(mach_cb)
	active_mach(mach_tl)
end

function chuan_bi_thuc_luc(isStarted, data)
  set_pass_ruong()
	pw2()
  add_chat_info("Xóa items...")
  xoa_items()
  add_chat_info("Dùng quà hành tẩu giang hồ...")
  dung_qua_hanh_tau_giang_ho(isStarted)
	add_chat_info("Rút hộp kỳ trân...")
	local ky_tran_mail = get_mail_by_item("box_power_redeem")
	while isStarted() and ky_tran_mail ~= nil do
		nx_pause(0)
		if ky_tran_mail == nil then
			break
		else
			rut_xoa_thu_by_serial(ky_tran_mail)
			ky_tran_mail = get_mail_by_item("box_power_redeem")
		end
	end
	-- sap xep lai tui de stack hộp kỳ trân lại
	dung_vat_pham("noop_item", 2)
	local form_bag = util_get_form("form_stage_main\\form_bag", true, false)
  nx_execute("form_stage_main\\form_bag", "on_btn_arrange_click", form_bag.btn_arrange)
  add_chat_info("Rút thư...")
  rut_het_qua_trong_thu(isStarted, true)
  add_chat_info("Up binh lục...")
	if get_item_amount("binglu111", 2) > 0 then
		dung_het_binh_luc("binglu111",  data.binh_luc)
	end
	if get_item_amount("binglu112", 2) > 0 then
		dung_het_binh_luc("binglu112",  data.binh_luc)
	end
	if get_item_amount("binglu113", 2) > 0 then
		dung_het_binh_luc("binglu113",  data.binh_luc)
	end
	add_chat_info("Mở hộp kỳ trân...")
	dung_het_vat_pham(isStarted, "box_power_redeem", 2, 1, {1,2,3,4})
	add_chat_info("Ăn tinh chế tuyết liên quả...")
	dung_het_vat_pham(isStarted, "additem_0020_4", 2, 0)
  dung_het_vat_pham(isStarted, "additem_0009", 2, 0)
  dung_het_vat_pham(isStarted, "additem_0010", 2, 0)
	add_chat_info("Chính tu tất cả các mạch...")
	chinh_tu_all_mach(isStarted)
	add_chat_info("Thay trang bị...")
	equip_bo_trang_bi({
		"wrist_daxia_30301",
		"leg_daxia_30301",
		"shoes_daxia_30301",
		"pants_daxia_30301",
		"cloth_daxia_30301",
		"helmet_daxia_30301"
	})
	add_chat_info("Mở hộp thẻ môn phái...")
	dung_het_vat_pham(isStarted, "box_redeem_menpaipaizi", 2, 1, {1})
	add_chat_info("Nội tu main skill set ...")
  noi_tu_main_skill_set(isStarted, data.main_skill_faculty)
  add_chat_info("Up nội công...")
  up_noi_cong_6(isStarted, data)
end

local used_count = 0
local dich_can_dan = "faculty_event_02_2"

function noi_tu_main_skill_set(isStarted, skills)
  local can_dien_vo = true
  used_count = 0
  for i = 1, table.getn(skills) do
    local cur_skill = skills[i]
    local skill_id = cur_skill.name
    local skill_info = query_skill_info(skill_id)
    if skill_info == nil then
      return
    end
    local remain_faculty = skill_info.TotalFillValue -  (skill_info.CurFillValue or 0)
    local dich_can_dan_amount = get_item_amount(dich_can_dan, 2)
    add_chat_info("Nội tu " ..nx_function("ext_widestr_to_utf8", util_text(skill_id)))
    while isStarted() and skill_info.Level < cur_skill.level and used_count < 150 and dich_can_dan_amount > 0 do
      noi_tu(skill_id)
      nx_pause(0)
      if remain_faculty >= 7000 then
        used_count = used_count + 1
        dung_vat_pham(dich_can_dan, 1, 2)
      elseif can_dien_vo then
        can_dien_vo = dien_vo(isStarted, 1)
      else
        break
      end
      skill_info = query_skill_info(cur_skill.name)
      remain_faculty = skill_info.TotalFillValue -  (skill_info.CurFillValue or 0)
      dich_can_dan_amount = get_item_amount(dich_can_dan, 2)
    end
  end
end

function up_noi_cong_6(isStarted, data)
  local school = data.school
  local nc6 = data.nc6
  local doi_noi_cong_6_pos = data.doi_noi_cong_6_pos
  local doi_noi_cong_6_id = data.doi_noi_cong_6_id
  local noicong = get_noi_cong_info(nc6)
  local can_dien_vo = true
  while isStarted() do
    nx_pause(0)
    noicong = get_noi_cong_info(nc6) 
    if noicong ~= nil and noicong.MaxLevel < 9 then
      if arrived(doi_noi_cong_6_pos, 0.5) then
        talk_id(doi_noi_cong_6_id, {805000000}, isStarted)
        local form = util_get_form("form_stage_main\\form_shop\\form_shop", true)
        if nx_is_valid(form) then
          local next_page = nx_int(noicong.MaxLevel) + 1
          nx_execute("custom_sender", "custom_exchange_item", form.shopid, form.curpage, next_page, 1)
          local book = "ng_book_" ..school .. "_0060" ..nx_string(next_page)
          while isStarted() and not has_item(book, 2) do
            nx_pause(1)
            add_chat_info("Chờ đổi page nội công page" ..nx_string(next_page))
          end
          if nx_is_valid(form) then
            nx_destroy(form)
          end
          study_book(book)
        end
      else
        move(doi_noi_cong_6_pos)
      end
    else
      break
    end
  end

  noi_tu(nc6)
  local noicong_info = get_noi_cong_info(nc6)
  local remain_faculty = noicong_info.TotalFillValue -  (noicong_info.CurFillValue or 0)
  local dich_can_dan_amount = get_item_amount(dich_can_dan, 2)
  add_chat_info("Nội tu " ..nx_function("ext_widestr_to_utf8", util_text(nc6)))
  while isStarted() 
    and noicong_info.Level < noicong_info.MaxLevel 
    and used_count <= 150 
    and dich_can_dan_amount > 0
  do
    nx_pause(0)
    noi_tu(nc6)
    if remain_faculty >= 7000 then
      used_count = used_count + 1
      dung_vat_pham(dich_can_dan, 1, 2)
    elseif can_dien_vo then
      can_dien_vo = dien_vo(isStarted, 1)
    elseif dich_can_dan_amount > 0 then
      dung_vat_pham(dich_can_dan, 1, 2)
    else
      break
    end
    noicong_info = get_noi_cong_info(nc6)
    remain_faculty = noicong_info.TotalFillValue -  (noicong_info.CurFillValue or 0)
    dich_can_dan_amount = get_item_amount(dich_can_dan, 2)
  end
  dien_vo(isStarted)
end