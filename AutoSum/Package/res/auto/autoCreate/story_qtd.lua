local file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\so_nhap.lua"))
local so_nhap = file()

function story(isStarted)
	local xa_phu = {
		id = "Transcity05D",
		pos = {490.969,24.105,873.176,-1.309}
	}
	local second_npc = {
		id = "Npc_yd_sh_cd_01",
		pos = {493.943,24.105,870.205,2.898}
	}
	local job_npc = {
		id = "JobChengD012",
		pos = {569.065,24.492,706.650,-2.710}
	}
	local step = 1
	while isStarted() do
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		if step == 1 then
			so_nhap(isStarted, xa_phu, second_npc, job_npc, "qtd")
			step = 2
		elseif step == 2 then
			local current_map = LayMapHienTai()
			if current_map == "school03" then
				step = 3
			end
		elseif step == 3 then
			nx_pause(5)
			local chi_dan_id = "FuncNpc01307"
			local chi_dan_pos = {231.706,71.973,432.036,1.567}
			if getNpcById(chi_dan_id) ~= nil then
				den_pos(chi_dan_pos, isStarted)
				talk_id(chi_dan_id, {1000}, isStarted)
				step = 4
			end
		elseif step == 4 then
			-- ket1: 570.617,23.297,807.983,-0.823 => 381.478,74.412,456.945,1.558
			local npc_id = "WorldNpc03305"
			local npc_pos = {529.770,103.650,457.400,1.626}
			-- local chuong_mon_path = {
			-- 	[1] = {{345.470,74.405,465.074,0.234}},
			-- 	[2] = {{376.662,74.408,465.436,1.587}},
			-- }
			-- den_pos_prevent_lag(chuong_mon_path, npc_pos, isStarted)
			den_pos( npc_pos, isStarted)
			--talk_id(npc_id, {200000055, 201000055}, isStarted)
			talk(npc_id, {0, 0}, isStarted)
			step = 5
		elseif step == 5 then
			-- local npc_id = "WorldNpc03305"
			-- local npc_pos = {529.770,103.650,457.400,1.626}
			-- den_pos(npc_pos, isStarted)
			-- talk_id(npc_id, {100000045, 101000045}, isStarted)
			step = 6
		elseif step == 6 then
			local npc_id = "WorldNpc03305"
			local npc_pos = {529.770,103.650,457.400,1.626}
			den_pos(npc_pos, isStarted)
			--talk_id(npc_id, {500000045, 501000045, 502000045, 503000045}, isStarted)
			talk(npc_id, {0, 0, 0, 0, 0}, isStarted)
			step = 7
		elseif step == 7 then
			local npc_id = "WorldNpc03305"
			local npc_pos = {529.770,103.650,457.400,1.626}
			den_pos(npc_pos, isStarted)
			--talk_id(npc_id, {501000045, 502000045, 503000045}, isStarted)
			talk(npc_id, {0}, isStarted)
			step = 8
		elseif step == 8 then
			local cam_pho = get_item_amount("useitem_bs001", 125)
			if cam_pho == 1 then
				step = 9
			end
		elseif step == 9 then
			dung_item_nhiem_vu("useitem_bs001", 1, 5)
			step = 10
		elseif step == 10 then
			local npc_id = "WorldNpc03305"
			local npc_pos = {529.770,103.650,457.400,1.626}
			den_pos(npc_pos, isStarted)
			--talk_id(npc_id, {500000045, 501000045, 201000045}, isStarted)
			talk(npc_id, {0, 0, 0}, isStarted)
			step = 11
		elseif step == 11 then
			-- local npc_id = "WorldNpc03305"
			-- local npc_pos = {529.770,103.650,457.400,1.626}
			-- den_pos(npc_pos, isStarted)
			-- talk_id(npc_id, {500000045, 501000045, 201000045}, isStarted)
			step = 12
		elseif step == 12 then -- nhan thuoc kinh mach
			local npc_id = "WorldNpc03305"
			local npc_pos = {529.770,103.650,457.400,1.626}
			den_pos(npc_pos, isStarted)
			--talk_id(npc_id, {100000485, 101000485}, isStarted)
			talk(npc_id, {0, 0}, isStarted)
			step = 13
		elseif step == 13 then 
			local npc_id = "WorldNpc03305"
			local npc_pos = {529.770,103.650,457.400,1.626}
			den_pos(npc_pos, isStarted)
			talk(npc_id, {0, 0}, isStarted)
			step = 14
		elseif step == 14 then -- su dung thuoc kinh mach
			dung_vat_pham("jmitem_actadd_03", 1, 5)
			step = 15
		elseif step == 15 then
			-- -- dung qua tan thu
			-- dung_vat_pham("item_skipsp_001", 1, 5)
			-- -- hoc toa thien
			-- study_book("book_zs_default_01")
			-- -- hoc am khi
			-- study_book("book_hw_normal")
			-- -- hoc lang khong dap hu
			-- study_book("book_qinggong_4")
			-- -- hoc skill tho thien : hoai trung bao nguyet
			-- study_book("tbook_CS_jh_cqgf03")
			-- -- hoc skill tho thien : bach van cai dinh
			-- study_book("tbook_CS_jh_cqgf02")
			-- -- hoc skill tho thien : dao bo that tinh
			-- study_book("tbook_CS_jh_cqgf05")
			-- -- dung qua dang nhap lan nua
			-- dung_vat_pham("item_skipsp_001", 1, 5)
			-- -- dung tuyet lien dang
			-- dung_vat_pham("additem_0020", 1, 4)
			-- dung_vat_pham("additem_0020", 1, 4)
			-- -- dung tuyet lien qua
			-- dung_vat_pham("additem_0011", 1, 4)
			-- -- dung qua hanh tau giang ho 1
			-- dung_vat_pham("box_cdjh_001", 1, 4)
			step = 16
		elseif step == 16 then
			den_pos({335.860,75.224,439.794,-0.027}, isStarted)
			step = 17
		elseif step == 17 then
			local hue_bang_phi_id = "Npc_yd_wg_jx_jz01"
			local pos = {-16.254,15.537,1.400,3.108}
			if getNpcById(hue_bang_phi_id) ~= nil then
				den_pos(pos, isStarted)
				talk(hue_bang_phi_id, {0}, isStarted)
				step = 18
			end
		elseif step == 18 then -- hoc thong tue cong
			study_book("ng_tbook_jz_001")
			step = 19
		elseif step == 19 then -- dung qua bon tau 1
			dung_vat_pham("box_bzjh_001", 1, 5)
			step = 20
		elseif step == 20 then 
			dung_vat_pham("additem_0010", 1, 5)
			dung_vat_pham("box_active_02", 1, 5) -- hop 10 lenh bai
			nx_execute("custom_sender", "custom_pickup_single_item", 1)
			step = 21
		elseif step == 21 then
			local hue_bang_phi_id = "Npc_yd_wg_jx_jz01"
			talk(hue_bang_phi_id, {0, 0, 0}, isStarted)
			step = 22
		elseif step == 22 then
			den_pos({-17.519,15.537,13.201,0.008}, isStarted)
			nx_pause(5)
			step = 23
		elseif step == 23 then
			local current_map = LayMapHienTai()
			if current_map == "school03" then
				step = 24
			end
		elseif step == 24 then -- doi nc 6
			local npc_id = "npc_6nei_jz_shop01"
			local pos = {488.707,106.074,690.936,0.069}
			-- local nc6_path = {
			-- 	[1] = {{476.627,101.633,468.803,1.269}},
			-- 	[2] = {{491.322,101.633,469.715,1.507}},
			-- }
			-- den_pos_prevent_lag(nc6_path, pos, isStarted)
			den_pos(pos, isStarted)
			talk_id(npc_id, {805000000}, isStarted)
			local form = util_get_form("form_stage_main\\form_shop\\form_shop", true)
			nx_pause(0.5)
			nx_execute("custom_sender", "custom_exchange_item", form.shopid, form.curpage, 1, 1)
			nx_pause(0.5)
			nx_destroy(form)
			step = 25
		elseif step == 25 then -- hoc nc6
			dung_vat_pham("ng_book_jz_00601", 1, 5)
			step = 26
		end
		if step == 26 then break end
	end
	
	
end

return story

