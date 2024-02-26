require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

-- Đè ping (Vừa ra skill vừa di chuyển or thao tác khác)
function yBreaker_god_ping()  
	if not isPing then
		isPing = true
		yBreaker_show_Utf8Text("Mở khóa nhân vật khi đang dùng kỹ năng!")
		while isPing == true do
			nx_pause(0)
			local is_vaild_data = true
			local game_client = nx_value("game_client")
			if not nx_is_valid(game_client) then
				is_vaild_data = false
			end
			
			local client_scene_obj = game_client:GetPlayer()
			-- Hứng lỗi khi vào liên server
			if client_scene_obj == false then
				isPing = false
				is_vaild_data = false
				yBreaker_show_Utf8Text("Dừng tính năng, khởi động lại khi vào liên server!")
				return
			end
			
			local game_visual = nx_value("game_visual")
			if not nx_is_valid(game_visual) then
				is_vaild_data = false
			end
			
			local visual_scene_obj = game_visual:GetSceneObj(client_scene_obj.Ident)
			if not nx_is_valid(visual_scene_obj) then
				is_vaild_data = false
			end
			
			if is_vaild_data then
				game_visual:EmitPlayerInput(visual_scene_obj, 21, 12)
			end
		end
	else
		isPing = false
		yBreaker_show_Utf8Text("Dừng tính năng")
	end
end