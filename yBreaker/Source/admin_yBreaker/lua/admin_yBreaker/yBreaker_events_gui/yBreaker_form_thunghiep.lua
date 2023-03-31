require("const_define")
require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("util_move")
require("admin_yBreaker\\yBreaker_admin_libraries\\tool_libs")

-- if nx_int(metmoi) == nx_int(60)
-- Thụ nghiệp kiếm đột phá
local is_running = false
local THIS_FORM = "admin_yBreaker\\yBreaker_form_thunghiep"


function on_form_main_init(form)
    form.Fixed = false
    form.is_minimize = false
end

function on_main_form_open(form)
    change_form_size()
    form.is_minimize = false
	form.cbtn_tiendo.Visible = false
	form.lbl_tiendo.Visible = false
end

function on_main_form_close(form)
    nx_destroy(form)
end

function change_form_size()
    local form = nx_value(THIS_FORM)
    if not nx_is_valid(form) then
        return
    end
	
	local gui = nx_value("gui")
	form.Left = 100
	form.Top = (gui.Height /2)
end

function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end

function show_hide_form_thunghiep()
	util_auto_show_hide_form(THIS_FORM)
end


function on_btn_thunghiep_click(btn)
	local form = btn.ParentForm
	
	if not nx_is_valid(form) then
		return
	end	
	
	local form = util_get_form(THIS_FORM, false, false)
	if nx_is_valid(form) then
		if is_running then 
			btn.Text = nx_function("ext_utf8_to_widestr", "Bắt Đầu")
		    is_running = false
			tools_show_notice(nx_function("ext_utf8_to_widestr", "Kết thúc treo thụ nghiệp"))
		else
			btn.Text = nx_function("ext_utf8_to_widestr", "Kết Thúc")
		    is_running = true
			tools_show_notice(nx_function("ext_utf8_to_widestr", "Bắt đầu treo thụ nghiệp"))
			start_thu_nghiep()
		end
	end
end


function start_thu_nghiep()

	while is_running == true do
		local is_vaild_data = true
		local game_client = nx_value("game_client")
		local game_visual = nx_value("game_visual")
		if not nx_is_valid(game_client) then
			is_vaild_data = false
		end
		local game_scence
		if is_vaild_data == true then
			game_scence = game_client:GetScene()
			if not nx_is_valid(game_scence) then
				is_vaild_data = false
			end
		end
		
		local client_player = game_client:GetPlayer()
		local visual_player = game_visual:GetPlayer()
		local batphai = {{name="school_jinyiwei",map="school01"}, {name="school_gaibang",map="school02"},{name="school_junzitang",map="school03"},{name="school_jilegu",map="school04"},{name="school_tangmen",map="school05"},{name="school_emei",map="school06"},{name="school_wudang",map="school07"},{name="school_shaolin",map="school08"}}
		
		if checktime() then
			local loading_flag = nx_value("loading")
			if is_vaild_data == true and not loading_flag then
				if X_DeadState(client_player) then
					X_Relive("near",12)
				else
					local ok_letsgo = false
					local check_batphai = client_player:FindProp("School")
					if map_id() == "city04" or map_id() == "city05" then
							ok_letsgo = true
					elseif nx_is_valid(client_player) and client_player:FindProp("School") == true then
						local playerschool = client_player:QueryProp("School")
						for i = 1 , #batphai do
							if playerschool == batphai[i].name then
								if map_id() == batphai[i].map or map_id() == "city04" or map_id() == "city05" then
									ok_letsgo = true
								else
									nx_execute("custom_sender","custom_return_school_home_point")
									nx_pause(10)
								end
							end
						end
					elseif nx_is_valid(client_player) and client_player:FindProp("NewSchool") == true then
						local playerNewSchool = client_player:QueryProp("NewSchool")
						local data = atData(playerNewSchool)
						if data == false then
							tele_map("city05")
							nx_pause(10)
						elseif map_id() == data.related_map then
							ok_letsgo = true
						elseif map_id() == data.telemap then
							local npcx, npcy, npcz = find_npc_pos(map_id(), data.npc_id)
							if distance3d(visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ, npcx, npcy, npcz) > 6 then
								if not be_finding() then
									move_(map_id(), npcx, npcy, npcz)
								end
							else
								local game_scence_objs = game_scence:GetSceneObjList()
								for k = 1, table.getn(game_scence_objs) do
									if not nx_value("loading") and nx_is_valid(game_scence_objs[k]) and game_scence_objs[k]:FindProp("Type") and game_scence_objs[k]:QueryProp("Type") == 4 then
										local npc_id = game_scence_objs[k]:QueryProp("ConfigID")
										if npc_id == data.npc_id then
											-- Mở cái bảng nói chuyện
											local is_talking = false
											while is_talking == false do
												nx_execute("custom_sender", "custom_select", game_scence_objs[k].Ident)
												nx_pause(0.2)
												local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
												is_talking = form_talk.Visible
											end

											nx_pause(0.2)
											-- Cuộc hội thoại về phái liên quan
											local TT_code = data.talk_code
											for j = 1, #TT_code do
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", TT_code[j])
												nx_pause(0.2)
											end
											nx_pause(10)
											break
										end
									end
								end
							end
						else
							if X_GetHomeSchool() == nil then
								tele_map("city04")
								nx_pause(10)
							else
								send_homepoint_msg_to_server(Use_HomePoint,X_GetHomeSchool(),4)
								nx_pause(10)
							end
						end
					else
						tele_map("city04")
						nx_pause(10)
					end
					
					local loading_flag = nx_value("loading")
					if ok_letsgo == true and not loading_flag then
						local FORM_SCHOOL_MEMBER = util_get_form("form_stage_main\\form_school_dance\\form_school_dance_member")
						if not nx_is_valid(FORM_SCHOOL_MEMBER) then -- ko có bảng đang thụ nghiệp thì chạy
							local city = map_id()
							local data = thu_nghiep(city)
							-- di chuyển tới tọa độ thụ nghiệp 
							if data ~= false then
								local npcx, npcy, npcz = find_npc_pos(map_id(), data.npc_id)
								if distance3d(visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ, npcx, npcy, npcz) > 6 then
									if not be_finding() then
										move_(map_id(), npcx, npcy, npcz)
									end
								else
									-- Tới chỗ rồi thì xuống ngựa nếu đang cưỡi ngựa
									X_StopFinding()
									xuongngua()
									local game_scence_objs = game_scence:GetSceneObjList()
									for k = 1, table.getn(game_scence_objs) do
										if nx_is_valid(game_scence_objs[k]) and game_scence_objs[k]:FindProp("Type") and game_scence_objs[k]:QueryProp("Type") == 4 then
											local npc_id = game_scence_objs[k]:QueryProp("ConfigID")
											if npc_id == data.npc_id then
												-- Mở cái bảng nói chuyện
												local is_talking = false
												while is_talking == false do
													nx_execute("custom_sender", "custom_select", game_scence_objs[k].Ident)
													nx_pause(0.2)
													local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
													is_talking = form_talk.Visible
												end

												nx_pause(0.2)
												nx_execute("form_stage_main\\form_talk_movie", "menu_select", data.talk_code) -- bắt đầu thụ nghiệp
												nx_pause(10)
												break
											end
										end
									end
									nx_pause(1)
								end
							else 
								tools_show_notice(nx_function("ext_utf8_to_widestr", "Sai vị trí!"))
								nx_pause(2)
							end
						end
					end
				end
			end
		else
			tools_show_notice(nx_function("ext_utf8_to_widestr", "Chưa đến giờ thụ nghiệp"))
		end
		nx_pause(2)
	end
end

-- Lấy dữ liệu thụ nghiệp
function thu_nghiep(map)
	
	-- Thành Đô
	if map == "city05" then
		return {
		npc_id = "SMSY_School09",
		toa_do = {x = 834.550, y = 23.272, z = 673.663},
		talk_code = 898000025
		}
	end
	-- Lạc Dương
	if map == "city04" then
		return {
		npc_id = "SMSY_School10",
		toa_do = {x = 1310, y = 15, z = 404},
		talk_code = 898000025
		}
	end
	-- Cẩm y vệ
	if map == "school01" then
		return {
		npc_id = "SMSY_School01",
		toa_do = {x = 248, y = 65.283, z = -74},
		talk_code = 898000025
		}
	end
	--Cái Bang
	if map == "school02" then
		return {
		npc_id = "SMSY_School02",
		toa_do = {x = 529.799, y = 17.027, z = 414.535},
		talk_code = 898000025
		}
	end
	--Quân Tử Đường
	if map == "school03" then
		return {
		npc_id = "SMSY_School03",
		toa_do = {x = 659, y = 103, z = 293},
		talk_code = 898000025
		}
	end
	--Cực Lạc Cốc
	if map == "school04" then
		return {
		npc_id = "SMSY_School04",
		toa_do = {x = 142, y = 0, z = -40},
		talk_code = 898000025
		}
	end
	--Đường Môn
	if map == "school05" then
		return {
		npc_id = "SMSY_School05",
		toa_do = {x = 1064, y = 0, z = -21},
		talk_code = 898000025
		}
	end
	--Nga Mi
	if map == "school06" then
		return {
		npc_id = "SMSY_School06",
		toa_do = {x = 631, y = 0, z = 305},
		talk_code = 898000025
		}
	end
	--Võ Đang
	if map == "school07" then
		return {
		npc_id = "SMSY_School07",
		toa_do = {x = 493, y = 0, z = 279},
		talk_code = 898000025
		}
	end
	--Thiếu Lâm
	if map == "school08" then
		return {
		npc_id = "SMSY_School08",
		toa_do = {x = 861, y = 77, z = 442},
		talk_code = 898000025
		}
	end
	return false
end	

function checktime(...)
  local Message_Delay = nx_value("MessageDelay")
  if not nx_is_valid(Message_Delay) then
    return false
  end
  local Server_Second = Message_Delay:GetServerSecond()
  local Server_Time = Server_Second % 86400
  -- 1 ngày có 86400s. bắt đầu bằng 07h 00ph 00s = 0
  --06h 59ph 59s = 86400
  if Server_Time > 1800 and Server_Time < 7200 then
	return true
  elseif Server_Time > 23400 and Server_Time < 28800 then
    return true
  elseif Server_Time > 45000 and Server_Time < 50400 then
    return true
  elseif Server_Time > 54000 and Server_Time < 59400 then
    return true
  else
    return false
  end
end