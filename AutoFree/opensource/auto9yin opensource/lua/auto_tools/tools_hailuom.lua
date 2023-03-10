require("utils")
require("util_gui")
require("util_move")
require("util_functions")
require("share\\chat_define")
require("auto_tools\\tool_libs")
require("auto\\lib2")
require("auto\\lib")
local THIS_FORM = "auto_tools\\tools_hailuom"

data_npc_id = {
"kuangshi_1001npc01", -- Thiết Khoáng
"kuangshi_1002npc01", --Đồng Khoáng
"kuangshi_1003npc01", -- Diên Khoáng
"kuangshi_1004npc01", -- Ngân Khoáng
"kuangshi_1006npc01", -- Kim Khoáng

"drug_1001npc01", -- Bạc Hà
"drug_1002npc01", -- Khổ Tình Hoa
"drug_1003npc01", -- Ngải Thảo
"drug_1004npc01", -- Bạch Thuật
"drug_1006npc01", -- Mã Bột

"tre_1001npc01", -- Cây Bạch Dương
"tre_1002npc01", -- Cây Bách
"tre_1003npc01", -- Cây quế
"tre_1004npc01", -- Cây Tùng
"tre_1006npc01", -- Cây Ngân Sam

"toxicant_1001npc01",
"toxicant_1002npc01",
"toxicant_1003npc01",
"toxicant_1004npc01",
"toxicant_1006npc01"
}
local PICK_FORM = "form_stage_main\\form_pick\\form_droppick"
local auto_is_running = false
local direct_run = false
local INTVAL_MESSAGE = 0
local PICK_FORM_TIMEOUT = 15 -- 15 giây không có form thì bỏ
local PICK_FORM_STARTTRACE = 0
function auto_run()
local demgio = 0
	local step = 1
	local pos_current = 1
	local pos_numbers = 1
	local num_cut = 0
	local wait_for_pickform = false
	local form2 = util_get_form(THIS_FORM, false, false)
x = {
nx_number(form2.toado_x1.Text),
nx_number(form2.toado_x2.Text),
nx_number(form2.toado_x3.Text)
}
y = {
nx_number(form2.toado_y1.Text),
nx_number(form2.toado_y2.Text),
nx_number(form2.toado_y3.Text)
}
z = {
nx_number(form2.toado_z1.Text),
nx_number(form2.toado_z2.Text),
nx_number(form2.toado_z3.Text)
}
npc_id = {
form2.combobox1.Text,
form2.combobox2.Text,
form2.combobox3.Text
}
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

			
			local logicstate = player_client:QueryProp("LogicState")
			
			-- Nếu bị chết thì phải bắt đầu lại từ đầu
			if logicstate == 120 then
				step = 1
				pos_current = 1
				nx_execute("custom_sender", "custom_relive", 2, 0)
				nx_pause(15)
			end
			
		--	local selected_text = form.combobox_ids.Text
			--local pos = get_data_pos(selected_text)
			local city = get_current_map()
			
			
			pos_numbers =3
			if pos_current > pos_numbers then
				pos_current = 1
			end
			
			-- Đến điểm pos[pos_current]
			if step == 1 then
				if not tools_move_isArrived(x[pos_current], y[pos_current], z[pos_current], 1) then
					tools_move(city, x[pos_current], y[pos_current], z[pos_current], direct_run)
					logmessage(util_text("tool_message_move_to_pos") .. nx_widestr(" ") .. nx_widestr(tostring(pos_current))) --Di chuyển đến điểm thứ
					direct_run = false
				else
					-- Đến điểm có cây gỗ thì chuyển sang bước 2
					step = 2
					num_cut = 0
					wait_for_pickform = false
					logmessage(util_text("tool_message_moved_to_pos") .. nx_widestr(" ") .. nx_widestr(tostring(pos_current)), true, true) --Đã đến điểm thứ
				end
			-- Chờ cho cây hoặc khoáng ra rồi hái, đào
			elseif step == 2 or step == 3 then
				if not tools_move_isArrived(x[pos_current], y[pos_current], z[pos_current], 1) and step == 2 then
					direct_run = true
					step = 1
					logmessage(util_text("tool_message_wrongstep1"), true, true) --Sai vị trí đứng tìm đường trở lại
				else
					if wait_for_pickform then
						logmessage(util_text("tool_message_wait_pickform"), true, true) --Chờ nhặt đồ
						local form_pick = nx_value(PICK_FORM)
						if nx_is_valid(form_pick) and form_pick.Visible then
							nx_pause(2)
							local form_pick1 = nx_value(PICK_FORM)
							if nx_is_valid(form_pick1) and form_pick1.Visible then
								--nx_execute(PICK_FORM, "on_btn_pick_click", form_pick1.btn_pick)
								pickup_all_item()
								wait_for_pickform = false
							end
						end
						if wait_for_pickform and tools_difftime(PICK_FORM_STARTTRACE) >= PICK_FORM_TIMEOUT then
							wait_for_pickform = false
							logmessage(util_text("tool_message_pickform_timeout"), true, true) -- ĐM, chờ hoài không có đồ để lụm, bỏ! Yêu Lại Từ Đầu - Khắc Việt
						end
					else
						local game_scence_objs = game_scence:GetSceneObjList()
						local num_objs = table.getn(game_scence_objs)
						local wood_ident = false
						local objPos = {}


						for i = 1, num_objs do
							local cfg_text = util_text(nx_string(game_scence_objs[i]:QueryProp("ConfigID")))
							local ident = game_scence_objs[i].Ident
							if cfg_text == npc_id[pos_current] then
							npc_test = game_scence_objs[i]:QueryProp("ConfigID")
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
								if check_cay(npc_test) then
									okPos = true 
									break
								end
								if not tools_move_isArrived(objPos.x, objPos.y, objPos.z, 0.5)  then
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
							logmessage(util_text("tool_message_wait_mine")) --Đang chờ khoáng, cây ra
							demgio = demgio + 1
							if demgio > 100 then
							logmessage(util_text("tool_message_pickform_timeout2"), true, true) --Chờ hoài không có gì để lượm, bạn chọn nhầm vị trí cmnr
							demgio =0 
							pos_current = pos_current + 1
							if pos_current > pos_numbers then
								pos_current = 1
							end
							step = 1
						end
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




function control_this_form(form, data_npc_id)
local form = util_get_form(THIS_FORM, false, false) -- xong
	local combobox1 = form.combobox1
	combobox1.DropListBox:ClearString()
	if combobox1.DroppedDown then
		combobox1.DroppedDown = false
	end
	local combobox2 = form.combobox2
	combobox2.DropListBox:ClearString()
	if combobox2.DroppedDown then
		combobox2.DroppedDown = false
	end
	local combobox3 = form.combobox3
	combobox3.DropListBox:ClearString()
	if combobox3.DroppedDown then
		combobox3.DroppedDown = false
	end
	for i = 1, table.getn(data_npc_id) do
		combobox1.DropListBox:AddString(util_text(data_npc_id[i]))
		combobox2.DropListBox:AddString(util_text(data_npc_id[i]))
		combobox3.DropListBox:AddString(util_text(data_npc_id[i]))
	end
	combobox1.Text = util_text(data_npc_id[1])
	combobox2.Text = util_text(data_npc_id[1])
	combobox3.Text = util_text(data_npc_id[1])

end

function click_toado1(form) -- xong
	local form = util_get_form(THIS_FORM, false, false)
	if not nx_is_valid(form) then
		return
	end
	local x,y,z = toado()
	form.toado_x1.Text  = nx_widestr(x)
	form.toado_y1.Text  = nx_widestr(y)
	form.toado_z1.Text  = nx_widestr(z)
	local combobox1 = form.combobox1
	combobox1.Text = util_text(check_npc_id())
end
function click_toado2(form) --xong
	local form = util_get_form(THIS_FORM, false, false)
	if not nx_is_valid(form) then
		return
	end
	local x,y,z= toado()
	form.toado_x2.Text  = nx_widestr(x)
	form.toado_y2.Text  = nx_widestr(y)
	form.toado_z2.Text  = nx_widestr(z)
	local combobox2 = form.combobox2
	combobox2.Text = util_text(check_npc_id())
end
function click_toado3(form) -- xong
	local form = util_get_form(THIS_FORM, false, false)
	if not nx_is_valid(form) then
		return
	end
	local x,y,z = toado()
	form.toado_x3.Text  = nx_widestr(x)
	form.toado_y3.Text  = nx_widestr(y)
	form.toado_z3.Text  = nx_widestr(z)
	local combobox3 = form.combobox3
	combobox3.Text = util_text(check_npc_id())
end

function auto_status()
local status = util_get_form(THIS_FORM)
if  nx_is_valid(status) and auto_is_running  then
		status.btn_control.Text = util_text("@tool_stop")
--		nx_pause(0.1)
end
end



function on_form_main_init(form)
	form.Fixed = false
	form.is_minimize = false
end
function on_main_form_open(form)
	change_form_size()
	control_this_form(form, data_npc_id)
	form.is_minimize = false
end
function on_main_form_close(form)
	nx_destroy(form)
end
function on_btn_close_click(btn)
	local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
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
function combobox1(combobox)
end
function combobox2(combobox)
end
function combobox3(combobox)
end
function tools_show_form() -- để đưa vào main.xml
local form = nx_value("auto_tools\\tools_hailuom")
  util_auto_show_hide_form("auto_tools\\tools_hailuom")
--  auto_status()
	if nx_is_valid(form) then
	control_this_form(form1, data_npc_id)
	end

end

function on_btn_control_click(btn)
	local form = btn.ParentForm
	if not nx_is_valid(form) then
		return
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
function pickup_all_item()
  for i = 1, 10 do
    nx_execute("custom_sender", "custom_pickup_single_item", i)
  end
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

function check_cay(npc)
local s =false
npc_id_cay = {
"tre_1001npc01", -- Cây Bạch Dương
"tre_1002npc01", -- Cây Bách
"tre_1003npc01", -- Cây quế
"tre_1004npc01", -- Cây Tùng
"tre_1006npc01" 	}		
for k = 1 , 5 do
	if npc == npc_id_cay[k] then
	s = true
	return s
	end
end
return s
end
function timerInit()
  return os.clock()
end
function timerDiff(t)
  return os.clock() - t
end

function check_npc_id()
local game_client = nx_value("game_client")
local game_scence = game_client:GetScene()
local game_scence_objs = game_scence:GetSceneObjList()
local num_objs = table.getn(game_scence_objs)
local sum_fish = table.getn(data_npc_id)
for i = 1, num_objs do
local npc_id = game_scence_objs[i]:QueryProp("ConfigID")
	for k = 1, sum_fish do
		if npc_id == data_npc_id[k] then
		return npc_id
		end
	end
end
return "null"
end