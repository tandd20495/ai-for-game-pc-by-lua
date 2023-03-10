require('auto_new\\autocack')

local THIS_FORM = "auto_new\\form_auto_qvcd"
local pos =
{
	{-76.750, 112.150, -114.750},
	{-21.750, 146.644, 65.250},
	{-162.750, 219.145, 168.250},
	{-135.582,117.371,-51.731},
	{-173.997,221.838,218.063},
	{-198.640,221.936,219.574},
	{-46.134,223.082,231.353},
	{113.823,107.132,-96.076},
	{132.263,112.117,-56.167}
}
local curpos = 1
local start_x, start_y, start_z = 0, 0, 0
function DoQVCD(cbtn)
if nx_execute('auto_new\\autocack','getAutoByNockasdd_Cack') then
	local form = cbtn.ParentForm
	form.check = os.time()
	UpdateStatus()
	while form.auto_start do
		nx_pause(0.1)
		local game_client=nx_value("game_client")
		local game_visual=nx_value("game_visual")		
		if nx_is_valid(game_client) and nx_is_valid(game_visual) then 
			local player_client=game_client:GetPlayer()
			local game_player=game_visual:GetPlayer()
			local game_scence=game_client:GetScene()
			if nx_is_valid(player_client) and nx_is_valid(game_player) and nx_is_valid(game_scence) then 
				local formtalk = nx_value("form_stage_main\\form_talk_movie")
				local fight = nx_value("fight")
				local goods_grid = nx_value("GoodsGrid")
				if player_client:FindProp("Dead") then
					nx_value("game_visual"):CustomSend(nx_int(290), nx_int(2), 0, "")
				end	
				--Kểm Tra kẹt lag:			
				if os.difftime(os.time(), form.check) >= 15 then
					if CheckSkill("CS_jh_tmjt06") then
						if nx_function("find_buffer", player_client, "buf_riding_01") then
							nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01")
						elseif nx_function("find_buffer", player_client, "buf_riding_01_diao") then
							nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01_diao")
						else
							if not IsBusy() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
								nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
							end
						end
					else
						if nx_function("find_buffer", player_client, "buf_riding_01") then
							nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01")
						elseif nx_function("find_buffer", player_client, "buf_riding_01_diao") then
							nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01_diao")
						else
							nx_value("fight"):TraceUseSkill("zs_suicide", false, false)
						end
					end
				else
					if os.difftime(os.time(), form.check) >= 2 and os.difftime(os.time(), form.check) <= 4 then
						if nx_function("find_buffer", player_client, "buf_riding_01") then
							nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01")
						elseif nx_function("find_buffer", player_client, "buf_riding_01_diao") then
							nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01_diao")
						else
							if nx_function("find_buffer", player_client, "buf_offline_abduct_fail") then
							else
								game_visual:SwitchPlayerState(game_player, "jump", 5)
							end
						end
					end
				end
				nx_value("game_visual"):CustomSend(nx_int(380), 1)
				nx_value("game_visual"):CustomSend(nx_int(380), 2)
				nx_value("game_visual"):CustomSend(nx_int(380), 3)
				nx_value("game_visual"):CustomSend(nx_int(380), 4)	
				if form.check_time == 0 or os.difftime(os.time(), form.check_time) >= 50 then
					form.check_time = os.time()
					local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<font color=\"#5FD00B\">{@1:text}</font> {@0:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Auto tự fam lịch luyện đang chạy!")))
					nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
				end
				if form.step == 1 then
					if form.cbtn_q1.Checked then
						-- Học tiếng Đông Doanh:
						nx_pause(0.5)
						if CheckNPC("npc_wjd_cm_01") ~= nil then
							form.check = os.time()
							while not formtalk.Visible do
								nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_cm_01").Ident)
								nx_pause(0.5)
							end
							local menu = formtalk.mltbox_menu
							local menu_num = menu.ItemCount
							if formtalk.Visible and menu.Visible then
								if nx_int(menu_num) > nx_int(0) then
									for k = 0, menu_num - 1 do
										local form_main_chat_logic = nx_value("form_main_chat")
										local form_aswer = menu:GetItemTextNoHtml(k)
										form_aswer = form_main_chat_logic:DeleteHtml(form_aswer)
										local form_a_check = util_text("talk_wjd_cm01_07")--Học tiếng Đông Doanh
										local form_a_check1 = util_text("talk_wjd_cm01_02")--Học tiếng Đông Doanh
										if 	nx_function("ext_ws_find", form_aswer, form_a_check1) ~= -1 then
											nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201)--Học tiếng Đông Doanh
											nx_pause(0.2)
											nx_execute("form_stage_main\\form_talk_movie", "menu_select", 20101)--Đã hiểu, hãy bắt đầu đi				
											nx_pause(0.2)
										end
										if nx_function("ext_ws_find", form_aswer, form_a_check) ~= -1  then
											nx_execute("form_stage_main\\form_talk_movie", "menu_select", 202)--Học tiếng Đông Doanh
											nx_pause(0.2)
											nx_execute("form_stage_main\\form_talk_movie", "menu_select", 20201)--Đã hiểu, hãy bắt đầu đi
											nx_pause(0.2)
											nx_execute("form_stage_main\\form_talk_movie", "menu_select", 2020101)--Học tiếng Đông Doanh
											nx_pause(0.2)
											nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Quá khen rồi, đều là nhờ trưởng thôn dạy giỏi
											form.step = 2
											break
										else
											nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Để ta suy nghĩ lại một chút!
										end
									end
								end
							end										
						else
							if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
								
							else
								form.check = os.time()
							end
							start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
							if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
								nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_cm_01")
							end
							if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
								if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
								end
								local form_bag = nx_value("form_stage_main\\form_bag")
								if nx_is_valid(form_bag) then
									form_bag.rbtn_tool.Checked = true
								end
								nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
							end
						end
					else
						form.step = 2
					end
				end
				if form.step == 2 then
					if form.cbtn_q2.Checked then
						-- Trêu chọc thôn dân:
						nx_pause(0.5)
						if not IsBusy() and nx_execute("util_move","distance3d", pos[9][1], pos[9][2], pos[9][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
							if CheckNPC("npc_wjd_cm_02a") ~= nil then
								form.check = os.time()
								while not formtalk.Visible do
									nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_cm_02a").Ident)
									nx_pause(0.5)
								end
								--local menu = formtalk.mltbox_menu
								--local menu_num = menu.ItemCount
								--if formtalk.Visible and menu.Visible then
									--if nx_int(menu_num) > nx_int(0) then
										--for k = 0, menu_num - 1 do
											--local form_main_chat_logic = nx_value("form_main_chat")
											--local form_aswer = menu:GetItemTextNoHtml(k)
											--form_aswer = form_main_chat_logic:DeleteHtml(form_aswer)
											--local form_a_check = util_text("talk_wjd_zhapian")--Xem ra người này khá ngốc, ta trêu chọc hắn ta một chút
											--if nx_function("ext_ws_find", form_aswer, form_a_check) ~= -1 then
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 216)--Xem ra người này khá ngốc, ta trêu chọc hắn ta một chút
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 21601)--Học tiếng Đông Doanh
												form.step = 3
												--break
											--else
												--nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Để ta suy nghĩ lại một chút!
											--end
										--end
									--end
								--end				
							end
						else
							if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
							
							else
								form.check = os.time()
							end
							start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
							if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
								nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[9][1]..","..pos[9][2]..","..pos[9][3])
							end
							if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
								if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
								end
								local form_bag = nx_value("form_stage_main\\form_bag")
								if nx_is_valid(form_bag) then
									form_bag.rbtn_tool.Checked = true
								end
								nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
							end
						end
					else
						form.step = 3
					end
				end
				if form.step == 3 then
					if form.cbtn_q3.Checked then
						--Do thám Đông Doanh
						nx_pause(0.5)
						if goods_grid:GetItemCount("item_wjd_11_01") > 0 then
							if goods_grid:GetItemCount("item_wjd_11_02") > 0 then
								if CheckNPC("npc_wjd_cm_06") ~= nil then
									form.check = os.time()
									while not formtalk.Visible do
										nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_cm_06").Ident)
										nx_pause(0.1)
									end
									nx_execute("form_stage_main\\form_talk_movie", "menu_select", 1000)--Đều là nhờ đại nhân biết cách hướng dẫn
									form.step = 4
									form.step1 = 1
								else
									if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
									
									else
										form.check = os.time()
									end
									start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ							
									if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_cm_06")
									end
									if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
										if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
										end
										local form_bag = nx_value("form_stage_main\\form_bag")
										if nx_is_valid(form_bag) then
											form_bag.rbtn_tool.Checked = true
										end
										nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
									end
								end
							else
								if not IsBusy() and nx_execute("util_move","distance3d", pos[curpos][1], pos[curpos][2], pos[curpos][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
									form.check = os.time()
									nx_pause(0.5)
									curpos = curpos + 1
									if curpos > 3 then
										curpos = 1
									end
								else
									if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
									
									else
										form.check = os.time()
									end
									start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ							
									if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[curpos][1]..","..pos[curpos][2]..","..pos[curpos][3])
									end
									if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
										if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
										end
										local form_bag = nx_value("form_stage_main\\form_bag")
										if nx_is_valid(form_bag) then
											form_bag.rbtn_tool.Checked = true
										end
										nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
									end
								end
							end
						else
							if CheckNPC("npc_wjd_cm_06") ~= nil then
								form.check = os.time()
								while not formtalk.Visible do
									nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_cm_06").Ident)
									nx_pause(0.5)
								end
								local menu = formtalk.mltbox_menu
								local menu_num = menu.ItemCount
								if formtalk.Visible and menu.Visible then
									if nx_int(menu_num) > nx_int(0) then
										for k = 0, menu_num - 1 do
											local form_main_chat_logic = nx_value("form_main_chat")
											local form_aswer = menu:GetItemTextNoHtml(k)
											form_aswer = form_main_chat_logic:DeleteHtml(form_aswer)
											local form_a_check = util_text("talk_wjd_cm06_02")--Do thám khu vực người Oa chiếm lĩnh
											if nx_function("ext_ws_find", form_aswer, form_a_check) ~= -1 then
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 211)--Do thám khu vực người Oa chiếm lĩnh
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 21101)--Giao cho ta đi, ta sẽ hoàn thành
												break
											else
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Để ta suy nghĩ lại một chút!
											end
										end
									end
								end							
							else
								if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
								
								else
									form.check = os.time()
								end
								start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
								if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_cm_06")
								end
								if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
									if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
									end
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_tool.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
								end
							end
						end	
					else
						form.step = 4
						form.step1 = 1
					end
				end
				if form.step == 4 then
					if form.cbtn_q4.Checked then
						--Thu thập đất sét(Trà Đạo):
						nx_pause(0.5)
						if form.step1 == 1 then
							if CheckNPC("npc_wjd_dy_01") ~= nil then
								form.check = os.time()
								while not formtalk.Visible do
									nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_dy_01").Ident)
									nx_pause(0.5)
								end
								local menu = formtalk.mltbox_menu
								local menu_num = menu.ItemCount
								if formtalk.Visible and menu.Visible then
									if nx_int(menu_num) > nx_int(0) then
										for k = 0, menu_num - 1 do
											local form_main_chat_logic = nx_value("form_main_chat")
											local form_aswer = menu:GetItemTextNoHtml(k)
											form_aswer = form_main_chat_logic:DeleteHtml(form_aswer)
											local form_a_check = util_text("talk_wjd_ls05_06")--Thu thập đất sét
											if nx_function("ext_ws_find", form_aswer, form_a_check) ~= -1 then
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 202)--Thu thập đất sét
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 20201)--Ta đi đâu lấy đất sét đây
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 2020101)--Ta hiểu rồi, ta đi rồi sẽ về
												form.step1 = 2
												break
											else
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Để ta suy nghĩ lại một chút!
											end
										end
									end
								end								
							else
								if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
								
								else
									form.check = os.time()
								end
								start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
								if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_dy_01")
								end
								if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
									if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
									end
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_tool.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
								end
							end
						end
						if form.step1 == 2 then
							nx_pause(0.5)
							if goods_grid:GetItemCount("item_wjd_04") > 0 then
								if CheckNPC("npc_wjd_dy_01") ~= nil then
									form.check = os.time()
									while not formtalk.Visible do
										nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_dy_01").Ident)
										nx_pause(0.1)
									end
									nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201)--Nhất đinh ta sẽ làm được!
									form.step = 5
									form.step1 = 3
								else
									if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
									
									else
										form.check = os.time()
									end
									start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ							
									if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_dy_01")
									end
									if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
										if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
										end
										local form_bag = nx_value("form_stage_main\\form_bag")
										if nx_is_valid(form_bag) then
											form_bag.rbtn_tool.Checked = true
										end
										nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
									end
								end
							else
								if goods_grid:GetItemCount("item_wjd_01") > 0 then
									if CheckNPC("itemnpc_wjd_04") ~= nil then
										form.check = os.time()
										if not string.find(player_client:QueryProp("State"), "offact") then
											nx_execute("custom_sender", "custom_select", CheckNPC("itemnpc_wjd_04").Ident)
										end
									else
										if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
										
										else
											form.check = os.time()
										end
										start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ								
										if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."itemnpc_wjd_04")
										end
										if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
											if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
												nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
											end
											local form_bag = nx_value("form_stage_main\\form_bag")
											if nx_is_valid(form_bag) then
												form_bag.rbtn_tool.Checked = true
											end
											nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
										end
									end
								else
									if CheckNPC("npc_wjd_cm_02a") ~= nil then
										form.check = os.time()
										if formtalk.Visible then
											nx_pause(0.1)
											nx_execute("form_stage_main\\form_talk_movie", "menu_select", 202)--Ta muốn mượn một ít công cụ
											nx_pause(0.1)
											nx_execute("form_stage_main\\form_talk_movie", "menu_select", 20201)--Ta mượn Thuổng Sắt
										else
											nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_cm_02a").Ident)
										end
									else
										if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
										
										else
											form.check = os.time()
										end
										start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ								
										if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_cm_02a")
										end
										if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
											if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
												nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
											end
											local form_bag = nx_value("form_stage_main\\form_bag")
											if nx_is_valid(form_bag) then
												form_bag.rbtn_tool.Checked = true
											end
											nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
										end
									end
								end
							end
						end
					else
						form.step = 5
					end
				end
				if form.step == 5 then
					if form.cbtn_q5.Checked then
						-- Chế tác trà cụ
						nx_pause(0.5)
						if goods_grid:GetItemCount("item_wjd_04") > 0 then
							if CheckNPC("npc_wjd_dy_01") ~= nil then
								form.check = os.time()
								while not formtalk.Visible do
									nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_dy_01").Ident)
									nx_pause(0.1)
								end
								nx_pause(0.1)
								nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201)--Ta muốn mượn một ít công cụ
								nx_pause(0.1)
								nx_execute("form_stage_main\\form_talk_movie", "menu_select", 20101)--Ta mượn Thuổng Sắt
								form.step = 6
							else
								if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
								
								else
									form.check = os.time()
								end
								start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ							
								if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_dy_01")
								end
								if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
									if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
									end
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_tool.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
								end
							end
						else
							if goods_grid:GetItemCount("item_wjd_01") > 0 then
								if CheckNPC("itemnpc_wjd_04") ~= nil then
									form.check = os.time()
									if not string.find(player_client:QueryProp("State"), "offact") then
										nx_execute("custom_sender", "custom_select", CheckNPC("itemnpc_wjd_04").Ident)
									end
								else
									if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
									
									else
										form.check = os.time()
									end
									start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ								
									if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."itemnpc_wjd_04")
									end
									if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
										if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
										end
										local form_bag = nx_value("form_stage_main\\form_bag")
										if nx_is_valid(form_bag) then
											form_bag.rbtn_tool.Checked = true
										end
										nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
									end
								end
							else
								if CheckNPC("npc_wjd_cm_02a") ~= nil then
									form.check = os.time()
									if formtalk.Visible then
										nx_pause(0.1)
										nx_execute("form_stage_main\\form_talk_movie", "menu_select", 202)--Ta muốn mượn một ít công cụ
										nx_pause(0.1)
										nx_execute("form_stage_main\\form_talk_movie", "menu_select", 20201)--Ta mượn Thuổng Sắt
									else
										nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_cm_02a").Ident)
									end
								else
									if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
									
									else
										form.check = os.time()
									end
									start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ								
									if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_cm_02a")
									end
									if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
										if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
										end
										local form_bag = nx_value("form_stage_main\\form_bag")
										if nx_is_valid(form_bag) then
											form_bag.rbtn_tool.Checked = true
										end
										nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
									end
								end
							end
						end
					else
						form.step = 6
					end
				end
				if form.step == 6 then
					if form.cbtn_q6.Checked then
						-- Tâng bốc 
						nx_pause(0.5)
						if not IsBusy() and nx_execute("util_move","distance3d", pos[4][1], pos[4][2], pos[4][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
							if CheckNPC("npc_wjd_dm_08a") ~= nil then
								form.check = os.time()
								while not formtalk.Visible do
									nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_dm_08a").Ident)							
									nx_pause(0.5)
								end	
								--local menu = formtalk.mltbox_menu
								--local menu_num = menu.ItemCount
								--if formtalk.Visible and menu.Visible then
									--if nx_int(menu_num) > nx_int(0) then
										--for k = 0, menu_num - 1 do
											--local form_main_chat_logic = nx_value("form_main_chat")
											--local form_aswer = menu:GetItemTextNoHtml(k)
											--form_aswer = form_main_chat_logic:DeleteHtml(form_aswer)
											--local form_a_check = util_text("talk_wjd_chuipeng")--Ta tâng bốc để hắn hớn hở một chút
											--if nx_function("ext_ws_find", form_aswer, form_a_check) ~= -1 then
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 215)--Ta tâng bốc để hắn hớn hở một chút
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 21501)--
												form.step = 7
												form.step2 = 1
												--break
											--else
												--nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Để ta suy nghĩ lại một chút!
											--end
										--end
									--end
								--end							
							end
						else
							if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
							
							else
								form.check = os.time()
							end
							start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
							if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
								nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[4][1]..","..pos[4][2]..","..pos[4][3])
							end
							if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
								if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
								end
								local form_bag = nx_value("form_stage_main\\form_bag")
								if nx_is_valid(form_bag) then
									form_bag.rbtn_tool.Checked = true
								end
								nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
							end
						end
					else
						form.step = 7
						form.step2 = 1
					end
				end
				if form.step == 7 then
					if form.cbtn_q7.Checked then
						-- So tài 
						nx_pause(0.5)
						if form.step2 == 1 then
							nx_pause(0.5)
							if not IsBusy() and nx_execute("util_move","distance3d", pos[4][1], pos[4][2], pos[4][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
								form.check = os.time()
								nx_pause(0.1)
								form.step2 = 2
							else
								if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
								
								else
									form.check = os.time()
								end
								start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
								if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[4][1]..","..pos[4][2]..","..pos[4][3])
								end
								if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
									if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
									end
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_tool.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
								end
							end
						end				
						if form.step2 == 2 then
							form.check = os.time()
							nx_pause(0.5)
							if nx_function("find_buffer", player_client, "buf_riding_01") then
								nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01")
							elseif nx_function("find_buffer", player_client, "buf_riding_01_diao") then
								nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01_diao")
							end
							if player_client:QueryProp("HPRatio") < 100 and player_client:QueryProp("LogicState") ~= 102 then -- tự ngồi thiền hồi máu mỗi khi xong
								local fight = nx_value("fight")
								nx_value("fight"):TraceUseSkill("zs_default_01", false, false)
							else
								if player_client:QueryProp("MPRatio") < 100 and player_client:QueryProp("LogicState") ~= 102 then
									local fight = nx_value("fight")
									nx_value("fight"):TraceUseSkill("zs_default_01", false, false)
								else
									if player_client:QueryProp("HPRatio") == 100 and player_client:QueryProp("MPRatio") == 100 then
										if player_client:FindProp("LogicState") and player_client:QueryProp("LogicState") == 102 then -- đầy máu rồi thì ngồi làm méo gì nữa ? =))
											local fight = nx_value("fight")
											nx_value("fight"):TraceUseSkill("zs_default_01", false, false)
										end
										local npc_check =  CheckNPC("npc_wjd_dm_08a")
										if npc_check ~= nil then  
											while not formtalk.Visible do												
												nx_execute("custom_sender", "custom_select", npc_check.Ident)							
												nx_pause(0.5)
											end
										end
										local menu = formtalk.mltbox_menu
										local menu_num = menu.ItemCount
										if formtalk.Visible and menu.Visible then
											if nx_int(menu_num) > nx_int(0) then
												for k = 0, menu_num - 1 do
													local form_main_chat_logic = nx_value("form_main_chat")
													local form_aswer = menu:GetItemTextNoHtml(k)
													form_aswer = form_main_chat_logic:DeleteHtml(form_aswer)
													local form_a_check = util_text("talk_wjd_qiecuo")--Tại hạ say mê võ học, hôm nay muốn cùng các hạ so tài để kiểm tra những gì đã học được
													if nx_function("ext_ws_find", form_aswer, form_a_check) ~= -1 then
														nx_execute("form_stage_main\\form_talk_movie", "menu_select", 100)--Tại hạ say mê võ học, hôm nay muốn cùng các hạ so tài để kiểm tra những gì đã học được
														form.step2 = 3
														break
													else
														nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Để ta suy nghĩ lại một chút!
													end
												end
											end
										end
									end
								end
							end
						end
						if form.step2 == 3 then
							nx_pause(0.5)
							if nx_function("find_buffer", player_client, "buf_riding_01") then
								nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01")
							elseif nx_function("find_buffer", player_client, "buf_riding_01_diao") then
								nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01_diao")
							end
							if CheckNPC2("npc_wjd_dm_08a") ~= nil then
								form.check = os.time()
								local fight = nx_value("fight")
								local selectobj = nx_value(GAME_SELECT_OBJECT)						
								if not nx_is_valid(selectobj) then
									nx_value("fight"):SelectTarget(game_visual:GetSceneObj(CheckNPC2("npc_wjd_dm_08a").Ident))
								else
									local vis_object = game_visual:GetSceneObj(selectobj.Ident)
									if nx_execute("util_move","distance3d", vis_object.PositionX, vis_object.PositionY, vis_object.PositionZ, game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 3 then
										if nx_value("fight"):CanAttackNpc(player_client, CheckNPC2("npc_wjd_dm_08a")) then
											nx_value("fight"):SelectTarget(game_visual:GetSceneObj(CheckNPC2("npc_wjd_dm_08a").Ident))
											local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
											local grid = form_shortcut.grid_shortcut_main
											local game_shortcut = nx_value("GameShortcut")
											if nx_is_valid(game_shortcut) then
												if nx_function("find_buffer", player_client, "buf_riding_01") then
													nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01")
												elseif nx_function("find_buffer", player_client, "buf_riding_01_diao") then
													nx_value("game_visual"):CustomSend(nx_int(1021), "buf_riding_01_diao")
												end
												if player_client:QueryProp("SP") >= 50 then
													game_shortcut:on_main_shortcut_useitem(grid, 8, true) -- nộ chiêu
												end
												for k = 0, 7 do
													game_shortcut:on_main_shortcut_useitem(grid, k, true)
												end
											end								
										else
											if formtalk.Visible then
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201)--Ta cũng mong như vậy, tạm biệt
												form.step2 = 4
												form.step = 8										
											else
												nx_value("fight"):SelectTarget(game_visual:GetSceneObj(CheckNPC2("npc_wjd_dm_08a").Ident))
											end
										end
									else
										if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
										
										else
											form.check = os.time()
										end
										start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ
										if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_execute("hyperlink_manager","find_path_npc_item","findpath,"..game_scence:QueryProp("Resource")..","..vis_object.PositionX..","..vis_object.PositionZ)
										end
										if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
											if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
												nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
											end
											local form_bag = nx_value("form_stage_main\\form_bag")
											if nx_is_valid(form_bag) then
												form_bag.rbtn_tool.Checked = true
											end
											nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
										end
									end
								end
							end
						end
					else
						form.step = 8
					end
				end
				if form.step == 8 then
					if form.cbtn_q8.Checked or form.cbtn_q9.Checked then
						nx_pause(0.5)
						if CheckNPC("npc_wjd_dm_04") ~= nil then
							form.check = os.time()
							while not formtalk.Visible do
								nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_dm_04").Ident)
								nx_pause(0.1)
							end
							local menu = formtalk.mltbox_menu
							local menu_num = menu.ItemCount
							if formtalk.Visible and menu.Visible then
								if nx_int(menu_num) > nx_int(0) then
									for k = 0, menu_num - 1 do
										local form_main_chat_logic = nx_value("form_main_chat")
										local form_aswer = menu:GetItemTextNoHtml(k)
										form_aswer = form_main_chat_logic:DeleteHtml(form_aswer)
										local form_a_check = util_text("talk_wjd_dm04_10")
										local form_a_check1 = util_text("talk_wjd_dm04_11")
										if nx_function("ext_ws_find", form_aswer, form_a_check) ~= -1 then
											form.step = 9
											form.step3 = 1
											break
										else
											if nx_function("ext_ws_find", form_aswer, form_a_check1) ~= -1 then
												form.step = 10
												form.step4 = 1
												break
											else
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Do thám khu vực người Oa chiếm lĩnh
												form.step = 11
												form.step5 = 1
											end
										end
									end
								end
							end
						else
							if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
							
							else
								form.check = os.time()
							end
							start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
							if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
								nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_dm_04")
							end
							if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
								if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
								end
								local form_bag = nx_value("form_stage_main\\form_bag")
								if nx_is_valid(form_bag) then
									form_bag.rbtn_tool.Checked = true
								end
								nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
							end
						end
					else
						form.step = 11
					end
				end
				if form.step == 9 then
					--Trưng Thu Lương Thực
					nx_pause(0.5)
					if goods_grid:GetItemCount("item_wjd_01_01") > 0 then
						if goods_grid:GetItemCount("item_wjd_01_02") > 0 then
							if CheckNPC("npc_wjd_dm_04") ~= nil then
								form.check = os.time()
								while not formtalk.Visible do
									nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_dm_04").Ident)
									nx_pause(0.1)
								end
								nx_execute("form_stage_main\\form_talk_movie", "menu_select", 101)--Do thám khu vực người Oa chiếm lĩnh
								form.step = 8
							else
								if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
								
								else
									form.check = os.time()
								end
								start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ							
								if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_dm_04")
								end
								if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
									if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
									end
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_tool.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
								end
							end
						else
							if form.step3 == 1 then
								nx_pause(0.5)
								if not IsBusy() and nx_execute("util_move","distance3d", pos[8][1], pos[8][2], pos[8][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
									form.check = os.time()
									nx_pause(0.1)
									form.step3 = 2
								else
									if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
									
									else
										form.check = os.time()
									end
									start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
									if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[8][1]..","..pos[8][2]..","..pos[8][3])
									end
									if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
										if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
										end
										local form_bag = nx_value("form_stage_main\\form_bag")
										if nx_is_valid(form_bag) then
											form_bag.rbtn_tool.Checked = true
										end
										nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
									end
								end
							end				
							if form.step3 == 2 then
								form.check = os.time()
								nx_pause(0.5)
								while not formtalk.Visible do
									nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_cm_02d").Ident)							
									nx_pause(0.5)
								end
								nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201)--Tại hạ say mê võ học, hôm nay muốn cùng các hạ so tài để kiểm tra những gì đã học được
								form.step3 = 3
							end
						end
					else
						if CheckNPC("npc_wjd_dm_04") ~= nil then
							form.check = os.time()
							while not formtalk.Visible do
								nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_dm_04").Ident)
								nx_pause(0.1)
							end
							nx_pause(0.1)
							nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201)--Do thám khu vực người Oa chiếm lĩnh
							nx_pause(0.1)
							nx_execute("form_stage_main\\form_talk_movie", "menu_select", 20101)--Giao cho ta đi, ta sẽ hoàn thành
							nx_pause(0.1)
							nx_execute("form_stage_main\\form_talk_movie", "menu_select", 2010101)--Giao cho ta đi, ta sẽ hoàn thành
						else
							if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
							
							else
								form.check = os.time()
							end
							start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
							if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
								nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_dm_04")
							end
							if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
								if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
								end
								local form_bag = nx_value("form_stage_main\\form_bag")
								if nx_is_valid(form_bag) then
									form_bag.rbtn_tool.Checked = true
								end
								nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
							end
						end
					end	
				end
				if form.step == 10 then
					--Bảo Dưỡng Binh Khí
					nx_pause(0.5)
					if form.step4 == 1 then
						if CheckNPC("npc_wjd_dm_04") ~= nil then
							form.check = os.time()
							while not formtalk.Visible do
								nx_execute("custom_sender", "custom_select", CheckNPC2("npc_wjd_dm_04").Ident)
								nx_pause(0.1)
							end
							nx_pause(0.1)
							nx_execute("form_stage_main\\form_talk_movie", "menu_select", 202)--Do thám khu vực người Oa chiếm lĩnh
							nx_pause(0.1)
							nx_execute("form_stage_main\\form_talk_movie", "menu_select", 20201)--Giao cho ta đi, ta sẽ hoàn thành
							form.step4 = 2
						else
							if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
							
							else
								form.check = os.time()
							end
							start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
							if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
								nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_dm_04")
							end
							if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
								if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
								end
								local form_bag = nx_value("form_stage_main\\form_bag")
								if nx_is_valid(form_bag) then
									form_bag.rbtn_tool.Checked = true
								end
								nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
							end
						end
					end
					if form.step4 == 2 then
						if goods_grid:GetItemCount("item_wjd_xx_001") > 0 then
							form.step4 = 3
						else
							if not IsBusy() and nx_execute("util_move","distance3d", pos[5][1], pos[5][2], pos[5][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
								if CheckNPC("npc_wjd_xx_001") ~= nil then
									form.check = os.time()
									while not formtalk.Visible do
										nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_xx_001").Ident)							
										nx_pause(0.1)
									end					
									nx_execute("form_stage_main\\form_talk_movie", "menu_select", 2000)--Do thám khu vực người Oa chiếm lĩnh
								end
							else
								if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
								
								else
									form.check = os.time()
								end
								start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
								if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[5][1]..","..pos[5][2]..","..pos[5][3])
								end
								if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
									if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
									end
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_tool.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
								end
							end
						end
					end
					if form.step4 == 3 then
						if goods_grid:GetItemCount("item_wjd_xx_002") > 0 then
							if not IsBusy() and nx_execute("util_move","distance3d", pos[5][1], pos[5][2], pos[5][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
								if CheckNPC("npc_wjd_xx_001") ~= nil then
									form.check = os.time()
									while not formtalk.Visible do
										nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_xx_001").Ident)							
										nx_pause(0.1)
									end					
									nx_execute("form_stage_main\\form_talk_movie", "menu_select", 1000)--Do thám khu vực người Oa chiếm lĩnh
									form.step4 = 4
								end
							else
								if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
								
								else
									form.check = os.time()
								end
								start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
								if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[5][1]..","..pos[5][2]..","..pos[5][3])
								end
								if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
									if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
									end
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_tool.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
								end
							end						
						else
							if not IsBusy() and nx_execute("util_move","distance3d", pos[6][1], pos[6][2], pos[6][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
								if CheckNPC("npc_wjd_xx_002") ~= nil then
									form.check = os.time()
									while not formtalk.Visible do
										nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_xx_002").Ident)							
										nx_pause(0.1)
									end					
									nx_execute("form_stage_main\\form_talk_movie", "menu_select", 3000)--Do thám khu vực người Oa chiếm lĩnh
								end
							else
								if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
								
								else
									form.check = os.time()
								end
								start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
								if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[6][1]..","..pos[6][2]..","..pos[6][3])
								end
								if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
									if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
									end
									local form_bag = nx_value("form_stage_main\\form_bag")
									if nx_is_valid(form_bag) then
										form_bag.rbtn_tool.Checked = true
									end
									nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
								end
							end						
						end
					end
					if form.step4 == 4 then
						if CheckNPC("npc_wjd_dm_04") ~= nil then
							form.check = os.time()
							while not formtalk.Visible do
								nx_execute("custom_sender", "custom_select", CheckNPC("npc_wjd_dm_04").Ident)
								nx_pause(0.1)
							end
							nx_pause(0.1)
							nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201)--Do thám khu vực người Oa chiếm lĩnh
							nx_pause(0.1)
							nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Do thám khu vực người Oa chiếm lĩnh
							form.step = 8
							form.step4 = 5
						else
							if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
							
							else
								form.check = os.time()
							end
							start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
							if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
								nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_dm_04")
							end
							if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
								if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
									nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
								end
								local form_bag = nx_value("form_stage_main\\form_bag")
								if nx_is_valid(form_bag) then
									form_bag.rbtn_tool.Checked = true
								end
								nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
							end
						end
					end
				end
				if form.step == 11 then
					if form.cbtn_q10.Checked then
						--Thăm Dò Bắc Loan Thôn
						nx_pause(0.5)
						if form.step5 == 1 then
							if CheckNPC("npc_wjd_rz_03") ~= nil then
								form.check = os.time()
								while not formtalk.Visible do
									nx_execute("custom_sender", "custom_select", CheckNPC2("npc_wjd_rz_03").Ident)
									nx_pause(0.5)
								end
								local menu = formtalk.mltbox_menu
								local menu_num = menu.ItemCount
								if formtalk.Visible and menu.Visible then
									if nx_int(menu_num) > nx_int(0) then
										for k = 0, menu_num - 1 do
											local form_main_chat_logic = nx_value("form_main_chat")
											local form_aswer = menu:GetItemTextNoHtml(k)
											form_aswer = form_main_chat_logic:DeleteHtml(form_aswer)
											local form_a_check = util_text("talk_wjd_rz03_08")--Thăm Dò Bắc Loan Thôn
											if nx_function("ext_ws_find", form_aswer, form_a_check) ~= -1 then
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201)--Thăm Dò Bắc Loan Thôn
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 20101)--Đại nhân, ta nên làm thế nào
												nx_pause(0.1)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 2010101)--Vâng, đại nhân, ta hiểu rồi
												form.step5 = 2
												break
											else
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", 60000)--Để ta suy nghĩ lại một chút!
											end
										end
									end
								end
							else
								if not IsBusy() and nx_execute("util_move","distance3d", pos[7][1], pos[7][2], pos[7][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
									if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
									
									else
										form.check = os.time()
									end
									start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
									if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_rz_03")
									end
									if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
										if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
										end
										local form_bag = nx_value("form_stage_main\\form_bag")
										if nx_is_valid(form_bag) then
											form_bag.rbtn_tool.Checked = true
										end
										nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
									end
								else
									if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
									
									else
										form.check = os.time()
									end
									start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
									if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
										nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[7][1]..","..pos[7][2]..","..pos[7][3])
									end
									if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
										if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
										end
										local form_bag = nx_value("form_stage_main\\form_bag")
										if nx_is_valid(form_bag) then
											form_bag.rbtn_tool.Checked = true
										end
										nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
									end
								end						
							end
						end
						if form.step5 == 2 then
							if goods_grid:GetItemCount("item_wjd_05_02") > 0 then
								if CheckNPC("npc_wjd_rz_03") ~= nil then
									form.check = os.time()
									while not formtalk.Visible do
										nx_execute("custom_sender", "custom_select", CheckNPC2("npc_wjd_rz_03").Ident)
										nx_pause(0.1)
									end
									nx_execute("form_stage_main\\form_talk_movie", "menu_select", 1000)--Do thám khu vực người Oa chiếm lĩnh
									form.step = 1
									form.step5 = 3
								else
									if not IsBusy() and nx_execute("util_move","distance3d", pos[7][1], pos[7][2], pos[7][3], game_player.PositionX, game_player.PositionY, game_player.PositionZ) <= 2 then
										if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
										
										else
											form.check = os.time()
										end
										start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
										if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_rz_03")
										end
										if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
											if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
												nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
											end
											local form_bag = nx_value("form_stage_main\\form_bag")
											if nx_is_valid(form_bag) then
												form_bag.rbtn_tool.Checked = true
											end
											nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
										end
									else
										if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
										
										else
											form.check = os.time()
										end
										start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
										if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_execute("hyperlink_manager","find_path_npc_item","findnpc,"..game_scence:QueryProp("Resource")..","..pos[7][1]..","..pos[7][2]..","..pos[7][3])
										end
										if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
											if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
												nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
											end
											local form_bag = nx_value("form_stage_main\\form_bag")
											if nx_is_valid(form_bag) then
												form_bag.rbtn_tool.Checked = true
											end
											nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
										end
									end						
								end
							else
								if nx_function("find_buffer", player_client, "buff_wjd_behavior05_01") then
									if CheckNPC("npc_wjd_cm_02a") ~= nil then
										form.check = os.time()
										while not formtalk.Visible do
											nx_execute("custom_sender", "custom_select", CheckNPC2("npc_wjd_cm_02a").Ident)
											nx_pause(0.1)
										end
										nx_execute("form_stage_main\\form_talk_movie", "menu_select", 201)--Do thám khu vực người Oa chiếm lĩnh
									else
										if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
										
										else
											form.check = os.time()
										end
										start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ					
										if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
											nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."npc_wjd_cm_02a")
										end
										if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
											if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
												nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
											end
											local form_bag = nx_value("form_stage_main\\form_bag")
											if nx_is_valid(form_bag) then
												form_bag.rbtn_tool.Checked = true
											end
											nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
										end
									end
								else
									if goods_grid:GetItemCount("item_wjd_05_01") > 0 then
										form.check = os.time()
										local form_bag = nx_value("form_stage_main\\form_bag")
										if nx_is_valid(form_bag) then
											form_bag.rbtn_task.Checked = true
										end
										nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "item_wjd_05_01")
									else
										if CheckNPC("itemnpc_wjd_05_02") ~= nil then
											form.check = os.time()
											if not string.find(player_client:QueryProp("State"), "offact") then
												nx_execute("custom_sender", "custom_select", CheckNPC("itemnpc_wjd_05_02").Ident)
											end
										else
											if not IsBusy() and nx_execute("util_move","distance2d", start_x, start_z, game_player.PositionX, game_player.PositionZ) <= 0.1 then
											
											else
												form.check = os.time()
											end
											start_x, start_y, start_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ						
											if not IsPathFinding() and not nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
												nx_execute("hyperlink_manager","find_path_npc_item","findnpc_new,"..game_scence:QueryProp("Resource")..",".."itemnpc_wjd_05_02")
											end
											if os.difftime(os.time(), form.check) == 0 and nx_find_custom(player_client, "mount_name") and player_client.mount_name ~= nil and not nx_function("find_buffer", player_client, "buf_riding_01") then
												if nx_function("find_buffer", player_client, "buf_CS_jh_tmjt06") then
													nx_value("fight"):TraceUseSkill("CS_jh_tmjt06", false, false)
												end
												local form_bag = nx_value("form_stage_main\\form_bag")
												if nx_is_valid(form_bag) then
													form_bag.rbtn_tool.Checked = true
												end
												nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", nx_string(player_client.mount_name))
											end
										end
									end
								end
							end
						end
					else
						form.step = 1
					end
				end
			end
		end
	end
	end
end
function UpdateStatus()
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if form.auto_start then 
			form.btn_control.Text = util_text("ui_begin")
			form.btn_control.ForeColor = "255,0,255,0"
		    form.auto_start = false	
			form.step = 1
		else
			form.btn_control.Text = util_text("ui_off_end")
			form.btn_control.ForeColor = "255,255,0,0"
		    form.auto_start = true
		end
	end
end
function DoQVCDIni(form)
	form.Fixed = false
	form.auto_start = false
	form.step = 1
	form.step1 = 0
	form.step2 = 0
	form.step3 = 0
	form.step4 = 0
	form.step5 = 0
	form.step6 = 0
	form.check_time = 0
	form.check = os.time()
end

-- Kiểm tra bận --
function IsBusy()	
	if nx_is_valid(nx_value("game_client")) then 		
		if nx_is_valid(nx_value("game_client"):GetPlayer()) then
			if string.find(nx_value("game_client"):GetPlayer():QueryProp("State"), "offact") or string.find(nx_value("game_client"):GetPlayer():QueryProp("State"), "interact") or string.find(nx_value("game_client"):GetPlayer():QueryProp("State"), "life") or nx_value("form_stage_main\\form_main\\form_main_curseloading") then
				return true
			end
		end
	end
	return false
end
-- Kiểm tra tìm đường --
function IsPathFinding()  
  if not nx_is_valid(nx_value("game_visual")) then
    return false
  end
  visual_player = util_get_role_model()
  if nx_is_valid(visual_player) and nx_find_custom(visual_player, "path_finding") and visual_player.path_finding ~= nil and visual_player.path_finding then
    return true
  end
  return false
end
-- Kiểm tra hồi skill --
function CheckSkill(id)
	if nx_is_valid(nx_value("game_client"))then
		
		for i = 1, table.getn(nx_value("game_client"):GetViewList()) do
			local view = nx_value("game_client"):GetViewList()[i]
			if view.Ident == nx_string(40) then
				local view_obj_table = view:GetViewObjList()
				for k = 1, table.getn(view_obj_table) do
					local view_obj = view_obj_table[k]
					if nx_string(view_obj:QueryProp("ConfigID")) == id then
						return true
					end
				end
			end
		end
	end
	return false
end

function CheckNPC(npc)
	if nx_is_valid(nx_value("game_client")) and  nx_is_valid(nx_value("game_visual"))then 
		local num_objs = table.getn(nx_value("game_client"):GetScene():GetSceneObjList())
		for i = 1, num_objs do
			local object = nx_value("game_client"):GetScene():GetSceneObjList()[i]
			if nx_is_valid(object) then
				if not nx_value("game_client"):IsPlayer(object.Ident) and object:QueryProp("Type") == 4 and object:QueryProp("ConfigID") == npc then
					local vis_object = nx_value("game_visual"):GetSceneObj(object.Ident)
					if nx_is_valid(vis_object) then
						if nx_execute("util_move","distance3d", vis_object.PositionX, vis_object.PositionY, vis_object.PositionZ, nx_value("game_visual"):GetPlayer().PositionX, nx_value("game_visual"):GetPlayer().PositionY, nx_value("game_visual"):GetPlayer().PositionZ) <= 2 then
							return object
						end
					end
				end
			end
		end
	end
	return nil
end
function CheckNPC2(npc)
	if nx_is_valid(nx_value("game_client"))and nx_is_valid(nx_value("game_visual"))then 
		local num_objs = table.getn(nx_value("game_client"):GetScene():GetSceneObjList())
		for i = 1, num_objs do
			local object = nx_value("game_client"):GetScene():GetSceneObjList()[i]
			if nx_is_valid(object) then
				if not nx_value("game_client"):IsPlayer(object.Ident) and object:QueryProp("Type") == 4 and object:QueryProp("ConfigID") == npc then
					local vis_object = nx_value("game_visual"):GetSceneObj(object.Ident)
					if nx_is_valid(vis_object) then
						return object
					end
				end
			end
		end
	end
	return nil
end




function DoQVCDOpen(form)
	if not form.auto_start then
		form.btn_control.Text = util_text("ui_begin")
		form.btn_control.ForeColor = "255,0,255,0"
	else
		form.btn_control.Text = util_text("ui_off_end")
		form.btn_control.ForeColor = "255,255,0,0"
	end	
	if SupportMap() then
		form.btn_control.Enabled = true
		
	else
		showUtf8Text(AUTO_LOG_VCD,3)
		form.btn_control.Enabled = false
	end
	form.cbtn_q1.Checked = true
	form.cbtn_q2.Checked = false
	form.cbtn_q3.Checked = false
	form.cbtn_q4.Checked = false
	form.cbtn_q5.Checked = false
	form.cbtn_q6.Checked = false
	form.cbtn_q6.Checked = false
	form.cbtn_q7.Checked = false
	form.cbtn_q8.Checked = false
	form.cbtn_q9.Checked = false
	form.cbtn_q10.Checked = false
	-- form.cbtn_q11.Checked = false
	-- form.cbtn_q12.Checked = false
	-- form.cbtn_q13.Checked = false
	-- form.cbtn_q14.Checked = false
	-- form.cbtn_q15.Checked = false
	-- form.cbtn_q16.Checked = false
	-- form.cbtn_q17.Checked = false
	-- form.cbtn_q18.Checked = false
	-- form.cbtn_q19.Checked = false
	-- form.cbtn_q20.Checked = false
end
function DoQVCDClose(form)

end
function Destroy(form)
	nx_destroy(form)
end
function MinimizeClick(btn)
	util_auto_show_hide_form(THIS_FORM)
end
function CloseClick(btn)
	local form = btn.ParentForm
	if not form.auto_start then
		local formab = nx_value(THIS_FORM)
		if not nx_is_valid(formab) then
			return
		end
		Destroy(form)
	else
		local textchat = nx_value("gui").TextManager:GetFormatText(nx_string('<font color=\"#5FD00B\">{@3:text}</font> {@0:text} <font color=\"#F10F07\">{@1:text}</font> {@2:text}'), nx_widestr(nx_function("ext_utf8_to_widestr","Vui lòng bấm ")), nx_widestr(nx_function("ext_utf8_to_widestr","Kết Thúc ")), nx_widestr(nx_function("ext_utf8_to_widestr","trước khi tắt Auto.......!")))
		nx_value("form_main_chat"):AddChatInfoEx(textchat, 17, false)
		nx_value("SystemCenterInfo"):ShowSystemCenterInfo(textchat, 3)
	end
end
function SupportMap()
	local game_client=nx_value("game_client")
	local game_scence=game_client:GetScene()
	if game_scence:QueryProp("Resource") == "scene19" then
		return true
	end
	return false
end
function on_cbtn_q1_changed(self)
end
function on_cbtn_q2_changed(self)
end
function on_cbtn_q3_changed(self)
end
function on_cbtn_q4_changed(self)
end
function on_cbtn_q5_changed(self)
end
function on_cbtn_q6_changed(self)
end
function on_cbtn_q7_changed(self)
end
function on_cbtn_q8_changed(self)
end
function on_cbtn_q9_changed(self)
end
function on_cbtn_q10_changed(self)
end
function on_cbtn_q11_changed(self)
end
function on_cbtn_q12_changed(self)
end
function on_cbtn_q13_changed(self)
end
function on_cbtn_q14_changed(self)
end
function on_cbtn_q15_changed(self)
end
function on_cbtn_q16_changed(self)
end
function on_cbtn_q17_changed(self)
end
function on_cbtn_q18_changed(self)
end
function on_cbtn_q19_changed(self)
end
function on_cbtn_q20_changed(self)
end