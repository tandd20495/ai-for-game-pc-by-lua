require("admin_yBreaker\\yBreaker_admin_libraries\\yBreaker_libs")

-- Đè ping (Vừa ra skill vừa di chuyển or thao tác khác)
function super_run_lock()
	if not test then
		test = true
		yBreaker_show_WstrText(util_text("Ping: ON"), 3)
		while test == true do
		nx_pause(0)
		local game_client = nx_value("game_client")
		local client_scene_obj = game_client:GetPlayer()
		local game_visual = nx_value("game_visual")
		local visual_scene_obj = game_visual:GetSceneObj(client_scene_obj.Ident)
		game_visual:EmitPlayerInput(visual_scene_obj, 21, 12)
		end
	else
		test = false
		yBreaker_show_WstrText(util_text("Ping: OFF"), 3)
	end
end

-- Function to become Kakashi
function yBreaker_pvp()
	-- Swap(có tích chọn: VK theo skill đánh/vk+oản 30%/bình thư/áo)
	-- Bắt Target
	-- Auto Def
	-- Bug Speed
	-- Bug Khinh công
	-- Swap Mạch/đồ

	-- Đè ping
	super_run_lock()

end


