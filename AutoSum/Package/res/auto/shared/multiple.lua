local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\core.lua"))
file()

function do_action(action, accounts, isStarted, actionName, step)
	actionName = actionName or "Running account"
	step = step or 1
	local count = 0
	while isStarted() and count <= table.getn(accounts) do
		nx_pause(0.1)
		local stage = nx_value("stage")
		if stage ~= nil and stage == "main" then
		-- cho load map xong
		local stage_main_flag = nx_value("stage_main")
		local loading_flag = nx_value("loading")
		while isStarted() and (loading_flag or nx_string(stage_main_flag) ~= nx_string("success")) do
			nx_pause(0.1)
			stage_main_flag = nx_value("stage_main")
			loading_flag = nx_value("loading")
		end
		
		local game_visual = nx_value("game_visual")
		game_visual.HidePlayer = true
		nx_function("ext_hide_player_F9")
		local world = nx_value("world")
		local scene = world.MainScene
		local game_control = scene.game_control
		game_control.MaxDisplayFPS = 24

		local game_config = nx_value("game_config")
		local account = game_config.login_account
		local msg = "[" ..nx_string(count) .."/" ..nx_string(table.getn(accounts)) .. "] " ..account
		nx_function("ext_set_window_title", nx_function("ext_utf8_to_widestr", msg))
		pw2()
		check_noi_tu();
		action()
		
		console("[" ..actionName .."] " ..account)
		count = count + step
		local userName = accounts[count]
		if userName ~= nil then
				if isStarted() then
					add_chat_info("Next account No #" ..nx_string(count) .." " ..userName, 3)
					nx_pause(3)
					changeAcc(userName)
				end
			end
			stage = nx_value("stage")
			while isStarted() and (stage == nil or stage ~= "login") do
				add_chat_info("Dang cho man hinh login 1", 3)
				nx_pause(1)
				stage = nx_value("stage")
			end
			
			stage = nx_value("stage")
			while isStarted() and (stage == nil or stage == "login") do
				add_chat_info("Dang o man hinh login 2", 3)
				nx_pause(1)
				stage = nx_value("stage")
			end
			
			stage = nx_value("stage")
			nx_pause(2)
			if stage == "roles" then nx_execute("client", "choose_role", 0) end
			
			stage = nx_value("stage")
			while isStarted() and (stage == nil or stage ~= "main") do
				add_chat_info("Dang cho man hinh chinh", 3)
				nx_pause(1)
				stage = nx_value("stage")
			end
		end
	end
	add_chat_info("Done Current Multiple " ..actionName)
end

return do_action