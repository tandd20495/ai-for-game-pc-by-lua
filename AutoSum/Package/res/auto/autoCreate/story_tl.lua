local file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\so_nhap.lua"))
local so_nhap = file()
file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\joinschool.lua"))
file()
local school_map = "school08"
local dvd_map = "groupscene012"
local nguoi_chi_dan_id = "FuncNpc00728"
local nguoi_chi_dan_pos = {744.880,62.301,549.637,-1.417}
local chuong_mon_id = "WorldNpc00212"
local chuong_mon_pos = {822.898,79.563,358.287,2.378}
local so_nhap_phai = "tl"
local q_gia_nhap_phai = 51
local skill_dao_bo_that_tinh = "CS_jh_cqgf05"

-- hoc vo cong 1
local skillset_1_prefix = "CS_sl_djgq0"
local q_nc1 = 1151
local q_dien_vo = 1140
local q_cach_dung_skill = 1661
local q_do_don = 1662
local q_cong_kich_thuong = 1663
local q_skill_no = 1664
local q_hoc_nghe_thanh_cong = 1665
local dien_vo_duong_out_id = "Npc_yd_wg_cs_sl02"
local dien_vo_duong_id = "Npc_yd_wg_cs_sl01"
local dien_vo_duong_pos = {864.770,75.891,432.783,-0.352}
local dai_de_tu_id = "Npc_yd_wg_jx_sl01"
local dai_de_tu_pos = {-16.105,15.537,1.677,-3.096}
local day_kien_vi_id = "Npc_yd_wg_jx_sl02"
local day_kien_vi_pos = {-11.423,15.497,-6.536,1.449}
local day_phong_ngu_id = "Npc_yd_wg_jx_sl03"
local day_phong_ngu_pos = {-14.584,15.497,-6.907,-1.688}
local day_pha_phong_id = "Npc_yd_wg_jx_sl04"
local day_pha_phong_pos = {-18.865,15.497,-7.125,-1.622}
local day_no_khi_id = "Npc_yd_wg_jx_sl05"
local day_no_khi_pos = {-22.325,15.497,-6.613,-1.558}
local nc1_page = "ng_tbook_sl_001"
local nc1 = "ng_sl_001"
local skill_bach_van_cai_dinh = "CS_jh_cqgf02"
local skill_hoai_trung_bao_nguyen = "CS_jh_cqgf03"
local skill_cong_kich_thuong = "zs_normal_00"
-- hoc vo cong 2
local skillset_2_prefix = "CS_sl_dmgf0"
local q_hoc_nghe_thanh_cong_2 = 1665
local q_vo_2_chuong_1 = 1409
local q_vo_2_chuong_2 = 1410
local q_vo_2_chuong_3 = 1411
local q_vo_2_chuong_4 = 1412
local npc_vo_hoc_2_pos = {899.387,86.351,340.976,2.788}
local npc_vo_hoc_2_id = "WorldNpc00210"
local doi_noi_cong_6_id = "npc_6nei_sl_shop01"
local doi_noi_cong_6_pos = {746.931,73.169,394.894,-0.295}
local npc_vo_2_chuong_2_danh_pos = {870.426,75.891,437.284,-0.300}
local npc_vo_2_chuong_2_danh_id = "Qiecuo008"
local npc_vo_2_chuong_3_danh_pos = {866.909,75.591,437.105,-0.298}
local npc_vo_2_chuong_3_danh_id = "Qiecuo009"
local nc6 = "ng_sl_006"
local nc6_page1 = "ng_book_sl_00601"
local skil_last_skill_1 = "CS_sl_djgq07"
local skill_vu_hoa_toa_son = "CS_jh_cqgf01"
-- hoc vo cong 3
local skillset_3_prefix = "CS_sl_wtgf0"
local q_vo_hoc_3 = 1295
local q_vo_3_chuong_1 = 1246
local q_vo_3_chuong_2 = 1247
local q_vo_3_chuong_3 = 1248
local q_vo_3_chuong_4 = 1249
local npc_vo_hoc_3_pos = {745.305,126.665,178.715,-1.790}
local npc_vo_hoc_3_id = "WorldNpc00211"
local npc_vo_3_chuong_2_danh_pos = {867.893,133.129,210.840,-1.957}
local npc_vo_3_chuong_2_danh_id = "WorldNpc00363"
local npc_vo_chuong_3_danh_pos = {604.554,65.133,165.298,-1.868}
local npc_vo_chuong_3_danh_id = "WorldNpc00332"
local skill_last_skill_3 = "CS_sl_wtgf03"
local main_skill_weapon = "lstuff_sl_10101"
local main_skill_faculty = {
	{
		["name"] = "CS_sl_djgq06",
		["level"] = 5
	},
	{
		["name"] = "CS_sl_djgq03",
		["level"] = 5
	},
	{
		["name"] = "CS_sl_djgq07",
		["level"] = 5
	},
	{
		["name"] = "CS_sl_djgq08",
		["level"] = 5
	}
}
local main_skillset_from = 0
local main_skillset_to = 7
local binh_luc_id = 100

function story(isStarted)
	local xa_phu = {
		id = "Transcity05D",
		pos = {490.969,24.105,873.176,-1.309}
	}
	local second_npc = {
		id = "Npc_yd_sh_cd_01",
		pos = {493.943,24.105,870.205,2.898}
	}
	local job_npc
	local step = 1
	while isStarted() do
		nx_pause(0.5)
		add_chat_info("Step: "..step)
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		
		if nx_is_valid(nx_value("form_stage_main\\form_map\\form_map_scene")) 
			and not nx_value("loading")
		then
			local current_map = LayMapHienTai()
			if step == 1 then
				-- if da_nhan_quest(q_nc1) or current_map == dvd_map or da_hoc_skill(skill_dao_bo_that_tinh) then 
					-- break 
				-- else
				if da_nhan_quest(q_gia_nhap_phai) then
					if not query_task_done_single(q_gia_nhap_phai) then
						step = 3
					else
						step = 4
					end
				else
					so_nhap(isStarted, xa_phu, second_npc, job_npc, so_nhap_phai)
					step = 2
				end
			elseif step == 2 then
				if current_map == school_map then
					step = 3
				end
			elseif step == 3 then
				if getNpcById(nguoi_chi_dan_id) ~= nil then
					den_pos(nguoi_chi_dan_pos, isStarted)
					talk_id(nguoi_chi_dan_id, {1000}, isStarted)
					step = 4
				end
			elseif step == 4 then
				ngu_phong()
				den_pos(chuong_mon_pos, isStarted)
				talk(chuong_mon_id, {0, 0, 0, 0, 0}, isStarted)
				step = 5
			elseif step == 5 then
				den_pos(chuong_mon_pos, isStarted)
				talk(chuong_mon_id, {0,0,1,0}, isStarted)
				step = 6
			elseif step == 6 then -- uong thuoc doc
				den_pos(chuong_mon_pos, isStarted)
				talk(chuong_mon_id, {0,0}, isStarted)
				step = 7
			elseif step == 7 then -- nhan thuoc kinh mach
				den_pos(chuong_mon_pos, isStarted)
				talk(chuong_mon_id, {0,0}, isStarted)
				talk(chuong_mon_id, {0,0}, isStarted)
				step = 8
			elseif step == 8 then -- dung thuoc kinh mach
				local kinh_mach = "jmitem_actadd_03"
				local kinh_mach_count = get_item_amount(kinh_mach, 2)
				if kinh_mach_count == 1 then
					dung_vat_pham(kinh_mach, 1, 5)
					step = 10
				end
			end
		end
		if step == 10 then break end
	end

	local data = {
		["binh_luc"] = binh_luc_id,
		["school"] = "sl",
		["main_skill_faculty"] = main_skill_faculty,
		["nc6"] = nc6,
		["doi_noi_cong_6_pos"] = doi_noi_cong_6_pos,
		["doi_noi_cong_6_id"] = doi_noi_cong_6_id
	}
	join_school_learn_skill(isStarted)
	chuan_bi_thuc_luc(isStarted, data)
end

function join_school_learn_skill(isStarted)
	pw2()
	set_auto_do_don()
	hoc_tho_thien_cong_phu(isStarted)
	local step = 1
	while isStarted() do
		nx_pause(0)
		local current_map = LayMapHienTai()
		_hoc_vo_hoc_1()
		_hoc_vo_hoc_2()
		_hoc_vo_hoc_3()
		ngu_phong()
		if da_nhan_quest(q_nc1) then
			if current_map == school_map then
				if not arrived(dien_vo_duong_pos) then
					step = 1
					move(dien_vo_duong_pos)
				else
					step = 2
					local dien_vo_duong = getNpcById(dien_vo_duong_id)
					if dien_vo_duong ~= nil then
						step = 3
						move(getPos(dien_vo_duong))
					end
				end
			elseif current_map == dvd_map then
				step = 4
				move(dai_de_tu_pos)
				if arrived(dai_de_tu_pos) then
					step = 5
					talk(dai_de_tu_id, {0,0,0}, isStarted)
				end
			end
		elseif get_item_amount(nc1_page, 2) == 1 then
			step = 6
			study_book(nc1_page)
		elseif da_nhan_quest(q_dien_vo) then
			if not query_task_done_single(q_dien_vo) then
				if get_player_prop("FacultyName") ~= nc1 then
					step = 8
					noi_tu(nc1)
				else
					step = 9
					dien_vo(isStarted, 1)
				end
			else
				step = 10
				move(dai_de_tu_pos)
				talk(dai_de_tu_id, {0, 0, 0}, isStarted)
			end
		elseif da_nhan_quest(q_cach_dung_skill) then
			move(dai_de_tu_pos)
			talk(dai_de_tu_id, {0, 0, 0}, isStarted)
		elseif da_nhan_quest(q_do_don) then
			step = 11
			if not query_task_status_by_target(q_do_don, "Qiecuo_jiaoxue_parry_1_"..nx_string(q_do_don)) then
				move(day_phong_ngu_pos)
				if can_talk(day_phong_ngu_id) then
					step = 12
					talk(day_phong_ngu_id, {0}, isStarted)
				else
					step = 13
					-- do don`
				end
			elseif not query_task_status_by_target(q_do_don, dai_de_tu_id) then
				step = 14
				move(dai_de_tu_pos)
				talk(dai_de_tu_id, {0,0}, isStarted)
			elseif not query_task_status_by_target(q_do_don, "Qiecuo_jiaoxue_parry_3_"..nx_string(q_do_don)) then
				step = 15
				move(day_phong_ngu_pos)
				if can_talk(day_phong_ngu_id) then
					step = 16
					talk(day_phong_ngu_id, {0}, isStarted)
				else
					step = 17
					skill_use(skill_hoai_trung_bao_nguyen)
				end
			else
				step = 18
				move(dai_de_tu_pos)
				talk(dai_de_tu_id, {0,0,0}, isStarted)
			end
		elseif da_nhan_quest(q_cong_kich_thuong) then
			step = 19
			if not query_task_status_by_target(q_cong_kich_thuong, "Qiecuo_jiaoxue_virtual_1_" ..nx_string(q_cong_kich_thuong)) then
				move(day_pha_phong_pos)
				if can_talk(day_pha_phong_id) then
					step = 20
					talk(day_pha_phong_id, {0}, isStarted)
				else
					step = 21
					skill_use(skill_cong_kich_thuong)
				end
			elseif not query_task_status_by_target(q_cong_kich_thuong, dai_de_tu_id) then
				step = 22
				move(dai_de_tu_pos)
				talk(dai_de_tu_id, {0,0}, isStarted)
			elseif not query_task_status_by_target(q_cong_kich_thuong, "Qiecuo_jiaoxue_virtual_3_" ..nx_string(q_cong_kich_thuong)) then
				step = 23
				move(day_pha_phong_pos)
				set_skill_short_cut(skill_bach_van_cai_dinh, 4)
				if can_talk(day_pha_phong_id) then
					step = 24
					talk(day_pha_phong_id, {0}, isStarted)
				else
					step = 25
					skill_use(skill_bach_van_cai_dinh)
				end
			else
				step = 26
				move(dai_de_tu_pos)
				talk(dai_de_tu_id, {0,0,0}, isStarted)
			end
		elseif da_nhan_quest(q_skill_no) then
			step = 27
			if not query_task_done_single(q_skill_no) then
				set_skill_short_cut(skill_dao_bo_that_tinh, 5)
				move(day_no_khi_pos)
				if can_talk(day_no_khi_id) then
					step = 28
					talk(day_no_khi_id, {0}, isStarted)
				else
					step = 29
					skill_use(skill_dao_bo_that_tinh)
				end
			else
				step = 30
				move(dai_de_tu_pos)
				talk(dai_de_tu_id, {0,0,0}, isStarted)
			end
		elseif da_nhan_quest(q_hoc_nghe_thanh_cong) then
			step = 31
			if current_map == dvd_map then
				step = 32
				local door = getNpcById(dien_vo_duong_out_id)
				local pos = getPos(door)
				if not arrived(pos) then
					move(pos)
				end
			elseif current_map == school_map then
				step = 33
				ngu_phong()
				move(npc_vo_hoc_2_pos)
				if arrived(npc_vo_hoc_2_pos) then
					step = 34
					talk(npc_vo_hoc_2_id, {0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(q_hoc_nghe_thanh_cong_2) then
			step = 35
			move(npc_vo_hoc_2_pos)
			if arrived(npc_vo_hoc_2_pos) then
				step = 36
				talk(npc_vo_hoc_2_id, {0,0}, isStarted)
			end
		elseif da_nhan_quest(q_vo_2_chuong_1) then
			if not query_task_status_by_target(q_vo_2_chuong_1, npc_vo_hoc_2_id) then
				move(npc_vo_hoc_2_pos)
				step = 43
				if arrived(npc_vo_hoc_2_pos) then
					step = 44
					talk(npc_vo_hoc_2_id, {0}, isStarted)
				end
			else
				move(npc_vo_hoc_2_pos)
				step = 47
				if arrived(npc_vo_hoc_2_pos) then
					step = 48
					talk(npc_vo_hoc_2_id, {0,0,0,0}, isStarted) -- sau buoc nay se het task, va chay tiep phan check nc6 de nhan Q chuong 2
				end
			end
		elseif da_nhan_quest(q_vo_2_chuong_2) then
			if not query_task_status_by_target(q_vo_2_chuong_2, npc_vo_hoc_2_id) then
				step = 49
				move(npc_vo_hoc_2_pos)
				if arrived(npc_vo_hoc_2_pos) then
					step = 50
					talk(npc_vo_hoc_2_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(q_vo_2_chuong_2, npc_vo_2_chuong_2_danh_id) then
				if arrived(npc_vo_2_chuong_2_danh_pos) then
					step = 53
					if can_talk(npc_vo_2_chuong_2_danh_id) then
						step = 54
						talk(npc_vo_2_chuong_2_danh_id, {0}, isStarted)
					else
						step = 55
						skill_use(skill_vu_hoa_toa_son)
					end
				else
					step = 56
					move(npc_vo_2_chuong_2_danh_pos)
				end
			else
				step = 51
				move(npc_vo_hoc_2_pos)
				if arrived(npc_vo_hoc_2_pos) then
					step = 52
					talk(npc_vo_hoc_2_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(q_vo_2_chuong_3) then
			if not query_task_status_by_target(q_vo_2_chuong_3, npc_vo_hoc_2_id) then
				step = 57
				move(npc_vo_hoc_2_pos)
				if arrived(npc_vo_hoc_2_pos) then
					step = 58
					talk(npc_vo_hoc_2_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(q_vo_2_chuong_3, npc_vo_2_chuong_3_danh_id) then
				if arrived(npc_vo_2_chuong_3_danh_pos) then
					step = 60
					if can_talk(npc_vo_2_chuong_3_danh_id) then
						step = 61
						talk(npc_vo_2_chuong_3_danh_id, {0}, isStarted)
					else
						step = 62
						skill_use(skill_vu_hoa_toa_son)
					end
				else
					step = 59
					move(npc_vo_2_chuong_3_danh_pos)
				end
			else
				move(npc_vo_hoc_2_pos)
				if arrived(npc_vo_hoc_2_pos) then
					step = 63
					talk(npc_vo_hoc_2_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(q_vo_2_chuong_4) then
			if not query_task_status_by_target(q_vo_2_chuong_4, npc_vo_hoc_2_id) then 
				move(npc_vo_hoc_2_pos)
				step = 64
				if arrived(npc_vo_hoc_2_pos) then
					step = 65
					talk(npc_vo_hoc_2_id, {0,0,0}, isStarted)
				end
			else
				move(npc_vo_hoc_2_pos)
				step = 64
				if arrived(npc_vo_hoc_2_pos) then
					step = 65
					talk(npc_vo_hoc_2_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(q_vo_hoc_3) then
			step = 66
			move(npc_vo_hoc_3_pos)
			if arrived(npc_vo_hoc_3_pos) then
				step = 67
				talk(npc_vo_hoc_3_id, {0,0,0}, isStarted)
			end
		elseif da_nhan_quest(q_vo_3_chuong_1) then
			if not query_task_status_by_target(q_vo_3_chuong_1, npc_vo_hoc_3_id) then 
				step = 68
				move(npc_vo_hoc_3_pos)
				if arrived(npc_vo_hoc_3_pos) then
					step = 69
					talk(npc_vo_hoc_3_id, {0}, isStarted)
				end
			else
				step = 72
				move(npc_vo_hoc_3_pos)
				if arrived(npc_vo_hoc_3_pos) then
					step = 73
					talk(npc_vo_hoc_3_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(q_vo_3_chuong_2) then
			if not query_task_status_by_target(q_vo_3_chuong_2, npc_vo_hoc_3_id) then
				step = 74
				move(npc_vo_hoc_3_pos)
				if arrived(npc_vo_hoc_3_pos) then
					step = 75
					talk(npc_vo_hoc_3_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(q_vo_3_chuong_2, npc_vo_3_chuong_2_danh_id) then
				if arrived(npc_vo_3_chuong_2_danh_pos) then
					step = 76
					if can_talk(npc_vo_3_chuong_2_danh_id) then
						step = 77
						talk(npc_vo_3_chuong_2_danh_id, {0}, isStarted)
					else
						step = 78
						skill_use(skill_vu_hoa_toa_son)
					end
				else
					step = 79
					move(npc_vo_3_chuong_2_danh_pos)
				end
			else
				step = 80
				move(npc_vo_hoc_3_pos)
				if arrived(npc_vo_hoc_3_pos) then
					step = 81
					talk(npc_vo_hoc_3_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(q_vo_3_chuong_3) then
			if not query_task_status_by_target(q_vo_3_chuong_3, npc_vo_hoc_3_id) then
				step = 74
				move(npc_vo_hoc_3_pos)
				if arrived(npc_vo_hoc_3_pos) then
					step = 75
					talk(npc_vo_hoc_3_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(q_vo_3_chuong_3, npc_vo_chuong_3_danh_id) then
				if arrived(npc_vo_chuong_3_danh_pos) then
					step = 77
					if can_talk(npc_vo_chuong_3_danh_id) then
						step = 78
						talk(npc_vo_chuong_3_danh_id, {0}, isStarted)
					else
						step = 79
						skill_use(skill_vu_hoa_toa_son)
					end
				else
					step = 76
					move(npc_vo_chuong_3_danh_pos)
				end
			else
				step = 80
				move(npc_vo_hoc_3_pos)
				if arrived(npc_vo_hoc_3_pos) then
					step = 81
					talk(npc_vo_hoc_3_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(q_vo_3_chuong_4) then
			if not query_task_status_by_target(q_vo_3_chuong_4, npc_vo_hoc_3_id) then 
				move(npc_vo_hoc_3_pos)
				step = 82
				if arrived(npc_vo_hoc_3_pos) then
					step = 83
					talk(npc_vo_hoc_3_id, {0,0,0}, isStarted)
				end
			else
				move(npc_vo_hoc_3_pos)
				step = 84
				if arrived(npc_vo_hoc_3_pos) then
					step = 85
					talk(npc_vo_hoc_3_id, {0,0,0}, isStarted)
				end
			end
		elseif da_hoc_skill(skill_last_skill_3) then
			set_main_skillset_shortcut(skillset_1_prefix, main_skillset_from, main_skillset_to)
			equip_trang_bi(main_skill_weapon)
			kich_hoat_noi_cong(nc6)
			break
		elseif da_hoc_nc(nc6) then
			move(npc_vo_hoc_2_pos)
			step = 41
			if arrived(npc_vo_hoc_2_pos) then
				step = 42
				talk(npc_vo_hoc_2_id, {0,0}, isStarted)
			end
		elseif da_hoc_skill(skil_last_skill_1) and not da_hoc_nc(nc6) then 
			if get_item_amount("box_bzjh_001", 2) > 0 then
				step = 37
				dung_vat_pham("box_bzjh_001", 1, 5) -- thuong bon tau 1
			elseif get_item_amount("box_active_02", 2) > 0 then
				step = 38
				dung_het_vat_pham(isStarted, "box_active_02", 2, 1, {1}) -- qua the mon phai 10 lb
			elseif get_item_amount("item_honor_" ..school_map, 125) >= 10 then -- doi nc6
				if arrived(doi_noi_cong_6_pos) then
					step = 40
					talk_id(doi_noi_cong_6_id, {805000000}, isStarted)
					local form = util_get_form("form_stage_main\\form_shop\\form_shop", true)
					nx_pause(0.5)
					nx_execute("custom_sender", "custom_exchange_item", form.shopid, form.curpage, 1, 1)
					nx_pause(0.5)
					nx_destroy(form)
				else
					step = 39
					move(doi_noi_cong_6_pos)
				end
			elseif has_item(nc6_page1, 2) then
				study_book(nc6_page1)
			end
		elseif da_hoc_nc(nc1) then
			step = 7
			move(dai_de_tu_pos)
			talk(dai_de_tu_id, {0, 0}, isStarted)
		end
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		add_chat_info("Learn Skill: " ..step)
	end
	add_chat_info("Learn Skill Done at: " ..step)
end

function _hoc_vo_hoc_1()
	hoc_all_skills(skillset_1_prefix, 8)
end

function _hoc_vo_hoc_2()
	hoc_all_skills(skillset_2_prefix, 7)
end

function _hoc_vo_hoc_3()
	hoc_all_skills(skillset_3_prefix, 6)
end

function hoc_all_skills(id, count)
	for i = 1, count do
		nx_pause(0)
		if has_item("tibook_" ..id ..nx_string(i), 2) then
			study_book("tibook_" ..id ..nx_string(i))
		end
	end
end

function set_main_skillset_shortcut(skillset_prefix, from, to)
	local skill_index = 1
	for i = from, to do
		set_skill_short_cut(skillset_prefix ..nx_string(skill_index), i - 1)
		skill_index = skill_index + 1
	end
	
	set_skill_short_cut("zs_default_01", 9) -- toa thien
end

return story

