function get_mail_by_item(id)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	local rownum = client_player:GetRecordRows("RecvLetterRec")
	for row = 0, rownum - 1 do
		local str_goods = client_player:QueryRecord("RecvLetterRec", row, 7)
		--add_chat_info(str_goods)
		if str_goods ~= nil and string.find(str_goods, id) then
			local serial = client_player:QueryRecord("RecvLetterRec", row, 10)
			local sender = client_player:QueryRecord("RecvLetterRec", row, 0)
			return serial, sender
		end
	end
	return nil
end

function rut_va_xoa_mail(id, type)
	local mail, sender = get_mail_by_item(id)
	--add_chat_info(id)
	if mail ~= nil then
		rut_xoa_thu_by_serial(mail, type)
		add_chat_info("Đã nhận " ..nx_function("ext_widestr_to_utf8", util_text(id)) .." từ " ..nx_function("ext_widestr_to_utf8", sender))
		return true
	end
	return false
end

function rut_xoa_thu_by_serial(mail_serial, type)
--add_chat_info(mail_serial)
	if (mail_serial ~= nil) then
		nx_execute("custom_sender", "custom_read_letter", mail_serial)
		nx_pause(1)
		-- rut qua
		nx_execute("custom_sender", "custom_get_appendix", mail_serial)
		nx_pause(1)
		-- xoa thu
		--nx_execute("custom_sender", "custom_select_letter", 1, mail_serial, 1)
		--nx_pause(1)
		--nx_execute("custom_sender", "custom_del_letter", 0, type or 2) -- 2 system, 1 user
	end
end

function xoa_thu_rong()
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	local rownum = client_player:GetRecordRows("RecvLetterRec")
	for row = 0, rownum - 1 do
		local str_goods = client_player:QueryRecord("RecvLetterRec", row, 7)
		local serial_no = client_player:QueryRecord("RecvLetterRec", row, 10)
		if string.find(str_goods, "<Object />") 
			or isempty(str_goods) 
			or not string.find(str_goods, "Object") 
		then
			nx_execute("custom_sender", "custom_read_letter", serial_no)
			nx_pause(1)
			-- xoa thu
			nx_execute("custom_sender", "custom_select_letter", 1, serial_no, 1)
		end
	end
	nx_pause(1)
	-- nx_execute("custom_sender", "custom_del_letter", 0, 2)
	-- nx_pause(2)
	nx_execute("custom_sender", "custom_del_letter_ok", 0, 2)
	nx_execute("custom_sender", "custom_del_letter", 0, 1)
end

function kiem_tra_qua_online()
	rut_va_xoa_mail("haiwai_VNhuangxcxinzaixianlibao_0")
	local amount = get_item_amount("haiwai_VNhuangxcxinzaixianlibao_01", 2)
	if amount > 0 then
		dung_vat_pham("haiwai_VNhuangxcxinzaixianlibao_01", 1, 5)
	end
	amount = get_item_amount("haiwai_VNhuangxcxinzaixianlibao_02", 2)
	if amount > 0 then
		dung_vat_pham("haiwai_VNhuangxcxinzaixianlibao_02", 1, 5)
	end
end

function rut_het_qua_trong_thu(isStarted, deleteRac)
	dung_vat_pham("noop_item",2)
	while isStarted() do
		nx_pause(0)
		local has_mail = false
		-- local available = check_bag_available(2)
		-- local form_bag = util_get_form("form_stage_main\\form_bag", true, false)
		-- if available <= 0 then
		-- 	nx_execute("form_stage_main\\form_bag", "on_btn_arrange_click", form_bag.btn_arrange)
		-- end
		arrange_bag(2, 0)
		mail_serial = get_mail_by_item("haiwai_VNhuangxcxinzaixianlibao_0") -- qua online 5 den 60'
		if mail_serial ~= nil then
			rut_xoa_thu_by_serial(mail_serial)
			has_mail = true
		else
			mail_serial = get_mail_by_item("item_ssmh_001") --minh chu mat ham
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end
			
			mail_serial = get_mail_by_item("fixitem_004") --cong cu sua chua
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end

			mail_serial = get_mail_by_item("binglu113") -- binh luc
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end

			mail_serial = get_mail_by_item("binglu111") -- binh luc ha
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end

			mail_serial = get_mail_by_item("binglu112") -- binh luc trung
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end

			mail_serial = get_mail_by_item("binglu113") -- binh luc thuong
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end

			mail_serial = get_mail_by_item("itm_neixiu_02") -- nguyet ngung noi tu dan
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end

			mail_serial = get_mail_by_item("additem_0009") -- bach nien tuyet lien qua
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end

			mail_serial = get_mail_by_item("box_dpj_wyfmp_20") -- hop ngu uan
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end
			if get_item_amount("box_dpj_wyfmp_20", 2) > 0 then
				dung_het_vat_pham(isStarted, "box_dpj_wyfmp_20", 2, 3, {0})
			end

			mail_serial = get_mail_by_item("box_dpj_binglu113_10") -- hop binh luc
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end
			if get_item_amount("box_dpj_binglu113_10", 2) > 0 then
				dung_het_vat_pham(isStarted, "box_dpj_binglu113_10", 2, 3, {0})
			end

			mail_serial = get_mail_by_item("item_xw_qd_001") -- qua chuc phuc
			if mail_serial ~= nil then
				rut_xoa_thu_by_serial(mail_serial)
				has_mail = true
			end
			if deleteRac then
			-- nguyet nhung noi tu dan 1 ngay, thuy ngoc noi tu dan
				xoa_thu_by_items({"itm_neixiu_08", "itm_neixiu_03"})
				xoa_thu_by_items({"ride_windrunner_001", "ride_windrunner_002","ride_windrunner_003","ride_windrunner_004","ride_windrunner_005"})
			end
		end
		if not has_mail then
			break
		end
	end
	xoa_thu_rong()
	arrange_bag(2, 999)
	add_chat_info("Da rut thu xong")
end

function xoa_thu_by_items(ids)
	local check_mail_serial
	for i = 1, table.getn(ids) do
		nx_pause(0)
		local mail_serial = get_mail_by_item(ids[i])
		if mail_serial ~= nil then
			check_mail_serial = mail_serial
			nx_execute("custom_sender", "custom_select_letter", 1, mail_serial, 1)
		end
	end
	nx_execute("custom_sender", "custom_del_letter", 0, 2)
	nx_pause(2)
	nx_execute("custom_sender", "custom_del_letter_ok", 0, 2)
	return check_mail_serial
end

function check_bag_available(view_id)
	local game_client = nx_value("game_client")
	local view = game_client:GetView(nx_string(view_id))
	local viewobj_list = view:GetViewObjList()
  local item_count = table.getn(viewobj_list)
  local base_cap = view:QueryProp("BaseCap")
  local bag_view = game_client:GetView(nx_string(view_id + 1))
  local bag_capacity = 0
  for index, view_item in pairs(bag_view:GetViewObjList()) do
    local beginPos = view_item:QueryProp("BeginPos")
    local endPos = view_item:QueryProp("EndPos")
    bag_capacity = bag_capacity + (endPos - beginPos) + 1
  end
  local total_capacity = base_cap + bag_capacity
	local available = total_capacity - item_count
	return available
end

function rut_xoa_thu_by_items(ids)
	local check_mail_serial
	for i = 1, table.getn(ids) do
		nx_pause(0)
		local mail_serial = get_mail_by_item(ids[i])
		if mail_serial ~= nil then
			check_mail_serial = mail_serial
			nx_execute("custom_sender", "custom_read_letter", mail_serial)
			nx_pause(0.5)
			nx_execute("custom_sender", "custom_get_appendix", mail_serial)
			nx_pause(0.5)
			nx_execute("custom_sender", "custom_select_letter", 1, mail_serial, 1)
			nx_pause(0.5)
			nx_execute("custom_sender", "custom_del_letter", 0, 1)
		end
	end
end

function gui_item_di(nguoi_nhan_thu, item, viewId)
  local bo_cau = get_item_amount("mail_xinge", 2)
  if bo_cau <= 0 then
    nx_execute("custom_sender", "custom_open_mount_shop", 1) -- mo shop
    nx_execute("custom_sender", "custom_buy_item", "Shop_zahuo_00102", 0, 1, 30)
    nx_execute("custom_sender", "custom_open_mount_shop", 0) -- close shop
	end
	local grid = nil
	if viewId == 125 then
		dung_item_nhiem_vu("noop_item", 0, 0) -- mo tui nhiem vu
		grid = "imagegrid_task"
	elseif viewId == 123 then
		dung_nguyen_lieu("noop_item", 0, 0) -- mo tui nguyen lieu
		grid = "imagegrid_material"
	elseif viewId == 2 then
		dung_vat_pham("noop_item", 0, 0) -- mo tui vat pham
		grid = "imagegrid_tool"
	end
	local bag = util_get_form("form_stage_main\\form_bag", true, false)
	
  nx_execute("form_stage_main\\form_mail\\form_mail", "auto_show_mail_form")
	local form = util_get_form("form_stage_main\\form_mail\\form_mail", false, false)
	if nx_is_valid(form) and form ~= nil then
		nx_execute("form_stage_main\\form_mail\\form_mail", "send_on_click", form.send)
		local form_send = util_get_form("form_stage_main\\form_mail\\form_mail_send", true, false)
		while not form_send.Visible do
			nx_pause(0)
		end
		if form_send.Visible then
			local view_index, id = tim_item_pos(item, viewId)
			if view_index >= 0 then
				local title = nx_widestr(util_text(id))
				local recipent = nx_function("ext_utf8_to_widestr", nguoi_nhan_thu)
				add_chat_info("Đang gửi "..nx_function("ext_widestr_to_utf8", util_text(id)) .." đến " ..nguoi_nhan_thu)
				form_send.targetname.Text = recipent
				form_send.lettername.Text = title
				form_send.rbtn_send.Checked = true
				form_send.sendletter.Enabled = true
				local postbox = form_send.postbox

				nx_execute("form_stage_main\\form_bag_func", "on_bag_select_changed", bag[grid], view_index - 1)
				local goodsgrid = nx_value("GoodsGrid")
				if not nx_is_valid(goodsgrid) then
					return
				end
				goodsgrid:ViewGridOnSelectItem(postbox, 0)
				nx_pause(1)
				nx_execute("custom_sender", "custom_send_letter", recipent, title, "", 0, 0, 0)
			end
		end
	end
end

function auto_mail_form()
	nx_execute("form_stage_main\\form_mail\\form_mail", "auto_show_mail_form")
end