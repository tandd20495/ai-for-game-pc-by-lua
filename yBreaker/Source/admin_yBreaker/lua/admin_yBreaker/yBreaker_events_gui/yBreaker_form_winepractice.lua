require("util_gui")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_winepractice"
function DoDrinking(cbtn)
	UpdateStatus()
	local form = cbtn.ParentForm
	while form.auto_start do
		nx_pause(0.1)
		local game_client=nx_value("game_client")
		local game_visual=nx_value("game_visual")
		if nx_is_valid(game_client)and nx_is_valid(game_visual)then 
			local player_client=game_client:GetPlayer()
			local game_player=game_visual:GetPlayer()
			local game_scence=game_client:GetScene()
			if not player_client:FindProp("IsCheckPass")or player_client:QueryProp("IsCheckPass")~=1 then 
				local textchat = nx_widestr(nx_function("ext_utf8_to_widestr","Mở mật khẩu rương trước khi bắt đầu"))
				nx_value("form_main_chat"):AddChatInfoEx(textchat, 17, false)
				nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
				UpdateStatus()
				return 
			end
			if nx_number(form.limit_round)<=0 then 
				local textchat = nx_widestr(nx_function("ext_utf8_to_widestr","Nhập số lượng bình"))
				nx_value("form_main_chat"):AddChatInfoEx(textchat, 17, false)
				nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
				UpdateStatus()
				return 
			end
			if form.cur_round < form.limit_round then
				if not check() then
					-- Mở shop
					nx_execute("custom_sender", "custom_open_mount_shop", 1)
					-- Mua Phú Thủy Xuân tron Tạp Hóa ------------- Shop Giang hồ ---- 0: Tạp Vật, 19: số thứ tự Phú Thủy Xuân, 1: Mua (Tương tự vậy thì 1,1,1: Tab Công Cụ, Mua Liệp Thú Đoản Kiếm
					nx_execute("custom_sender", "custom_buy_item", "Shop_zahuo_00102", 0,19,1)					
					-- Đóng shop
					nx_execute("custom_sender", "custom_open_mount_shop", 0)
				else
					local buff_drunk1 = GetBuff("buf_drunk_1")
					local buff_drunk2 = GetBuff("buf_drunk_2")
					local buff_drunk3 = GetBuff("buf_drunk_3")
					local buff_wine = GetBuff("buf_wine_3")
					if buff_drunk1 == nil and buff_drunk2 == nil and buff_drunk3 == nil and ( buff_wine == nil or buff_wine <= 9) and player_client:QueryProp("State") ~= "offact289" then
						-- Uống Phú Thủy Xuân có ID: jiu_10001
						nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "jiu_10001")
						form.cur_round = form.cur_round + 1
						form.lbl_limit_number.Text = nx_widestr(form.limit_round - form.cur_round)
						form.lbl_turn_number.Text = nx_widestr(form.cur_round)
					end
				end
			end
		end
		nx_pause(2)
	end
end
function UpdateStatus()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if form.auto_start then 
			form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Bắt Đầu")
			--form.btn_control.ForeColor = "255,0,255,0"
		    form.auto_start = false	
			step = 1
		else
			form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Kết Thúc")
			--form.btn_control.ForeColor = "255,255,255,255"
			form.limit_round = nx_number(form.ipt_limit_turn.Text)
			form.lbl_limit_number.Text=nx_widestr(form.limit_round)
			form.lbl_turn_number.Text=nx_widestr(form.cur_round)
		    form.auto_start = true
		end
	end
end
function on_form_main_init(form)
	form.Fixed = false
	form.auto_start = false
	form.limit_round = 0 
	form.cur_round = 0
	form.limit_round = 0 
end
function on_main_form_open(form)
	change_form_size()
	if not form.auto_start then
	form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Bắt Đầu")
	--form.btn_control.ForeColor = "255,255,255,255"
	end
end

function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = 100
	form.Top = (gui.Height - form.Height) / 2
end

function on_main_form_close(form)
	nx_destroy(form)
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return nil
	end
	on_main_form_close(form)
end

function show_hide_form_winepractice()
	util_auto_show_hide_form(THIS_FORM)
end
function GetBuff(buff_id)
	-- Nếu tồn tại buff_id thì trả về thời gian của buff đó, nếu buff không có thời gian thì trả về -1
	-- Nếu không tồn tại buff thì thả về nil
	local form = nx_value("form_stage_main\\form_main\\form_main_buff")
	if not nx_is_valid(form) then
		return nil
	end

	for i = 1, 24 do
		if nx_string(form["lbl_photo" .. tostring(i)].buffer_id) == buff_id then
			local buff_time = GetSecondFromText(form["lbl_time" .. tostring(i)].Text)
			if buff_time == nil then
				return -1
			else
				return buff_time
			end
		end
	end

	return nil
end
function GetSecondFromText(text)
	local num
	local texttime
	--ui_minute=phút
	--ui_hour=Giờ
	--ui_day=Ngày
	--ui_second=s
	num = string.match(nx_string(text), "(%d+)")
	if num ~= nil then
		local cstart = string.len(num) + 1
		texttime = string.sub(nx_string(text), cstart, cstart)
		num = tonumber(num)

		if texttime == "N" or texttime == "n" then
			num = num * 86400
		elseif texttime == "G" or texttime == "g" then
			num = num * 3600
		elseif texttime == "P" or texttime == "p" then
			num = num * 60
		end

		return num
	end

	return nil
end
function check()
	local client = nx_value("game_client")
	if not nx_is_valid(client) then
	return 0
	end
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
	return 0
	end
	local scene = client:GetScene()
	local is_found = false
	if not nx_is_valid(scene) then
	return 0
	end
	local view_table = client:GetViewList()
	for i = 1, table.getn(view_table) do
	  local view = view_table[i]
	  if view.Ident == "123" then
		local view_obj_table = view:GetViewObjList()
		for k = 1, table.getn(view_obj_table) do
		  local view_obj = view_obj_table[k]
		  if nx_string(view_obj:QueryProp("ConfigID")) == "jiu_10001" then
			is_found = true
			break
		  end
		end
		break
	  end
	end
	return is_found
end
