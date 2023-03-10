
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
          nx_pause(1)
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
		tools_show_notice(util_text("tool_stop"))
		return false
	else 
		return true
	end
end
local x = 654.729
local y = 31.218
local z = 314.887
local auto_is_running = false

function auto_init()
local game_client = nx_value("game_client")
local player_client = game_client:GetPlayer()
local noitu = player_client:QueryProp("FacultyState")
if nx_int(noitu) == nx_int(0) then
	nx_execute("custom_sender", "custom_send_faculty_msg", 11)
end
local view = game_client:GetView(nx_string(49))
local FORM_DANCE = util_get_form("form_stage_main\\form_wuxue\\form_team_faculty_member")
	-- Click 1 cai thi chay, click cai nua thi dung
	if not auto_is_running then
		auto_is_running = true	
		while auto_is_running == true do
			check_metmoi()
			local city = get_current_map()
			if city == "city05"  and check_metmoi() then
						if not tools_move_isArrived( x, y, z) and not nx_is_valid(view)  then
							tools_move(city, x,y, z, direct_run)
							tools_show_notice(util_text("tool_auto_luyencong_label"))
							direct_run = false
						end
						if  tools_move_isArrived( x, y, z) then
							xuongngua()
							--check_metmoi()
						--	tools_show_chat(util_text("tool_message_lc_chat"), 1)
							xinvaoptlc()
							nx_pause(3)
							break
						end
		--	else
		--		tools_show_notice(util_text("tool_message_lc_map"))
		--		auto_is_running = false
		--		nx_pause(1)
			end
		nx_pause(10)	
		end
	else
		auto_is_running = false
		tools_show_notice(util_text("tool_stop"))
		tools_show_notice(util_text("tool_message_lc_map"))
	end
end