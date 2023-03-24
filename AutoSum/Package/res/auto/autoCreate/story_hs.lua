
local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()

local tam_diep_lac_mai = "CS_jz_xytf01"
local con_ngoc_thu_suong = "CS_jz_xytf02"
local linh_xa_bai_vi = "CS_jz_xytf03"
local bang_tieu_diep_tan = "CS_jz_xytf04"
local thu_hao_vo_pham = "CS_jz_xytf05"
local san_san_luc_anh = "CS_jz_xytf06"
local han_mai_nhi_tho = "CS_jz_xytf07"

function story_hs(isStarted)
	local step = 0
	set_pass_ruong("18392755")
	while isStarted() do
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		add_chat_info("Story Step : " .. step)
		if has_buff("buf_baosd_01") then -- doi qua an banh bao thoi
			dung_vat_pham("caiyao20002", 2, 5)
		end
		close_all_open_form()
		if step == 0 then
			set_auto_do_don()
			xoa_thu_rong()
			hoc_tho_thien_cong_phu()
			set_skill_short_cut("zs_default_01", 9) -- set toa thien short cut
			-- an banh bao de mo ruong, moi co the xoa dc
			dung_vat_pham("caiyao20007", 1, 1)
			-- xoa that huyen cam de rong ruong
			delete_item_by_id("tool_qs_01", 2, 1)
			-- xoa bach khoa toan thu
			delete_item_by_id("itm_bxyl_001", 2, 1)
			-- xoa tuyet lien tu
			delete_item_by_id("qizhen_0101_01", 2, 1)
			-- xoa 5 man thau
			delete_item_by_id("caiyao20007", 2, 5)
			step = 1
		elseif step == 1 then
			step = 2
		elseif step == 2 then
			if not da_hoc_skill("CS_jz_lyfh08") then
				hoc_lac_anh_phi_hoa_kiem(isStarted)
			end
			step = 3
		elseif step == 3 then
			if not da_hoc_skill("CS_jz_xytf07") then
				hoc_tieu_dao_thoai_phap(isStarted)
			end
			step = 4
		elseif step == 4 then
			if not da_hoc_skill("CS_jz_wyjf07") then
				hoc_vo_nhai_kiem_phap(isStarted)
			end
			add_chat_info("Hoc xong vo hoc qtd")
			step = 5
		elseif step == 5 then
			add_chat_info("Chuan bi thuc luc")
			chuan_bi_thuc_luc(isStarted)
			step = 6
		elseif step == 6 then
			nhan_quest_gia_nhap_hs(isStarted)
			step = 7
		elseif step == 7 then
			--lam_quest_thi_kiem_that_tu(isStarted)
			step = 8
		end
		if step == 8 then 
			break
		end
	end
end

function hoc_lac_anh_phi_hoa_kiem(isStarted)
	local step = 1
	local hue_bang_phi_id = "Npc_yd_wg_jx_jz01"
	local phung_hien_thanh = "Npc_yd_wg_jx_jz02"
	local dinh_bich_van = "Npc_yd_wg_jx_jz03"
	local tu_thu_sanh_van = "Npc_yd_wg_jx_jz04"
	local tran_trung_luong = "Npc_yd_wg_jx_jz05"
	while isStarted() do
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		add_chat_info("Lac Anh Phi Hoa Kiem: " ..step)
		if step == 1 then
			step = 2
		elseif step == 2 then
			noi_tu("ng_jz_001")
			step = 3
		elseif step == 3 then
			dien_vo(isStarted, 1)
			step = 4
		elseif step == 4 then
			-- den vo duong
			local pos = {335.499,75.458,440.917,-1.475}
			den_pos(pos, isStarted)
			step = 5
		elseif step == 5 then
			local npc = getNpcById(hue_bang_phi_id)
			if npc ~= nil then
				step = 6
			elseif LayMapHienTai() == "school03" then
				jump_to_the_air()
			end
		elseif step == 6 then
			__talk_hue_bang_phi({0,0,0}, isStarted)
			step = 7
		elseif step == 7 then
			__talk_hue_bang_phi({0,0,0}, isStarted)
			step = 8
		elseif step == 8 then
			local npc = getNpcById(dinh_bich_van)
			den_pos(getPos(npc), isStarted)
			talk(dinh_bich_van, {0}, isStarted)
			step = 9
		elseif step == 9 then
			if query_task_status_by_target(1682, "Qiecuo_jiaoxue_parry_1_1682") then
				step = 10
			end
		elseif step == 10 then
			__talk_hue_bang_phi({0}, isStarted)
			step = 11
		elseif step == 11 then
			skill_use("CS_jh_cqgf03") -- Hoai trung bao nguyet
			local npc = getNpcById(dinh_bich_van)
			den_pos(getPos(npc), isStarted)
			talk(dinh_bich_van, {0}, isStarted)
			step = 12
		elseif step == 12 then
			if query_task_status_by_target(1682, "Qiecuo_jiaoxue_parry_3_1682") then
				step = 13
			end
		elseif step == 13 then -- tra nhiem vu
			__talk_hue_bang_phi({0,0,0}, isStarted)
			step = 14
		elseif step == 14 then
			if get_item_amount("tibook_CS_jz_lyfh01", 2) > 0 then
				-- hoc anh hung vo le
				study_book("tibook_CS_jz_lyfh01")
				-- hoc lac tran tieu 
				study_book("tibook_CS_jz_lyfh04")
				step = 15
			end
		elseif step == 15 then
			local npc = getNpcById(tu_thu_sanh_van)
			den_pos(getPos(npc), isStarted)
			talk(tu_thu_sanh_van, {0}, isStarted)
			equip_trang_bi("sword_jz_10101")
			step = 16
		elseif step == 16 then
			if query_task_status_by_target(1683, "Qiecuo_jiaoxue_virtual_1_1683") then
				step = 17
			else
				skill_use("zs_normal_02")
			end
		elseif step == 17 then
			__talk_hue_bang_phi({0}, isStarted)
			step = 18
		elseif step == 18 then
			set_skill_short_cut("CS_jh_cqgf02", 4)
			den_pos(getPos(getNpcById(tu_thu_sanh_van)), isStarted)
			talk(tu_thu_sanh_van, {0}, isStarted)
			step = 19
		elseif step == 19 then
			if query_task_status_by_target(1683, "Qiecuo_jiaoxue_virtual_3_1683") then
				step = 20
			else
				skill_use("CS_jh_cqgf02") -- bach van cai dinh
			end
		elseif step == 20 then
			__talk_hue_bang_phi({0,0,0}, isStarted)
			step = 21
		elseif step == 21 then
			study_book("tibook_CS_jz_lyfh02") -- phi yen phan
			study_book("tibook_CS_jz_lyfh03") -- hoa vo ngon
			study_book("tibook_CS_jz_lyfh05") -- lac anh phi hoa
			step = 22
		elseif step == 22 then
			set_skill_short_cut("CS_jh_cqgf05", 5)
			den_pos(getPos(getNpcById(tran_trung_luong)), isStarted)
			talk(tran_trung_luong, {0}, isStarted)
			step = 23
		elseif step == 23 then
			if query_task_done_single(1684) then
				step = 24
			else
				skill_use("CS_jh_cqgf05") -- dao bo that tinh
			end
		elseif step == 24 then
			__talk_hue_bang_phi({0,0,0}, isStarted)
			step = 25
		elseif step == 25 then
			study_book("tibook_CS_jz_lyfh06") -- hanh hoa xuan vu
			study_book("tibook_CS_jz_lyfh07") -- phong hoa tuyet nguyet
			study_book("tibook_CS_jz_lyfh08") -- kinh hoa thuy nguyet
			step = 26
		elseif step == 26 then
			den_pos({-16.595,15.537,13.542,-0.001}, isStarted)
			step = 27
		elseif step == 27 then
			if getNpcById("WorldNpc03466") ~= nil then -- Tu Thanh`
				step = 28
			end
		elseif step == 28 then
			local trinh_di_mac = "WorldNpc03316"
			den_pos({660.098,101.633,569.637,1.529}, isStarted)
			talk(trinh_di_mac, {0,0}, isStarted)
			step = 29
		end
		if step == 29 then 
			break
		end
	end
end

function hoc_tieu_dao_thoai_phap(isStarted)
	local step = 1
	local trinh_di_mac = "WorldNpc03316"
	local trinh_di_mac_pos = {660.098,101.633,569.637,1.529}
	local ly_thanh_huyen = "Qiecuojzt002"
	local ly_thanh_huyen_pos = {622.396,101.633,532.183,1.920}
	local han_ngoc_linh = "Qiecuojzt005"
	local han_ngoc_linh_pos = {654.065,102.601,514.582,0.540}
	while isStarted() do
		nx_pause(0.5)
		add_chat_info("Tieu Dao Thoai Phap: " ..step)
		if step == 1 then
			den_pos(trinh_di_mac_pos, isStarted)
			talk(trinh_di_mac, {0,0}, isStarted)
			nx_pause(1)
			talk(trinh_di_mac, {0,0,0}, isStarted)
			nx_pause(1)
			talk(trinh_di_mac, {0}, isStarted)
			step = 2
		elseif step == 2 then
			study_book("tibook_CS_jz_xytf01") -- tam diep lac mai
			study_book("tibook_CS_jz_xytf02") -- con ngoc thu suong
			step = 3
		elseif step == 3 then
			den_pos(trinh_di_mac_pos, isStarted)
			talk(trinh_di_mac, {0,0,0}, isStarted)
			nx_pause(1)
			talk(trinh_di_mac, {0}, isStarted)
			step = 4
		elseif step == 4 then
			study_book("tibook_CS_jz_xytf03") -- linh xa bai vi
			study_book("tibook_CS_jz_xytf05") -- thu hao vo pham
			step = 5
		elseif step == 5 then
			den_pos(ly_thanh_huyen_pos, isStarted)
			talk(ly_thanh_huyen, {0}, isStarted)
			step = 6
		elseif step == 6 then
			if query_task_status_by_target(1291,"Qiecuojzt002") then
				step = 7
			else
				skill_use("CS_jz_xytf01") -- tam diep lac mai
			end
		elseif step == 7 then
			den_pos(trinh_di_mac_pos, isStarted)
			talk(trinh_di_mac, {0,0,0}, isStarted)
			nx_pause(1)
			talk(trinh_di_mac, {0}, isStarted)
			step = 8
		elseif step == 8 then
			study_book("tibook_CS_jz_xytf04") -- bang tieu diep tan
			step = 9
		elseif step == 9 then
			den_pos(han_ngoc_linh_pos, isStarted)
			talk(han_ngoc_linh, {0}, isStarted)
			step = 10
		elseif step == 10 then
			if query_task_status_by_target(1292,"Qiecuojzt005") then
				step = 11
			else
				skill_use("CS_jz_xytf01") -- tam diep lac mai
			end
		elseif step == 11 then
			den_pos(trinh_di_mac_pos, isStarted)
			talk(trinh_di_mac, {0,0,0}, isStarted)
			nx_pause(1)
			talk(trinh_di_mac, {0}, isStarted)
			step = 12
		elseif step == 12 then
			study_book("tibook_CS_jz_xytf06") -- san san luc anh
			study_book("tibook_CS_jz_xytf07") -- han mai nhi tho
			step = 13
		elseif step == 13 then
			den_pos(trinh_di_mac_pos, isStarted)
			talk(trinh_di_mac, {0,0,0}, isStarted)
			step = 14
		end
		
		if step == 14 then
			break
		end
	end
end

function hoc_vo_nhai_kiem_phap(isStarted)
	local step = 1
	local yen_truong_khong = "WorldNpc03315"
	local yen_truong_khong_pos = {315.497,75.827,440.900,1.714}
	local chu_hoa = "Qiecuojzt001"
	local chu_hoa_pos = {327.982,74.366,473.286,1.610}
	local giang_thai_nga = "Qiecuojzt004"
	local giang_thai_nga_pos = {232.090,71.973,421.802,-2.498}
	while isStarted() do
		nx_pause(0.5)
		add_chat_info("Vo Nhai Kiem Phap: " ..step)
		if step == 1 then
			den_pos(yen_truong_khong_pos, isStarted)
			talk(yen_truong_khong, {0,0,0}, isStarted)
			nx_pause(1)
			talk(yen_truong_khong, {0}, isStarted)
			step = 2
		elseif step == 2 then
			study_book("tibook_CS_jz_wyjf03") -- thuong hai nhat tuc
			study_book("tibook_CS_jz_wyjf02") -- hai thien nhat tuyen
			study_book("tibook_CS_jz_wyjf04") -- hoi phong nhat kiem
			step = 3
		elseif step == 3 then
			den_pos(yen_truong_khong_pos, isStarted)
			talk(yen_truong_khong, {0,0,0}, isStarted)
			nx_pause(1)
			talk(yen_truong_khong, {0}, isStarted)
			study_book("tibook_CS_jz_wyjf05") -- phan qua nhat kich
			step = 4
		elseif step == 4 then
			den_pos(chu_hoa_pos, isStarted)
			talk(chu_hoa, {0}, isStarted)
			step = 5
		elseif step == 5 then
			if query_task_status_by_target(1287, chu_hoa) then
				step = 6
			else
				skill_use("CS_jz_xytf01") -- tam diep lac mai
			end
		elseif step == 6 then
			den_pos(yen_truong_khong_pos, isStarted)
			talk(yen_truong_khong, {0,0,0}, isStarted)
			nx_pause(1)
			talk(yen_truong_khong, {0}, isStarted)
			study_book("tibook_CS_jz_wyjf06") -- ngu thien nhat no
			step = 7
		elseif step == 7 then
			den_pos(giang_thai_nga_pos, isStarted)
			talk(giang_thai_nga, {0}, isStarted)
			step = 8
		elseif step == 8 then
			if query_task_status_by_target(1288, giang_thai_nga) then
				step = 9
			else
				skill_use("CS_jz_xytf01") -- tam diep lac mai
			end
		elseif step == 9 then
			den_pos(yen_truong_khong_pos, isStarted)
			talk(yen_truong_khong, {0,0,0}, isStarted)
			nx_pause(1)
			talk(yen_truong_khong, {0}, isStarted)
			step = 10
		elseif step == 10 then
			study_book("tibook_CS_jz_wyjf01") -- bich thuy nhat tam
			study_book("tibook_CS_jz_wyjf07") -- dang nhien nha khong
			step = 11
		elseif step == 11 then
			den_pos(yen_truong_khong_pos, isStarted)
			talk(yen_truong_khong, {0,0,0}, isStarted)
			step = 12
		end

		if step == 12 then
			break
		end
	end
end

function __talk_hue_bang_phi(choices, isStarted)
	local hue_bang_phi_id = "Npc_yd_wg_jx_jz01"
	local npc = getNpcById(hue_bang_phi_id)
	den_pos(getPos(npc), isStarted)
	talk(hue_bang_phi_id, choices, isStarted)
end

function chuan_bi_thuc_luc(isStarted)
	local step = 1
	while isStarted() do
		nx_pause(0.5)
		add_chat_info("Thuc Luc: " ..step)
		if step == 1 then
			step = 2
		elseif step == 2 then
			local ky_tran_mail = get_mail_by_item("box_power_redeem")
			if ky_tran_mail == nil then
				step = 3
			else
				rut_xoa_thu_by_serial(ky_tran_mail)
			end
		elseif step == 3 then
			local tuyet_lien_qua = get_mail_by_item("additem_0009")
			if tuyet_lien_qua == nil then
				step = 4
			else
				rut_xoa_thu_by_serial(tuyet_lien_qua)
			end
		elseif step == 4 then
			-- an tuyet lien qua
			dung_het_vat_pham(isStarted, "additem_0009", 2, 2)
			step = 5
		elseif step == 5 then
			-- do nothing
			step = 6
		elseif step == 6 then
			-- mo hop ky tran
			dung_het_vat_pham(isStarted, "box_power_redeem", 2, 1, {1,2,3,4})
			step = 7
		elseif step == 7 then
			-- an tinh che tuyet lien qua
			dung_het_vat_pham(isStarted, "additem_0020_4", 2, 0)
			step = 8
		elseif step == 8 then
			chinh_tu_all_mach(isStarted)
			step = 9
		elseif step == 9 then
			kich_hoat_noi_cong("ng_jz_006")
			step = 10
		elseif step == 10 then
			noi_tu_tieu_dao_thoai_phap(isStarted)
			step = 11
		elseif step == 11 then
			set_skill_short_cut(bang_tieu_diep_tan, 0) -- bang tieu diep tan
			nx_pause(0.5)
			set_skill_short_cut(con_ngoc_thu_suong, 1) -- con ngoc thu suong
			nx_pause(0.5)
			set_skill_short_cut(han_mai_nhi_tho, 2) -- han mai nhi tho
			nx_pause(0.5)
			set_skill_short_cut(san_san_luc_anh, 3) -- san san luc anh
			nx_pause(0.5)
			set_skill_short_cut(linh_xa_bai_vi, 4) -- linh xa bai vi
			nx_pause(0.5)
			set_skill_short_cut(tam_diep_lac_mai, 5) -- tam diep lac mai
			nx_pause(0.5)
			set_skill_short_cut(thu_hao_vo_pham, 6) -- thu hao vo pham
			step = 12
		end

		if step == 12 then
			break
		end
	end
end

function noi_tu_tieu_dao_thoai_phap(isStarted)
	local step = 1
	local con_ngoc_thu_suong = "CS_jz_xytf02"
	local bang_tieu_diep_tan = "CS_jz_xytf04"
	local thu_hao_vo_pham = "CS_jz_xytf05"
	local san_san_luc_anh = "CS_jz_xytf06"
	local han_mai_nhi_tho = "CS_jz_xytf07"
	local dich_can_dan = "faculty_event_02_2"
	while isStarted() do 
		nx_pause(0.5)
		if step == 1 then
			local skill = query_skill_info(san_san_luc_anh)
			if skill.Level == 1 then
				noi_tu_lv_4(isStarted, san_san_luc_anh)
			end
			step = 2
		elseif step == 2 then
			noi_tu(san_san_luc_anh)
			local skill = query_skill_info(san_san_luc_anh)
			if skill.Level == 4 then
				dung_vat_pham(dich_can_dan, 25, 5) -- len lv 5
			end
			step = 3
		elseif step == 3 then
			local skill = query_skill_info(han_mai_nhi_tho)
			if skill.Level < 4 then
				noi_tu_lv_4(isStarted, han_mai_nhi_tho)
			end
			step = 4
		elseif step == 4 then
			local skill = query_skill_info(con_ngoc_thu_suong)
			if skill.Level < 4 then
				noi_tu_lv_4(isStarted, con_ngoc_thu_suong)
			end
			step = 5
		elseif step == 5 then
			local skill = query_skill_info(bang_tieu_diep_tan)
			if skill.Level < 3 then
				noi_tu_lv_3(isStarted, bang_tieu_diep_tan)
			end
			step = 6
		elseif step == 6 then
			noi_tu(thu_hao_vo_pham)
			dung_vat_pham(dich_can_dan, 1, 5)
			step = 7
		elseif step == 7 then
			dien_vo(isStarted)
			check_noi_tu()
			step = 8
		end

		if step == 8 then break end
	end
end

function noi_tu_lv_4(isStarted, skill_id)
	local step = 1
	local dich_can_dan = "faculty_event_02_2"
	while isStarted() do 
		nx_pause(0.5)
		local skill_info = query_skill_info(skill_id)
		if skill_info.Level == 4 then 
			break
		end
		if step == 1 then
			noi_tu(skill_id)
			dung_vat_pham(dich_can_dan, 2, 4)
			step = 2
		elseif step == 2 then
			if skill_info.Level == 2 then -- cho 3'
				step = 3
			else
				dien_vo(isStarted, 1)
			end
		elseif step == 3 then
			noi_tu(skill_id)
			dung_vat_pham(dich_can_dan, 6, 4)
			step = 4
		elseif step == 4 then
			if skill_info.Level == 3 then
				step = 5
			end
		elseif step == 5 then
			noi_tu(skill_id)
			dung_vat_pham(dich_can_dan, 14, 4)
			step = 6
		elseif step == 6 then
			if skill_info.Level == 4 then -- cho 4'
				step = 7
			else
				dien_vo(isStarted, 1)
			end
		end
		if step == 7 then break end
	end
end

function noi_tu_lv_3(isStarted, skill_id)
	local step = 1
	local dich_can_dan = "faculty_event_02_2"
	while isStarted() do 
		nx_pause(0.5)
		local skill_info = query_skill_info(skill_id)
		if skill_info.Level == 3 then 
			break
		end
		if step == 1 then
			noi_tu(skill_id)
			dung_vat_pham(dich_can_dan, 2, 4)
			step = 2
		elseif step == 2 then
			if skill_info.Level == 2 then -- cho 3'
				step = 3
			else
				dien_vo(isStarted, 1)
			end
		elseif step == 3 then
			noi_tu(skill_id)
			dung_vat_pham(dich_can_dan, 6, 4)
			step = 4
		elseif step == 4 then
			if skill_info.Level == 3 then
				step = 5
			end
		end
		if step == 5 then break end
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
	active_mach(mach_clc)
	active_mach(mach_cb)
	active_mach(mach_vd)
	active_mach(mach_qtd)
end

function nhan_quest_gia_nhap_hs(isStarted)
	local step = 1
	local cm_pos = {529.110,103.650,457.678,1.569}
	local cm_npc = "WorldNpc03305"
	local combo = {
		[1] = han_mai_nhi_tho,
		[2] = con_ngoc_thu_suong,
		[3] = bang_tieu_diep_tan
		--[4] = linh_xa_bai_vi
	}
	local combo_count = 1
	while isStarted() do
		nx_pause(0.5)
		add_chat_info("Nhan Q HS Step: "..step)
		local map = LayMapHienTai()
		
		if step == 1 then
			if da_nhan_quest(30410) then
				step = 3
			elseif da_nhan_quest(30403) then
				if map ~= "city04" then
					step = 5
				else
					step = 8
				end
			else
				den_pos(cm_pos, isStarted)
				step = 2
			end
		elseif step == 2 then
			nx_pause(1)
			talk_id(cm_npc, {100030410, 101030410, 501030410}, isStarted)
			step = 3
		elseif step == 3 then
			local pos = {753.028,102.700,496.675,1.650}
			den_pos(pos, isStarted)
			equip_trang_bi("ssword_jz_10101")
			skill_use("CS_jz_wyjf05")
			step = 4
		elseif step == 4 then
			local target = query_uncomplete_task_target(30411)
			if target ~= nil then
				if combo_count > table.getn(combo) then
					combo_count = 1
				end
				target_npc(target)
				den_pos(getDest(getNpcById(target)), isStarted)
				local skill = combo[combo_count]
				skill_use(skill)
				combo_count = combo_count + 1
			else
				step = 5
			end
		elseif step == 5 then
			mo_than_hanh()
			nx_pause(1)
			thanhanh_add_hp_by_id(hp) -- them long mon thach quat bach thao duong lac duong
			step = 6
		elseif step == 6 then
			if map ~= "city04" then
				local hp = "HomePointcity04B"
				thanhanh_to_hp_by_id(hp)
				nx_pause(15)
			else
				step = 7
			end
		elseif step == 7 then
			if getNpcById("Relive_Fhjiangyou") ~= nil then
				step = 8
			end
		elseif step == 8 then
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
			elseif get_item_amount("itembag_002_a", 2) > 0 then
				step = 9
			end
		elseif step == 9 then
			local pos = {1014.126,-19.878,970.404,-1.033}
			local npc = "LuoYangLeitaiRewardNpc"
			den_pos(pos, isStarted)
			talk_id(npc, {805000000}, isStarted)
			local form = util_get_form("form_stage_main\\form_shop\\form_shop", true, false)
			local page = 0
			local shopId = "Shop_leitei_001"
			if form.Visible then
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 1, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 1, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 1, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 2, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 2, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 2, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 3, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 3, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 3, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 4, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 4, 1)
				nx_pause(0.5)
				nx_execute("custom_sender", "custom_buy_item", form.shopid, page, 4, 1)
				nx_destroy(form)
				step = 10
			end
		elseif step == 10 then
			local pos = {1747.864,0.116,1457.371,0.931}
			local npc = "DoorNpc00070"
			den_pos(pos, isStarted)
			local door = getNpcById(npc)
			if door ~= nil then
				jump_to(getPos(door))
				step = 11
			end
		elseif step == 11 then
			local door = "DoorNpc00073"
			if getNpcById(door) ~= nil then
				step = 12
			end
		elseif step == 12 then
			local pos = {1731.358,95.722,952.349,-1.781}
			local chu_lang_chi = "npc_hsp_cc_006"
			local chu_nhuoc_y = "npc_hsp_cc_005"
			den_pos(pos, isStarted)
			talk(chu_lang_chi, {0}, isStarted)
			den_pos(pos, isStarted)
			talk(chu_nhuoc_y, {0}, isStarted)
			den_pos(pos, isStarted)
			talk(chu_lang_chi, {0}, isStarted)
			step = 13
		elseif step == 13 then
			dung_vat_pham("wnhd_jianghudaxia_01", 1, 5)
			rut_va_xoa_mail("box_sxlb_001")
			dung_vat_pham("box_sxlb_001", 1, 5)
			dung_vat_pham("additem_0020", 1, 5)
			step = 14
		elseif step == 14 then
			equip_bo_trang_bi({
				"wrist_daxia_30301",
				"leg_daxia_30301",
				"shoes_daxia_30301",
				"pants_daxia_30301",
				"cloth_daxia_30301",
				"helmet_daxia_30301"
			})
			set_item_short_cut(get_item_unique_id("yaopin10009", 2), 200) --lag mau 2' -- phuc phuong bach duoc hoan
			set_item_short_cut(get_item_unique_id("yaopin_005001", 2), 201) --lag mau 10s -- tuc menh hoan
			set_item_short_cut(get_item_unique_id("lt_new_hp002", 2), 206) --lag mau 10' -- long ngam dan
			set_item_short_cut(get_item_unique_id("lt_new_hp001", 2), 207) --lag mau full -- ho khieu dan
			set_item_short_cut(get_item_unique_id("lt_new_mp002", 2), 208) --lag mp 10' -- phung minh dan
			set_item_short_cut(get_item_unique_id("lt_new_mp001", 2), 209) --lag mp full -- quy van dan
			rut_va_xoa_mail("binglu113")
			step = 15
		end

		if step == 15 then
			break
		end
	end
end

function lam_quest_thi_kiem_that_tu(isStarted)
	local step = 8
	local thai_phong = "npc_hsp_020"
	local thai_phong_target = "npc_hsp_cc_028"
	local lam_dat_quyen = "npc_hsp_019"
	local lam_dat_quyen_target = "npc_hsp_cc_027"
	local ta_lac_siu = "npc_hsp_018"
	local ta_lac_siu_target = "npc_hsp_cc_026"
	local van_tuy_minh = "npc_hsp_017"
	local van_tuy_minh_target = "npc_hsp_cc_025"
	local dien_nguyen_tuc_target = "npc_hsp_cc_024"
	local don_hoa_le = "npc_hsp_cc_023"
	local trinh_van_anh = "npc_hsp_cc_022"
	while isStarted() do
		nx_pause(0.5)
		if step == 1 then
			local status = query_task_status_by_target(30404, thai_phong_target)
			if not status then
				local pos = {1777.177,97.663,900.764,1.469}
				den_pos(pos, isStarted)
				skill_use(thu_hao_vo_pham)
				nx_pause(3)
				talk(thai_phong_target, {0}, isStarted)
			end
			step = 2
		elseif step == 2 then
			local status = query_task_status_by_target(30404, thai_phong_target)
			if status then
				step = 3
			else
				-- danh boss
			end
		elseif step == 3 then
			local status = query_task_status_by_target(30404, lam_dat_quyen_target)
			if not status then
				local pos = {1760.488,101.616,855.694,-2.417}
				den_pos(pos, isStarted)
				skill_use(thu_hao_vo_pham)
				nx_pause(3)
				talk(lam_dat_quyen_target, {0}, isStarted)
			end
			step = 4
		elseif step == 4 then
			local status = query_task_status_by_target(30404, lam_dat_quyen_target)
			if status then
				step = 5
			else
				-- danh boss
			end
		elseif step == 5 then
			local status = query_task_status_by_target(30404, ta_lac_siu_target)
			if not status then
				local pos =  {1810.739,103.239,879.184,-0.702}
				den_pos(pos, isStarted)
				talk(ta_lac_siu_target, {0,0,0,0,0,0,0,0}, isStarted)
			end
			step = 6
		elseif step == 6 then
			local status = query_task_status_by_target(30404, van_tuy_minh_target)
			if not status then
				local pos =  {1846.642,109.167,849.980,2.456}
				den_pos(pos, isStarted)
				talk(van_tuy_minh_target, {0}, isStarted)
			end
			step = 7
		elseif step == 7 then
			local status = query_task_status_by_target(30404, van_tuy_minh_target)
			if status then
				step = 8
			else
				-- danh boss
			end
		elseif step == 8 then
			local status = query_task_status_by_target(30405, dien_nguyen_tuc_target)
			if not status then
				local pos = {1868.346,113.484,812.549,-3.067}
				den_pos(pos, isStarted)
				talk(dien_nguyen_tuc_target, {0}, isStarted)
			end
			step = 9
		elseif step == 9 then
			local status = query_task_status_by_target(30405, don_hoa_le)
			if not status then
				local pos = {1830.503,115.585,756.773,-2.839}
				den_pos(pos, isStarted)
				talk(don_hoa_le, {0, 0}, isStarted)
			end
			step = 10
		elseif step == 10 then
			local status = query_task_status_by_target(30405, trinh_van_anh)
			if not status then
				local pos = {1819.445,118.290,812.088,-0.286}
				den_pos(pos, isStarted)
				skill_use(thu_hao_vo_pham)
				nx_pause(3)
				talk(trinh_van_anh, {0}, isStarted)
			end
			step = 11
		elseif step == 11 then
			local status = query_task_status_by_target(30405, trinh_van_anh)
			if status then
				step = 12
			else
				-- danh boss
			end
		end

		if step == 12 then
			add_chat_info("DONE")
			break
		end
	end
end

function close_all_open_form()
	local form = util_get_form("form_stage_main\\from_word_protect\\form_protect_tips", false, false)
	if nx_is_valid(form) then
		nx_destroy(form)
	end
	form = util_get_form("form_stage_main\\from_word_protect\\form_time_protect", false, false)
	if nx_is_valid(form) then
		nx_destroy(form)
	end
	form = util_get_form("form_common\\form_confirm", false, false)
	if nx_is_valid(form) then
		nx_execute("form_common\\form_confirm", "ok_btn_click", form)
	end
end
return story_hs
