require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")
------------------------------------
-- Tăng tốc
--	
function yBreaker_bug_speed()
	-- Harcode value speed_int
	local speed_int = 8
	local role = util_get_role_model()
	local game_visual = nx_value("game_visual")
	
	if not isSpeeding then
		isSpeeding = true
		yBreaker_show_Utf8Text("Tốc độ hiện tại tăng: "..nx_string(nx_int(speed_int)).." lần.", 3)
		while isSpeeding == true do
			if nx_is_valid(role) and role.state ~= "locked" and role.state ~= "motion" then
				game_visual:SetRoleMoveSpeed(role, speed_int)
				game_visual:QueryRoleMoveSpeed(role)
				local scene_obj = nx_value("scene_obj")
				local scene = nx_value("scene")
				local terrain = scene.terrain
				terrain = nx_value("terrain")
			end
			nx_pause(0)
		end
	else
		isSpeeding = false
		-- yBreaker_show_Utf8Text("Dừng tăng tốc!")
	end
end


