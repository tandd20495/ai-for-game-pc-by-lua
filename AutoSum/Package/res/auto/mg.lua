local file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\so_nhap.lua"))
local so_nhap = file()
file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\joinschool.lua"))
file()

local school_map = "school20"
local dvd_map = "groupscene037"
local nguoi_chi_dan_id = "FuncNpc01505"
local nguoi_chi_dan_pos = {345.155,64.355,97.079,-1.417}
local chuong_mon_id = "newmp_mj_001"
local chuong_mon_pos = {-4.542,125.852,297.197,3.105}
local q_gia_nhap_phai = 58
local skill_dao_bo_that_tinh = "CS_jh_lydgd08"

-- hoc vo cong 1
local skill_1_count = 8
local skillset_1_prefix = "CS_jh_lydgd0"
local q_nc1 = 73175
local q_dien_vo = 73176
local q_cach_dung_skill = 73177
local q_do_don = 73178
local q_cong_kich_thuong = 73179
local q_skill_no = 73180
local q_hoc_nghe_thanh_cong = 73181
local dien_vo_duong_out_id = "Npc_yd_wg_cs_mj02"
local dien_vo_duong_out_pos = {-16.813,15.496,15.76,1.465}
local dien_vo_duong_id = "Npc_yd_wg_cs_mj01"
local dien_vo_duong_pos = {-252.207,56.63,-180.141,0}
local lang_phong_id = "Npc_yd_wg_jx_mj01"
local lang_phong_pos = {-18.42,15.536,1.988,1.615}
local day_kien_vi_id = "Npc_yd_wg_jx_mj02"
local day_kien_vi_pos = {-11.423,15.497,-6.536,1.449}
local day_phong_ngu_id = "Npc_yd_wg_jx_mj03"
local day_phong_ngu_pos = {-14.584,15.497,-6.907,-1.688}
local day_pha_phong_id = "Npc_yd_wg_jx_mj04"
local day_pha_phong_pos = {-18.865,15.497,-7.125,-1.622}
local day_no_khi_id = "Npc_yd_wg_jx_mj05"
local day_no_khi_pos = {-22.325,15.497,-6.613,-1.558}
local nc1_page = "ng_book_mj_fc_001"
local nc1 = "ng_mj_001"
local skill_bach_van_cai_dinh = "CS_jh_lydgd03"
local skill_hoai_trung_bao_nguyen = "CS_jh_lydgd05"
local skill_cong_kich_thuong = "zs_normal_00"
-- hoc vo cong 2
local skill_2_count = 8
local skillset_2_prefix = "CS_jy_yzq0"
local q_hoc_nghe_thanh_cong_2 = 12749
local q_vo_2_chuong_1 = 1274
local q_vo_2_chuong_2 = 1275
local q_vo_2_chuong_3 = 1276
local q_vo_2_chuong_4 = 1277
local npc_vo_hoc_2_id = "newmp_mj_006"
local npc_vo_hoc_2_pos = get_npc_pos(school_map, npc_vo_hoc_2_id) --{899.387,86.351,340.976,2.788}
local doi_noi_cong_6_id = "NpcSchoolshop_mj_fc_01"
local doi_noi_cong_6_pos = get_npc_pos(school_map, doi_noi_cong_6_id)--{746.931,73.169,394.894,-0.295}
local npc_vo_2_chuong_2_danh_id = "Qiecuojyw003"
local npc_vo_2_chuong_2_danh_pos = get_npc_pos(school_map, npc_vo_2_chuong_2_danh_id)--{870.426,75.891,437.284,-0.300}
local npc_vo_2_chuong_3_danh_id = "Qiecuojyw004"
local npc_vo_2_chuong_3_danh_pos = get_npc_pos(school_map, npc_vo_2_chuong_3_danh_id)--{866.909,75.591,437.105,-0.298}
local nc6 = "ng_mj_006"
local nc6_page1 = "ng_book_mj_fc_00601"
local skil_last_skill_1 = "CS_jh_lydgd07"
local skill_vu_hoa_toa_son = "CS_jh_cqgf01"
-- hoc vo cong 3
local skill_3_count = 7
local skillset_3_prefix = "CS_jy_shd0"
local q_vo_hoc_3 = 1318
local q_vo_3_chuong_1 = 1270
local q_vo_3_chuong_2 = 1271
local q_vo_3_chuong_3 = 1272
local q_vo_3_chuong_4 = 1273
local npc_vo_hoc_3_id = "WorldNpc04104"
local npc_vo_hoc_3_pos =  get_npc_pos(school_map, npc_vo_hoc_3_id)--{745.305,126.665,178.715,-1.790}
local npc_vo_3_chuong_2_danh_id = "Qiecuojyw001"
local npc_vo_3_chuong_2_danh_pos =  get_npc_pos(school_map, npc_vo_3_chuong_2_danh_id)--{867.893,133.129,210.840,-1.957}
local npc_vo_chuong_3_danh_id = "Qiecuojyw002"
local npc_vo_chuong_3_danh_pos =  get_npc_pos(school_map, npc_vo_chuong_3_danh_id)--{604.554,65.133,165.298,-1.868}
local skill_last_skill_3 = "CS_jy_shd06"
local main_skill_weapon = "thorn_tm_10101"
local main_skill_faculty = {
	{
		["name"] = "CS_jh_lydgd08",
		["level"] = 5
	},
	{
		["name"] = "CS_jh_lydgd01",
		["level"] = 5
	},
	{
		["name"] = "CS_jh_lydgd02",
		["level"] = 5
	},
	{
		["name"] = "CS_jh_lydgd03",
		["level"] = 5
	}
}
local main_skillset_from = 1
local main_skillset_to = 8
local binh_luc_id = 101
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
	local step =1
	while isStarted() do
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		if step == 1 then
						add_chat_info("da vao ")
			so_nhap(isStarted, xa_phu, second_npc, job_npc, "mg")
			step = 2
		elseif step == 2 then
			local current_map = LayMapHienTai()
			if current_map == "school20" then
				step = 3
			end
		elseif step == 3 then
			nx_pause(5)
			local chi_dan_id = "newmp_mjzyb_001"
			local chi_dan_pos = {-14.178,77.537,-176.485,3.203}
			if getNpcById(chi_dan_id) ~= nil then
				den_pos(chi_dan_pos, isStarted)
				talk_id(chi_dan_id, {1000}, isStarted)
				step = 4
			end
		elseif step == 4 then
			-- ket1: 570.617,23.297,807.983,-0.823 => 381.478,74.412,456.945,1.558
			local npc_id = "newmp_mj_001"
			local npc_pos = {-4.542,125.852,297.197,3.105}
			-- local chuong_mon_path = {
			-- 	[1] = {{345.470,74.405,465.074,0.234}},
			-- 	[2] = {{376.662,74.408,465.436,1.587}},
			-- }
			-- den_pos_prevent_lag(chuong_mon_path, npc_pos, isStarted)
			den_pos( npc_pos, isStarted)
			--talk(chuong_mon_id, {0,0}, isStarted)
				--talk(chuong_mon_id, {0,0}, isStarted)
			talk(npc_id, {0,0,0,0,0}, isStarted)
			step = 5
		elseif step == 5 then -- nhan thuoc kinh mach
				den_pos(chuong_mon_pos, isStarted)
				talk(chuong_mon_id, {0,0}, isStarted)
				talk(chuong_mon_id, {0,0}, isStarted)
				step = 6
		elseif step == 6 then -- dung thuoc kinh mach
				local kinh_mach = "jmitem_actadd_03"
				local kinh_mach_count = get_item_amount(kinh_mach, 2)
				if kinh_mach_count == 1 then
					dung_vat_pham(kinh_mach, 1, 5)
					step = 26
				end
		end
		if step == 26 then break end
	end
	add_chat_info("da gia nhap phai thanh cong")
	if isStarted() then
		local data = {
			["binh_luc"] = binh_luc_id,
			["school"] = "jh",
			["main_skill_faculty"] = main_skill_faculty,
			["nc6"] = nc6,
			["doi_noi_cong_6_pos"] = doi_noi_cong_6_pos,
			["doi_noi_cong_6_id"] = doi_noi_cong_6_id
		}
		join_school_learn_skill(isStarted)
		chuan_bi_thuc_luc(isStarted, data)
	end
	
end
function join_school_learn_skill(isStarted)
	set_pass_ruong()
	pw2()
	set_auto_do_don()
	--hoc_tho_thien_cong_phu(isStarted)
	local step = 1
	while isStarted() do
		nx_pause(0)
		local current_map = LayMapHienTai()
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
				move(lang_phong_pos)
				if arrived(lang_phong_pos) then
					step = 5
					talk(lang_phong_id, {0,0,0}, isStarted)
				end
				_hoc_vo_hoc_1()
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
				move(lang_phong_pos)
				talk(lang_phong_id, {0, 0, 0}, isStarted)
				_hoc_vo_hoc_1()
			end
		elseif da_nhan_quest(q_cach_dung_skill) then
			move(lang_phong_pos)
			talk(lang_phong_id, {0, 0, 0}, isStarted)
			_hoc_vo_hoc_1()
			equip_trang_bi(main_skill_weapon)
		--nx_pause(0.5)
		--nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "thorn_tm_10101")
		elseif da_nhan_quest(q_do_don) then
		add_chat_info("test")
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
			elseif not query_task_status_by_target(q_do_don, lang_phong_id) then
				step = 14
				move(lang_phong_pos)
				talk(lang_phong_id, {0,0}, isStarted)
				_hoc_vo_hoc_1()
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
				move(lang_phong_pos)
				talk(lang_phong_id, {0,0,0}, isStarted)
				_hoc_vo_hoc_1()
				equip_trang_bi(main_skill_weapon)
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
			elseif not query_task_status_by_target(q_cong_kich_thuong, lang_phong_id) then
				step = 22
				move(lang_phong_pos)
				talk(lang_phong_id, {0,0}, isStarted)
				_hoc_vo_hoc_1()
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
				move(lang_phong_pos)
				talk(lang_phong_id, {0,0,0}, isStarted)
				_hoc_vo_hoc_1()
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
				move(lang_phong_pos)
				talk(lang_phong_id, {0,0,0}, isStarted)
				_hoc_vo_hoc_1()
			end
		elseif da_nhan_quest(q_hoc_nghe_thanh_cong) then
			step = 31
			--move(dien_vo_duong_out_pos)
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
		--	ngu_phong()
			--move_scene(npc_vo_hoc_2_pos, school_map)
			--if arrived(npc_vo_hoc_2_pos) then
			--	step = 34
			--	talk(npc_vo_hoc_2_id, {0,0}, isStarted)
		--	end
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
					--_hoc_vo_hoc_2()
				end
			end

		elseif da_hoc_skill(skil_last_skill_1) and not da_hoc_nc(nc6) then 
			set_main_skillset_shortcut(skillset_1_prefix, main_skillset_from, main_skillset_to)
			break
		elseif da_hoc_nc(nc1) then
			step = 7
			move(lang_phong_pos)
			talk(lang_phong_id, {0, 0}, isStarted)
		end
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		add_chat_info("Learn Skill: " ..step)
	end
	add_chat_info("Learn Skill Done at: " ..step)
end

function _hoc_vo_hoc_1()
	hoc_all_skills(skillset_1_prefix, skill_1_count)
end

function hoc_all_skills(id, count)
	for i = 1, count do
		if has_item("book_" ..id ..nx_string(i), 2) then
			study_book("book_" ..id ..nx_string(i))
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

function joinschool_isStarted()
	return auto_so_nhap_bat_phai
end

function joinschool()
	if not joinschool_isStarted() then
		auto_so_nhap_bat_phai = true

		add_chat_info("Start Join School for all accounts")
		function run_story()
		add_chat_info(1)
			story(joinschool_isStarted)
		end
		run_story()
	
		auto_so_nhap_bat_phai = false
	else 
		add_chat_info("Stop joining school")
		auto_so_nhap_bat_phai = false
	end
end
joinschool()

