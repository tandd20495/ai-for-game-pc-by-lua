local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\core.lua"))
file()

function changeacc(str)
	nx_pause(0.5)
	local game_config = nx_value("game_config")
	game_config.login_account = nx_string(str)
	local gEffect = nx_value("global_effect")
    if nx_is_valid(gEffect) then
      gEffect:ClearEffects()
    end
    local team_manager = nx_value("team_manager")
    if nx_is_valid(team_manager) then
      team_manager:ClearAllData()
    end
	nx_execute("stage", "set_current_stage", "login")
	nx_execute("client", "close_connect")
end

function isStarted()
	return create_acc
end

function autocreate(accounts, isMan, replacement, newvalue)
	if not create_acc then
		create_acc = true
		local count = 1
		local userName = accounts[count]
		console("Tao Account "..userName)
		changeacc(userName)
		step = 1
		local form
		while create_acc do
			nx_pause(0.5)
			nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
			local stage = nx_value("stage")
			if not nx_value("loading") then
				if step == 1 then
					if stage == "create" then -- acount chua dc tao
						step = 2
					elseif stage == "roles" then -- account da tao roi
						step = 3
					end
				elseif step == 2 then
					nx_pause(5)
					form = util_get_form("form_stage_create\\form_select_book", true)
					nx_pause(0.5)
					form.rbtn_3.Checked = true -- quan tu truyen ky
					-- form.rbtn_5.Checked = true -- vmp
					nx_execute("form_stage_create\\form_select_book", "on_btn_book_select_click", form.rbtn_3)
					nx_pause(5)
					nx_execute("form_stage_create\\form_select_book", "on_btn_ok_click", form.btn_ok)
					nx_pause(5)
					form = util_get_form("form_stage_create\\form_create", true)
					nx_pause(0.5)
					if isMan then
						form.rbtn_man.Checked = true
						nx_execute("form_stage_create\\form_create", "on_rbtn_man_checked_changed", form.rbtn_man)
					else
						form.rbtn_woman.Checked = true
						nx_execute("form_stage_create\\form_create", "on_rbtn_woman_checked_changed", form.rbtn_woman)
					end
					nx_pause(1)
					nx_execute("form_stage_create\\form_create", "on_btn_enter_frist_name_click", form.btn_enter_frist_name)
					local frist_name = util_get_form("form_stage_main\\form_firstname_list", true)
					userName = userName:gsub(replacement, newvalue)
					frist_name.ipt_name.Text = nx_function("ext_utf8_to_widestr", userName)
					nx_execute("form_stage_create\\form_create", "on_btn_enter_game_click", form.btn_enter_game)
					step = 3
				elseif step == 3 then
					if stage == "roles" then
						nx_execute("client", "choose_role", 0)
						step = 4
						nx_pause(5)
					end
				elseif step == 4 then
					if stage == "main" then
						nx_pause(5)
						form = util_get_form("form_single_select", true)
						if form.Visible then
							nx_execute("form_single_select", "cancel_btn_click", form.cancel_btn)
							step = 5
						else
							step = 6
						end
					end
				elseif step == 5 then
					nx_pause(1)
					form = util_get_form("form_single_question", true)
					if form.Visible then
						nx_gen_event(form, "confirm_return", "can_skip")
						nx_destroy(form)
						step = 6
					end
				elseif step == 6 then
					local file1 = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\vai.lua"))
					local check
					check = file1()
					if check == 1 then
						-- check_map = false
						-- while check_map == false do
							-- local cur_map = LayMapHienTai()
							-- if cur_map == "city05" then
								-- check_map = true
							-- end
							-- nx_pause(3)
						-- end
						step = 7
					end
				elseif step == 7 then 
					count = count + 1
					userName = accounts[count]
					if userName ~= nil then
						step = 1
						changeacc(userName)
						console("Tao Account "..userName)
					else
						break
					end
				end
			end
		end
	else
		create_acc = false
	end
end

return autocreate