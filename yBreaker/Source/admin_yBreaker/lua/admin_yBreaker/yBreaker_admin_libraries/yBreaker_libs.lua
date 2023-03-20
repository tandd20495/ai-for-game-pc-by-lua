require("util_gui")
require("util_functions")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")

local inspect = require("admin_yBreaker\\yBreaker_admin_libraries\\inspect")

--Function to show notice
function yBreaker_show_notice(info, noticetype)
	if noticetype == nil then
		noticetype = 3
	end
	nx_value("SystemCenterInfo"):ShowSystemCenterInfo(info, noticetype)
end

-- Function for scene
function tools_getsceneobj_byid(id)
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return false
	end
	local client_scene_obj = game_client:GetSceneObj(nx_string(id))
	if not nx_is_valid(client_scene_obj) then
		return false
	end
	return client_scene_obj
end
function get_powerlevel(level)
  if nx_number(level) < 6 then
    return "tips_title_0"
  elseif nx_number(level) >= 151 then
    return "tips_title_151"
  elseif nx_number(level) >= 136 then
    return "tips_title_136"
  elseif nx_number(level) >= 121 then
    return "tips_title_121"
  end
  if 6 <= level % 10 then
  elseif 6 == 0 then
  else
  end
  return "tips_title_" .. nx_string(nx_int(level / 10 - 1) * 10 + 1)
end

-- Function for time
function get_second_from_text(text)
	local num
	local texttime
	--ui_minute=phút
	--ui_hour=Giờ
	--ui_day=Ngày
	--ui_second=s
	num = string.match(nx_string(text), "(%d+)")
	if num ~= nil then
		local cstart = string.len(num) + 1
		texttime = string.sub(nx_string(text), cstart, cstart)
		num = tonumber(num)

		if texttime == "N" or texttime == "n" then
			num = num * 86400
		elseif texttime == "G" or texttime == "g" then
			num = num * 3600
		elseif texttime == "P" or texttime == "p" then
			num = num * 60
		end

		return num
	end

	return nil
end

function tools_show_chat(...)
  local str = arg[1]
  local kenh = arg[2]
  	if kenh == nil then
		kenh = 1
	end
  nx_execute("custom_sender", "custom_chat", kenh, str)
end
function tools_difftime(t)
	if t == nil then
		return os.time()
	end
	return os.difftime(os.time(), t)
end
function in_array(item, array)
	for _,v in pairs(array) do
		if v == item then
			return true
		end
	end
	return false
end
function get_current_map()
	return nx_value("form_stage_main\\form_map\\form_map_scene").current_map
end
function console(str, isdebug)
	local file = io.open("C:\\log.txt", "a")
	if file == nil then
		nx_value("SystemCenterInfo"):ShowSystemCenterInfo(nx_widestr("Can't open file C:\\log.txt, please check this file!"), 3)
	else
		file:write(inspect(str))
		if isdebug ~= nil then
			file:write("\n")
			file:write(inspect(getmetatable(str)))
			file:write("\n--------------------------------------")
		end
		file:write("\n")
		file:close()
	end
end

-- nx_execute("auto_tools\\tool_libs", "console", str, debug)
-- GetPropList()

function tools_move(scene, x, y, z, passtest)
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		return false
	end
	local game_player = game_visual:GetPlayer()
	if not nx_is_valid(game_player) then
		return false
	end
	if passtest ~= nil and passtest == true then
		tools_show_notice(util_text("tool_start_findpath"))
		nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
		return true
	end
	local beforeX = string.format("%.3f", game_player.PositionX)
	local beforeY = string.format("%.3f", game_player.PositionY)
	local beforeZ = string.format("%.3f", game_player.PositionZ)
	nx_pause(1)
	local afterX = string.format("%.3f", game_player.PositionX)
	local afterY = string.format("%.3f", game_player.PositionY)
	local afterZ = string.format("%.3f", game_player.PositionZ)

	local pxd = beforeX - afterX
	local pyd = beforeY - afterY
	local pzd = beforeZ - afterZ

  	local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
  	if distance <= 0.6 then
		tools_show_notice(util_text("tool_start_findpath"))
		nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
  	end
end

function tools_move_isArrived(x, y, z, offset)
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		return false
	end
	local game_player = game_visual:GetPlayer()
	if not nx_is_valid(game_player) then
		return false
	end
	if offset == nil then
		offset = 1
	end

	local px = string.format("%.3f", game_player.PositionX)
	local py = string.format("%.3f", game_player.PositionY)
	local pz = string.format("%.3f", game_player.PositionZ)

	local pxd = px - x
	local pyd = py - y
	local pzd = pz - z

  	local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)

  	if offset >= distance then
  	  return true
  	end
  	return false
end

function get_buff_info(buff_id)
	-- Nếu tồn tại buff_id thì trả về thời gian của buff đó, nếu buff không có thời gian thì trả về -1
	-- Nếu không tồn tại buff thì thả về nil
	local form = nx_value("form_stage_main\\form_main\\form_main_buff")
	if not nx_is_valid(form) then
		return nil
	end

	for i = 1, 24 do
		if nx_string(form["lbl_photo" .. tostring(i)].buffer_id) == buff_id then
			local buff_time = get_second_from_text(form["lbl_time" .. tostring(i)].Text)
			if buff_time == nil then
				return -1
			else
				return buff_time
			end
		end
	end

	return nil
end

function print_r(t)
	local text_table = ""
	local print_r_cache = {}

	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			text_table = text_table .. indent .. "*" .. tostring(t) .. "\n"
		else
			print_r_cache[tostring(t)] = true

			if (type(t) == "table") then
				for pos, val in pairs(t) do
					if (type(val) == "table") then
						text_table = text_table .. indent.."["..pos.."] => "..tostring(t).." {" .. "\n"
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						text_table = text_table .. indent..string.rep(" ",string.len(pos)+6).."}" .. "\n"
					elseif (type(val)=="string") then
						text_table = text_table .. indent.."["..pos..'] => "'..val..'"' .. "\n"
					else
						text_table = text_table .. indent.."["..pos.."] => "..tostring(val) .. "\n"
					end
				end
			else
				text_table = text_table .. indent..tostring(t) .. "\n"
			end
		end
	end
	if (type(t)=="table") then
		text_table = text_table .. tostring(t).." {" .. "\n"
		sub_print_r(t,"    ")
		text_table = text_table .. "}" .. "\n"
	else
		sub_print_r(t,"    ")
	end
	return text_table
end

function auto_capture_qt(obj_list)
	if obj_list == nil then
		local game_client = nx_value("game_client")
		if not nx_is_valid(game_client) then
			return false
		end
		local game_scence = game_client:GetScene()
		if not nx_is_valid(game_scence) then
			return false
		end
		obj_list = game_scence:GetSceneObjList()
	end

	local obj_num = table.getn(obj_list)
	local has_qt = false
	for i = 1, obj_num do
		if obj_list[i]:FindProp("Type") and obj_list[i]:QueryProp("Type") == 4 and obj_list[i]:FindProp("ConfigID") then
			local npc_id = obj_list[i]:QueryProp("ConfigID")
			local qt_data = get_qt_data(npc_id)
			local npc_ident = nx_property(obj_list[i], "Ident")
			if qt_data ~= false and npc_ident ~= nil then
				-- Mở cái bảng nói chuyện
				local is_talking = false
				local num_select_NPC = 0
				while (is_talking == false and num_select_NPC < 30) do
					num_select_NPC = num_select_NPC + 1
					nx_execute("custom_sender", "custom_select", npc_ident)
					nx_pause(0.2)
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					is_talking = form_talk.Visible
				end

				-- Cuộc hội thoại nhận kỳ ngộ
				for j = 1, table.getn(qt_data) do
					nx_pause(0.6)
					nx_execute("form_stage_main\\form_talk_movie", "menu_select", qt_data[j])
				end

				nx_pause(1)

				-- Tắt cái form nói chuyện nếu có
				local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
				if form_talk.Visible == true then
					nx_execute("form_stage_main\\form_talk_movie", "menu_select", 843000005) -- Ta biết rồi
					nx_pause(0.2)
					nx_execute("form_stage_main\\form_talk_movie", "menu_select", 600000000) -- Để ta suy nghĩ lại
					nx_pause(0.2)
				end

				-- Tắt cái form nhận đồ
				nx_pause(0.2)
				local form_giveitems = util_get_form("form_stage_main\\form_give_item", true)
				if nx_is_valid(form_giveitems) then
					nx_pause(0.2)
					local form_giveitems1 = nx_value("form_stage_main\\form_give_item")
					if nx_is_valid(form_giveitems1) then
						nx_execute("form_stage_main\\form_give_item", "on_btn_mail_click", form_giveitems1.btn_mail)
					end
				end

				has_qt = true
				break
			end
		end
	end

	if has_qt == true then
		local game_client = nx_value("game_client")
		if not nx_is_valid(game_client) then
			return false
		end
		local game_scence = game_client:GetScene()
		if not nx_is_valid(game_scence) then
			return false
		end
		return game_scence:GetSceneObjList()
	else
		return obj_list
	end
end

function get_qt_data(npc_id)
	-- Thành Trường Nghĩa (Đả Cẩu Bổng)
	if npc_id == "gb340" then
		return {"841002737", "841002738", "840027381"}
	end
	-- Thù Di (Tham Hợp Chỉ)
	if npc_id == "Npc_qygp_chz_002" then
		return {"841006739", "840067390"}
	end
	-- Tiêu Dao Sơn Nhân (Thái Cực Quyền)
	if npc_id == "wd004" then
		return {"841001121", "841001122", "841001123", "840011231"}
	end
	-- Từ Lão Hán (Nữ Nhi Hồng x4)
	if npc_id == "npc_qygp_zy_xlh2" then
		return {"841004884", "841004885", "100011213", "101011213"}
	end
	-- Tiểu Mẫn (Thiết 1)
	if npc_id == "npc_qy_luxia_xiaomin_0" then
		return {"841005683", "100012257", "101012257"}
	end
	-- Tô Tú Vân (Thiết 2)
	--if npc_id == "WorldNpc01146" then
	--	return {"841001445", "840014451"}
	--end
	-- Ô Hạ (Nữ Nhi Hồng x4)
	if npc_id == "npc_qygp_cc_wu" then
		return {"841004886", "100018911", "101018911"}
	end
	-- Bốc Man Tài (Gà Nướng Trui)
	if npc_id == "NPC_qygp_bybukuai" then
		return {"841004952", "100018240", "101018240"}
	end
	-- Trần Tiểu Thành (Nghịch Thiên Tà Công)
	if npc_id == "funnpcskill002001" then
		return {"841004298", "841004299", "841004300", "840043000"}
	end
	-- Nhạc Minh Kha (Mảnh Thác Bản)
	if npc_id == "WorldNpc_qywx_007" then
		return {"841006152", "100010345", "101010345"}
	end
	-- Ngô Quỳnh (Kim Ngân Hoa)
	if npc_id == "Npc_qygp_chz_003" then
		return {"841006740", "840067400"}
	end
	-- Chồn con (Điêu nhung)
	--if npc_id == "npc_cwqy_cc_01" then
	--	return {"841004405", "100012222", "101012222"}
	--end
	-- La Sát Nữ (Tàn Dương)
	if npc_id == "qy_ng_cjbook_jh_202" then
		return {"841003673", "840036730"}
	end
	-- La Sát Nữ (Vô Vọng)
	if npc_id == "qy_ng_cjbook_jh_201" then
		return {"841003672", "840036720"}
	end
	-- La Sát Nữ (Tử Hà)
	--if npc_id == "qy_ng_cjbook_jh_204" then
	--	return {"841003675", "840036750"}
	--end
	-- Năng Chuyên Đô (Bệ Xảo 2)
	if npc_id == "WorldNpc09727" then
		return {"841001239", "840012391"}
	end
	-- Thành Bích Quân (Đả Cẩu Bổng)
	if npc_id == "WorldNpc09611" then
		return {"841001143", "841001072", "840010721"}
	end
	-- Tổ Hưng (Long Trảo Thủ)
	if npc_id == "WorldNpc00343" then
		return {"841001465", "841001466", "841001467", "841001517", "841001518", "841001519", "840015191"}
	end
	-- Lư Đại Thúc (Phệ Ma Tán)
	if npc_id == "npc_qygp_dy_wle" then
		return {"841004887", "100018763", "101018763"}
	end
	-- Võ tăng tuần tra (Long Trảo Thủ)
	if npc_id == "sl006" then
		return {"841000819", "841000820", "840008201"}
	end
	-- Dị Hương (Thái Cực Quyền)
	if npc_id == "wd061" then
		return {"841001313", "841001314", "840013141"}
	end
	-- Thanh Pháp (Long Trảo Thủ)
	if npc_id == "FuncNpc00718" then
		return {"841001330", "841001331", "841001332", "840013321"}
	end
	-- Lý Thu Hà (Thái Cực Quyền)
	if npc_id == "wd013" then
		return {"841001715", "840017151"}
	end
	-- Phan Thắng Dịch (Đả Cấu Bổng)
	if npc_id == "WorldNpc08409" then
		return {"841001661", "841001662", "840016621"}
	end
	-- Tằng Thị Lộc (Thái Cực Quyền)
	if npc_id == "WorldNpc10474" then
		return {"841001036", "841001795", "841001183", "840011831"}
	end
	-- Phú Thương Cát Tiền (Du mộc)
	if npc_id == "wd016" then
		return {"841000879", "841000936", "840009361"}
	end
	-- Kiếm Ngô Khu (Phệ Ma Tán)
	if npc_id == "NPC_qygp_tjq_jmy001" then
		return {"841004877", "841004878", "841004879", "841004880", "841004881", "841004882", "841004883", "100010930", "101010930"}
	end
	-- Bành Xương Quý (Đả Cẩu Bổng)
	if npc_id == "WorldNpc04349" then
		return {"841002465", "841002466", "841002467", "841002468", "841002470", "100017404", "101017404"}
	end
	-- Mật Lư - Trị Giang (Yết Chi Thượng Hạng) - Bỏ, rẻ rờ
	--if npc_id == "Npc_qygp_shl_002" then
		--return {"841008048", "841008049", "840080490"}
	--end
	return false
end

function tool_getPickForm()
	local PICK_FORM = "form_stage_main\\form_pick\\form_droppick"
	local waitCount = 0
	local isOkForm = false

	while 1 do
		local form = nx_value(PICK_FORM)
		if not nx_is_valid(form) or not form.Visible then
			return
		end
		waitCount = waitCount + 1
		if nx_find_custom(form, "readyTriggerPick") and form.readyTriggerPick then
			isOkForm = true
			break
		end
		if waitCount >= 20 then
			break
		end
		nx_pause(0.1)
	end

	if isOkForm then
		nx_pause(1)
		local form = nx_value(PICK_FORM)
		if nx_is_valid(form) and form.Visible then
			nx_execute(PICK_FORM, "on_btn_pick_click", form.btn_pick)
			nx_pause(0.1)
		end
	end
end

--new


function find_npc_pos(scene_id, search_npc_id) --  tìm npc trả về tọa độ xyz
  local mgr = nx_value("SceneCreator")
  if nx_is_valid(mgr) then
    local res = mgr:GetNearestNpcPos(scene_id, search_npc_id)
    if res ~= nil and table.getn(res) == 3 then
      return res[1], res[2], res[3]
    end
  end
  return -10000, -10000, -10000
end

function tools_move_isArrived_2D(x, z, d)
  local game_visual = nx_value("game_visual")
  local visual_player = game_visual:GetPlayer()
  if not nx_is_valid(visual_player) then
    return false
  end
  local X_player = visual_player.PositionX
  local Z_player = visual_player.PositionZ
  local distance = math.sqrt((Z_player - z) * (Z_player - z) + (X_player - x) * (X_player - x))
  if d >= distance then
    return true
  end
  return false
end
function tools_move_2D(x, z, y)
  local form_map = nx_value("form_stage_main\form_map\form_map_scene")
  if not nx_is_valid(form_map) then
    return
  end
  local path_finding = nx_value("path_finding")
  if not nx_is_valid(path_finding) then
    return
  end
  path_finding:FindPathScene(form_map.current_map, x, 0, z, 0)
end
function xuongngua()
while get_buff_info("buf_riding_01") ~= nil do
	nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
	nx_pause(0.2)
end
end

function item_count_id(iem_id) -- tìm số lượng item
local goods_grid = nx_value("GoodsGrid")
local item_count = goods_grid:GetItemCount(iem_id)
return item_count
end
function use_item_id(item_id) --sử dụng item
local tuido = util_get_form("form_stage_main\\form_bag", true, true)
if nx_is_valid(tuido) then
tuido:Show()
tuido.Visible = true
tuido.rbtn_tool.Checked = true
end
nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", item_id)
end
function find_buffer(buff_id) -- tìm buff chỉ trả về có hoặc không
if nx_function("find_buffer", nx_value("game_client"):GetPlayer(), buff_id) then
	return true
end
return false
end
function AutoSendNotice(info, noticetype)
 local info = nx_function("ext_utf8_to_widestr", info)
	if noticetype == nil then
		noticetype = 3
	end
	nx_value("SystemCenterInfo"):ShowSystemCenterInfo(info, noticetype)
end
function use_skill_id(skill_id)
local fight = nx_value("fight")
fight:TraceUseSkill(skill_id, false, false)
end
function  lvlup()
local game_client = nx_value("game_client")
local client_player = game_client:GetPlayer()
local cur_state = client_player:QueryProp("FacultyState") 
if nx_int(cur_state) == nx_int(0) then
	nx_execute("custom_sender", "custom_send_faculty_msg", 11) -- nhấn tiếp tục nội tu khi lên lvl
end
end
function  boss_info()
	-- Xác định vị trí tọa độ con boss thth
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
return x,y,z,bossName,bossScene		
end
function toado()
local game_visual = nx_value("game_visual")
local visual_player = game_visual:GetPlayer()
local x = visual_player.PositionX
local y = visual_player.PositionY
local z = visual_player.PositionZ
return x,y,z
end
function TargetLastNpc()
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return
  end
  local game_visual = nx_value("game_visual")
  local select_target_ident = client_player:QueryProp("LastObject")
  local select_target = game_client:GetSceneObj(nx_string(select_target_ident))
  if not nx_is_valid(select_target) then
    return
  end
  local visual_scene_object = game_visual:GetSceneObj(nx_string(select_target_ident))
  if nx_is_valid(visual_scene_object) then
    nx_execute("shortcut_game", "mouse_use_item", visual_scene_object, "left")
  end
end
function pickup_all_item()
  for i = 1, 10 do
    nx_execute("custom_sender", "custom_pickup_single_item", i)
  end
end
function gotoNpcById(npc_id, npc_x, npc_z, scene_id)
  local path_finding = nx_value("path_finding")
  if not nx_is_valid(path_finding) then
    return
  end
  if npc_id == "" then
    path_finding:FindPathScene(scene_id, npc_x, 0, npc_z, 0)
  else
    path_finding:TraceTargetByID(scene_id, npc_x, 0, npc_z, 1.8, npc_id)
  end
end