
local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()
local school_map = "school05"
local anthe_map = "school15"
local nhan_nv_id = "npc_nlb_mxm15" -- Pho Yen
local kim_lang_map = "city03"
function get_npc_pos_dm(id)
	return get_npc_pos(school_map, id)
end

function get_npc_pos_kl(id)
	return get_npc_pos(kim_lang_map, id)
end

function get_npc_pos_anthe(id)
	return get_npc_pos(anthe_map, id)
end

local nhan_nv_pos = get_npc_pos_dm(nhan_nv_id)

function story(isStarted)
	while isStarted() do
		nx_pause(0)
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
    ngu_phong()
    tat_movie()
    do_confirm()
    equip_trang_bi("thorn_tm_10101")
		if nx_is_valid(nx_value("form_stage_main\\form_map\\form_map_scene")) 
			and not nx_value("loading")
		then
      local current_map = LayMapHienTai()
      if da_nhan_quest(21235) then
        local target1 = "Event_nlb_cc_15880"
        local target1_sub = "DoorNpc00045"
        local target2 = "Event_nlb_cc_15880"
        local target2_sub = "GotoDoornlb_lh01"
        local target3 = "npc_nlb_001"
				local step1 = query_task_status_by_order(21235, 1)
        local step2 = query_task_status_by_order(21235, 2)
        local step3 = query_task_status_by_order(21235, 3)
        if not step1 then
          if current_map ~= "city05" then
            mo_than_hanh()
            thanhanh_to_hp_by_id("HomePointcity05A")
            nx_pause(3)
          else
            move(get_npc_pos("city05", target1_sub), 5)
            nx_pause(5)
          end
        elseif not step2 then
          move(get_npc_pos_anthe(target2_sub), 1)
          tat_movie()
        elseif not step3 then
          move(get_npc_pos_anthe(target3), 1)
          talk(target3, {0,0,0}, isStarted)
        else
          move(get_npc_pos_anthe(target3), 1)
          talk(target3, {0,0,0}, isStarted)
        end
      elseif da_nhan_quest(21280) then
        local target1 = "npc_nlb_mxm32"
        local target2 = "item_nlb_ww28"
        local target2_sub = "npc_nlb_ww03"
				local step1 = query_task_status_by_target(21280, target1)
        local step2 = query_task_status_by_target(21280, target2)
        if not step1 then
          move(get_npc_pos_kl(target1), 1)
          talk(target1, {0,0,0}, isStarted)
        elseif not step2 then
          move(get_npc_pos_kl(target2_sub), 1)
          talk(target2_sub, {1,0,0,0}, isStarted)
        else
          talk(target2_sub, {0,0,0}, isStarted)
        end
      elseif da_nhan_quest(21270) then
				local target1 = "npc_nlb_mxm20"
        local target2 = "npc_nlb_mxm21"
        local target3 = "Event_nlb_mxm11"
        local target4 = "npc_nlb_mxm22"
				local step1 = query_task_status_by_target(21270, target1)
        local step2 = query_task_status_by_target(21270, target2)
        local step3 = query_task_status_by_target(21270, target3)
        local step4 = query_task_status_by_target(21270, target4)
				if not step1 then
					move(get_npc_pos_kl(target1), 1)
					talk(target1, {0,0}, isStarted)
				elseif not step2 then
					move(get_npc_pos_kl(target2), 1)
          talk(target2, {0,0}, isStarted)
        elseif not step3 then
					move({548.750,4.590,985.750,-0.000}, 1)
				elseif not step4 then
					move({552.631,4.590,977.418,2.734}, 1)
					if getNpcById(target4) ~= nil then
						while isStarted() and not step4 do
							nx_pause(0)
							Fight_Skill(target4, nil, 2)
							step4 = da_nhan_quest(21280)
						end
          end
				end
			elseif da_nhan_quest(21269) then
        local target1 = "Event_nlb_mxm10"
        local target1_sub = "npc_nlb_mxm43"
				local target2 = "npc_nlb_mxm19"
				local target3 = "npc_nlb_mxm19"
				local target4 = nil
				local target4_sub = "npc_nlb_mxm23"
				local step1 = query_task_status_by_target(21269, target1)
				local step2 = query_task_status_by_order(21269, 2)
				local step3 = query_task_status_by_order(21269, 3)
				local step4 = query_task_status_by_order(21269, 4)
				if not step1 then
          move(get_npc_pos_dm(target1_sub), 1)
          talk(target1_sub, {0,0}, isStarted)
				elseif not step2 then
          local pos = get_npc_pos_kl(target2)
          move(pos, 1)
          if arrived(pos, 2) then
            talk(target2, {0,0}, isStarted)
            if getNpcById(target2) ~= nil then
              while isStarted() and not step2 do
                nx_pause(0)
                Fight_Skill(target2, nil, 2)
                step2 = query_task_status_by_order(21269, 2)
              end
            end
          end
				elseif not step3 then
					move(get_npc_pos_kl(target3), 1)
					talk(target3, {0,0,0,0}, isStarted)
				elseif not step4 then
					local pos = get_npc_pos_kl(target4_sub)
          move(pos, 1)
          talk(target4_sub, {0,0}, isStarted)
        end
			elseif da_nhan_quest(21268) then
				local target1 = "npc_nlb_mxm15"
        local target2 = "WorldNpc02201"
        local target3 = "WorldNpc02203"
        local target4 = "Event_nlb_mxm17"
        local target5 = "npc_nlb_mxm17"
				local step1 = query_task_status_by_target(21268, target1)
				local step2 = query_task_status_by_target(21268, target2)
        local step3 = query_task_status_by_target(21268, target3)
        local step4 = query_task_status_by_target(21268, target4)
        local step5 = query_task_status_by_target(21268, target5)

				if not step1 then
					move(get_npc_pos_dm(target1), 1)
					talk(target1, {0,0,0,0}, isStarted)
				elseif not step2 then
					move(get_npc_pos_dm(target2), 1)
					talk(target2, {0,0,0,0}, isStarted)
				elseif not step3 then
					move(get_npc_pos_dm(target3), 1)
          talk(target3, {0,0,0,0}, isStarted)
        elseif not step4 then
          move({760.516,24.751,45.069,1.918}, 1)
          tat_movie()
        elseif not step5 then
          move(get_npc_pos_dm(target5), 1)
          talk(target5, {0,0,0,0,0,0,0}, isStarted)
				end
			else
				local game_player = getPlayer()
        local school = game_player:QueryProp("NewSchool")
        if school == "newschool_nianluo" then
          nhan_danh_phan(3301) --nam
          nhan_danh_phan(3311) --nu
          nx_pause(1)
          nhan_thuong_danh_phan(3301)
          nhan_thuong_danh_phan(3311)
          nx_pause(1)
          dung_vat_pham("nianluoba01", 121, 0)
          mac_do_danh_phan()
          den_pos({2134.677,108.031,1008.157,-0.004}, isStarted)
          talk("Reliveschool15A", {0,0,0,0}, isStarted)
          break
        elseif current_map ~= school_map then
          thanhanh_to_hp_by_id("HomePointschool05A") -- moc van trang bach thao duong
          nx_pause(3)
        else
          move(nhan_nv_pos, 1)
          talk(nhan_nv_id, {0,0,0,0}, isStarted)
        end
			end
		end
	end
end

function mo_hop_qua_gia_nhap()
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

return story