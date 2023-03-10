require("utils")
require("util_gui")
require("util_move")
require("util_functions")
require("share\\chat_define")
require("auto_tools\\tool_libs")

local THIS_FORM = "auto_tools\\tools_woodcut"
local PICK_FORM = "form_stage_main\\form_pick\\form_droppick"
local auto_is_running = false
local direct_run = false
local INTVAL_MESSAGE = 0
local PICK_FORM_TIMEOUT = 15 -- 15 giây không có form thì bỏ
local PICK_FORM_STARTTRACE = 0

function auto_run()
	local step = 1
	local pos_current = 1
	local pos_numbers = 1
	local num_cut = 0
	local wait_for_pickform = false
	
	direct_run = true
	
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
				control_this_form(form, ids)
				return false
			end
			
			local logicstate = player_client:QueryProp("LogicState")
			
			-- Nếu bị chết thì phải bắt đầu lại từ đầu
			if logicstate == 120 then
				step = 1
				pos_current = 1
				nx_execute("custom_sender", "custom_relive", 2, 0)
				nx_pause(15)
			end
			
			local selected_text = form.combobox_ids.Text
			local pos = get_data_pos(selected_text)
			local city = get_current_map()
			
			if pos == false then
				control_this_form(form, false)
				return false
			end
			
			pos_numbers = table.getn(pos)
			if pos_current > pos_numbers then
				pos_current = 1
			end
			
			-- Đến điểm pos[pos_current]
			if step == 1 then
				if not tools_move_isArrived(pos[pos_current].x, pos[pos_current].y, pos[pos_current].z, 0.5) then
					tools_move(city, pos[pos_current].x, pos[pos_current].y, pos[pos_current].z, direct_run)
					logmessage(util_text("tool_message_move_to_pos") .. nx_widestr(" ") .. nx_widestr(tostring(pos_current)))
					direct_run = false
				else
					-- Đến điểm có cây gỗ thì chuyển sang bước 2
					step = 2
					num_cut = 0
					wait_for_pickform = false
					logmessage(util_text("tool_message_moved_to_pos") .. nx_widestr(" ") .. nx_widestr(tostring(pos_current)), true, true)
				end
			-- Chờ cho cái cây gỗ nó ra rồi chặt
			elseif step == 2 then
				if not tools_move_isArrived(pos[pos_current].x, pos[pos_current].y, pos[pos_current].z, 0.5) then
					direct_run = true
					step = 1
					logmessage(util_text("tool_message_wrongstep1"), true, true)
				else
					if wait_for_pickform then
						logmessage(util_text("tool_message_wait_pickform"), true, true)
						local form_pick = nx_value(PICK_FORM)
						if nx_is_valid(form_pick) and form_pick.Visible then
							nx_pause(2)
							local form_pick1 = nx_value(PICK_FORM)
							if nx_is_valid(form_pick1) and form_pick1.Visible then
								nx_execute(PICK_FORM, "on_btn_pick_click", form_pick1.btn_pick)
								wait_for_pickform = false
							end
						end
						if wait_for_pickform and tools_difftime(PICK_FORM_STARTTRACE) >= PICK_FORM_TIMEOUT then
							wait_for_pickform = false
							logmessage(util_text("tool_message_pickform_timeout"), true, true)
						end
					else
						local game_scence_objs = game_scence:GetSceneObjList()
						local num_objs = table.getn(game_scence_objs)
						local wood_ident = false
						
						for i = 1, num_objs do
							local cfg_text = util_text(nx_string(game_scence_objs[i]:QueryProp("ConfigID")))
							local ident = game_scence_objs[i].Ident
							if cfg_text == selected_text then
								wood_ident = ident
								break;
							end
						end
						
						-- Chặt cây
						if wood_ident ~= false then
							nx_execute("custom_sender", "custom_select", wood_ident)
							nx_pause(0.2)
							nx_execute("custom_sender", "custom_select", wood_ident)
							num_cut = num_cut + 1
							wait_for_pickform = true
							PICK_FORM_STARTTRACE = os.time()
							logmessage(util_text("tool_message_start_pick"), true, true)
						else
							logmessage(util_text("tool_message_wait_mine"))
						end
						
						-- Chặt hết cây
						if wood_ident == false and num_cut ~= 0 then
							pos_current = pos_current + 1
							if pos_current > pos_numbers then
								pos_current = 1
							end
							step = 1
							logmessage(util_text("tool_message_end_restart"), true, true)
						end
					end
				end
			end
		end
		nx_pause(1)
	end
end
function get_data()
	local map = get_current_map()
	-- Thành Đô
	if map == "city05" then
		return {
			"tre_1001npc01" -- Cây bạch dương
		}
	end
	-- Võ Đang
	if map == "school07" then
		return {
			"tre_1002npc01" -- Cây bách
		}
	end
	-- Tô Châu
	if map == "city02" then
		return {
			"tre_1003npc01" -- Cây quế
		}
	end
	-- Thiên Đăng Trấn
	if map == "born04" then
		return {
			"tre_1001npc01" -- Cây bạch dương
		}
	end
	-- Cực Lạc Cốc
	if map == "school04" then
		return {
			"tre_1002npc01" -- Cây bách
		}
	end
	-- Quân Tử Đường
	if map == "school03" then
		return {
			"tre_1002npc01" -- Cây bách
		}
	end
	-- Yến Kinh
	if map == "city01" then
		return {
			"tre_1003npc01" -- Cây quế
		}
	end
	return false
end
function get_data_pos(id)
	local map = get_current_map()
	-- Thành Đô
	if map == "city05" then
		-- Cây bạch dương
		if id == util_text("tre_1001npc01") then
			return {
				{x = 299.301, y = 27.444, z = 567.499},
				{x = 325.646, y = 26.772, z = 689.127}
			}
		end
	end
	-- Thiên Đăng Trấn
	if map == "born04" then
		-- Cây bạch dương
		if id == util_text("tre_1001npc01") then
			return {
				{x = 364.985, y = -25.689, z = 731.351},
				{x = 469.892, y = -30.372, z = 871.290}
			}
		end
	end
	-- Võ Đang
	if map == "school07" then
		-- Cây bách
		if id == util_text("tre_1002npc01") then
			return {
				{x = 28.791, y = 19.567, z = 636.403},
				{x = 176.155, y = 5.559, z = 786.989}
			}
		end
	end
	-- Tô Châu
	if map == "city02" then
		-- Cây quế
		if id == util_text("tre_1003npc01") then
			return {
				{x = 863.152, y = 12.820, z = 602.466},
				{x = 1188.534, y = 16.868, z = 295.824},
				{x = 1623.181, y = 4.846, z = 221.000}
			}
		end
	end
	-- Cực Lạc Cốc
	if map == "school04" then
		-- Cây bách
		if id == util_text("tre_1002npc01") then
			return {
				{x = 607.074, y = 38.874, z = 88.496},
				{x = 420.281, y = 21.442, z = 209.950}
			}
		end
	end
	-- Quân Tử Đường
	if map == "school03" then
		-- Cây bách
		if id == util_text("tre_1002npc01") then
			return {
				{x = 1064.103, y = 7.165, z = 1245.232},
				{x = 1297.691, y = 59.549, z = 1192.319},
			}
		end
	end
	-- Yến Kinh
	if map == "city01" then
		-- Cây quế
		if id == util_text("tre_1003npc01") then
			return {
				{x = 1088.813, y = -105.969, z = 1305.310},
				{x = 1261.250, y = -94.630, z = 1037.750},
				{x = 1498.703, y = -78.008, z = 890.929}
			}
		end
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