function superunlock()
	Console("code new is comming")
	if not test then
		test = true
		SendNotice(nx_widestr("Start"), 3)
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
		SendNotice(nx_widestr("Stop"), 3)
	end
end

superunlock()