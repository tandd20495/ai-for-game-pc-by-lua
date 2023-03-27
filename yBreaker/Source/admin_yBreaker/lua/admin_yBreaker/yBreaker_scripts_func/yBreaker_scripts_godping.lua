require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

-- Đè ping (Vừa ra skill vừa di chuyển or thao tác khác)
function yBreaker_god_ping()  
	if not isPing then
		isPing = true
		yBreaker_show_Utf8Text("Đè ping chi thuật")
		while isPing == true do
			nx_pause(0)
			local game_client = nx_value("game_client")
			local client_scene_obj = game_client:GetPlayer()
			local game_visual = nx_value("game_visual")
			local visual_scene_obj = game_visual:GetSceneObj(client_scene_obj.Ident)
			game_visual:EmitPlayerInput(visual_scene_obj, 21, 12)
		end
	else
		isPing = false
		yBreaker_show_Utf8Text("Dừng cấm thuật")
	end
end
