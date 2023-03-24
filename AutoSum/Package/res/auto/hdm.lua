
local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()
local school_map = "school01"
local anc = "born02"
local hdm_map = "school13"
local chuong_mon_id = "worldnpc04101"
local chuong_mon_pos = {352.850,76.170,-118.721}

function story(isStarted)
	while isStarted() do
		nx_pause(0)
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		ngu_phong()
		if nx_is_valid(nx_value("form_stage_main\\form_map\\form_map_scene")) 
			and not nx_value("loading")
		then
			local current_map = LayMapHienTai()
			if da_nhan_quest(20819) then
				local target1 = "Event_xdm_016"
				local target2 = "npc_xdm_031"
				local step1 = query_task_status_by_target(20819, target1)
				local step2 = query_task_status_by_target(20819, target2)
				if not step1 then
					local npc_vao_cong = "npc_xdm_in"
					move(get_npc_pos(anc, npc_vao_cong), 1)
					talk(npc_vao_cong, {0,0}, isStarted)
				elseif not step2 then
					move(get_npc_pos(hdm_map, target2), 1)
					talk(target2, {0,0,0,0}, isStarted)
				else
					move(get_npc_pos(hdm_map, target2), 1)
					talk(target2, {0,0,0,0}, isStarted)
				end
			elseif da_nhan_quest(20814) then
				local target1 = "Event_xdm_013"
				local target2 = "npc_xdm_018"
				local target3 = "npc_xdm_013"
				local target4 = "item_xdm_012"
				local target4_sub = "npc_xdm_019"
				local target5 = "npc_xdm_013"
				local target6 = "item_xdm_ww02"
				local step1 = query_task_status_by_target(20814, target1)
				local step2 = query_task_status_by_target(20814, target2)
				local step3 = query_task_status_by_target(20814, target3)
				local step4 = query_task_status_by_target(20814, target4)
				local step5 = query_task_status_by_order(20814, 5)
				local step6 = query_task_status_by_target(20814, target6)
				if not step1 then
					move(get_npc_pos_cyv(target1), 1)
				elseif not step2 then
					local pos = get_npc_pos_cyv(target2)
					move(pos, 1)
					if getNpcById(target2) ~= nil then
						equip_trang_bi("blade_jy_10101")
						while isStarted() and not step2 do
							nx_pause(0)
							Fight_Skill(target2, nil, 7)
							step2 = query_task_status_by_target(20814, target2)
						end
					end
				elseif not step3 then
					den_pos(get_npc_pos_cyv(target3), isStarted)
					talk(target3, {0,0,0,0}, isStarted)
				elseif not step4 then
					local temp_pos = {535.861,35.068,-25.396,1.509}
					den_pos(temp_pos, isStarted)
					local npc_pos = get_npc_pos_cyv(target4_sub)
					jump_to_arrived(npc_pos, isStarted)
					if arrived(npc_pos, 2) then
						target_npc(target4_sub)
						dung_item_nhiem_vu(target4, 1)
						jump_to_the_air()
					end
				elseif not step5 then
					local temp_pos = {535.861,35.068,-25.396,1.509}
					if getNpcById(target4_sub) ~= nil then
						jump_to_arrived(temp_pos, isStarted)
						if arrived(temp_pos, 2) then
							den_pos(get_npc_pos_cyv(target5), isStarted)
							talk(target5, {0,0,0,0}, isStarted)
						end
					else
						den_pos(get_npc_pos_cyv(target5), isStarted)
						talk(target5, {0,0,0,0}, isStarted)
					end
				elseif not step6 then
					if current_map ~= anc then
						mo_than_hanh() -- mo them o than hanh
						thanhanh_to_hp_by_id("HomePointborn02A")
						while current_map ~= anc do
							nx_pause(1)
							current_map = LayMapHienTai()
						end 
					else
						if not da_hoc_nghe("sh_ys") then
							add_chat_info("hoc duoc su")
							local duoc_su = "JobERG009"
							den_pos(get_npc_pos(anc, duoc_su), isStarted)
							talk(duoc_su, {0,0,0,0}, isStarted)
						elseif not da_hoc_nghe("sh_nf") then
							add_chat_info("hoc nong phu")
							local nong_phu = "JobERG005"
							den_pos(get_npc_pos(anc, nong_phu), isStarted)
							talk(nong_phu, {0,0,0,0}, isStarted)
						else
							local te_hao = "npc_xdm_143"
							den_pos(get_npc_pos(anc, te_hao), isStarted)
							talk(te_hao, {1}, isStarted)
						end
					end
				else
					local te_hao = "npc_xdm_143"
					den_pos(get_npc_pos(anc, te_hao), isStarted)
					talk(te_hao, {0,0,0,0}, isStarted)
				end
			elseif da_nhan_quest(20813) then
				local target2 = "npc_xdm_016"
				local target3 = "npc_xdm_017"
				local step1 = query_task_status_by_target(20813, chuong_mon_id)
				local step2 = query_task_status_by_target(20813, target2)
				local step3 = query_task_status_by_target(20813, target3)
				if not step1 then
					den_pos(chuong_mon_pos, isStarted)
					talk(chuong_mon_id, {0,0,0,0}, isStarted)
				elseif not step2 then
					den_pos(get_npc_pos_cyv(target2), isStarted)
					talk(target2, {0,0,0,0}, isStarted)
				elseif not step3 then
					den_pos(get_npc_pos_cyv(target3), isStarted)
					talk(target3, {0,0,0,0}, isStarted)
				end
			elseif current_map ~= hdm_map then
				den_pos(chuong_mon_pos, isStarted)
				talk(chuong_mon_id, {0,0,0,0}, isStarted)
			else
				add_chat_info("Mo Hop Qua")
				mo_hop_qua_gia_nhap_hdm()
				add_chat_info("Da gia nhap hdm thanh cong")
				break
			end
		end
	end
end

function mo_hop_qua_gia_nhap_hdm()
	local tui_vo_hoc = "Box_xdm_taskprize_0"
	local trang_vo_hoc = "book_CS_xd_dyshd"
	while has_item(tui_vo_hoc, 2) do
		dung_vat_pham(tui_vo_hoc, 2, 2)
		local has_trang_sach, id = has_item(trang_vo_hoc, 2)
		while has_trang_sach do
			nx_pause(0)
			study_book(id)
			has_trang_sach, id = has_item(trang_vo_hoc, 2)
		end
	end
end

function get_npc_pos_cyv(id)
	return get_npc_pos(school_map, id)
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


