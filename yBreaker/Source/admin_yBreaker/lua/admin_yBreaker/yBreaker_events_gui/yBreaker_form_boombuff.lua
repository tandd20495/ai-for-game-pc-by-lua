require("util_gui")
require("util_move") -- Xac dinh toa do distance3d
require("share\\chat_define")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")
require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

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
	form.chk_acceptreq.Checked = true
	form.chk_relive.Checked = true
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

function on_btn_start_click(btn)
	local form = btn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	
	UpdateStatus()
	while is_start do
		-- Tránh bị treo game trong vòng lặp (Nếu trong while do không có nx_pause(0.1) sẽ bị treo game)
		nx_pause(0.1)	
		
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
			-- Mode Boom
			if form.rbtn_buff.Checked then
				local game_scence_objs = game_scence:GetSceneObjList()
				local num_objs = table.getn(game_scence_objs)
			   
				for i = 1, num_objs do
					local obj_type = 0		
					if game_scence_objs[i]:FindProp("Type") then
						obj_type = game_scence_objs[i]:QueryProp("Type")
					end	
					
					-- Handle for Player checked
					if form.chk_player.Checked then 
						-- Type 2 là người chơi
						if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then
						
							local name_player = game_scence_objs[i]:QueryProp("Name")
							
							-- Kiểm tra đúng tên thì chọn mục tiêu
							if name_player == nx_widestr(form.edt_player_txt.Text) then
								-- Chọn mục tiêu
								nx_execute('custom_sender', 'custom_select', game_scence_objs[i].Ident)
								
								--Lấy khoảng cách từ nhân vật tới mục tiêu đang chọn
								local visualObj = game_visual:GetSceneObj(game_scence_objs[i].Ident)
								local dist_player = getDistanceWithObj({game_player.PositionX, game_player.PositionY, game_player.PositionZ}, visualObj)
								
								if form.chk_relive.Checked then
									-- Nếu bị chết thì trị thương lân cận
									local logicstate = player_client:QueryProp("LogicState")
									if logicstate == 120 then
										nx_execute("custom_sender", "custom_relive", 2, 0)
										nx_pause(7)
										break
									end
								end
							
								if dist_player <= 20 then
									--1. Get buff trên người xem đang cưỡi ngựa hay không? Có thì xuống ngựa
									if yBreaker_get_buff_id_info("buf_riding_01") ~= nil then
										nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
										nx_pause(0.2)
									end	
									
									--: Mê Nghiệt của HHMD: buf_CS_by_xhmdl01_01
									--: Cấm khinh công của DM: wuji_buf_CS_tm_ywt08_range (wuji: Võ kỹ)
									--: Mê của THBB : buf_CS_jh_lbwb01_01stun
									--: Mê của PTC: buf_CS_jh_xfz02
									--: Mê của UUSD: buf_CS_jh_yydf03
									--: Cấm KC UUSD: buf_CS_jh_yydf07
									--: Phá def THBB: buf_CS_jh_yydf07
									--: Trói của CYV: buf_CS_jy_xsd01_01
									--: Trói ném CYV: buf_CS_jy_tdshs05_1
									--: Mê của Rồng: buf_CS_jh_xlsbz15_02
									--: Lao tới Rồng: buf_CS_jh_xlsbz07
									--: Mê của Khai Cổ: buf_CS_wd_tjq08
									--: Mê của Khai thường: buf_CS_wdzp_tjq08
									--: Cấm Trịch Bút: wuji_buf_CS_tm_ywt07 (Võ kỹ)
									--: Thổ tín: buf_CS_tm_jsc02
									--: Bản đằng choáng: buf_CS_jh_llt02
									--: Trường tam: buf_CS_jh_llt03_2: Giảm tốc + chính xác / buf_CS_jh_llt03_1: Phong chiêu + cấm KC
									
									--yBreaker_show_Utf8Text("Trong phạm vi buff, đang check buff xấu trên người mục tiêu...")
									-- Check buff xấu tốn tại trên người mục tiêu  
									if  get_buff_info("buf_CS_by_xhmdl01_01", game_scence_objs[i]) 				or
										get_buff_info("wuji_buf_CS_tm_ywt08_range", game_scence_objs[i])		or
										get_buff_info("buf_CS_jh_lbwb01_01stun", game_scence_objs[i]) 			or
										get_buff_info("buf_CS_jh_xfz02", game_scence_objs[i]) 					or
										get_buff_info("buf_CS_jh_yydf03", game_scence_objs[i]) 					or
										get_buff_info("buf_CS_jh_yydf07", game_scence_objs[i]) 					or
										get_buff_info("buf_CS_jh_yqq04", game_scence_objs[i]) 					or
										get_buff_info("buf_CS_jy_xsd01_01", game_scence_objs[i]) 				or
										get_buff_info("buf_CS_wd_tjq08", game_scence_objs[i]) 					or
										get_buff_info("buf_CS_wdzp_tjq08", game_scence_objs[i]) 				or
										get_buff_info("buf_CS_jy_tdshs05_1", game_scence_objs[i]) 				or
										get_buff_info("buf_CS_jh_xlsbz15_02", game_scence_objs[i]) 				or
										get_buff_info("buf_CS_tm_jsc02", game_scence_objs[i]) 					or
										get_buff_info("buf_CS_jh_llt03_2", game_scence_objs[i]) 				or
										get_buff_info("buf_CS_jh_llt03_1", game_scence_objs[i]) 				or
										get_buff_info("buf_CS_jh_llt02", game_scence_objs[i]) 					or
										get_buff_info("wuji_buf_CS_tm_ywt07", game_scence_objs[i]) 				then
										
										local fight = nx_value("fight")
										--Use skill buff PTC trạng thái buff (trạng thái tấn công: CS_jh_xfz02)
										fight:TraceUseSkill("CS_jh_xfz02_hide", false, false)
									end
				
								else
									if form.chk_autorun.Checked then				
										yBreaker_show_Utf8Text("Ngoài phạm vi buff, đang di chuyển lại mục tiêu trong phạm vi 20m")
										-- Di chuyển đến khoảng cách trong tầm buff
										local map_query = nx_value("MapQuery")
										local city = map_query:GetCurrentScene()
										local posX = visualObj.PositionX - 10
										local posY = visualObj.PositionY - 10
										local posZ = visualObj.PositionZ - 10
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
		
			if form.rbtn_boom.Checked then
	
				local game_scence_objs = game_scence:GetSceneObjList()
				local num_objs = table.getn(game_scence_objs)
			   
				for i = 1, num_objs do

					local obj_type = 0
					if game_scence_objs[i] == nil then
						break
					end
					if game_scence_objs[i]:FindProp("Type") then
						obj_type = game_scence_objs[i]:QueryProp("Type")
						
						-- Type 2 là người chơi
						if obj_type == 2 and game_scence_objs[i]:QueryProp("OffLineState") == 0 then

							local name_player = game_scence_objs[i]:QueryProp("Name")
							
							-- Nếu đúng tên thì select
							if form.chk_player.Checked and name_player == nx_widestr(form.edt_player_txt.Text) then

								-- Tự vào PT theo tên người chơi đã điền
								if form.chk_acceptreq.Checked then
									local FORM_MAIN_REQUEST = "form_stage_main\\form_main\\form_main_request"
									local num_request = nx_execute(FORM_MAIN_REQUEST, "get_num_request")
									if num_request >= 1 then
										for i = num_request, 1, -1 do
											local request_type = nx_execute(FORM_MAIN_REQUEST, "get_request_type", i)
											local request_player = nx_execute(FORM_MAIN_REQUEST, "get_request_player", i)
											if request_type ~= nil and  request_player ~= nil then
												if request_type == REQUESTTYPE_INVITETEAM or request_type == REQUESTTYPE_TEAMREQUEST then
													nx_value("form_main_chat"):AddChatInfoEx(nx_widestr(request_type) .. nx_widestr(request_player) .. nx_widestr(" xin to doi"), CHATTYPE_SYSTEM, false)
													if nx_widestr(form.edt_player_txt.Text) == nx_widestr(request_player) then
														nx_execute("custom_sender", "custom_request_answer", request_type, request_player, 1)
														nx_execute(FORM_MAIN_REQUEST, "clear_special_request", request_type)
														break
													end
												end
											end
											nx_pause(0.3)
										end
									end
								end
							
								-- Object đang target
								if nx_string(player_client:QueryProp("LastObject")) ~= nx_string(game_scence_objs[i].Ident) then
									
									--Lấy khoảng cách từ nhân vật tới mục tiêu đang chọn
									local visualObj = game_visual:GetSceneObj(game_scence_objs[i].Ident)
									
									local dist_player = getDistanceWithObj({game_player.PositionX, game_player.PositionY, game_player.PositionZ}, visualObj)
									
									if form.chk_relive.Checked then
										-- Nếu bị chết thì trị thương lân cận
										local logicstate = player_client:QueryProp("LogicState")
										if logicstate == 120 then
											nx_execute("custom_sender", "custom_relive", 2, 0)
											nx_pause(7)
											break
										end
									end
									
									if dist_player < 20 then
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
									else
										if form.chk_autorun.Checked then
											-- Di chuyển đến khoảng cách trong tầm buff
											local map_query = nx_value("MapQuery")
											local city = map_query:GetCurrentScene()
											local posX = visualObj.PositionX
											local posY = visualObj.PositionY
											local posZ = visualObj.PositionZ
											tools_move(city, posX, posY, posZ, direct_run)	
											direct_run = false
											
											break -- Dùng lệnh này để tránh object không tồn tại
										end
									end
								end
							else
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
				yBreaker_show_Utf8Text("Chỉ hỗ trợ buff mục tiêu trong phạm vi 50m")
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
				yBreaker_show_Utf8Text("Chỉ hỗ trợ ném boom vào các mục tiêu tìm được trong phạm vi 50m")
			end
			
			form.btn_start.Text = nx_function("ext_utf8_to_widestr", "Dừng")
			form.btn_start.ForeColor = "255,220,20,60"
		    is_start = true
		end
	end
end
