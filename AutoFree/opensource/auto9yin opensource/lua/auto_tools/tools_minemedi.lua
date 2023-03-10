require("utils")
require("util_gui")
require("util_move")
require("util_functions")
require("share\\chat_define")
require("auto_tools\\tool_libs")

local THIS_FORM = "auto_tools\\tools_minemedi"
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
				if not tools_move_isArrived(pos[pos_current].x, pos[pos_current].y, pos[pos_current].z, 1) then
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
			-- Chờ cho cây hoặc khoáng ra rồi hái, đào
			elseif step == 2 or step == 3 then
				if not tools_move_isArrived(pos[pos_current].x, pos[pos_current].y, pos[pos_current].z, 1) and step == 2 then
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
						local objPos = {}
						
						for i = 1, num_objs do
							local cfg_text = util_text(nx_string(game_scence_objs[i]:QueryProp("ConfigID")))
							local ident = game_scence_objs[i].Ident
							if cfg_text == selected_text then
								objPos.x = game_scence_objs[i].PosiX
								objPos.y = game_scence_objs[i].PosiY
								objPos.z = game_scence_objs[i].PosiZ
								wood_ident = ident
								step = 3
								break;
							end
						end
						
						-- Có khoáng hoặc cây
						if wood_ident ~= false then
							-- Chạy lại chỗ đó (Thử lại 5 lần)
							direct_run = true
							local okPos = false
							logmessage(util_text("tool_message_detected"), true, true)
							for i = 1, 5 do
								if not tools_move_isArrived(objPos.x, objPos.y, objPos.z, 0.5) then
									tools_move(city, objPos.x, objPos.y, objPos.z, direct_run)
									direct_run = false
									nx_pause(1)
								else
									okPos = true
									break
								end
							end
							
							if okPos then
								logmessage(util_text("tool_message_start_pick"), true, true)
								nx_execute("custom_sender", "custom_select", wood_ident)
								nx_pause(0.2)
								nx_execute("custom_sender", "custom_select", wood_ident)
								nx_pause(0.2)
								nx_execute("custom_sender", "custom_select", wood_ident)
								nx_pause(0.2)
								nx_execute("custom_sender", "custom_select", wood_ident)
								num_cut = num_cut + 1
								wait_for_pickform = true
								PICK_FORM_STARTTRACE = os.time()
							end
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
	-- Quân Tử Đường
	if map == "school03" then
		return {
			"kuangshi_1002npc01", -- Đồng khoáng
		}
	end
	-- Nga My
	if map == "school06" then
		return {
			"kuangshi_1002npc01", -- Đồng khoáng
		}
	end
	-- Đường Môn
	if map == "school05" then
		return {
			"kuangshi_1002npc01" -- Đồng khoáng
		}
	end
	-- Tô Châu
	if map == "city02" then
		return {
			"kuangshi_1003npc01" -- Diên Khoáng
		}
	end
	-- Thiên Đăng Trấn
	if map == "born04" then
		return {
			"kuangshi_1001npc01" -- Thiết Khoáng
		}
	end
	-- Thành Đô
	if map == "city05" then
		return {
			"kuangshi_1001npc01" -- Thiết Khoáng
		}
	end
	-- Cực Lạc Cốc
	if map == "school04" then
		return {
			"kuangshi_1002npc01" -- Đồng khoáng
		}
	end
	-- Võ Đang
	if map == "school07" then
		return {
			"kuangshi_1002npc01" -- Đồng khoáng
		}
	end
	-- Yến Kinh
	if map == "city01" then
		return {
			"kuangshi_1003npc01" -- Diên Khoáng
		}
	end
	-- Lạc Dương
	if map == "city04" then
		return {
			"drug_1001npc01" -- Bạc Hà
		}
	end
	return false
end
function get_data_pos(id)
	local map = get_current_map()
	-- Quân Tử Đường
	if map == "school03" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			return {
				{x = 1198.326, y = 8.314, z = 1121.685},
				{x = 1202.574, y = 4.250, z = 962.572},
				{x = 1523.266, y = -0.599, z = 966.391}
			}
		end
	end
	-- Đường Môn
	if map == "school05" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			return {
				{x = 610.244, y = 20.523, z = 618.751},
				{x = 503.201, y = -12.361, z = 622.314},
				{x = 516.398, y = 44.497, z = 772.539}
			}
		end
	end
	-- Tô Châu
	if map == "city02" then
		-- Diên khoáng
		if id == util_text("kuangshi_1003npc01") then
			return {
				{x = 1734.842, y = 5.576, z = 327.667},
				{x = 1651.532, y = 2.233, z = 477.975},
				{x = 1758.140, y = 2.605, z = 759.232}
			}
		end
	end
	-- Thiên Đăng Trấn
	if map == "born04" then
		-- Thiết khoáng
		if id == util_text("kuangshi_1001npc01") then
			return {
				{x = 646.675, y = -43.181, z = 908.064},
				{x = 702.477, y = -36.092, z = 897.055},
				{x = 777.764, y = -31.803, z = 917.164}
			}
		end
	end
	-- Thành Đô
	if map == "city05" then
		-- Thiết khoáng
		if id == util_text("kuangshi_1001npc01") then
			return {
				{x = 484.545, y = 16.364, z = 996.176},
				{x = 735.914, y = 43.820, z = 1180.685}				
			}
		end
	end
	-- Cực Lạc Cốc
	if map == "school04" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			return {
				{x = 872.036, y = 14.495, z = 300.579},
				{x = 810.543, y = 19.083, z = 465.835}
			}
		end
	end
	-- Yến Kinh
	if map == "city01" then
		-- Diên khoáng
		if id == util_text("kuangshi_1003npc01") then
			return {
				{x = 1020.328, y = -76.435, z = 196.159},
				{x = 992.636, y = -71.380, z = -309.893}
			}
		end
	end
	-- Nga My
	if map == "school06" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			return {
				{x = 412.114, y = -7.435, z = 920.399},
				{x = 342.491, y = 15.958, z = 859.062},
				{x = 158.676, y = 0.705, z = 762.064}
			}
		end
	end
	-- Võ Đang
	if map == "school07" then
		-- Đồng khoáng
		if id == util_text("kuangshi_1002npc01") then
			return {
				{x = 175.621, y = 16.550, z = 321.110},
				{x = 24.396, y = 28.483, z = 164.450},
				{x = -23.104, y = 39.803, z = 67.657}
			}
		end
	end
	-- Lạc Dương
	if map == "city04" then
		-- Bạc Hà
		if id == util_text("drug_1001npc01") then
			return {
				{x = 662.991, y = -19.687, z = 1150.124},
				{x = 809.397, y = -21.638, z = 1173.984},
				{x = 965.856, y = -13.374, z = 1190.551}
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
function tools_show_form()
util_auto_show_hide_form("auto_tools\\tools_minemedi")
end