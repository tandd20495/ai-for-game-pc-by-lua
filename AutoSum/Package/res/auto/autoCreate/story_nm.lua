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
	local job_npc = nil
	local step = 1
	while isStarted() do
		nx_pause(0.5)
		if step == 1 then
			so_nhap(isStarted, xa_phu, second_npc, job_npc, "nm")
			step = 2
		elseif step == 2 then
			local current_map = LayMapHienTai()
			if current_map == "school06" then
				step = 3
			end
		elseif step == 3 then
			nx_pause(5)
			local chi_dan_id = "FuncNpc01114"
			if getNpcById(chi_dan_id) ~= nil then
				talk_id(chi_dan_id, {1000}, isStarted)

				local form = util_get_form("form_common\\form_confirm", true)
				while not nx_is_valid(form) do
					nx_pause(1)
				end
				nx_execute("form_common\\form_confirm", "ok_btn_click", form.ok_btn)
				step = 4
			end
		elseif step == 4 then
			dung_vat_pham("ride_windrunner_002", 1, 5)
			local npc_id = "WorldNpc02604"
			local npc_pos = {489.232,149.783,124.420,3.089}
			den_pos(npc_pos, isStarted)
			talk_id(npc_id, {200000053, 201000053, 101000043}, isStarted)
			step = 5
		elseif step == 5 then
			step = 6
		elseif step == 6 then
			local npc_id = "WorldNpc02686"
			local npc_pos = {536.560,135.856,225.965,-1.546}
			den_pos(npc_pos, isStarted)
			talk_id(npc_id, {500000043}, isStarted)
			step = 7
		elseif step == 7 then
			step = 8
		elseif step == 8 then
			local item = get_item_amount("useitem_bs008", 125)
			if item == 1 then
				step = 9
			end
		elseif step == 9 then
			dung_item_nhiem_vu("useitem_bs008", 1, 5)
			step = 10
		elseif step == 10 then
			local npc_id = "WorldNpc02686"
			local npc_pos = {536.560,135.856,225.965,-1.546}
			den_pos(npc_pos, isStarted)
			talk_id(npc_id, {500000043, 501000043}, isStarted)
			step = 11
		elseif step == 11 then
			local npc_id = "WorldNpc02604"
			local npc_pos = {489.232,149.783,124.420,3.089}
			den_pos(npc_pos, isStarted)
			talk_id(npc_id, {200000043, 201000043}, isStarted)
			step = 12
		elseif step == 12 then
			local npc_pos = {517.464,135.664,228.208,0.523}
			den_pos(npc_pos, isStarted)
			step = 13
		elseif step == 13 then 
			local npc_id = "Npc_yd_wg_jx_em01"
			if getNpcById(npc_id) ~= nil then
				talk(npc_id, {0,0}, isStarted)
				step = 14
			end
		elseif step == 14 then 
			step = 15
		elseif step == 15 then
			study_book("ng_tbook_em_001")
			dung_vat_pham("box_bzjh_001",1,5)
			dung_vat_pham("box_active_02",1,5)
			nx_execute("custom_sender", "custom_pickup_single_item", 1)
			step = 16
		elseif step == 16 then
			local npc_pos = {-16.522,15.537,14.080,-0.094}
			den_pos(npc_pos, isStarted)
			step = 17
		elseif step == 17 then
			while getNpcById("matchschool_exchange_em") == nil do
				nx_pause(0)
			end
			den_pos({294.864,135.987,95.094,-3.079}, isStarted)
			step = 18
		elseif step == 18 then
			talk_id("npc_6nei_em_shop01", {805000000}, isStarted)
			step = 19
		elseif step == 19 then 
			local form = util_get_form("form_stage_main\\form_shop\\form_shop", true)
			nx_pause(0.5)
			nx_execute("custom_sender", "custom_exchange_item", form.shopid, form.curpage, 1, 1)
			nx_pause(0.5)
			nx_destroy(form)
			step = 20
		elseif step == 20 then 
			study_book("ng_book_em_00601")
			step = 21
		end
		if step == 21 then break end
	end
end

return story

