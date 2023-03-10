-- Các define cho THHT
require("form_stage_main\\form_tiguan\\form_tiguan_util")

local FORM_TIGUAN_MAIN = "form_stage_main\\form_tiguan\\form_tiguan_one"
local FORM_TIGUAN_CHOICE_BOSS = "form_stage_main\\form_tiguan\\form_tiguan_choice_boss"
local FORM_TIGUAN_DS_TRACE = "form_stage_main\\form_tiguan\\form_tiguan_ds_trace" -- Bảng thời gian khiêu chiến, nút mời hảo hữu
local FORM_SHORTCUT = "form_stage_main\\form_main\\form_main_shortcut"
local FORM_MAIN_SELECT = "form_stage_main\\form_main\\form_main_select"

local DO_TIGUAN_LEVEL = 1
local DO_TIGUAN_GUAN_ID = 1

local WINEXEC_PATH = "C:\\Users\\phant\\Desktop\\New\\test.exe"

-- Thiết lập auto, sau này sẽ căn cứ vào config để build ra
local cfg = {
	numTiguan = 4, -- Số cấp khiêu chiến 1 => 4
	numGuanPerTiguan = { -- Số thể lực sẽ đánh ở mỗi cấp
		[1] = 1,
		[2] = 6,
		[3] = 4,
		[4] = 4
	},
	doType = 2, -- 1 đánh ngược hoặc 2 đánh xuôi:
	dissMissLastGuan = 1, -- Bỏ thế lực cuối nếu không ra boss đỏ.
	allowWinExec = false, -- Đặt là TRUE để khởi chạy chức năng điều khiển bàn phím, chuột (bật cái này thì cần phải để nguyên chuột và bàn phím)
	continueArrest = 1, -- Tiếp tục đánh nếu boss tiếp theo đỏ mặc dù đã đạt giới hạn số thế lực
	breakOne = false, -- Đặt là true thì sẽ dừng lại khi đánh xong mỗi thế lực
	pauseOne = { -- Đặt là true thì sẽ dừng lại khi xong boss để tự mở rương
		[1] = false,
		[2] = false,
		[3] = false,
		[4] = false
	}
}
local dissMissLastGuan = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0
}
local stopPlusThisLevel = {
	[1] = false,
	[2] = false,
	[3] = false,
	[4] = false
}
local tiguanLimit = {
	[1] = 6,
	[2] = 6,
	[3] = 4,
	[4] = 4
}
local isRightMouseDown = false

function get_tiguan_record(array_name, child_name)
	return nx_execute(FORM_TIGUAN_MAIN, "get_tiguan_record", array_name, child_name)
end

function get_boss_id(guan_id, boss_index)
	return nx_execute(FORM_TIGUAN_MAIN, "get_boss_id", guan_id, boss_index)
end

function get_arrest_boss(level, guanname)
	local form = nx_value(FORM_TIGUAN_MAIN)
	if not nx_is_valid(form) then
	end

	for i = 1, 7 do
		local guan_id = nx_execute(FORM_TIGUAN_MAIN, "get_arrest_data", level, i, 1)
		local boss_id = nx_execute(FORM_TIGUAN_MAIN, "get_arrest_data", level, i, 2)
		local guan_name = nx_widestr("")

		local gui = nx_value("gui")
		if not nx_is_valid(gui) then
			return 0
		end
		local ui_ini = form.guan_ui_ini
		if not nx_is_valid(ui_ini) then
			return 0
		end
		local index = ui_ini:FindSectionIndex(guan_id)
		if index >= 0 then
			guan_name = nx_execute(FORM_TIGUAN_MAIN, "get_desc_by_id", ui_ini:ReadString(index, "Name", ""))
		end
		if guanname == guan_name then
			return gui.TextManager:GetText(boss_id)
		end
	end
	return nx_widestr("")
end

function get_do_tiguan(form)
	if not nx_is_valid(form) then
		return
	end
	for i = 1, 4 do
		-- Click chọn cấp khiêu chiến
		local btn_name = "rbtn_level_" .. tostring(i)
		local btn = form[btn_name]
		if not btn.Checked then
			btn.Checked = true
			nx_execute(FORM_TIGUAN_MAIN, "on_rbtn_level_checked_changed", btn)
			nx_pause(0.7)
		end
		-- Quét các đối thủ theo hướng tiến
		-- Kiểu đánh tiến thì cứ đánh theo thứ tự
		local pass_this_level = false
		local guan_do = 0

		for j = 1, tiguanLimit[i] do
			guan_do = j
			local array_name = "guan" .. nx_string(i) .. "sub" .. nx_string(j)
			local record_complete = nx_number(get_tiguan_record(array_name, "value7")) --0: Chưa mở; 1: Đã mở; 2: Đã đánh xong
			-- Đánh xong thế lực thứ j và j đã đạt mốc hoặc là đã đánh ít nhất một đối thủ và kiểu đánh ngược
			if record_complete == 2 and (j >= (cfg.numGuanPerTiguan[i] - dissMissLastGuan[i]) or cfg.doType == 1) then
				pass_this_level = true
				break
			elseif record_complete < 2 then
				break
			end
		end
		if not pass_this_level then
			return i, guan_do
		end
	end
	local i = 4
	while i >= 1 do
		-- Click chọn cấp khiêu chiến
		local btn_name = "rbtn_level_" .. tostring(i)
		local btn = form[btn_name]
		if not btn.Checked then
			btn.Checked = true
			nx_execute(FORM_TIGUAN_MAIN, "on_rbtn_level_checked_changed", btn)
			nx_pause(0.7)
		end

		local pass_this_level = false
		local guan_do = 0

		for j = 1, tiguanLimit[i] do
			guan_do = j
			local array_name = "guan" .. nx_string(i) .. "sub" .. nx_string(j)
			local record_complete = nx_number(get_tiguan_record(array_name, "value7")) -- 0: Chưa mở; 1: Đã mở; 2: Đã đánh xong
			-- Đánh xong thế lực thứ j và j đã đạt mốc
			if record_complete == 2 and j >= (cfg.numGuanPerTiguan[i] - dissMissLastGuan[i]) then
				-- Dừng đánh nếu có lệnh stop hoặc loại thế lực cuối, nếu không thử mở ra thế lực tiếp theo
				if dissMissLastGuan[i] > 0 or stopPlusThisLevel[i] or j >= tiguanLimit[i] or not cfg.continueArrest then
					pass_this_level = true
					break
				end
			elseif record_complete < 2 then
				break
			end
		end
		if not pass_this_level then
			return i, guan_do
		end
		i = i - 1
	end
	return false, false
end

function find_npc_pos(scene_id, search_npc_id)
  local mgr = nx_value("SceneCreator")
  if nx_is_valid(mgr) then
    local res = mgr:GetNearestNpcPos(scene_id, search_npc_id)
    if res ~= nil and table.getn(res) == 3 then
      return res[1], res[2], res[3]
    end
  end
  return -10000, -10000, -10000
end

function get_obj_actions(ident, action_id, isFull)
	local game_visual = nx_value("game_visual")
	local role = game_visual:GetSceneObj(nx_string(ident))
	if not nx_is_valid(role) then
		if action_id == nil then
			return {}
		else
			return false
		end
	end
	-- isFull: 0 chỉ có action cơ bản, 1 action cơ bản và acction cắt, 2 chỉ có action cắt
	if isFull == nil then
		isFull = 1
	end
	local actor_role = role:GetLinkObject("actor_role")
	if nx_is_valid(actor_role) then
	  role = actor_role
	end
	local mount_action_list = role:GetActionBlendList()
	local floor_count = table.maxn(mount_action_list)
	local action_name = ""
	local action_blended = false
	local action_unblending = false
	local action_loop = false
	local action_lists = {}

	for i = 0, floor_count - 1 do
		action_name = mount_action_list[i + 1]
	    action_blended = role:IsActionBlended(action_name)
	    action_unblending = role:IsActionUnblending(action_name)
	    action_loop = role:GetBlendActionLoop(action_name)
		if action_name == action_id then
			return true
		end
		if isFull == 0 or isFull == 1 then
			table.insert(action_lists, action_name)
		end
		if isFull == 1 or isFull == 2 then
			local action_name1 = nx_widestr(action_name)
			if nx_function("ext_ws_find", action_name1, nx_widestr("parrying_up")) > -1 then
				table.insert(action_lists, "parrying_up")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("hurt")) > -1 then
				table.insert(action_lists, "hurtdown")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("fi_stand")) > -1 then
				table.insert(action_lists, "fi_stand")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("fi_ready")) > -1 then
				table.insert(action_lists, "fi_ready")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("atk7")) > -1 then
				table.insert(action_lists, "atk7")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("datk2")) > -1 then
				table.insert(action_lists, "datk2")
			elseif nx_function("ext_ws_find", action_name1, nx_widestr("buffloop1")) > -1 then
				table.insert(action_lists, "buffloop")
			end
		end
	end
	if action_id == nil then
		return action_lists
	else
		return false
	end
end

function get_obj_actions_full(ident, action_id)
	return get_obj_actions(ident, action_id, 1)
end

function get_obj_actions_convert(ident, action_id)
	return get_obj_actions(ident, action_id, 2)
end

function activeRightMouse()
	if not cfg.allowWinExec then
		return
	end
	nx_function("ext_win_exec", WINEXEC_PATH .. " MOUSEDOWN")
end

function unActiveRightMouse()
	if not cfg.allowWinExec then
		return
	end
	nx_function("ext_win_exec", WINEXEC_PATH .. " MOUSEUP")
end

function getAllowUseSkill(bossName, actions)
	if in_array("hurtdown", actions) or (in_array("fi_stand", actions) and table.getn(actions) == 2) or in_array("fi_ready", actions) then
		return true
	end
	-- Cơ Lăng Phượng
	if bossName == "bosstg23005" then
		-- Viên Nguyệt Loan Khai
		if in_array("buffloop", actions) and in_array("atk7", actions) then
			return false
		end
	end
	-- Nam Cung Bình
	if bossName == "bosstg05004" then
		if in_array("buffloop", actions) then
			return false
		end
	end
	-- Yến Cô Hồng
	if bossName == "bosstg20004" then
		if in_array("buffloop", actions) and in_array("datk2", actions) then
			return false
		end
	end
	return true
end

local step = 1
local bossX = 0
local bossY = 0
local bossZ = 0
local bossName = ""
local bossScene = ""

while 1 do
	if step == 1 then
		-- Mở cái form THTH lên
		local form_tiguan_one = nx_value(FORM_TIGUAN_MAIN)
		while not nx_is_valid(form_tiguan_one) do
			util_auto_show_hide_form(FORM_TIGUAN_MAIN)
			form_tiguan_one = nx_value(FORM_TIGUAN_MAIN)
		end
		nx_pause(0.5)

		-- Xác định cấp hiện tại sẽ khiêu chiến
		-- Cho là 1 đi
		DO_TIGUAN_LEVEL = 1

		-- Thế lực sẽ khiêu chiến
		DO_TIGUAN_GUAN_ID = 1

		DO_TIGUAN_LEVEL, DO_TIGUAN_GUAN_ID = get_do_tiguan(form_tiguan_one)

		--if 1 then
		--	tools_show_notice(nx_widestr(DO_TIGUAN_LEVEL) .. nx_widestr(" - ") .. nx_widestr(DO_TIGUAN_GUAN_ID))
		--	return
		--end

		if DO_TIGUAN_LEVEL == false or DO_TIGUAN_GUAN_ID == false then
			tools_show_notice(nx_widestr("Da THTH xong, vui long thiet lap lai turn moi"))
			return
		end

		local array_name = "guan" .. nx_string(DO_TIGUAN_LEVEL) .. "sub" .. nx_string(DO_TIGUAN_GUAN_ID)
		local record_complete = nx_number(get_tiguan_record(array_name, "value7")) --0: Chưa mở; 1: Đã mở; 2: Đã đánh xong

		-- Click mở chọn ô
		if record_complete == 0 then
			local cbtn = form_tiguan_one["cbtn_arrestboss" .. DO_TIGUAN_GUAN_ID]
			nx_execute(FORM_TIGUAN_MAIN, "on_cbtn_arrestboss_click", cbtn)
			nx_pause(4)
		end

		local record_guan_id = nx_number(get_tiguan_record(array_name, "value1"))
		local record_boss_index = nx_number(get_tiguan_record(array_name, "value2"))
		local record_task_id = nx_number(get_tiguan_record(array_name, "value3"))
		local record_reset_spent = nx_number(get_tiguan_record(array_name, "value4"))
		local record_show = nx_number(get_tiguan_record(array_name, "value5"))
		local record_appraise = nx_number(get_tiguan_record(array_name, "value8"))
		local record_times = nx_number(get_tiguan_record(array_name, "value10")) -- Thời gian đánh con boss

		-- Xác định boss hiện tại
		local ui_ini = form_tiguan_one.guan_ui_ini
		if not nx_is_valid(ui_ini) then
			return 0
		end
		local gui = nx_value("gui")
		if not nx_is_valid(gui) then
			return 0
		end
		local guan_name_text = nx_widestr("")
		local index = ui_ini:FindSectionIndex(nx_string(record_guan_id))
		if index >= 0 then
			guan_name_text = nx_execute(FORM_TIGUAN_MAIN, "get_desc_by_id", ui_ini:ReadString(index, "Name", ""))
		end
		local boss_id = get_boss_id(nx_string(record_guan_id), nx_number(record_boss_index))
		local boss_name = gui.TextManager:GetText(boss_id)
		local arrest_boss_name = get_arrest_boss(DO_TIGUAN_LEVEL, guan_name_text)

		-- Thế lực khiêu chiến cuối cùng của cấp (thế lực này phải lớn hơn 1) và không phải boss đỏ, cấu hình bỏ nếu không có boss đỏ
		if arrest_boss_name ~= boss_name and DO_TIGUAN_GUAN_ID >= cfg.numGuanPerTiguan[DO_TIGUAN_LEVEL] and DO_TIGUAN_GUAN_ID > 1 and cfg.dissMissLastGuan == 1 then
			dissMissLastGuan[DO_TIGUAN_LEVEL] = 1
			--if 1 then
			--	return
			--end
		else
			--if 1 then
			--	tools_show_notice(nx_widestr(DO_TIGUAN_LEVEL) .. nx_widestr(" - ") .. nx_widestr(DO_TIGUAN_GUAN_ID))
			--	return
			--end

			-- Chọn boss đỏ nếu như cấp khiêu chiến số 4 và còn free 
			if arrest_boss_name ~= boss_name and form_tiguan_one.free_appoint == 1 and DO_TIGUAN_LEVEL == 4 then
				local btn = form_tiguan_one["btn_choice" .. DO_TIGUAN_GUAN_ID]
				nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", btn)
				nx_pause(0.8)

				local form = nx_value(FORM_TIGUAN_CHOICE_BOSS)
				if not nx_is_valid(form) then
					return 0
				end

				-- Bọn boss đỏ
				for i = 1, form.cur_gbox_count do
					local gbox = form.groupscrollbox_1:Find("gbox_choice_boss_" .. nx_string(i))
					if nx_is_valid(gbox) then
						local cbtn_select = gbox:Find("cbtn_choice_boss_select_" .. nx_string(i))
						local cbtn_label = gbox:Find("lbl_choice_boss_name_" .. nx_string(i))
						if nx_is_valid(cbtn_select) and nx_is_valid(cbtn_label) and cbtn_label.Text == arrest_boss_name then
							cbtn_select.Checked = true
						end
					end
				end
				nx_pause(0.5)

				-- Mỗi ngày chọn 1 đối thủ
				if form.free_appoint then
					form.cbtn_spent_item.Checked = true
					nx_pause(0.2)
				end

				local btn = form.btn_select
				nx_execute(FORM_TIGUAN_CHOICE_BOSS, "on_btn_select_click", btn)
			end

			-- Bắt đầu khiêu chiến
			-- Thời gian khiêu chiến hiện tại
			-- Kết thúc khiêu chiến còn
			local btn = form_tiguan_one.btn_start
			nx_execute(FORM_TIGUAN_MAIN, "on_btn_start_click", btn)
			step = 2
		end
	elseif step == 2 then
		-- Bỏ click chuột phải
		if isRightMouseDown then
			unActiveRightMouse()
			isRightMouseDown = false
		end
		-- Các thao tác khi đang khiêu chiến
		-- Đợi màn hình load xong, có form tính giờ bật lên
		local form = nil
		while not nx_is_valid(form) do
			nx_pause(0.1)
			form = nx_value(FORM_TIGUAN_DS_TRACE)
		end
		nx_pause(1)
		-- Xác định vị trí tọa độ con boss
		local finish_cdts = nx_value("tiguan_finish_cdts")
		if not nx_is_valid(finish_cdts) or finish_cdts:GetChildCount() < 1 then
		  return 0
		end
		local cdt_tab = finish_cdts:GetChildList()
		local gui = nx_value("gui")
		if not nx_is_valid(gui) then
		  return 0
		end
		local boss_place = nx_widestr("")
		for i = 1, table.getn(cdt_tab) do
		  local child = cdt_tab[i]
		  if nx_number(child.ismust) == 1 then
			boss_place = gui.TextManager:GetText("ui_tiguan_place_" .. nx_string(child.cdt_id))
		  end
		end
		local gui = nx_value("gui")
		if not nx_is_valid(gui) then
		  return 0
		end
		local front = nx_function("ext_ws_find", boss_place, nx_widestr("href=\""))
		local back = nx_function("ext_ws_find", boss_place, nx_widestr("\" style="))
		boss_place = nx_function("ext_ws_substr", boss_place, front + 6, back - 9)
		boss_place = nx_function("ext_split_string", nx_string(boss_place), ",")
		local x, y, z = find_npc_pos(boss_place[2], boss_place[3])

		bossX = x
		bossY = y
		bossZ = z
		bossName = boss_place[3]
		bossScene = boss_place[2]
		step = 3

		-- Di chuyển đến tọa độ con boss
		local direct_run = true
		while not tools_move_isArrived(x, y, z) do
			tools_move(boss_place[2], x, y, z, direct_run)
			direct_run = false
			nx_pause(0.7)
		end

		-- Tới chố con boss rồi thì xuống ngựa nếu đang cưỡi ngựa
		while get_buff_info("buf_riding_01") ~= nil do
			nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
			nx_pause(0.2)
		end
	elseif step == 3 then
		-- Kiểm tra lại chỗ đứng
		if not tools_move_isArrived_2D(bossX, bossY, bossZ, 3) then
			step = 2
		elseif not nx_is_valid(nx_value(FORM_TIGUAN_DS_TRACE)) then
			-- Mất cái form này có nghĩa là khiêu chiến thành công
			if cfg.pauseOne[DO_TIGUAN_LEVEL] then
				nx_function("ext_flash_window")
				step = 10
			else
				step = 4
			end
		else
			-- Target vào con boss, đợi boss bắt đầu đỏ lên thì xuất chiêu
			local isSelNPC = false
			local bossID = ""
			while not isSelNPC do
				local game_client = nx_value("game_client")
				if not nx_is_valid(game_client) then
					return false
				end
				local game_scence = game_client:GetScene()
				if not nx_is_valid(game_scence) then
					return false
				end
				local game_scence_objs = game_scence:GetSceneObjList()
				local game_scence_objsn = table.getn(game_scence_objs)
				local hasNPC = false
				for i = 1, game_scence_objsn do
					local obj = game_scence_objs[i]
					if obj:FindProp("Type") and obj:QueryProp("Type") == 4 and obj:FindProp("ConfigID") and obj:QueryProp("ConfigID") == bossName then
						hasNPC = true
						bossID = obj.Ident
						nx_execute("custom_sender", "custom_select", obj.Ident)
						break
					end
				end
				if not hasNPC then
					bossID = ""
					break
				end
				local form = nx_value(FORM_MAIN_SELECT)
				if nx_is_valid(form) and form.Visible == true and nx_find_custom(form, "role_actor2") and nx_is_valid(form.role_actor2) and form.lbl_name.Text == util_text(bossName) then
					isSelNPC = true
				else
					nx_pause(0.1)
				end
			end
			-- Kích hoạt chuột phải đỡ đòn
			if not isRightMouseDown then
				activeRightMouse()
				isRightMouseDown = true
			end
			-- Lệnh đánh con boss
			local obj = tools_getsceneobj_byid(bossID)
			if obj ~= false then
				local fight = nx_value("fight")
				local game_client = nx_value("game_client")
				local client_self = game_client:GetPlayer()
				local can_attack = fight:CanAttackNpc(client_self, obj)
				local actions = get_obj_actions_full(bossID)
				if can_attack then
					console(actions)
					console(bossName)
					local form = nx_value(FORM_SHORTCUT)
					local grid = form.grid_shortcut_main

					local game_shortcut = nx_value("GameShortcut")
					if nx_is_valid(game_shortcut) then
						local allowUseSkill = false
						-- Boss đỡ đòn thì xài skill phá def
						if in_array("parrying_up", actions) then
							allowUseSkill = true
							game_shortcut:on_main_shortcut_useitem(grid, 0, true)
						end
						if not cfg.allowWinExec or getAllowUseSkill(bossName, actions) == true then
							allowUseSkill = true
						end
						if allowUseSkill then
							-- Không có buff ôn thần, boss không bị ngã hoặc còn lại 5s thì mới xài
							local buffNC = get_buff_info("buf_CS_jl_shuangci07")
							if (buffNC == nil or buffNC < 5) and not in_array("hurtdown", actions) then
								allowUseSkill = true
								game_shortcut:on_main_shortcut_useitem(grid, 3, true)
							end
							game_shortcut:on_main_shortcut_useitem(grid, 1, true)
							game_shortcut:on_main_shortcut_useitem(grid, 2, true)
						end
					end
				end
			end
		end
	elseif step == 4 then
		if isRightMouseDown then
			unActiveRightMouse()
			isRightMouseDown = false
		end
		nx_pause(3)
		nx_execute("custom_sender", "custom_tiguan_request_leave")
		step = 5
	elseif step == 5 then
		local form_tiguan_one = nx_value(FORM_TIGUAN_MAIN)
		if nx_is_valid(form_tiguan_one) and form_tiguan_one.Visible == true then
			if cfg.breakOne then
				step = 10
			else
				step = 1
			end
			nx_pause(5)
		end
	else
		break
	end
	nx_pause(0.1)
end

nx_value("form_main_chat"):AddChatInfoEx(nx_widestr("HAHAHA"), CHATTYPE_SYSTEM, false)
