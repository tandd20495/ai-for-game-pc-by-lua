local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\core.lua"))
file()

function check_school_button(form, schoolName)
	if schoolName == "qtd" then
		form.rbtn_jzt.Checked = true
	elseif schoolName == "tl" then
		form.rbtn_sl.Checked = true
	elseif schoolName == "cb" then
		form.rbtn_bg.Checked = true
	elseif schoolName == "nm" then
		form.rbtn_em.Checked = true
	elseif schoolName == "vd" then
		form.rbtn_wd.Checked = true
	elseif schoolName == "dm" then
		form.rbtn_tm.Checked = true
	elseif schoolName == "clc" then
		form.rbtn_jlg.Checked = true
	elseif schoolName == "cyv" then
		form.rbtn_jyw.Checked = true
	elseif schoolName == "mg" then
		form.rbtn_mj.Checked = true
	end
end

function so_nhap(isStarted, xa_phu, second_npc, job_npc, schoolName)
	job_npc = job_npc or {}
	local step = 1
	local xa_phu_id = xa_phu.id
	local xa_phu_pos = xa_phu.pos
	local npc_id = second_npc.id
	local npc_pos = second_npc.pos
	local job_npc_id = job_npc.id
	local job_npc_pos = job_npc.pos
	SendNotice("So Nhap Giang Ho", 3)
	while isStarted() do
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
		if step == 1 then
			den_pos(xa_phu_pos, isStarted)
			talk(xa_phu_id, {0, 0, 0, 0}, isStarted)
			nx_pause(2)
			step = 2
		elseif step == 2 then
			talk(xa_phu_id, {0, 0, 0}, isStarted)
			step = 3
		elseif step == 3 then
			talk(xa_phu_id, {0, 0}, isStarted)
			step = 4
		elseif step == 4 then
			talk(xa_phu_id, {0}, isStarted)
			step = 5
		elseif step == 5 then
			den_pos(npc_pos, isStarted)
			talk(npc_id, {0, 0}, isStarted)
			step = 6
		elseif step == 6 then
			den_pos(xa_phu_pos, isStarted)
			talk(xa_phu_id, {0}, isStarted)
			step = 7
		elseif step == 7 then
			step = 8
		elseif step == 8 then -- rut thu va su dung ngu phong than thuy
			local ngu_phong_mail = get_mail_by_item("ride_windrunner_002")
			--if ngu_phong_mail ~= nil then
				-- doc thu
				nx_execute("custom_sender", "custom_read_letter", ngu_phong_mail)
				nx_pause(1)
				-- rut qua
				nx_execute("custom_sender", "custom_get_appendix", ngu_phong_mail)
				nx_pause(1)
				-- xoa thu
				nx_execute("custom_sender", "custom_select_letter", 1, ngu_phong_mail, 1)
				nx_pause(1)
				nx_execute("custom_sender", "custom_del_letter", 0, 2)
				step = 9
			--end
		elseif step == 9 then
			dung_vat_pham("box_wnhd_dllb01", 1, 5) -- qua dang nhap
			dung_vat_pham("bind_money_5", 1, 5)
			if job_npc_id ~= nil then
				step = 10
			else
				step = 12
			end
		elseif step == 10 then
			den_pos(job_npc_pos, isStarted)
			talk(job_npc_id, {0, 0}, isStarted)
			nx_pause(1)
			local confirm_form = util_get_form("form_common\\form_confirm", true)
			nx_execute("form_common\\form_confirm", "ok_btn_click", confirm_form.ok_btn)
			nx_pause(1)
			talk(job_npc_id, {0, 0, 0}, isStarted)
			dung_vat_pham("hcitem_1000001", 1, 5)
			step = 11
		elseif step == 11 then
			den_pos(xa_phu_pos, isStarted)
			talk(xa_phu_id, {0}, isStarted)
			step = 12
		elseif step == 12 then
			local form = util_get_form("form_stage_main\\form_main\\form_school_introduce", true)
			nx_pause(0.5)
			check_school_button(form, schoolName)
			nx_pause(0.5)
			nx_execute("form_stage_main\\form_main\\form_school_introduce", "on_btn_school_click", form.btn_school)
			nx_pause(1)
			step = 13
		end
			
		if step == 13 then
			break 
		end
	end
end

return so_nhap

