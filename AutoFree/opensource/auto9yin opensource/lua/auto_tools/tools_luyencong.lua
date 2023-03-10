require("const_define")
require("util_gui")
require("util_move")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
require("auto_tools\\tool_libs")

local x = 654.729
local y = 31.218
local z = 314.887
local auto_is_running = false
function xinvaoptlc(...)
  local game_client = nx_value("game_client")
  local game_scene = game_client:GetScene()
  if not nx_is_valid(game_scene) then
    return false
  end
  local game_scence_objs = game_scene:GetSceneObjList()
  for i = 1, #game_scence_objs do
    if nx_is_valid(game_scence_objs[i]) then
      local QueryProp_NpcType = game_scence_objs[i]:QueryProp("NpcType")
      local QueryProp_Name = game_scence_objs[i]:QueryProp("Name")
      if QueryProp_NpcType == 0 and nx_widestr(QueryProp_Name) ~= nx_widestr("0") and nx_widestr(QueryProp_Name) ~= nx_widestr("") then
        local state = game_scence_objs[i]:QueryProp("TeamFacultyState")
        if nx_string(state) == nx_string("1") then
          nx_execute("custom_sender", "custom_request", 38, nx_widestr(QueryProp_Name))
          nx_pause(3)
        end
      end
    end
  end
  return false
end
function check_metmoi()
local game_client = nx_value("game_client")
local player_client = game_client:GetPlayer()
local cur_team_value = player_client:QueryProp("TeamFacultyValue")
local total_team_value = 80000
local metmoi = nx_int((total_team_value - cur_team_value) * 100 / total_team_value)
	if nx_int(metmoi) >= nx_int(100)  then
		tools_show_notice(util_text("tool_message_lc_full"))
		auto_is_running = false
		return false
	else 
		return true
	end
end


function auto_init()
	-- Click 1 cai thi chay, click cai nua thi dung
	if not auto_is_running then
		auto_is_running = true	
		while auto_is_running == true do
		lvlup()
		local FORM_DANCE = util_get_form("form_stage_main\\form_wuxue\\form_faculty_back")
		if not nx_is_valid(FORM_DANCE) then -- không có cái bảng đen mờ thì chạy
			local city = get_current_map()
			if city == "city05"  and check_metmoi()  then
						if not tools_move_isArrived( x, y, z)   then
							tools_show_notice(util_text("tool_auto_luyencong_label"))
							tools_move(city, x,y, z, direct_run)
							direct_run = false
							nx_pause(3)	
						end
						if  tools_move_isArrived( x, y, z) then
							xuongngua()
							xinvaoptlc()
						end
			else
				tools_show_notice(util_text("tool_message_lc_map"))
				auto_is_running = false
			end
		nx_pause(1)	
		end
		nx_pause(1)	
		end
	else
		auto_is_running = false
		tools_show_notice(util_text("tool_stop"))
	end
end
