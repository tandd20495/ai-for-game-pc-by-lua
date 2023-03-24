
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
		add_chat_info("Đã luyện công xong")
		tool_auto_lc = false
		return false
	else 
		return true
	end
end

if not tool_auto_lc then
	local lc_pos = {657.408,29.750,317.188,0.295} --{654.729, 31.218, 314.887}
	local game_client = nx_value("game_client")
	local view = game_client:GetView(nx_string(49))
	local FORM_DANCE = util_get_form("form_stage_main\\form_wuxue\\form_team_faculty_member")
	tool_auto_lc = true	
	while tool_auto_lc do
		check_metmoi()
		local city = LayMapHienTai()
		if city == "city05"  then -- Thành Đô
			if not arrived(lc_pos) and not nx_is_valid(view)  then
				move(lc_pos, 2)
			end
			if arrived(lc_pos) then
				check_metmoi()
				while tool_auto_lc and has_buff("buf_riding_01") do
					remove_buff("buf_riding_01")
					nx_pause(0.2)
				end
				xinvaoptlc()
				nx_pause(3)
			end
		else
			add_chat_info("Cần đến Thành Đô để lc")
			tool_auto_lc = false
			nx_pause(1)
		end
		nx_pause(10)	
	end
else
	tool_auto_lc = false
	add_chat_info("Dừng auto lc")
end
