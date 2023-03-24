
local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()

local school_map = "school08"

function get_npc_pos_anthe(id)
	return get_npc_pos(school_map, id)
end

local lac_duong_map = "city04"
local trai_ngoai_map = "scene08"
local anthe_map = "school18"
local chuong_mon_id = "WorldNpc00212"
local chuong_mon_pos = get_npc_pos_anthe(chuong_mon_id)
local chuong_mon = {
	id = chuong_mon_id,
	name = "Huyền Hoài Đại Sư",
	mapId = school_map
}

function story(isStarted)
	local ngu_phong_3 = "ride_windrunner_002"
	while isStarted() do
		nx_pause(0)
		mo_than_hanh()
		local game_player = getPlayer()
		local school = game_player:QueryProp("NewSchool")
		if school == "newschool_damo" then
			nx_pause(5)
			nhan_danh_phan(3801) --origin_3801=Xích Cước Khổ Sĩ
			nx_pause(2)
			nhan_thuong_danh_phan(3801)
			nx_pause(2)
			dung_vat_pham("damo01", 121, 0)
			mac_do_danh_phan()
			break
		end

		if not has_item(ngu_phong_3, 2) then
			rut_va_xoa_mail(ngu_phong_3)
		end
		local form = util_get_form("form_stage_main\\form_movie_new", false, false)
		if nx_is_valid(form) then
			nx_execute("form_stage_main\\form_movie_new", "on_btn_end_click", form.btn_end)
		end
		do_confirm()

		ngu_phong()
		if nx_is_valid(nx_value("form_stage_main\\form_map\\form_map_scene")) 
			and not nx_value("loading")
		then
			local current_map = LayMapHienTai()
			if da_nhan_quest(21712) then
				local step1 = query_task_status_by_order(21712, 1)
				local step2 = query_task_status_by_order(21712, 2)
				local step3 = query_task_status_by_order(21712, 3)
				local step4 = query_task_status_by_order(21712, 4)
				local step5 = query_task_status_by_order(21712, 5)
				if not step1 then
					if current_map == school_map then
						talk_to({
							id = "npc_dmp_mxm30",
							name = "Ngộ Ngã",
							mapId = school_map
						}, {841008783, 840008783})
					elseif current_map == trai_ngoai_map then
						talk_to({
							id = "npc_dmp_mxm21",
							name = "Ma Phương",
							mapId = trai_ngoai_map
						}, {500021712, 501021712})
					end
				elseif not step2 then
					if current_map == anthe_map then
						if not getNpcById("newmp_dmp_05") and not getNpcById("dmp_zc_shqf_001") then --Ma Phong
							talk_to({
								id = "Transschool18A",
								name = "Khổ Tăng",
								mapId = anthe_map
							}, {841008761, 840087611}, false)
						else
							thanhanh_bay_den(get_npc_pos(anthe_map, "newmp_dmp_05"), 50, isStarted)
							talk_to({
								id = "newmp_dmp_05",
								name = "Na Tu Đà-Chưởng Môn",
								mapId = anthe_map
							}, {500021712, 501021712, 502021712}, false)
						end
					elseif current_map == trai_ngoai_map then
						move(get_npc_pos(trai_ngoai_map, "DoorNpc00087"), 3)
					end
				elseif not step3 then
					if current_map ~= school_map then
						tele_ve_map(school_map)
					elseif current_map == school_map then
						talk_to(chuong_mon, {500021712})
					end
				elseif not step4 then
					if current_map == trai_ngoai_map then
						talk_to({
							id = "npc_dmp_mxm31",
							name = "Lâm Vận",
							mapId = trai_ngoai_map
						}, {500021712})
					elseif current_map == school_map then
						talk_to({
							id = "npc_dmp_mxm30",
							name = "Ngộ Ngã",
							mapId = school_map
						}, {841008783, 840008783})
					end
				elseif not step5 then
					if current_map == trai_ngoai_map then
						move(get_npc_pos(trai_ngoai_map, "DoorNpc00087"), 3)
					elseif current_map == anthe_map then
						talk_to({
							id = "npc_damo_xu_001",
							name = "Trương Nguyệt",
							mapId = anthe_map
						}, {810000001}, false)
					end
				else
					talk_to({
						id = "npc_damo_xu_001",
						name = "Trương Nguyệt",
						mapId = anthe_map
					}, {200021712, 201021712}, false)
				end
			elseif da_nhan_quest(21711) then
				local step1 = query_task_status_by_order(21711, 1)
				local step2 = query_task_status_by_order(21711, 2)
				local step3 = query_task_status_by_order(21711, 3)
				if (not step1 or not step2) and current_map ~= lac_duong_map then
					tele_ve_map(lac_duong_map)
				else
					if not step1 then
						local pos = get_npc_pos(lac_duong_map, "event_dmp_mxm01")
						if not arrived(pos, 1) then
							move(pos, 1)
						end
					elseif not step2 then
						talk_to({
							id = "WorldNpc10536",
							name = "Ô Hạ",
							mapId = lac_duong_map
						}, {500021711})
					elseif not step3 then
						talk_to(chuong_mon, {500021711, 501021711, 502021711})
					end
				end
			elseif da_nhan_quest(21710) then
				local step1 = query_task_status_by_order(21710, 1)
				local step2 = query_task_status_by_order(21710, 2)
				local step3 = query_task_status_by_order(21710, 3)
				local step4 = query_task_status_by_order(21710, 4)
				if not step1 then
					talk_to(chuong_mon, {500021710})
				elseif not step2 then
					talk_to({
						id = "npc_dmp_mxm17",
						name = "Hùng Vô Phương",
						mapId = school_map
					}, {500021710})
				elseif not step3 then
					talk_to({
						id = "npc_dmp_mxm18",
						name = "Võ Biện",
						mapId = school_map
					}, {500021710})
				elseif not step4 then
					talk_to({
						id = "npc_dmp_mxm19",
						name = "Mạc Trường Không",
						mapId = school_map
					}, {500021710})
				end
			elseif not da_nhan_quest(21710) then
				if current_map == school_map then
					talk_to(chuong_mon, {100021710, 101021710})
				else
					tele_ve_map(school_map)
				end
			end
		end
	end
end


-- function mo_hop_qua_gia_nhap_hdm()
-- 	local tui_vo_hoc = "Box_xdm_taskprize_0"
-- 	local trang_vo_hoc = "book_CS_xd_dyshd"
-- 	while has_item(tui_vo_hoc, 2) do
-- 		dung_vat_pham(tui_vo_hoc, 2, 2)
-- 		local has_trang_sach, id = has_item(trang_vo_hoc, 2)
-- 		while has_trang_sach do
-- 			nx_pause(0)
-- 			study_book(id)
-- 			has_trang_sach, id = has_item(trang_vo_hoc, 2)
-- 		end
-- 	end
-- end

return story