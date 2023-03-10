require("utils")
require("util_gui")
require("util_move")
require("util_functions")
require("share\\chat_define")
require("auto_tools\\tool_libs")

local THIS_FORM = "auto_tools\\tools_fish"
local FISH_FORM = "form_stage_main\\form_life\\form_fishing_op"
local PICK_FORM = "form_stage_main\\form_pick\\form_droppick"
local auto_is_running = false
local INTVAL_MESSAGE = 0
local PICK_FORM_TIMEOUT = 15 -- 15 giây không có form thì bỏ
local PICK_FORM_STARTTRACE = 0

function auto_run()
	while auto_is_running == true do
		local is_vaild_data = true
		local game_client
		local game_visual
		local game_player
		local player_client
		local game_scence

		game_client = nx_value("game_client")
		if not nx_is_valid(game_client) then
			is_vaild_data = false
		end
		game_visual = nx_value("game_visual")
		if not nx_is_valid(game_visual) then
			is_vaild_data = false
		end
		if is_vaild_data == true then
			game_player = game_visual:GetPlayer()
			if not nx_is_valid(game_player) then
				is_vaild_data = false
			end
			player_client = game_client:GetPlayer()
			if not nx_is_valid(player_client) then
				is_vaild_data = false
			end
			game_scence = game_client:GetScene()
			if not nx_is_valid(game_scence) then
				is_vaild_data = false
			end
		end
		local form = nx_value(THIS_FORM)
		if not nx_is_valid(form) then
			is_vaild_data = false
		end

		if is_vaild_data == true then
			local ids = get_data()
			if ids == false then
				control_this_form(form, false)
				return false
			end

			local selected_text = form.combobox_ids.Text
			local id = false
			local city = get_current_map()

			for i = 1, table.getn(ids) do
				if selected_text == util_text(ids[i]) then
					id = ids[i]
					break
				end
			end

			if id == false then
				control_this_form(form, false)
				return false
			end

			local game_scence_objs = game_scence:GetSceneObjList()
			local isTriggerForm = false

			for i = 1, table.getn(game_scence_objs) do
				if game_scence_objs[i]:QueryProp("ConfigID") == id then
					nx_execute("custom_sender", "custom_select", game_scence_objs[i].Ident)
					nx_pause(1)
					nx_execute(FISH_FORM, "start_fishing")
					isTriggerForm = true
					break
				end
			end

			-- Phát hiện có cá (Phát hiện xong sẽ lặp trong vòng này, dừng 6s trước khi chạy lại)
			if isTriggerForm then
				local waitFormTime = 0 -- Bộ đếm chờ cái form câu cá bật lên
				local formOpenOK = false

				while 1 do
					local formFish = nx_value(FISH_FORM)
					if nx_is_valid(formFish) and formFish.Visible == true then
						formOpenOK = true
						break
					end
					waitFormTime = waitFormTime + 1
					if waitFormTime >= 20 then
						break
					end
					nx_pause(0.1)
				end

				if not formOpenOK then
					logmessage(nx_widestr("Loi khong xac dinh (Khong mo form cau ca len)"), true, true)
				else
					local isFormOK = true
					local isFishPull = false
					local isFishComplete = false
					local isTriggerPick = false

					while 1 do
						-- Đợi cá cắn câu
						local formFish = nx_value(FISH_FORM)
						if not nx_is_valid(formFish) then
							logmessage(util_text("tools_fish_finish"), true, true)
							break
						end

						-- Câu cá xong chờ nhặt cá
						if isFishComplete and not isTriggerPick then
							logmessage(util_text("tools_fish_waitpick"), true, true)
							local form_pick = nx_value(PICK_FORM)
							if nx_is_valid(form_pick) and form_pick.Visible then
								nx_execute(PICK_FORM, "on_btn_pick_click", form_pick.btn_pick)
								isTriggerPick = true
							end
						end

						-- Đợi cá cắn câu rồi kéo cá
						if not isFishComplete then
							if isFishPull then
								if not formFish.groupbox_fishing.Visible then
									isFishComplete = true
								end
							end

							if formFish.groupbox_fishing.Visible then
								isFishPull = true
								if formFish.lbl_fish.BackImage ~= "fishing_mouse4" then
									nx_execute(FISH_FORM, "on_btn_fishing_right_click", formFish.btn_fishing)
								end
							end
						end

						-- Chờ cái form nhặt cá mất
						if isTriggerPick then
							local form_pick = nx_value(PICK_FORM)
							if not nx_is_valid(form_pick) then
								logmessage(util_text("tools_fish_waitpick1"), true, true)
								isFishPull = false
								isFishComplete = false
								isTriggerPick = false
							end
						end
						nx_pause(0.2)
					end
				end
				nx_pause(5)
			else
				logmessage(util_text("tools_fish_nofish"))
			end
		end
		nx_pause(1)
	end
end
function get_data()
	local map = get_current_map()
	-- Yến Kinh
	if map == "city01" then
		return {
			"fishnpc10076", -- Đàn Cá Tầm Trắng
			"fishnpc10098" -- Đàn Cá Bạc Trắng
		}
	end
	-- Thành Đô
	if map == "city05" then
		return {
			"fishnpc10013" -- Đàn Cá Hồi
		}
	end
	return false
end
function control_this_form(form, ids)
	local map = get_current_map()
	form.lbl_2.Text = util_text(map)
	if ids == false then
		auto_is_running = false
		form.btn_control.Text = nx_widestr("...")
		form.lbl_4.Text = util_text("tool_status_cant")
		return false
	end
	local combobox_ids = form.combobox_ids
	combobox_ids.DropListBox:ClearString()
	if combobox_ids.DroppedDown then
		combobox_ids.DroppedDown = false
	end
	for i = 1, table.getn(ids) do
		combobox_ids.DropListBox:AddString(util_text(ids[i]))
	end
	combobox_ids.Text = util_text(ids[1])
	form.lbl_4.Text = util_text("tool_status_ok")
	form.btn_control.Text = util_text("tool_start")
end
function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	change_form_size()
	form.is_minimize = false
	auto_is_running = false
	local ids = get_data()
	control_this_form(form, ids)
end
function on_main_form_close(form)
	auto_is_running = false
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_btn_control_click(btn)
	local form = btn.ParentForm
	if not nx_is_valid(form) then
		return
	end
	if btn.Text == nx_widestr("...") then
		return 0
	end
	if auto_is_running then
		auto_is_running = false
		btn.Text = util_text("tool_start")
	else
		auto_is_running = true
		btn.Text = util_text("tool_stop")
		auto_run()
	end
end
function change_form_size()
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	local gui = nx_value("gui")
	form.Left = (gui.Width - form.Width) / 2
	--form.Top = (gui.Height - form.Height) / 2
	form.Top = 100
end
function on_combobox_ids_selected(combobox)
end
function get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end
function logmessage(text, resetCounter, resetAfterCall)
	if resetCounter ~= nil then
		INTVAL_MESSAGE = 0
	end
	INTVAL_MESSAGE = INTVAL_MESSAGE + 1
	if INTVAL_MESSAGE == 1 then
		tools_show_notice(text)
	end
	if INTVAL_MESSAGE >= 6 then
		INTVAL_MESSAGE = 0
	end
	if resetAfterCall ~= nil then
		INTVAL_MESSAGE = 0
	end
end
