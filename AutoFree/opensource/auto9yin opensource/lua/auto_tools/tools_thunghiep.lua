require("const_define")
require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("auto_tools\\tool_libs")
   -- if nx_int(metmoi) == nx_int(60)
-- auto thụ nghiệp kiếm đột phá
 local auto_is_running = false

function auto_init()
  local game_client = nx_value("game_client")
 local game_scence = game_client:GetScene()
	--Click 1 cai thi chay, click cai nua thi dung
	if not auto_is_running then
		auto_is_running = true	
		while auto_is_running == true do
			local FORM_SCHOOL_MEMBER = util_get_form("form_stage_main\\form_school_dance\\form_school_dance_member")
			if not nx_is_valid(FORM_SCHOOL_MEMBER) then -- ko có bảng đang thụ nghiệp thì chạy
			local city = get_current_map()
			local data = thu_nghiep(city)
			-- di chuyển tới tọa độ thụ nghiệp 
		if data ~= 1 then
			tools_show_notice(util_text("tool_auto_thunghiep_label"))
			if not tools_move_isArrived(data.toa_do.x, data.toa_do.y, data.toa_do.z) then
				tools_move(city, data.toa_do.x, data.toa_do.y, data.toa_do.z, direct_run)
				nx_pause(4)
				direct_run = false
			end
			if tools_move_isArrived(data.toa_do.x, data.toa_do.y, data.toa_do.z) -- and checktime() 
					then
					-- Tới chỗ rồi thì xuống ngựa nếu đang cưỡi ngựa
				xuongngua()
				local game_scence_objs = game_scence:GetSceneObjList()

							for k = 1, table.getn(game_scence_objs) do
								if game_scence_objs[k]:FindProp("Type") and game_scence_objs[k]:QueryProp("Type") == 4 then
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
										nx_execute("form_stage_main\\form_talk_movie", "menu_select", 898000025) -- bắt đầu thụ nghiệp
										nx_pause(10)
										break
									end
								end
							end
					nx_pause(1)
			end
		else 
			tools_show_notice(util_text("tool_status_cant"))
			auto_is_running = false
			nx_pause(2)
		end
		nx_pause(2)
		end 
		--
		nx_pause(2)
		end
	else
		auto_is_running = false
		tools_show_notice(util_text("tool_stop"))
	end
end		


-- Lấy tọa độ thụ nghiệp
function thu_nghiep(map)
	local toa_do = false
	-- Thành Đô - xong
	if map == "city05" then
		return {
		npc_id = "SMSY_School09",
		toa_do = {x = 834.550, y = 23.272, z = 673.663}
		}
	end
	-- Cẩm y vệ
	if map == "school01" then
		return {
		npc_id = "SMSY_School01",
		toa_do = {x = 248.466995, y = 65.304001, z = -74.028999}
		}
	end
	--Cái Bang -xong
	if map == "school02" then
		return {
		npc_id = "SMSY_School02",
		toa_do = {x = 529.799, y = 17.027, z = 412.535}
		}
	end
	--Quân Tử Đường
	if map == "school03" then
		return {
		npc_id = "SMSY_School03",
		toa_do = {x = 834.550, y = 23.272, z = 673.663}
		}
	end
	--Cực Lạc Cốc
	if map == "school04" then
		return {
		npc_id = "SMSY_School04",
		toa_do = {x = 834.550, y = 23.272, z = 673.663}
		}
	end
	--Đường Môn
	if map == "school05" then
		return {
		npc_id = "SMSY_School05",
		toa_do = {x = 834.550, y = 23.272, z = 673.663}
		}
	end
	--Nga Mi
	if map == "school06" then
		return {
		npc_id = "SMSY_School06",
		toa_do = {x = 834.550, y = 23.272, z = 673.663}
		}
	end
	--Võ Đang
	if map == "school07" then
		return {
		npc_id = "SMSY_School07",
		toa_do = {x = 834.550, y = 23.272, z = 673.663}
		}
	end
	--Thiếu Lâm
	if map == "school08" then
		return {
		npc_id = "SMSY_School08",
		toa_do = {x = 834.550, y = 23.272, z = 673.663}
		}
	end
		--minh giáo
	if map == "school20" then
		return {
		npc_id = "SMSY_School20",
		toa_do = {x = -232.93, y = 53.82, z = -174.82}
		}
	end
	if toa_do == false then
		return 1
	end
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
  if Server_Time > 23400 and Server_Time < 28800 then
    return true
  elseif Server_Time > 1800 and Server_Time < 7200 then
    return true
  elseif Server_Time > 45000 and Server_Time < 50400 then
    return true
  else
    return false
  end
end
    
function get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end			