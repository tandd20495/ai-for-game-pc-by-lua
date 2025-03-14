require("util_gui")
require("util_move") -- Xac dinh toa do distance3d
require("share\\chat_define")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_lib_moving")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_util")

local THIS_FORM = "admin_yBreaker\\yBreaker_form_boombuff"
local is_start = false
local item = {}

function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
	is_start = false

end
function on_main_form_open(form)
	change_form_size()
	form.btn_start.Text = nx_function("ext_utf8_to_widestr", "Chạy")
	form.btn_start.ForeColor = "255,255,255,255"
	form.rbtn_buff.Checked = true
	form.chk_player.Checked = true
	form.chk_relive.Checked = false
	form.lbl_title.Text = ""
	form.edt_player_txt.Text = IniReadUserConfig("BoomBuff_Player", "PlayerList", nx_widestr(""))
	loadPlayerlist()
end
function on_main_form_close(form)
	is_start = false
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function getName_myself()
    local player = nx_value("game_client"):GetPlayer()
    if not nx_is_valid(player) then
        return 0
    end
    local name_myself = player:QueryProp("Name")
    return name_myself
end

local TablePlayerList = {}
local nPlayer = 1

-- Load player list from ini file
function loadPlayerlist()
    TablePlayerList = {}

    local playerStr = IniReadUserConfig("BoomBuff_Player", "PlayerList", "")
	
    if playerStr ~= "" then
        local pLst = util_split_string(nx_string(playerStr), ";")
        for i = 1, #pLst do
			table.insert(TablePlayerList, pLst[i])
        end
    end
end

-- Add player
function on_btn_add_name_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local client = nx_value("game_client")
	if not nx_is_valid(client) then
		return
	end
	local player = client:GetPlayer()
	if not nx_is_valid(player) then
		return
	end
	local obj = client:GetSceneObj(nx_string(player:QueryProp("LastObject")))
	
	local crtTxt = form.edt_player_txt.Text
	if nx_is_valid(obj) then
		local tmp = obj:QueryProp("Name")
		
		local l = util_split_wstring(crtTxt, ";")
		for i = 1, #l do
			-- Kiểm tra trùng tên
			if l[i] == tmp then
				yBreaker_show_Utf8Text("Tên nhân vật trùng!")
				return
			end
		end
		if crtTxt ~= nx_widestr("") then
			crtTxt = crtTxt .. nx_widestr(";")
		end
		form.edt_player_txt.Text = crtTxt .. tmp
	end
	
	yBreaker_show_Utf8Text("Đã cập nhật danh sách mới!")
	IniWriteUserConfig("BoomBuff_Player", "PlayerList", form.edt_player_txt.Text)
end

function on_btn_start_click(btn)
	local form = btn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	loadPlayerlist() -- Test load config
	UpdateStatus()
	while is_start do
		-- Tránh bị treo game trong vòng lặp (Nếu trong while do không có nx_pause(0.1) sẽ bị treo game)
		nx_pause(0.2)	
		
		local is_vaild_data = true
        local game_client
        local game_visual
        local game_player
        local player_client
        local game_scence

        game_client = nx_value("game_client")
        if not nx_is_valid(game_client) then
            is_vaild_data = false
        end
        game_visual = nx_value("game_visual")
        if not nx_is_valid(game_visual) then
            is_vaild_data = false
        end
        if is_vaild_data == true then
            game_player = game_visual:GetPlayer()
            if not nx_is_valid(game_player) then
                is_vaild_data = false
            end
            player_client = game_client:GetPlayer()
            if not nx_is_valid(player_client) then
                is_vaild_data = false
            end
            game_scence = game_client:GetScene()
            if not nx_is_valid(game_scence) then
                is_vaild_data = false
            end
        end
		
		local form = nx_value(THIS_FORM)
		if not nx_is_valid(form) then
			return
		end

		-- Nếu bị chết và có check vào hồi sinh thì hồi sinh lân cận (mặc định hồi sinh lân cận)
		if form.chk_relive.Checked then
			local game_client = nx_value("game_client")
			local player_client = game_client:GetPlayer()
			local logicstate = player_client:QueryProp("LogicState")
			if logicstate == 120 then
				nx_pause(2)
				nx_execute("custom_sender", "custom_relive", 0, 0)
				nx_pause(8)
			end
		else
			local game_client = nx_value("game_client")
			local player_client = game_client:GetPlayer()
			local logicstate = player_client:QueryProp("LogicState")
			if logicstate == 120 then
				nx_pause(2)
				nx_execute("custom_sender", "custom_relive", 2, 0)
				nx_pause(8)
			end
		end
		
		if is_vaild_data == true then
			-- MODE BUFF
			if form.rbtn_buff.Checked then
				loopBuff()
			end	
		
			--MODE BOOM
			if form.rbtn_boom.Checked then
				loopBoom()
			end
		end
    end
end

function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = 1323
	form.Top = 855
	--form.Top = (gui.Height - form.Height) / 2
end

function show_hide_form_boombuff()
	util_auto_show_hide_form(THIS_FORM)
end

function UpdateStatus()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if is_start then 
			form.btn_start.Text = nx_function("ext_utf8_to_widestr", "Chạy")
			form.btn_start.ForeColor = "255,255,255,255"
		    is_start = false
			
			-- Dừng di chuyển
			StopMoving()
		
		else
			-- Check có học skill PTC chưa?
			if form.rbtn_buff.Checked then
				
				local skill_id = "CS_jh_xfz02_hide"
				local fight = nx_value("fight")
				local skill = fight:FindSkill(skill_id)
				if not nx_is_valid(skill) then
					tools_show_notice(nx_function("ext_utf8_to_widestr", "Chưa học kĩ năng Không Tương Vô Tương, không thể dùng chức năng này!"), 2)
					return
				end
				--yBreaker_show_Utf8Text("Tìm đối tượng trọng phạm vi 50mét.")
			end
		
			-- Check có học skill Boom Đường Môn chưa?
			if form.rbtn_boom.Checked then
				
				local skill_id = "CS_tm_fgzyc05"
				local fight = nx_value("fight")
				local skill = fight:FindSkill(skill_id)
				if not nx_is_valid(skill) then
					tools_show_notice(nx_function("ext_utf8_to_widestr", "Chưa học kĩ năng Tiềm Tung Niếp Tích, không thể dùng chức năng này!"), 2)
					return
				end
				--yBreaker_show_Utf8Text("Tìm đối tượng trọng phạm vi 50mét.")
			end
			
			form.btn_start.Text = nx_function("ext_utf8_to_widestr", "Dừng")
			form.btn_start.ForeColor = "255,220,20,60"
		    is_start = true
		end
		
		-- Tự động chạy
		if form.chk_autorun.Checked then
			
			-- Bắt đầu di chuyển theo danh sách tọa thiết lập
			StartMoving()	
		end
	end
end

-- Logic moving to postion
--local Running = false
local PositionList = {}
local nextPos = 1
local TimerObjNotValid = 0

function StartMoving()
	-- Load config position from ini file
    loadConfig()
	
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end

    while is_start do
		nx_pause(0.2)
		
		-- Nếu bị chết và có check vào hồi sinh thì hồi sinh lân cận (mặc định hồi sinh lân cận)
		if form.chk_relive.Checked then
			local game_client = nx_value("game_client")
			local player_client = game_client:GetPlayer()
			local logicstate = player_client:QueryProp("LogicState")
			if logicstate == 120 then
				nx_pause(2)
				nx_execute("custom_sender", "custom_relive", 0, 0)
				nx_pause(8)
			end
		else
			local game_client = nx_value("game_client")
			local player_client = game_client:GetPlayer()
			local logicstate = player_client:QueryProp("LogicState")
			if logicstate == 120 then
				nx_pause(2)
				nx_execute("custom_sender", "custom_relive", 2, 0)
				nx_pause(8)
			end
		end
		
		-- Handle moving
        loopMoving()
		
		-- MODE BUFF
		if form.rbtn_buff.Checked then
			loopBuff()
		end	
		
		--MODE BOOM
		if form.rbtn_boom.Checked then
			loopBoom()
		end
		
    end
end

function StopMoving()
    StopFindPath()
end

-- Private
function loopMoving()
    if IsMapLoading() then
        return
    end

    if nextPos > #PositionList then
        nextPos = 1
    end

    local p = PositionList[nextPos]
    if GetCurMap() ~= p.map then
        GoToMapByPublicHomePoint(p.map)
        return
    end
    

    if GetDistance(p.x, p.y, p.z) > 2 then
        GoToPosition(p.x, p.y, p.z)
    else
		-- waitTimeOut()
		-- Tăng position +1
		nextPos = nextPos + 1
	end

    XuongNgua()
end

function waitTimeOut()
    if TimerDiff(TimerObjNotValid) < 7 then
        return
    end
    if TimerDiff(TimerObjNotValid) < 8 then
        nextPos = nextPos + 1
    end
    TimerObjNotValid = TimerInit()
end

-- Load config position from ini file
function loadConfig()
    PositionList = {}
    local posStr = IniReadUserConfig("BoomBuff_Pos", "P", "")
    if posStr ~= "" then
        local posList = util_split_string(nx_string(posStr), ";")
        for _, pos in pairs(posList) do
            local prop = util_split_string(pos, ",")
            if nx_string(prop[1]) == "1" then
                local p = {
                    ["map"] = prop[2],
                    ["x"] = nx_number(prop[3]),
                    ["y"] = nx_number(prop[4]),
                    ["z"] = nx_number(prop[5])
                }
                table.insert(PositionList, p)
            end
        end
        nextPos = 1
    else
        StopMoving()
    end
end

-- Xử lý boom
function loopBoom()
	local is_vaild_data = true
	local game_client
	local game_visual
	local game_player
	local player_client
	local game_scence

	game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		is_vaild_data = false
	end
	game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		is_vaild_data = false
	end
	if is_vaild_data == true then
		game_player = game_visual:GetPlayer()
		if not nx_is_valid(game_player) then
			is_vaild_data = false
		end
		player_client = game_client:GetPlayer()
		if not nx_is_valid(player_client) then
			is_vaild_data = false
		end
		game_scence = game_client:GetScene()
		if not nx_is_valid(game_scence) then
			is_vaild_data = false
		end
	end
	
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
		
	if is_vaild_data == true then
		-- MODE BOOM
		if form.rbtn_boom.Checked then
	
			local game_scence_objs = game_scence:GetSceneObjList()
			local num_objs = table.getn(game_scence_objs)
		   
			for i = 1, num_objs do

				local obj_type = 0
				if nx_is_valid(game_scence_objs[i]) and game_scence_objs[i]:FindProp("Type") then
					obj_type = game_scence_objs[i]:QueryProp("Type")
				end
					
				-- Type 2 là người chơi
				if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then

					local name_player = game_scence_objs[i]:QueryProp("Name")
					local name_guild = game_scence_objs[i]:QueryProp("GuildName")
					
					-- Duyệt danh sách tên người chơi
					for iplayer = nPlayer , #TablePlayerList do
						-- Kiểm tra đúng tên thì chọn mục tiêu
						if form.chk_player.Checked and nx_string(name_player) == nx_string(TablePlayerList[iplayer]) then
							--yBreaker_show_Utf8Text("Cách " .. TablePlayerList[iplayer] .. " ".. nx_string(nx_int(dist_player)) .. " mét, trong phạm vi ném boom!")
							local name_myself = getName_myself()
						
							---- Check name not select my self
							--if name_myself ~= nx_widestr(name_player) then
							--	-- Chọn mục tiêu
							--	nx_execute('custom_sender', 'custom_select', game_scence_objs[i].Ident)
							--end

							--Lấy khoảng cách từ nhân vật tới mục tiêu đang chọn
							local visualObj = game_visual:GetSceneObj(game_scence_objs[i].Ident)
							
							local dist_player = getDistanceWithObj({game_player.PositionX, game_player.PositionY, game_player.PositionZ}, visualObj)
							
							if dist_player <= 20 then
								--1. Get buff trên người xem đang cưỡi ngựa hay không? Có thì xuống ngựa
								if yBreaker_get_buff_id_info("buf_riding_01") ~= nil then
									nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
									nx_pause(0.2)
								end

								-- Check mục tiêu có buff không?
								if not get_buff_info("buf_CS_tm_fgzyc05a_range", game_scence_objs[i]) then		 
									-- Ném boom
									-- Kiểm tra có buff boom không? Nếu không mới ném
									nx_value('gui').GameHand:SetHand('groundpick', 'Default', 'map\\tex\\Target_area_G.dds', '' .. 4, 'xxx', nx_string(10))
									nx_execute('game_effect', 'hide_ground_pick_decal')
									local object_target = nx_value('game_visual'):GetSceneObj(game_scence_objs[i].Ident)
									nx_execute('game_effect', 'locate_ground_pick_decal', object_target.PositionX + math.random() + math.random(-2, 2), object_target.PositionY, object_target.PositionZ + math.random() + math.random(-2, 2), 30)
									nx_value('fight'):TraceUseSkill('cs_tm_fgzyc05', true, false)
								end
							end
							
							if dist_player > 20 then
								--yBreaker_show_Utf8Text("Cảnh báo! Cách " .. TablePlayerList[iplayer] .. " ".. nx_string(nx_int(dist_player)) .. " mét, đang di chuyển lại gần!")
								-- Di chuyển theo sau mục tiêu
								local map_query = nx_value("MapQuery")
								local city = map_query:GetCurrentScene()
								local posX = visualObj.PositionX + 5
								local posY = visualObj.PositionY
								local posZ = visualObj.PositionZ
								tools_move(city, posX, posY, posZ, direct_run)	
								direct_run = false
								break -- Dùng lệnh này để tránh object không tồn tại
							end
						end
					end
					
					if not form.chk_player.Checked then
						--yBreaker_show_Utf8Text("Đang tự ném boom dưới chân!")
						local player = yBreaker_get_player()
						-- Ném boom dưới chân
						nx_value('gui').GameHand:SetHand('groundpick', 'Default', 'map\\tex\\Target_area_G.dds', '' .. 4, 'xxx', nx_string(10))
						nx_execute('game_effect', 'hide_ground_pick_decal')
						local object_target = nx_value('game_visual'):GetSceneObj(player.Ident)
						nx_execute('game_effect', 'locate_ground_pick_decal', object_target.PositionX + math.random() + math.random(-2, 2), object_target.PositionY, object_target.PositionZ + math.random() + math.random(-2, 2), 30)
						nx_value('fight'):TraceUseSkill('cs_tm_fgzyc05', true, false)
					end
				end

			end
		end
    end
end

-- Xử lý buff
function loopBuff()
	
	local is_vaild_data = true
	local game_client
	local game_visual
	local game_player
	local player_client
	local game_scence

	game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		is_vaild_data = false
	end
	game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		is_vaild_data = false
	end
	if is_vaild_data == true then
		game_player = game_visual:GetPlayer()
		if not nx_is_valid(game_player) then
			is_vaild_data = false
		end
		player_client = game_client:GetPlayer()
		if not nx_is_valid(player_client) then
			is_vaild_data = false
		end
		game_scence = game_client:GetScene()
		if not nx_is_valid(game_scence) then
			is_vaild_data = false
		end
	end
	
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
		
	if is_vaild_data == true then
		-- MODE BUFF
		if form.rbtn_buff.Checked then
			local game_scence_objs = game_scence:GetSceneObjList()
			local num_objs = table.getn(game_scence_objs)
		   
			for i = 1, num_objs do
				local obj_type = 0		
				if nx_is_valid(game_scence_objs[i]) and game_scence_objs[i]:FindProp("Type") then
					obj_type = game_scence_objs[i]:QueryProp("Type")
				end	
				
				-- Type 2 là người chơi
				if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then
				
					local name_player = game_scence_objs[i]:QueryProp("Name")
					local name_guild = game_scence_objs[i]:QueryProp("GuildName")
					
					-- Duyệt danh sách tên người chơi
					for iplayer = nPlayer , #TablePlayerList do
						-- Kiểm tra đúng tên thì chọn mục tiêu
						if form.chk_player.Checked and nx_string(name_player) == nx_string(TablePlayerList[iplayer]) then
							
							local name_myself = getName_myself()
						
							---- Check name not select my self
							--if name_myself ~= nx_widestr(name_player) then
							--	-- Chọn mục tiêu
							--	nx_execute('custom_sender', 'custom_select', game_scence_objs[i].Ident)
							--end
						
							--Lấy khoảng cách từ nhân vật tới mục tiêu đang chọn
							local visualObj = game_visual:GetSceneObj(game_scence_objs[i].Ident)
							local dist_player = getDistanceWithObj({game_player.PositionX, game_player.PositionY, game_player.PositionZ}, visualObj)
					
							if dist_player <= 20 then
								--1. Get buff trên người xem đang cưỡi ngựa hay không? Có thì xuống ngựa
								if yBreaker_get_buff_id_info("buf_riding_01") ~= nil then
									nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
									nx_pause(0.2)
								end	
								--yBreaker_show_Utf8Text("Cách " .. TablePlayerList[iplayer] .. " ".. nx_string(nx_int(dist_player)) .. " mét, trong phạm vi buff!")
							
								--: CẤP 1: Skill hiệu ứng cứng quan trọng quần công:
									--: buf_CS_jh_xlsbz15_02=Long Chiến Vu Dã (Hôn mê)
									--: buf_CS_jh_xlsbz07=Đột Như Kỳ Lai (Hôn mê)
									--: buf_CS_by_xhmdl01_01=Nghiệt (HHMD Hôn mê)
									--: buf_cs_wd_tjq08=Khai Thái Cực (Cổ)
									--: buf_CS_wdzp_tjq08=Khai Thái Cực (Phái)
									--: buf_CS_jh_lbwb01_01stun=Điểm huyệt (Thần Hành)
									--: buf_CS_jh_yqq04=Dã Cầu Quyền-4 (Thần Hành)
									--: buf_CS_jy_xsd01_01=Huyết Tẩy Sơn Hà (Trói xích CYV)
									--: buf_CS_jy_tdshs05_1=Triền Nhiễu (Trói ném CYV)
									--: buf_CS_jh_xfz02=Hôn Mê (Phật Tâm)
									--: buf_CS_yhwq_hsqs01=Điệp Mang (Vô Khuyết) -> Buff không giải được hiệu ứng
									--: buf_CS_yh_hsqs01=Điệp Mang (Thế Lực)  -> Buff không giải được hiệu ứng
									--: buf_CS_jh_yydf03=Hôn mê (Uyên Ương Song Đao Hút)
									--: buf_CS_jh_yydf07=Cấm Khinh Công (Uyên Ương Song Đao Phá Def)
									--: buf_CS_jh_jgjf08_1=Cửu Kiếm Quy Nhất (Cửu Cung)
									--: buf_CS_jh_jgjf05b_range=Thiên Khuyết (Cửu Cung)
									--: buf_CS_jh_jgjf06b_range=Địa liệt (Cửu Cung)
									--: buf_CS_jh_jgjf09=Cửu Cửu Hoàn Nguyên (Nộ Cửu Cung)
									--: buf_CS_jh_flxmz06_range=Thụ Đại Chiêu Phong (Phong Lôi Trượng)
									--: buf_CS_jh_lybj06_02=Phong Ảnh Cù Triền  (Liệt Vân Bát Tiễn: Trừ né 100%) -> Buff không giải được hiệu ứng trừ né 100%
									--: buf_CS_jh_lybj06_01=Hôn mê 2s (Liệt Vân Bát Tiễn)
									--: wuji_buf_CS_tm_ywt08_range=Oan Hồn Triền Túc (Bẫy phong chiêu/ Định thân Trịch Bút/ wuji: Võ kỹ)
									--: wuji_buf_CS_tm_ywt07=Diêm Vương Trịch Bút (Nộ Giảm tốc/ Cấm khinh công/ Đơ/ wuji: Võ kỹ)
									--: buf_CS_tm_jsc02=Thổ Tín 
									--: buf_CS_jh_llt02=Bản Đẳng (Lung Linh Đẩu)
									--: buf_CS_jh_llt03_1=Trường Tam Tiểu (Lung Linh Đẩu:  Phong chiêu + cấm KC)
									--: buf_CS_jh_llt03_2=Trường Tam Đại (Lung Linh Đẩu: Giảm tốc + chính xác)
									--: buf_CS_jh_tmby03_01=Faint Dư Âm Âm Ba (Nộ Đàn)
									--: buf_CS_jh_sfgp08=Long Du Đại Hải (Nộ Cờ)
									--: buf_CS_jh_sf08=Long Du Đại Hải (Nộ Cờ)
									--: buf_CS_gb_dgbf05=Áp Biển Cẩu Bối (Phá def trừ KC)
									--: buf_CS_gb_dgbf05_01=Áp Biển Cẩu Bối (Phá def cấm KC)
									--: buf_wuji_CS_gbzp_dgbf08=Thiên Hạ Vô Cẩu (Nộ DCB Võ Kỹ Cấm Nhảy)
									--: buf_CS_jh_chz03_02=Nhất Đạn Chỉ Khoảnh (Điểm huyệt Tham Hợp Chỉ)
									--: buf_CS_jh_tmjt06_range=Ma Khí Tung Hoành (Vòng ma tâm) -> Buff không giải được hiệu ứng trừ vòng
									--: buf_CS_jh_tmjt04=Ma Tình Mê Tung (Phá def ma tâm) -> Buff không giải được hiệu ứng -100% nội ngoại phòng
							
								--: CẤP 1+: Skill hiệu ứng mềm và cứng ngắn:
									--: buf_cantparry=Phá vỡ (Bể def) -> Buff không giải được hiệu ứng vỡ def
									--: buf_CantParry01=Phá vỡ -> Buff không giải được hiệu ứng vỡ def
									
								--: CẤP 2: Hiệu ứng Nội công: 
									--: buf_ng_jh_105_01 = Hàn Băng Chân Khí/ buf_ng_jh_105_02= Hàn Khí
									--: buf_ng_th_001_2=Triều Khởi (Bích Ba Tâm Kinh)
									--: buf_ng_th_001_1=Triều Thoái (Bích Ba Tâm Kinh)
									--: buf_ng_jh_307_01=Huyết Đao (Huyết Đao Kinh) -> Buff không giải được hiệu ứng
									--: buf_ng_kl_002_1=Kiều Dương Chân Khí (Kiêu Dương Quyết) -> Buff không giải được hiệu ứng
									
								--: CẤP 3: Trạng thái nhân vật: 
									--: locked = Xung phong -> Không check vì khi xung phong hoặc bị xung phong đều buff -> Mất skill khi đang ra
									--: be_hitout = Hất lên
									--: hitdown = Đánh Ngã
							
								-- Get state of object
								local role = game_visual:GetSceneObj(nx_string(game_scence_objs[i].Ident))
							
								-- Check buff xấu tốn tại trên người mục tiêu  
								if  get_buff_info("buf_CS_jh_xlsbz15_02", game_scence_objs[i]) 			or -- Lưu ý khi dùng hàm get_buff_info: Với chuỗi string truyền vào phải là CS viết hoa:
									get_buff_info("buf_CS_jh_xlsbz07", game_scence_objs[i]) 			or -- get_buff_info("buf_CS_xx", game_scence_objs[i]) thì mới hoạt động
									get_buff_info("buf_CS_by_xhmdl01_01", game_scence_objs[i])			or -- get_buff_info("buf_cs_xx", game_scence_objs[i]) sẽ không hoạt động
									get_buff_info("buf_cs_wd_tjq08", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_wdzp_tjq08", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_jh_lbwb01_01stun", game_scence_objs[i]) 		or
									get_buff_info("buf_CS_jh_yqq04", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_jy_xsd01_01", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_jy_tdshs05_1", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_jh_xfz02", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_yhwq_hsqs01", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_yh_hsqs01", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_jh_yydf03", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_jh_yydf07", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_jh_jgjf08_1", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_jh_jgjf05b_range", game_scence_objs[i]) 		or
									get_buff_info("buf_CS_jh_jgjf06b_range", game_scence_objs[i]) 		or
									get_buff_info("buf_CS_jh_jgjf09", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_jh_flxmz06_range", game_scence_objs[i]) 		or
									get_buff_info("buf_CS_jh_lybj06_02", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_jh_lybj06_01", game_scence_objs[i]) 			or
									get_buff_info("wuji_buf_CS_tm_ywt08_range", game_scence_objs[i]) 	or
									get_buff_info("wuji_buf_CS_tm_ywt07", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_tm_jsc02", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_jh_llt02", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_jh_llt03_1", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_jh_llt03_2", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_jh_tmby03_01", game_scence_objs[i]) 			or
									get_buff_info("buf_CS_jh_sfgp08", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_jh_sf08", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_gb_dgbf05", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_gb_dgbf05_01", game_scence_objs[i]) 			or
									get_buff_info("buf_wuji_CS_gbzp_dgbf08", game_scence_objs[i]) 		or
									get_buff_info("buf_CS_jh_tmjt06_range", game_scence_objs[i]) 		or
									get_buff_info("buf_CS_jh_tmjt04", game_scence_objs[i]) 				or
										
									get_buff_info("buf_cantparry", game_scence_objs[i]) 				or
									get_buff_info("buf_CantParry01", game_scence_objs[i]) 				or
									
									get_buff_info("buf_ng_jh_105_01", game_scence_objs[i]) 				or
									get_buff_info("buf_ng_th_001_2", game_scence_objs[i]) 				or
									get_buff_info("buf_ng_th_001_1", game_scence_objs[i]) 				or
									get_buff_info("buf_ng_jh_307_01", game_scence_objs[i]) 				or
									get_buff_info("buf_ng_kl_002_1", game_scence_objs[i]) 				or
									get_buff_info("buf_CS_jh_chz03_02", game_scence_objs[i]) 			or
									
									nx_string(role.state) == "hitdown" or nx_string(role.state) == "be_hitout" then
									
									-- Check name not select my self
									if name_myself ~= nx_widestr(name_player) then
										-- Chọn mục tiêu cần buff
										nx_execute('custom_sender', 'custom_select', game_scence_objs[i].Ident)
										
										local fight = nx_value("fight")
										-- Use skill buff PTC trạng thái buff (trạng thái tấn công: CS_jh_xfz02)
										fight:TraceUseSkill("CS_jh_xfz02_hide", false, false)
									end
									
									-- Target mục tiêu khác
									--if i > 1 then
										-- Delay để target
									--	nx_pause(4)
									--	nx_execute('custom_sender', 'custom_select', game_scence_objs[i - 1].Ident)
									--end
								end	
								--else

								local fight = nx_value("fight")
								
								-- Use skill attack object
								--fight:TraceUseSkill("CS_jh_xfz06", false, false)
								--nx_pause(0.2)
								--fight:TraceUseSkill("CS_jh_xfz01", false, false)
								
								if nx_is_valid(form) and form.chk_skill.Checked then
									
									-- Use khí chiêu và giá chiêu PTC
									fight:TraceUseSkill("CS_jh_xfz07", false, false)
									nx_pause(0.2)
									fight:TraceUseSkill("CS_jh_xfz03", false, false)
								end
								--nx_pause(0.2)
								--break
							--end
		
							end

							if dist_player > 20 then
								--yBreaker_show_Utf8Text("Cảnh báo! Cách " .. TablePlayerList[iplayer] .. " ".. nx_string(nx_int(dist_player)) .. " mét, đang di chuyển lại gần!")
								-- Di chuyển theo sau mục tiêu
								local map_query = nx_value("MapQuery")
								local city = map_query:GetCurrentScene()
								
								local posX = visualObj.PositionX + 5
								local posY = visualObj.PositionY 
								local posZ = visualObj.PositionZ 
								tools_move(city, posX, posY, posZ, direct_run)	
								direct_run = false
								break -- Dùng lệnh này để tránh object không tồn tại			
							end
						end
					end
				end						
			end	
		end
    end
end

--
function util_get_target_role_model()
  local game_client = nx_value("game_client")
  local game_visual = nx_value("game_visual")
  if nx_is_valid(game_visual) then
    local client_role = game_client:GetSceneObj(game_visual.PlayerIdent)
    if nx_is_valid(client_role) then
      local target_ident = client_role:QueryProp("LastObject")
      local vis_target = game_visual:GetSceneObj(nx_string(target_ident))
      return vis_target
    end
  end
  return nx_null()
end