local file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\so_nhap.lua"))
local so_nhap = file()
file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\joinschool.lua"))
file()
local clc_map = "school04"
local dvd_map = "groupscene018"
local skills = {
	{
		["name"] = "CS_jl_shuangci07",
		["level"] = 5
	},
	{
		["name"] = "CS_jl_shuangci02",
		["level"] = 5
	},
	{
		["name"] = "CS_jl_shuangci05",
		["level"] = 5
	},
	{
		["name"] = "CS_jl_shuangci06",
		["level"] = 5
	}
}

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
	local nguoi_chi_dan_id = "FuncNpc01404"
	local nguoi_chi_dan_pos = {387.000,71.615,119.000,-1.993}
	local chuong_mon_id = "WorldNpc03816"
	local chuong_mon_pos = {82.391,144.620,-26.308,-2.269}
	while isStarted() do
		nx_pause(0.5)
		add_chat_info("Step: "..step)
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		local current_map = LayMapHienTai()
		if step == 1 then
			if da_nhan_quest(1157) or current_map == dvd_map or da_hoc_skill("CS_jh_cqgf05") then 
				break 
			elseif da_nhan_quest(57) then
				if not query_task_done_single(57) then
					step = 3
				else
					step = 4
				end
			else
				so_nhap(isStarted, xa_phu, second_npc, job_npc, "clc")
				step = 2
			end
		elseif step == 2 then
			if current_map == clc_map then
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
			talk(chuong_mon_id, {0}, isStarted)
			step = 6
		elseif step == 6 then -- uong thuoc doc
			local thuoc_doc = "useitem_bs003"
			local thuoc_doc_count = get_item_amount(thuoc_doc, 125)
			if thuoc_doc_count == 1 then
				dung_item_nhiem_vu(thuoc_doc, 1, 5)
				step = 7
			end
		elseif step == 7 then -- gia nhap cuc lac coc
			den_pos(chuong_mon_pos, isStarted)
			talk(chuong_mon_id, {0,0}, isStarted)
			step = 8
		elseif step == 8 then -- nhan thuoc kinh mach
			den_pos(chuong_mon_pos, isStarted)
			talk(chuong_mon_id, {0,0}, isStarted)
			talk(chuong_mon_id, {0,0}, isStarted)
			step = 9
		elseif step == 9 then -- dung thuoc kinh mach
			local kinh_mach = "jmitem_actadd_03"
			local kinh_mach_count = get_item_amount(kinh_mach, 2)
			if kinh_mach_count == 1 then
				dung_vat_pham(kinh_mach, 1, 5)
				step = 10
			end
		end
		if step == 10 then break end
	end

	local data = {
		["main_skill_faculty"] = skills,
		["school"] = "jl",
		["doi_noi_cong_6_pos"] =  {153.555,128.096,49.916,-0.373},
		["doi_noi_cong_6_id"] = "npc_6nei_jl_shop01",
		["nc6"] = "ng_jl_006"
	}
	__join_school_learn_skill(isStarted)

	chuan_bi_thuc_luc(isStarted, data)
end

function __join_school_learn_skill(isStarted)
	local dien_vo_duong_id = "Npc_yd_wg_cs_jl01"
	local dien_vo_duong_pos = {178.473,128.076,-94.115,1.037}
	local step = 1
	-- hoc vo cong 1
	local dien_dong_id = "Npc_yd_wg_jx_jl01"
	local dien_dong_pos = {-16.105,15.537,1.677,-3.096}
	local tiet_truyen_long_id = "Npc_yd_wg_jx_jl02"
	local tiet_truyen_long_pos = {-11.423,15.497,-6.536,1.449}
	local du_mong_id = "Npc_yd_wg_jx_jl03"
	local du_mong_pos = {-14.584,15.497,-6.907,-1.688}
	local vien_long_id = "Npc_yd_wg_jx_jl04"
	local vien_long_pos = {-18.865,15.497,-7.125,-1.622}
	local duong_thanh_id = "Npc_yd_wg_jx_jl05"
	local duong_thanh_pos = {-22.325,15.497,-6.613,-1.558}
	local nc1_page = "ng_tbook_jl_001"
	local nc1 = "ng_jl_001"
	-- hoc vo cong 2
	local vu_ho_pos = {247.903,91.662,47.752,3.026}
	local vu_ho_id = "WorldNpc03811"
	-- hoc vo cong 3
	local don_thien_ta_pos = {264.764,89.905,114.096,-0.442}
	local don_thien_ta_id = "WorldNpc03807"
	set_auto_do_don()
	hoc_tho_thien_cong_phu(isStarted)
	while isStarted() do
		nx_pause(0)
		local current_map = LayMapHienTai()
		_hoc_truy_phong_dao()
		_hoc_hu_cot_chuong()
		_hoc_thien_dia_diet_thich()
		ngu_phong()
		if da_nhan_quest(1157) then -- hoc nc 1
			if current_map == clc_map then
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
				move(dien_dong_pos)
				if arrived(dien_dong_pos) then
					step = 5
					talk(dien_dong_id, {0,0,0}, isStarted)
				end
			end
		elseif get_item_amount(nc1_page, 2) == 1 then -- da nhan nc1
			step = 6
			study_book(nc1_page)
		elseif da_nhan_quest(1146) then
			if not query_task_done_single(1146) then
				if get_player_prop("FacultyName") ~= nc1 then
					step = 8
					noi_tu(nc1)
				else
					step = 9
					dien_vo(isStarted, 1)
				end
			else
				step = 10
				move(dien_dong_pos)
				talk(dien_dong_id, {0, 0, 0}, isStarted)
			end
		elseif da_nhan_quest(1691) then -- cach dung skill
			move(dien_dong_pos)
			talk(dien_dong_id, {0, 0, 0}, isStarted)
		elseif da_nhan_quest(1692) then -- Q do don`
			step = 11
			if not query_task_status_by_target(1692, "Qiecuo_jiaoxue_parry_1_1692") then
				move(du_mong_pos)
				if can_talk(du_mong_id) then
					step = 12
					talk(du_mong_id, {0}, isStarted)
				else
					step = 13
					-- do don`
				end
			elseif not query_task_status_by_target(1692, "Npc_yd_wg_jx_jl01") then
				step = 14
				move(dien_dong_pos)
				talk(dien_dong_id, {0,0}, isStarted)
			elseif not query_task_status_by_target(1692, "Qiecuo_jiaoxue_parry_3_1692") then
				step = 15
				move(du_mong_pos)
				if can_talk(du_mong_id) then
					step = 16
					talk(du_mong_id, {0}, isStarted)
				else
					step = 17
					skill_use("CS_jh_cqgf03")
				end
			else
				step = 18
				move(dien_dong_pos)
				talk(dien_dong_id, {0,0,0}, isStarted)
			end
		elseif da_nhan_quest(1693) then -- Q cong kich thuong
			step = 19
			if not query_task_status_by_target(1693, "Qiecuo_jiaoxue_virtual_1_1693") then
				move(vien_long_pos)
				if can_talk(vien_long_id) then
					step = 20
					talk(vien_long_id, {0}, isStarted)
				else
					step = 21
					skill_use("zs_normal_00") -- con kich thuong do thu
				end
			elseif not query_task_status_by_target(1693, "Npc_yd_wg_jx_jl01") then
				step = 22
				move(dien_dong_pos)
				talk(dien_dong_id, {0,0}, isStarted)
			elseif not query_task_status_by_target(1693, "Qiecuo_jiaoxue_virtual_3_1693") then
				step = 23
				move(vien_long_pos)
				set_skill_short_cut("CS_jh_cqgf02", 4)
				if can_talk(vien_long_id) then
					step = 24
					talk(vien_long_id, {0}, isStarted)
				else
					step = 25
					skill_use("CS_jh_cqgf02")
				end
			else
				step = 26
				move(dien_dong_pos)
				talk(dien_dong_id, {0,0,0}, isStarted)
			end
		elseif da_nhan_quest(1694) then -- Q skill no
			step = 27
			if not query_task_done_single(1694) then
				set_skill_short_cut("CS_jh_cqgf05", 5)
				move(duong_thanh_pos)
				if can_talk(duong_thanh_id) then
					step = 28
					talk(duong_thanh_id, {0}, isStarted)
				else
					step = 29
					skill_use("CS_jh_cqgf05")
				end
			else
				step = 30
				move(dien_dong_pos)
				talk(dien_dong_id, {0,0,0}, isStarted)
			end
		elseif da_nhan_quest(1695) then -- tra Q hoc nghe thanh cong
			step = 31
			if current_map == dvd_map then
				step = 32
				local door = getNpcById("Npc_yd_wg_cs_jl02")
				local pos = getPos(door)
				if not arrived(pos) then
					move(pos)
				end
			elseif current_map == clc_map then
				step = 33
				ngu_phong()
				move(vu_ho_pos)
				if arrived(vu_ho_pos) then
					step = 34
					talk(vu_ho_id, {0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(1321) then -- tra Q hoc nghe thanh cong
			step = 35
			move(vu_ho_pos)
			if arrived(vu_ho_pos) then
				step = 36
				talk(vu_ho_id, {0,0}, isStarted)
			end
		elseif da_nhan_quest(1417) then -- Q hu cot chuong 1
			if not query_task_status_by_target(1417, vu_ho_id) then
				move(vu_ho_pos)
				step = 43
				if arrived(vu_ho_pos) then
					step = 44
					talk(vu_ho_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(1417, "CS_jl_fgz03") then
				step = 45
				--study_book("tibook_CS_jl_fgz03")
			elseif not query_task_status_by_target(1417, "CS_jl_fgz04") then
				step = 46
				--study_book("tibook_CS_jl_fgz04")
			else
				move(vu_ho_pos)
				step = 47
				if arrived(vu_ho_pos) then
					step = 48
					talk(vu_ho_id, {0,0,0,0}, isStarted) -- sau buoc nay se het task, va chay tiep phan check nc6 de nhan Q chuong 2
				end
			end
		elseif da_nhan_quest(1418) then -- Q hu cot chuong 2
			local truong_ban_pos = {250.641,91.629,60.237,0.673}
			local truong_ban_id = "Qiecuojlg001"
			if not query_task_status_by_target(1418, vu_ho_id) then
				step = 49
				move(vu_ho_pos)
				if arrived(vu_ho_pos) then
					step = 50
					talk(vu_ho_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(1418, truong_ban_id) then
				if arrived(truong_ban_pos) then
					step = 53
					if can_talk(truong_ban_id) then
						step = 54
						talk(truong_ban_id, {0}, isStarted)
					else
						step = 55
						skill_use("CS_jh_cqgf01")
					end
				else
					step = 56
					move(truong_ban_pos)
				end
			else
				step = 51
				move(vu_ho_pos)
				if arrived(vu_ho_pos) then
					step = 52
					talk(vu_ho_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(1419) then -- Q hu cot chuong 3
			local chu_uy_pos = {260.262,91.629,39.405,1.919}
			local chu_uy_id = "Qiecuojlg002"
			if not query_task_status_by_target(1419, vu_ho_id) then
				step = 57
				move(vu_ho_pos)
				if arrived(vu_ho_pos) then
					step = 58
					talk(vu_ho_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(1419, chu_uy_id) then
				if arrived(chu_uy_pos) then
					step = 60
					if can_talk(chu_uy_id) then
						step = 61
						talk(chu_uy_id, {0}, isStarted)
					else
						step = 62
						skill_use("CS_jh_cqgf01")
					end
				else
					step = 59
					move(chu_uy_pos)
				end
			else
				move(vu_ho_pos)
				if arrived(vu_ho_pos) then
					step = 63
					talk(vu_ho_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(1420) then -- Q hu cot chuong 4
			if not query_task_status_by_target(1420, vu_ho_id) then 
				move(vu_ho_pos)
				step = 64
				if arrived(vu_ho_pos) then
					step = 65
					talk(vu_ho_id, {0,0,0}, isStarted)
				end
			else
				move(vu_ho_pos)
				step = 64
				if arrived(vu_ho_pos) then
					step = 65
					talk(vu_ho_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(1322) then -- Q thien dia diet thich
			step = 66
			move(don_thien_ta_pos)
			if arrived(don_thien_ta_pos) then
				step = 67
				talk(don_thien_ta_id, {0,0,0}, isStarted)
			end
		elseif da_nhan_quest(1262) then -- Q thien dia diet thich chuong 1
			if not query_task_status_by_target(1262, don_thien_ta_id) then 
				step = 68
				move(don_thien_ta_pos)
				if arrived(don_thien_ta_pos) then
					step = 69
					talk(don_thien_ta_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(1262, "CS_jl_shuangci01") then 
				step = 70
			elseif not query_task_status_by_target(1262, "CS_jl_shuangci05") then 
				step = 71
			else
				step = 72
				move(don_thien_ta_pos)
				if arrived(don_thien_ta_pos) then
					step = 73
					talk(don_thien_ta_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(1263) then -- Q thien dia diet thich chuong 2
			local diep_ich_pos = {254.637,89.905,116.788,-0.312}
			local diep_ich_id = "Qiecuojlg003"
			if not query_task_status_by_target(1263, don_thien_ta_id) then
				step = 74
				move(don_thien_ta_pos)
				if arrived(don_thien_ta_pos) then
					step = 75
					talk(don_thien_ta_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(1263, diep_ich_id) then
				if arrived(diep_ich_pos) then
					step = 76
					if can_talk(diep_ich_id) then
						step = 77
						talk(diep_ich_id, {0}, isStarted)
					else
						step = 78
						skill_use("CS_jh_cqgf01")
					end
				else
					step = 79
					move(diep_ich_pos)
				end
			else
				step = 80
				move(don_thien_ta_pos)
				if arrived(don_thien_ta_pos) then
					step = 81
					talk(don_thien_ta_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(1264) then -- Q thien dia diet thich chuong 3
			local ma_hien_van_pos = {266.461,89.905,121.913,-0.341}
			local ma_hien_van_id = "Qiecuojlg004"
			if not query_task_status_by_target(1264, don_thien_ta_id) then
				step = 74
				move(don_thien_ta_pos)
				if arrived(don_thien_ta_pos) then
					step = 75
					talk(don_thien_ta_id, {0}, isStarted)
				end
			elseif not query_task_status_by_target(1264, ma_hien_van_id) then
				if arrived(ma_hien_van_pos) then
					step = 77
					if can_talk(ma_hien_van_id) then
						step = 78
						talk(ma_hien_van_id, {0}, isStarted)
					else
						step = 79
						skill_use("CS_jh_cqgf01")
					end
				else
					step = 76
					move(ma_hien_van_pos)
				end
			else
				step = 80
				move(don_thien_ta_pos)
				if arrived(don_thien_ta_pos) then
					step = 81
					talk(don_thien_ta_id, {0,0,0}, isStarted)
				end
			end
		elseif da_nhan_quest(1265) then -- Q hu cot chuong 4
			if not query_task_status_by_target(1265, don_thien_ta_id) then 
				move(don_thien_ta_pos)
				step = 82
				if arrived(don_thien_ta_pos) then
					step = 83
					talk(don_thien_ta_id, {0,0,0}, isStarted)
				end
			else
				move(don_thien_ta_pos)
				step = 84
				if arrived(don_thien_ta_pos) then
					step = 85
					talk(don_thien_ta_id, {0,0,0}, isStarted)
				end
			end
		elseif da_hoc_skill("CS_jl_shuangci07") then -- da hoc thien dien diet thich
			set_thien_dia_diet_thich_short_cut()
			equip_trang_bi("sthorn_jl_10101")
			kich_hoat_noi_cong("ng_jl_006")
			break
		elseif da_hoc_nc("ng_jl_006") then -- da hoc nc6, den hoc hu cot chuong
			move(vu_ho_pos)
			step = 41
			if arrived(vu_ho_pos) then
				step = 42
				talk(vu_ho_id, {0,0}, isStarted)
			end
		elseif da_hoc_skill("CS_jl_zfd06") and not da_hoc_nc("ng_jl_006") then -- da hoc bat phuong phong vu, den hoc nc6
			if get_item_amount("box_bzjh_001", 2) > 0 then
				step = 37
				dung_vat_pham("box_bzjh_001", 1, 5) -- thuong bon tau 1
			elseif get_item_amount("box_active_02", 2) > 0 then
				step = 38
				dung_het_vat_pham(isStarted, "box_active_02", 2, 1, {1}) -- qua the mon phai 10 lb
			elseif get_item_amount("item_honor_school04", 125) >= 10 then -- doi nc6
				local npc_id = "npc_6nei_jl_shop01"
				local pos = {153.555,128.096,49.916,-0.373}
				if arrived(pos) then
					step = 40
					talk_id(npc_id, {805000000}, isStarted)
					local form = util_get_form("form_stage_main\\form_shop\\form_shop", true)
					nx_pause(0.5)
					nx_execute("custom_sender", "custom_exchange_item", form.shopid, form.curpage, 1, 1)
					nx_pause(0.5)
					if nx_is_valid(form) and form ~= nil then
						nx_destroy(form)
					end
				else
					step = 39
					move(pos)
				end
			elseif has_item("ng_book_jl_00601", 2) then
				study_book("ng_book_jl_00601")
			end
		elseif da_hoc_nc(nc1) then
			step = 7
			move(dien_dong_pos)
			talk(dien_dong_id, {0, 0}, isStarted)
		end
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		add_chat_info("Learn Skill: " ..step)
	end
	add_chat_info("Learn Skill Done at: " ..step)
end

function _hoc_truy_phong_dao()
	hoc_clc_skills("tibook_CS_jl_zfd0", 7)
end

function _hoc_hu_cot_chuong()
	hoc_clc_skills("tibook_CS_jl_fgz0", 7)
end

function _hoc_thien_dia_diet_thich()
	hoc_clc_skills("tibook_CS_jl_shuangci0", 8)
end

function hoc_clc_skills(id, count)
	for i = 1, count do
		nx_pause(0)
		if has_item(id ..nx_string(i), 2) then
			study_book(id ..nx_string(i))
		end
	end
end

function set_thien_dia_diet_thich_short_cut()
	set_skill_short_cut("CS_jl_shuangci02", 0) -- huyen doc toa moc
	set_skill_short_cut("CS_jl_shuangci04", 1) -- doc xa tho tin
	set_skill_short_cut("CS_jl_shuangci06", 2) -- tu la hu cot
	set_skill_short_cut("CS_jl_shuangci05", 3) -- am hon xuat khieu
	set_skill_short_cut("CS_jl_shuangci07", 4) -- on than tu dat
	set_skill_short_cut("CS_jl_shuangci03", 5) -- ac quy tranh thuc
	set_skill_short_cut("CS_jl_shuangci01", 6) -- cuu uu am phong
	set_skill_short_cut("CS_jl_shuangci08", 7) -- ac co toan tam
	set_skill_short_cut("zs_default_01", 9) -- toa thien
end

return story

