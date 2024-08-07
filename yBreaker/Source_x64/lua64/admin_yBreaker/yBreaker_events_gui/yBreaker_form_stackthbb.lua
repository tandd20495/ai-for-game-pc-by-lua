require("util_gui")
require("util_static_data")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_stackthbb"
local isStartTHBB = false
--  Neigong is using
local neigong_using = ""

function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	form.cbtn_lhq.Checked = false
	form.btn_control.Text = nx_function("ext_utf8_to_widestr", "Chạy")
	form.btn_control.ForeColor = "255,255,255,255"
	form.lbl_title.Text = ""
end

function on_main_form_close(form)
    isStartTHBB = false
    nx_destroy(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
	
	local gui = nx_value("gui")
	form.Left = 1310
	form.Top = 750
	--form.Top = (gui.Height /2)
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function on_btn_thbb_click(btn)
    local form = btn.ParentForm
    if not nx_is_valid(form) then
        return
    end
	
    if isStartTHBB then
		-- Stop status
		isStartTHBB = false
		
		--Có setting ở Config nội chính không? Có thì chuyển về nội chính ở phần cài đặt PVP
		--local ini = nx_create("IniDocument")
		--local game_config = nx_value("game_config")
        --local account = game_config.login_account
		--
		--local game_client = nx_value("game_client")
		--local player_client = game_client:GetPlayer()
		--if nx_is_valid(ini) then
		--	ini.FileName = account .. "\\yBreaker_config.ini"
		--	if ini:LoadFromFile() then
		--		-- Đọc nội công từ cài đặt PVP
		--		local max_neigong = ""
		--		max_neigong = ini:ReadString(nx_string("neigong"), nx_string("max"), "")
		--		
		--		if max_neigong ~= "" or  max_neigong ~= 0 then 
		--			-- Max_neigong khác với Nội đang dùng thì mới đổi qua nội
		--			if nx_is_valid(player_client) and nx_string(max_neigong) ~= nx_string(player_client:QueryProp("CurNeiGong")) then
		--				nx_execute("custom_sender", "custom_use_neigong", nx_string(max_neigong))
		--			end
		--		end
		--	end
		--end
		
		local game_client = nx_value("game_client")
		local player_client = game_client:GetPlayer()
		
		-- Đổi lại nội chính đang dùng trước khi swap nội Cái Bang
		if nx_string(neigong_using) ~= "" and nx_string(neigong_using) ~= nx_string(player_client:QueryProp("CurNeiGong")) then
			nx_execute("custom_sender", "custom_use_neigong", nx_string(neigong_using))
		end
		
		---- Nếu đang ngồi thì mới dùng
		local game_visual = nx_value("game_visual")
        local game_player = game_visual:GetPlayer()
		if nx_is_valid(game_player) and game_player.state == "sitcross" then
			local fight = nx_value("fight")
			--Use skill Tọa Thiền Điều Tức,zs_default_01  để đứng dậy
			fight:TraceUseSkill("zs_default_01", false, false)
		end
		
		btn.Text = nx_function("ext_utf8_to_widestr", "Chạy")
		btn.ForeColor = "255,255,255,255"

    else
		isStartTHBB = true
		btn.Text = nx_function("ext_utf8_to_widestr", "Dừng")
		btn.ForeColor = "255,220,20,60"
		-- Gọi hàm xử lý tích THBB
		stack_THBB()
    end
end

-- Show hide form stack thần hành bách biến
function show_hide_form_stackthbb()
	util_auto_show_hide_form("admin_yBreaker\\yBreaker_form_stackthbb")
end

-- Show hide form gia viên
function show_hide_house_form()
	util_auto_show_hide_form("form_stage_main\\form_main\\form_main_shortcut")
end

-- Get buff stack from buff_name/id
function yBreaker_get_stack_buff_info_myself(id_buff_info)
	local game_client = nx_value("game_client")
	local player_client = game_client:GetPlayer()
	if nx_is_valid(player_client) then
		for j = 1, 25 do
			local buff = player_client:QueryProp("BufferInfo" .. tostring(j))
			if buff ~= 0 then
				local buff_info = util_split_string(buff, ",")
				local buff_name = nx_string(buff_info[1])
				if nx_string(buff_name) == nx_string(id_buff_info) then		
					-- Hiển thị buff name
					--local buff_name_text = util_text(buff_name)
					
					-- Hiển thị xếp chồng buff
					local buff_count_stack = buff_info[5]
					local buff_count_info = util_split_string(buff_count_stack, "|")

					if buff_count_info ~= nil then
						buff_count_info = buff_count_info[1]
						if buff_count_info ~= nil and tonumber(buff_count_info) > 0 then
							return tonumber(buff_count_info)
						end
					end
					
					return nil
				end
			end
		end
	end
end

-- Get buff time remain from buff name/id
function yBreaker_get_time_buff_info_myself(id_buff_info)
	local game_client = nx_value("game_client")
	local player_client = game_client:GetPlayer()
	if nx_is_valid(player_client) then
		for j = 1, 25 do
			local buff = player_client:QueryProp("BufferInfo" .. tostring(j))
			if buff ~= 0 then
				local buff_info = util_split_string(buff, ",")
				local buff_name = nx_string(buff_info[1])

				if nx_string(buff_name) == nx_string(id_buff_info) then		
					-- Hiển thị buff name
					--local buff_name_text = util_text(buff_name)
					
					-- Hiển thị thời gian buff
					local MessageDelay = nx_value("MessageDelay")
					if not nx_is_valid(MessageDelay) then
						return 0
					end
					local buff_time = buff_info[4]
					local server_now_time = MessageDelay:GetServerNowTime()
					local buff_diff_time = nx_int((buff_time - server_now_time) / 1000) -- Unit timesamp
					local buff_remain_h = nx_int(buff_diff_time / 3600) -- Giờ
					local buff_remain_m = nx_int((buff_diff_time - (buff_remain_h * 3600)) / 60) -- Phút
					local buff_remain_s = nx_int(buff_diff_time - (buff_remain_h * 3600) - (buff_remain_m * 60)) -- Giây
					local buff_remain_second = nx_int(buff_remain_h) * 3600 + nx_int(buff_remain_m) * 60 + nx_int(buff_remain_s)
					if buff_remain_second ~= nil and buff_remain_second > 0 then
						-- Return value
						return buff_remain_second
					end
					
					return nil
				end
			end
		end
	end
end


-- Function để tích stack THBB
function stack_THBB()
	yBreaker_show_Utf8Text("Gọi Chung Linh Điêu để tích nhanh hơn!") -- Hiện tại chưa tự gọi được npc_homepet_001=Chung Linh Điêu)
	while isStartTHBB == true do
		-- Not non responding
		nx_pause(0.2)
		
		--Get buff trên người xem đang cưỡi ngựa hay không? Có thì xuống ngựa
		if yBreaker_get_buff_id_info("buf_riding_01") ~= nil then
			nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
		end		
		
		--Gọi PET (Hiện tại chưa gọi được npc_homepet_001=Chung Linh Điêu)
		local game_visual = nx_value("game_visual")
		local game_player = game_visual:GetPlayer()
			
		-- Chỉ khi nhân vật đứng yên mới thực hiện
		if nx_is_valid(game_player) and game_player.state == "static" then
			-- Chưa có stack nào/ hoặc stack < 10 hoặc thời gian thần hành còn thấp hơn 300s mới tích
			local count_buff_myself = yBreaker_get_stack_buff_info_myself("buf_CS_jh_lbwb02")
			local remain_buff_myself = yBreaker_get_time_buff_info_myself("buf_CS_jh_lbwb02")
			--yBreaker_show_Utf8Text("Stack: " .. nx_string(count_buff_myself) .. "Time:" .. nx_string(remain_buff_myself))
			if count_buff_myself == nil or count_buff_myself ~= nil and count_buff_myself < 10 or remain_buff_myself ~= nil and remain_buff_myself < 300  then
				
				-- Check chưa dùng nội 3 Cái Bang thì chuyển nội công 3 Cái Bang
				local game_client = nx_value("game_client")
				local player_client = game_client:GetPlayer()
				
				-- Nội đang dùng khác với nội Cái Bang thì mới đổi
				if nx_is_valid(player_client) and nx_string(player_client:QueryProp("CurNeiGong")) ~= nx_string("ng_gb_003")  then
					-- Lưu tạm nội đang dùng để chút đổi lại
					neigong_using = nx_string(player_client:QueryProp("CurNeiGong"))
					
					-- Đổi sang nội 3 Cái Bang
					nx_execute("custom_sender", "custom_use_neigong", nx_string("ng_gb_003"))
				end
				
				local fight = nx_value("fight")
				--Use skill Thần Hành Bách Biến,CS_jh_lbwb02
				fight:TraceUseSkill("CS_jh_lbwb02", false, false)
				
				nx_pause(0.5)
				
				--Use skill Tọa Thiền Điều Tức,zs_default_01 ngồi xuống
				fight:TraceUseSkill("zs_default_01", false, false)
				
				-- Default time delay for sitcross
				local time_delays = 6 -- Time delay when Chung Linh Điêu: buf_pet_qinggongpoint/ 8: PET thường: buf_pet_qinggongpoint_1/ 10: Không có PET
			
				-- Waiting for countdown 
				nx_pause(nx_int(time_delays))
				--yBreaker_show_Utf8Text("Delay: " .. nx_string(time_delays))
			else
				-- Không tích nữa thì swap về nội chính đã lưu ở cài đặt
				--local ini = nx_create("IniDocument")
				--local game_config = nx_value("game_config")
				--local account = game_config.login_account
				--
				--local game_client = nx_value("game_client")
				--local player_client = game_client:GetPlayer()
				--if nx_is_valid(ini) then
				--	ini.FileName = account .. "\\yBreaker_config.ini"
				--	if ini:LoadFromFile() then
				--		-- Đọc nội công từ cài đặt PVP
				--		local max_neigong = ""
				--		max_neigong = ini:ReadString(nx_string("neigong"), nx_string("max"), "")
				--		if max_neigong ~= "" or  max_neigong ~= 0 then 
				--			-- Max_neigong khác với Nội đang dùng thì mới đổi qua nội
				--			if nx_is_valid(player_client) and nx_string(max_neigong) ~= nx_string(player_client:QueryProp("CurNeiGong")) then
				--				nx_execute("custom_sender", "custom_use_neigong", nx_string(max_neigong))
				--			end
				--		end
				--	end
				--end
				
				local game_client = nx_value("game_client")
				local player_client = game_client:GetPlayer()
				
				-- Đổi lại nội chính đang dùng trước khi swap nội Cái Bang
				if nx_string(neigong_using) ~= "" and nx_string(neigong_using) ~= nx_string(player_client:QueryProp("CurNeiGong")) then
					nx_execute("custom_sender", "custom_use_neigong", nx_string(neigong_using))
				end
			end
			
			if nx_is_valid(game_player) and game_player.state == "sitcross" then
				local fight = nx_value("fight")
				--Use skill Tọa Thiền Điều Tức,zs_default_01  để đứng dậy
				fight:TraceUseSkill("zs_default_01", false, false)
				--if yBreaker_get_buff_id_info("buf_pet_qinggongpoint") ~= nil then
				--	yBreaker_show_Utf8Text("Buff PET hồi 10 KC: delay 6")
				--
				--end
				--
				--if yBreaker_get_buff_id_info("buf_pet_qinggongpoint_1") ~= nil then
				--	yBreaker_show_Utf8Text("Buff PET hồi 5 KC: delay 8")
				--end
			end
		end
	
		-- Xử lý cho việc tích LHQ
		local form = util_get_form("admin_yBreaker\\yBreaker_form_stackthbb", true, false)
		if form.cbtn_lhq.Checked == true then
			local fight = nx_value("fight")
			local game_client = nx_value("game_client")
			local player_client = game_client:GetPlayer()
			local game_visual = nx_value("game_visual")
			local game_player = game_visual:GetPlayer()
		
			local count_buff_lhq = yBreaker_get_stack_buff_info_myself("buf_CS_sl_lhq03")
			local time_remain_lhq = yBreaker_get_time_buff_info_myself("buf_CS_sl_lhq03")
			--yBreaker_show_Utf8Text("Stack: " .. nx_string(count_buff_lhq) .."LHQ: " .. nx_string(time_remain_lhq))
			
			-- Check mana còn, ít hơn 30% thì ngồi thiền 
			if  nx_is_valid(player_client) and player_client:QueryProp("MPRatio") > 30 then 
				if time_remain_lhq == nil or count_buff_lhq == nil or count_buff_lhq < 10  or (count_buff_lhq == 10 and time_remain_lhq < 15) then
					--nx_is_valid(game_player) and game_player.state == "static" then

					--Use skill Như Lai Niêm Hoa,CS_sl_lhq05
					fight:TraceUseSkill("CS_sl_lhq05", false, false)
					
					nx_pause(0.2)
					
					--Use skill  Liên Hoàn Tam Khiêu, CS_sl_lhq01
					fight:TraceUseSkill("CS_sl_lhq01", false, false)
				end
				
			else
				-- Đang đứng thì ngồi thiền để hồi mana
				if nx_is_valid(game_player) and game_player.state == "static" then

					--Use skill Tọa Thiền Điều Tức,zs_default_01  để ngồi thiền
					fight:TraceUseSkill("zs_default_01", false, false)
					--nx_pause(6)
				end
			end
		end
	end	
end
