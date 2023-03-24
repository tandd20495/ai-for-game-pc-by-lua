
function equip_trang_bi(id)
	util_show_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	local form = util_get_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	form.rbtn_equip.Checked = true
	nx_pause(0.5)
	nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_equip)
	nx_pause(0.5)
	nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", id)
	--util_show_form("form_stage_main\\form_bag", false)
end

function equip_bo_trang_bi(danh_sach)
	util_show_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	local form = util_get_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	form.rbtn_equip.Checked = true
	nx_pause(0.5)
	nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_equip)
	nx_pause(0.5)
	for i = 1, table.getn(danh_sach) do
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", danh_sach[i])
	end
end