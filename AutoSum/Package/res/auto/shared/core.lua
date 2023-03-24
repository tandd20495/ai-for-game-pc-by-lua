require("util_functions")
require("share\\view_define")
require("util_gui")
require("share\\capital_define")
require("custom_sender")
require("form_stage_main\\form_die_util")
require("share\\client_custom_define")
require("define\\sysinfo_define")
require("form_stage_main\\form_tiguan\\form_tiguan_util")
require("util_static_data")
require("tips_data")
require("form_stage_main\\form_wuxue\\form_wuxue_util")
require("form_stage_main\\switch\\switch_define")
require("form_stage_main\\form_origin_new\\new_origin_define")
local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\util.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\task.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\message_manager.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\inspect.lua"))
local inspect = file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\mach.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\skill.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\equipment.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\shortcut.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\mail.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\form.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\tableinfo.lua"))
file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\constants.lua"))
file()


function console(str, isdebug)
	local file = io.open("D:\\console.txt", "a")
	if file == nil then
		nx_value("SystemCenterInfo"):ShowSystemCenterInfo(nx_widestr("Can't open file D:\\log.txt, please check this file!"), 3)
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

function getNpcById(id)
	local game_client = nx_value("game_client")
	local game_scence = game_client:GetScene()
	local game_scence_objs = game_scence:GetSceneObjList()
	for i = 1, table.getn(game_scence_objs) do
		if game_scence_objs[i]:FindProp("NpcType") and game_scence_objs[i]:QueryProp("ConfigID"):lower() == id:lower() then
			return game_scence_objs[i]
		end
	end
	return nil
end

function getNearestCanPickNpc(id, radian)
	local checking_radian = radian or 999
	local npc = nil
	local npc_pos = nil
	local distance = 999
	local game_client = nx_value("game_client")
	local game_scene = game_client:GetScene()
	if not nx_is_valid(game_scene) then
		return nil
	end
	local obj_lst = game_scene:GetSceneObjList()
	for i, obj in pairs(obj_lst) do
		local cfg = nx_string(obj:QueryProp("ConfigID"))
		local is_dead = obj:FindProp("Dead") and tostring(obj:QueryProp("Dead")) == "1"
		local can_pick = obj:FindProp("CanPick") and tostring(obj:QueryProp("CanPick")) == "1"
		if cfg == id and can_pick then
			local d, pos =  getDistanceToObj(obj)
			if distance > d and d < checking_radian then
				distance = d
				npc = obj
				npc_pos = pos
			end
		end
	end
	return npc, npc_pos
end

function pickup_all()
	local form = nx_value("form_stage_main\\form_pick\\form_droppick")
	if nx_is_valid(form) and form.Visible then
		nx_execute("form_stage_main\\form_pick\\form_droppick", "on_btn_pick_click", form.btn_pick)
		local bind = nx_value("form_stage_main\\form_itembind\\form_itembind_pickup")
		if nx_is_valid(bind) and bind.Visible then
			nx_execute("form_stage_main\\form_itembind\\form_itembind_pickup", "on_btn_bind_ok_click", bind.btn_bind_ok)
		end
		return true
	end
	return false
end

function getCanPickNpc(id, radian)
	local checking_radian = radian or 999
	local npc = 0
	local npc_pos = nil
	local distance = 999
	local game_client = nx_value("game_client")
	local game_scene = game_client:GetScene()
	if not nx_is_valid(game_scene) then
		return nil
	end
	local obj_lst = game_scene:GetSceneObjList()
	for i, obj in pairs(obj_lst) do
		local cfg = nx_string(obj:QueryProp("ConfigID"))
		local is_dead = obj:FindProp("Dead") and tostring(obj:QueryProp("Dead")) == "1"
		local can_pick = obj:FindProp("CanPick") and tostring(obj:QueryProp("CanPick")) == "1"
		if cfg == id and can_pick then
			local d, pos =  getDistanceToObj(obj)
			return obj, pos
		end
	end
	return npc, npc_pos
end

function getNpcByIdent(ident)
	local game_client = nx_value("game_client")
	local game_scence = game_client:GetScene()
	local game_scence_objs = game_scence:GetSceneObjList()
	for i = 1, table.getn(game_scence_objs) do
		if nx_string(game_scence_objs[i].Ident) == nx_string(ident) then
			return game_scence_objs[i]
		end
	end
	return nil
end

function getNpcByIdPattern(id)
	local game_client = nx_value("game_client")
	local game_scence = game_client:GetScene()
	local game_scence_objs = game_scence:GetSceneObjList()
	for i = 1, table.getn(game_scence_objs) do
		local npc = game_scence_objs[i]
		local npcId = npc:QueryProp("ConfigID")
		if npc:FindProp("NpcType") and string.find(npcId, id) then
			return game_scence_objs[i]
		end
	end
	return nil
end

function getNpcByIdExcludePos(id, posList)
	local game_client = nx_value("game_client")
	local game_scence = game_client:GetScene()
	local game_scence_objs = game_scence:GetSceneObjList()
	for i = 1, table.getn(game_scence_objs) do
		local obj = game_scence_objs[i]
		if obj:FindProp("NpcType") and obj:QueryProp("ConfigID") == id then
			-- check pos
			local valid = true
			for j = 1, table.getn(posList) do
				local checkPos = posList[j]
				if 	math.floor(obj.PosiX) == math.floor(checkPos[1])
				and math.floor(obj.PosiY) == math.floor(checkPos[2])
				and math.floor(obj.PosiZ) == math.floor(checkPos[3]) then
					valid = false
					break
				end
			end
			if valid then
				return obj
			end
		end
	end
	return nil
end

function getAnyNpcByIds(ids)
	local game_client = nx_value("game_client")
	local game_scence = game_client:GetScene()
	local game_scence_objs = game_scence:GetSceneObjList()
	local result = nil
	local configId = nil
	for i = 1, table.getn(game_scence_objs) do
		configId = game_scence_objs[i]:QueryProp("ConfigID")
		if game_scence_objs[i]:FindProp("NpcType") and ids[configId] then
			result = game_scence_objs[i]
			break
		end
	end
	return result, configId
end

function getCanAttackNpcById(ids)
	local game_client = nx_value("game_client")
	local game_scence = game_client:GetScene()
	local game_scence_objs = game_scence:GetSceneObjList()
	local result = nil
	local configId = nil
	for i = 1, table.getn(game_scence_objs) do
		configId = game_scence_objs[i]:QueryProp("ConfigID")
		if game_scence_objs[i]:FindProp("NpcType") and ids[configId] and can_attack(configId) then
			result = game_scence_objs[i]
			break
		end
	end
return result, configId
end

function getAnyNpcHasSkillById(ids, skill_id)
	local game_client = nx_value("game_client")
	local game_scence = game_client:GetScene()
	local game_scence_objs = game_scence:GetSceneObjList()
	local result = nil
	for i = 1, table.getn(game_scence_objs) do
		local obj = game_scence_objs[i]
		local configId = obj:QueryProp("ConfigID")
		if obj:FindProp("NpcType") and ids[configId] and obj:QueryProp("CurSkillID") == "skill_hs_dy_06" then
			result = obj
			break
		end
	end
	return result
end

function clickNpcByName(name)
	local npcIdent = getNpcIdentByName(name)
	if npcIdent == nil then
		return false
	end
	target_npc_by_ident(npcIdent)
end

function getNpcIdentByName(npc_name)
	local game_client = nx_value("game_client")
	local game_scene = game_client:GetScene()
	if not nx_is_valid(game_scene) then
		return nil
	end
	local client_obj_lst = game_scene:GetSceneObjList()
	for i = 1, #client_obj_lst do
		local obj_type = client_obj_lst[i]:QueryProp("NpcType")
		local obj_dead = client_obj_lst[i]:QueryProp("Dead")
		if obj_type ~= 0 and obj_dead ~= 1 then
			local obj_id = client_obj_lst[i]:QueryProp("ConfigID")
			if nx_string(obj_id) ~= nx_string("0") then
				local obj_name = util_text(nx_string(obj_id))
				if obj_name == utf8ToWstr(npc_name) then
					return client_obj_lst[i].Ident
				end
			end
		end
	end
	return nil
end

function getPlayerByName(name)
	local game_client = nx_value("game_client")
	local game_scene = game_client:GetScene()
	if not nx_is_valid(game_scene) then
		return nil
	end
	local client_obj_lst = game_scene:GetSceneObjList()
	for i = 1, #client_obj_lst do
		if client_obj_lst[i]:FindProp("Name") 
			and nx_string(client_obj_lst[i]:QueryProp("Name")) == nx_string(name) then
			return client_obj_lst[i]
		end
	end
	return nil
end

function targetPlayerByName(name)
	local player = getPlayerByName(name)
	if player == nil then
		return false
	end
	target_npc_by_ident(player.Ident)
end

function can_attack(npcId)
	local is_can_attack = nil 
	local npc = getNpcById(npcId)
	if npc ~= nil then
		local game_client = nx_value('game_client')
		local client_player = game_client:GetPlayer()
		local obj_type = nx_number(npc:QueryProp('Type'))
		
		if obj_type == 4 then 
			is_can_attack = nx_value('fight'):CanAttackNpc(client_player, npc)
		elseif obj_type == 2 then 
			is_can_attack = nx_value('fight'):CanAttackPlayer(client_player, npc)
		end
	end
	return is_can_attack
end

function target_npc(id)
	local npc = getNpcById(id)
	if npc ~= nil then
		nx_execute("custom_sender", "custom_select", npc.Ident)
		nx_pause(0.5)
	end
end

function target_npc_by_ident(ident)
	if ident ~= nil then
		nx_execute("custom_sender", "custom_select", ident)
		nx_pause(0.5)
	end
end

function convert_pos_to_id(checkPos)
	local cX, cY, cZ = checkPos[1], checkPos[2], checkPos[3]
	local game_client = nx_value("game_client")
	local game_scence = game_client:GetScene()
	local game_scence_objs = game_scence:GetSceneObjList()
	for i = 1, table.getn(game_scence_objs) do
		local object = game_scence_objs[i]
		local x, y, z = object.PosiX, object.PosiY, object.PosiZ
		if object:FindProp("NpcType") then
			if x ~= nil and y ~= nil and z ~= nil and math.floor(x) == math.floor(cX) and math.floor(y) == math.floor(cY) and math.floor(z) == math.floor(cZ) then
				return object:QueryProp("ConfigID")
			end
		end
	end
	return nil
end

function can_talk(configId)
	local npc = getNpcById(configId)
	if npc ~= nil then 
		nx_execute("custom_sender", "custom_select", npc.Ident)
		nx_pause(0.5)
		local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
		return nx_is_valid(form_talk) and form_talk.Visible
	end
	return false
end

function talk(configId, choices, isStarted)
	local npc = getNpcById(configId)
	if npc ~= nil then 
		-- local dis = getDistanceToObj(npc)
		-- if dis > 3 then return end
		local is_talking = false
		while isStarted() and not is_talking do
			nx_execute("custom_sender", "custom_select", npc.Ident)
			if unexpected_condition then
				nx_pause(1)
			else
				nx_pause(0.5)
			end
			
			local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
			if nx_is_valid(form_talk) then
				is_talking = form_talk.Visible				
			else
				SendNotice("Anh là ai tôi không biết anh, anh đi ra đi", 3)
				is_talking = true
			end
		end
		nx_pause(0.5)
		local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
		
		if nx_is_valid(form_talk) then
			for i = 1, table.getn(choices) do
				local menu_id = form_talk.mltbox_menu:GetItemKeyByIndex(choices[i])
				nx_execute("form_stage_main\\form_talk_movie", "menu_select", menu_id)
				nx_pause(1)
			end
		end
	end
end

function talk_Hoa(configId, choices, isStarted)
	local npc = getNpcById(configId)
	local dem = 0
	if npc ~= nil then 
		-- local dis = getDistanceToObj(npc)
		-- if dis > 3 then return end
		local is_talking = false
		while isStarted() and not is_talking do
	
			nx_execute("custom_sender", "custom_select", npc.Ident)
			if unexpected_condition then
				nx_pause(1)
			else
				nx_pause(0.5)
			end
			
			local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
			if nx_is_valid(form_talk) then
		
				dem = dem + 1
			if(dem == 5) then
			is_talking = true	
			end 	
			
			else
				SendNotice("Anh là ai tôi không biết anh, anh đi ra đi", 3)
				is_talking = true
			end
			
		end
		nx_pause(0.5)
		local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
		
		if nx_is_valid(form_talk) then
			for i = 1, table.getn(choices) do
				local menu_id = form_talk.mltbox_menu:GetItemKeyByIndex(choices[i])
				nx_execute("form_stage_main\\form_talk_movie", "menu_select", menu_id)
				nx_pause(1)
			end
		end
	end
end
function talk_ident(ident, choices, isStarted)
	local is_talking = false
	while isStarted() and not is_talking do
		nx_execute("custom_sender", "custom_select", ident)
		if unexpected_condition then
			nx_pause(1)
		else
			nx_pause(0.5)
		end
		local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
		if nx_is_valid(form_talk) then
			is_talking = form_talk.Visible
		else
			SendNotice("Anh là ai tôi không biết anh, anh đi ra đi", 3)
			is_talking = true
		end
	end
	nx_pause(0.5)
	local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
	if nx_is_valid(form_talk) then
		for i = 1, table.getn(choices) do
			local menu_id = form_talk.mltbox_menu:GetItemKeyByIndex(choices[i])
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", menu_id)
			nx_pause(1)
		end
	end
end

function talk_id(configId, choices, isStarted)
	local npc = getNpcById(configId)
	if npc ~= nil then 
		local is_talking = false
		while isStarted() and not is_talking do
			nx_execute("custom_sender", "custom_select", npc.Ident)
			if unexpected_condition then
				nx_pause(1)
			else
				nx_pause(0.5)
			end
			local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
			if nx_is_valid(form_talk) then
				is_talking = form_talk.Visible
			else
				SendNotice("Anh là ai tôi không biết anh, anh đi ra đi", 3)
				is_talking = true
			end
		end
		nx_pause(0.5)
		local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
		if nx_is_valid(form_talk) then
			for i = 1, table.getn(choices) do
				nx_execute("form_stage_main\\form_talk_movie", "menu_select", choices[i])
				nx_pause(1)
			end
		end
	end
end

function talk_to(npcInfo, menuInfo, use_tele)
	local talk_menu = menuInfo or npcInfo.menu
	local tele = use_tele == nil and true
	local sock = nx_value("game_sock")
	local form = util_get_form("form_stage_main\\form_talk_movie", true)
	if not nx_is_valid(form) or not form.Visible then
		form = util_get_form("form_stage_main\\form_talk", true)
	end
	if nx_is_valid(form) and form.Visible then
		local ident = form.npcid
		for i = 1, table.getn(talk_menu) do
			nx_pause(1)
			--sock.Sender:Select(nx_string(ident), nx_int(menu))
			nx_execute("form_stage_main\\form_talk_movie", "menu_select", talk_menu[i])
		end
	end
	if LayMapHienTai() == npcInfo.mapId then
		local pos = npcInfo.pos or get_npc_pos(npcInfo.mapId, npcInfo.id)
		if arrived(pos, 1) then
			add_chat_info("arrived")
			if npcInfo.id then
				target_npc(npcInfo.id)
			elseif npcInfo.name then
				clickNpcByName(npcInfo.name)
			end
			return 101
		else
			add_chat_info("moving")
			move_scene(pos, npcInfo.mapId, 0)
			return 102
		end
	else
		if npcInfo.tusatquayve then
			local client = nx_value("game_client")
    	local client_player = client:GetPlayer()
			if client_player and client_player:FindProp("Dead") and client_player:QueryProp("Dead") == 1  then
				-- hoi sinh ve mon phai
				nx_execute("custom_sender", "custom_relive", 0, 0)
			elseif not nx_function("find_buffer", client_player, "buf_CS_jh_tmjt06") then
				tu_sat()
			end
		elseif tele then
			tele_ve_map(npcInfo.mapId)
		else 
			local pos = npcInfo.pos or get_npc_pos(npcInfo.mapId, npcInfo.id)
			move(pos, 0)
		end
		return 103
	end
end

function comfirm_talk()
	local form = util_get_form("form_stage_main\\form_talk", true)
	if nx_is_valid(form) then
		nx_execute("form_stage_main\\form_talk", "on_menu_func_select", form.mltbox_menu_func, 0)
		nx_pause(10)
	end
end

function debug_talk(configId, choices, isStarted)
	local npc = getNpcById(configId)
	if npc ~= nil then 
		local is_talking = false
		while isStarted() and not is_talking do
			nx_execute("custom_sender", "custom_select", npc.Ident)
			if unexpected_condition then
				nx_pause(1)
			else
				nx_pause(0.5)
			end
			local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
			if nx_is_valid(form_talk) then
				is_talking = form_talk.Visible
			else
				SendNotice("Anh là ai tôi không biết anh, anh đi ra đi", 3)
				is_talking = true
			end
		end
		nx_pause(0.5)
		local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
		if nx_is_valid(form_talk) then
			for i = 1, table.getn(choices) do
				local menu_id = form_talk.mltbox_menu:GetItemKeyByIndex(choices[i])
				local str = nx_widestr("TASKID: ") ..nx_widestr(menu_id) .. nx_widestr("    IDENT: ") .. nx_widestr(npc.Ident) .. nx_widestr("    CFG: ") ..nx_widestr(configId)
				console(nx_string(str))
				nx_execute("form_stage_main\\form_talk_movie", "menu_select", menu_id)
				nx_pause(0.3)
			end
		end
	end
end

function arrived(pos, d)
  local game_visual = nx_value("game_visual")
	if 
		not nx_is_valid(game_visual) 
		or pos == nil
		or pos[1] == nil
		or pos[2] == nil
		or pos[3] == nil
	then
    return false
  end
  local game_player = game_visual:GetPlayer()
  if not nx_is_valid(game_player) or game_player == nil then
    return false
  end
  if d == nil then
		d = 3
  end
  local px = string.format("%.3f", game_player.PositionX)
  local py = string.format("%.3f", game_player.PositionY)
	local pz = string.format("%.3f", game_player.PositionZ)
  local pxd =  nx_float(px) - nx_float(pos[1])
  local pyd =  nx_float(py) - nx_float(pos[2])
  local pzd =  nx_float(pz) - nx_float(pos[3])
	local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
	add_chat_info("distance: " ..tostring(distance))
  if d >= distance then
    return true
  end
  return false
end

function getDistanceTo(pos)
	local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return false
  end
  local game_player = game_visual:GetPlayer()
  if not nx_is_valid(game_player) then
    return false
  end
  local px = string.format("%.3f", game_player.PositionX)
  local py = string.format("%.3f", game_player.PositionY)
  local pz = string.format("%.3f", game_player.PositionZ)
  local pxd =  nx_float(px) - nx_float(pos[1])
  local pyd =  nx_float(py) - nx_float(pos[2])
  local pzd =  nx_float(pz) - nx_float(pos[3])
  local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
  return distance
end

function getDistanceToObj(obj)
	local vObj = getVisualObj(obj)
	if not nx_is_valid(vObj) then
		return 9999999999
	end
	local pos = {vObj.PositionX, vObj.PositionY, vObj.PositionZ}
	local distance = getDistanceTo(pos)
	return distance, pos
end


function jump_to(pos, prefix)
	prefix = prefix or ""
	local role = nx_value("role")
	if not arrived(pos, 0.5) and nx_is_valid(role) then
		local x = nx_float(pos[1])
		local y = nx_float(pos[2])
		local z = nx_float(pos[3])
		local px = string.format("%.3f", nx_string(x))
		local py = string.format("%.3f", nx_string(y))
		local pz = string.format("%.3f", nx_string(z))
		add_chat_info(prefix.."Jumping to " .."X:" ..px .." Y:"..py .." Z:" ..pz)
		local game_visual = nx_value("game_visual")
		local role = nx_value("role")
		local scene_obj = nx_value("scene_obj")
		scene_obj:SceneObjAdjustAngle(role, x, z)
		role.move_dest_orient = role.AngleY
		role.server_pos_can_accept = true
		-- game_visual:SwitchPlayerState(role, 1, 5)
		-- game_visual:SwitchPlayerState(role, 1, 6)
		-- game_visual:SwitchPlayerState(role, 1, 7)
		-- if y > role.PositionY then
		  role:SetPosition(role.PositionX, y, role.PositionZ)
		-- end
		game_visual:SetRoleMoveDestX(role, x)
		game_visual:SetRoleMoveDestY(role, y)
		game_visual:SetRoleMoveDestZ(role, z)
		game_visual:SetRoleMoveDistance(role, 50)
		game_visual:SetRoleMaxMoveDistance(role, 1)
		game_visual:SwitchPlayerState(role, 1, 103)
		nx_pause(2)
	end
end

function jump_to_next()
	local game_visual = nx_value("game_visual")
	local role = nx_value("role")
	local pos = getDest(getPlayer())
	jump_to(pos)
end

function jump_to_the_air()
	local role = nx_value("role")
	local game_visual = nx_value("game_visual")
	game_visual:SwitchPlayerState(role, 1, 5)
	nx_pause(0.7)
	game_visual:SwitchPlayerState(role, 1, 6)
	nx_pause(0.7)
	game_visual:SwitchPlayerState(role, 1, 7)
end

function jump_to_arrived(pos, isStarted, prefix)
	prefix = prefix or ""
	local form_map = nx_value("form_stage_main\\form_map\\form_map_scene")
	local game_visual = nx_value("game_visual")
	if
		pos == nil
		or pos[1] == nil 
		or pos[2] == nil 
		or pos[3] == nil 
		or not nx_is_valid(game_visual) 
		or nx_is_valid(nx_value("form_common\\form_loading")) 
	then
		return nil
	end
	local game_player = game_visual:GetPlayer()
	if not nx_is_valid(game_player) or game_player == nil 
		or not nx_is_valid(nx_value("path_finding"))
		or form_map == nil 
		or not nx_is_valid(form_map)
		or form_map.current_map == nil 
		--or not nx_is_valid(form_map.current_map)
	then
		return nil
	end
	if ____last_move_time == nil then
		____last_move_time = os.time()
	end
	local currentTime = os.time()
	local diff_time = currentTime -  ____last_move_time
	local x, y, z = nx_float(pos[1]), nx_float(pos[2]), nx_float(pos[3])
	local fx, fy, fz = nx_string(x),nx_string(y), nx_string(z)
	fx, fy, fz = string.format("%.3f", fx), string.format("%.3f", fy), string.format("%.3f", fz)
	if passtest ~= nil and passtest == true then
		add_chat_info(prefix.."Jumping to " .."X:" ..fx .." Y:"..fy .." Z:" ..fz)
		jump_to(pos)
	else
		local beforeX = string.format("%.3f", game_player.PositionX)
		local beforeY = string.format("%.3f", game_player.PositionY)
		local beforeZ = string.format("%.3f", game_player.PositionZ)
		nx_pause(1)
		if nx_is_valid(nx_value("form_common\\form_loading")) then 
			return nil 
		end
		local afterX = string.format("%.3f", game_player.PositionX)
		local afterY = string.format("%.3f", game_player.PositionY)
		local afterZ = string.format("%.3f", game_player.PositionZ)

		local pxd = beforeX - afterX
		local pyd = beforeY - afterY
		local pzd = beforeZ - afterZ

		local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
		if distance <= 0.6 then
			add_chat_info(prefix.."Jumping to " .."X:" ..fx .." Y:"..fy .." Z:" ..fz)
			show_head_message("Stop: "..nx_string(diff_time), 10000)
			--nx_pause(2)
			local game_client = nx_value("game_client")
			local player = game_client:GetPlayer()
			local state = player:QueryProp("State")
			if nx_string(state) == "" or state == nil or state == 0 then
				jump_to(pos)
			end
		else
			if has_buff('buf_riding_01') and not has_buff("buf_riding_spurt01") then
				nx_execute("custom_sender", "custom_send_ride_skill", "riding_jiben")
			end
			____last_move_time = os.time()
		end
	end
	return diff_time
end

function pick_item(id)
	local game_client = nx_value("game_client")
	local player = game_client:GetPlayer()
	local item = getNpcById(id)
	if item ~= nil then
		nx_execute("custom_sender", "custom_select", item.Ident)
		nx_pause(1)
		while player:QueryProp("LogicState") ~= 0 do
			nx_pause(1)
		end
		nx_execute("custom_sender", "custom_pickup_single_item", 1)
		nx_execute("custom_sender", "custom_pickup_single_item", 2)
		nx_execute("custom_sender", "custom_pickup_single_item", 3)
		nx_execute("custom_sender", "custom_pickup_single_item", 4)
	end
end

function pick_item_by_ident(ident)
	local game_client = nx_value("game_client")
	local player = game_client:GetPlayer()
	nx_execute("custom_sender", "custom_select", ident)
	while player:QueryProp("LogicState") == 104 do -- dang hai'
		nx_pause(0.3)
	end
	nx_execute("custom_sender", "custom_pickup_single_item", 1)
	nx_execute("custom_sender", "custom_pickup_single_item", 2)
	nx_execute("custom_sender", "custom_pickup_single_item", 3)
end

function pick_item_by_click(pos, id, indexes)
	click(pos, id)
	local game_client = nx_value("game_client")
	local player = game_client:GetPlayer()
	while player:QueryProp("LogicState") == 104 do -- dang hai'
		nx_pause(0.3)
	end
	for i = 1, table.getn(indexes) do
		nx_execute("custom_sender", "custom_pickup_single_item", indexes[i])
	end
end

function has_buff(buffId)
	local client = nx_value("game_client")
	local game_player = client:GetPlayer()
	return nx_function("find_buffer", game_player, buffId)
end

function remove_buff(buff_id)
	if has_buff(buff_id) then
		nx_execute("custom_sender", "custom_remove_buffer", buff_id)
	end
end

function target_has_buff(targetId, buffId)
	local npc = getNpcById(targetId)
	return nx_function("find_buffer", npc, buffId)
end

function split(source, delimiters)
	local elements = {}
	local pattern = '([^'..delimiters..']+)'
	string.gsub(source, pattern, function(value) elements[#elements + 1] =     value;  end);
	return elements
end
  
function buff_stack(targetId, buff_id)
	local buffInfoCount = 1
	local target = getNpcById(targetId)
	if target ~= nil and target_has_buff(targetId, buff_id) then
		local buffInfo = target:QueryProp("BufferInfo"..nx_string(buffInfoCount))
		while buffInfo ~= nil and buffInfo ~= "" do
			local info = split(buffInfo, ",|")
			if info[1] == nx_string(buff_id) then 
				return info[#info]
			end
			buffInfoCount = buffInfoCount + 1
			buffInfo = target:QueryProp("BufferInfo"..nx_string(buffInfoCount))
		end
	end
	return 0
end

function my_buf_stack(buff_id)
	local buffInfoCount = 0
		local player = getPlayer()
		while buffInfoCount < 20 and nx_is_valid(player) do
			nx_pause(0)
			local has_buffInfo = player:FindProp("BufferInfo"..nx_string(buffInfoCount))
			if has_buffInfo and nx_is_valid(player) then
				local buffInfo = player:QueryProp("BufferInfo"..nx_string(buffInfoCount))
				local info = split(nx_string(buffInfo), ",|")
				if info[1] == nx_string(buff_id) then
					return info[#info]
				end
			end
			buffInfoCount = buffInfoCount + 1
			player = getPlayer()
		end
end

function get_item_amount(id, viewId, all)
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return 0
	end
	local view = game_client:GetView(nx_string(viewId))
	if not nx_is_valid(view) then
		return 0
	end
	local amount = 0
	local viewobj_list = view:GetViewObjList()
	for index, view_item in pairs(viewobj_list) do
		if view_item:QueryProp("ConfigID") == id then
			amount = amount + view_item:QueryProp("Amount")
			if not all then
				return amount
			end
		end
	end
	return amount
end

function has_item(id, viewId, status)
	--status 1: khoa, 0: khong khoa, nil: khong check
	if viewId == 2 then
		dung_vat_pham("noop", 0,0)
	elseif viewId == 125 then
		dung_item_nhiem_vu("noop", 0, 0)
	elseif viewId == 123 then
		dung_nguyen_lieu("noop", 0, 0)
	end
	local game_client = nx_value("game_client")
	local view = game_client:GetView(nx_string(viewId))
	local viewobj_list = view:GetViewObjList()
	for index, view_item in pairs(viewobj_list) do
		local configId =  view_item:QueryProp("ConfigID")
		if configId ~= nil and string.find(configId, id) then
			if
				(status == 1 and view_item:FindProp("BindStatus"))
				or (status == 0 and not view_item:FindProp("BindStatus"))
				or status == nil
			then
				return true, configId
			end
		end
	end
	return false
end

function delete_item_by_id(id, viewId, amount)
	local goods_grid = nx_value("GoodsGrid")
	if not nx_is_valid(goods_grid) then
		return
	end
	local grid, grid_index = goods_grid:GetToolBoxGridAndPos(id)
	if grid ~= nil then
		local view_index = grid:GetBindIndex(grid_index)
		nx_execute("custom_sender", "custom_delete_item", viewId, view_index, amount)
	end
end

function currentPos()
	local game_visual = nx_value("game_visual")
	if not nx_is_valid(game_visual) then
		return nil
	end
	local game_player = game_visual:GetPlayer()
	if not nx_is_valid(game_player) then
		return nil
	end
	return {game_player.PositionX, game_player.PositionY, game_player.PositionZ}
end

function changeAcc(userName)
	local game_config = nx_value("game_config")
	game_config.login_account = nx_string(userName)
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

function dung_vat_pham(id, count, delay, pick_indices)
	util_show_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	local form = util_get_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	if nx_is_valid(form) and form.Visible then
		form.rbtn_tool.Checked = true
		nx_pause(0.5)
		nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
		nx_pause(0.5)
		for i = 1, count do
			nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", id)
			nx_pause(delay or 0)
			if pick_indices ~= nil then
				for i = 1, table.getn(pick_indices) do
					nx_execute("custom_sender", "custom_pickup_single_item", pick_indices[i])
				end
			end
		end
	end
end

function dung_vat_pham_tracking(isStarted, id, amount, delay, pick_indices)
	util_show_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	local form = util_get_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	form.rbtn_tool.Checked = true
	nx_pause(0.5)
	nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_tool)
	nx_pause(0.5)
	local count = 1
	while isStarted() and count <= amount do
		nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", id)
		if pick_indices ~= nil then
			for i = 1, table.getn(pick_indices) do
				nx_execute("custom_sender", "custom_pickup_single_item", pick_indices[i])
			end
		end
		count = count + 1
		nx_pause(delay or 0)
	end
end

function dung_item_nhiem_vu(id, count, delay)
	util_show_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	local form = util_get_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	form.rbtn_task.Checked = true
	nx_pause(0.5)
	nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_task)
	nx_pause(0.5)
	nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", id)
	nx_pause(delay or 0)
end

function dung_nguyen_lieu(id, count, delay)
	util_show_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	local form = util_get_form("form_stage_main\\form_bag", true)
	nx_pause(0.5)
	form.rbtn_material.Checked = true
	nx_pause(0.5)
	nx_execute("form_stage_main\\form_bag", "on_rbtn_checked_changed", form.rbtn_material)
	nx_pause(0.5)
	nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", id)
	nx_pause(delay)
end

function use_skill(skillId)
	local fight = nx_value("fight")
	fight:TraceUseSkill(skillId, false, false)
end

function stop_moving()
	local path_finding = nx_value("path_finding")
	if not nx_is_valid(path_finding) then
		return
	end
	path_finding:StopPathFind(1)
end

local ____last_move_time
function move(pos, d, msg_pre, passtest)
	local form_map = nx_value("form_stage_main\\form_map\\form_map_scene")
	local game_visual = nx_value("game_visual")
	if
		pos == nil
		or pos[1] == nil 
		or pos[2] == nil 
		or pos[3] == nil 
		or not nx_is_valid(game_visual) 
		or nx_is_valid(nx_value("form_common\\form_loading")) 
	then
		return nil
	end
	local game_player = game_visual:GetPlayer()
	if not nx_is_valid(game_player) or game_player == nil 
		or not nx_is_valid(nx_value("path_finding"))
		or form_map == nil 
		or not nx_is_valid(form_map)
		or form_map.current_map == nil 
		--or not nx_is_valid(form_map.current_map)
	then
		return nil
	end
	if ____last_move_time == nil then
		____last_move_time = os.time()
	end
	local currentTime = os.time()
	local diff_time = currentTime -  ____last_move_time
	local x, y, z = nx_float(pos[1]), nx_float(pos[2]), nx_float(pos[3])
	local fx, fy, fz = nx_string(x),nx_string(y), nx_string(z)
	fx, fy, fz = string.format("%.3f", fx), string.format("%.3f", fy), string.format("%.3f", fz)
	if msg_pre == nil then msg_pre = "Den Vi Tri: " end
	if passtest ~= nil and passtest == true then
		add_chat_info(msg_pre .."X:"..fx.." Y:"..fy.." Z:"..fz)
		--____last_move_time = os.time()
		nx_value("path_finding"):FindPathScene(form_map.current_map, x, y, z, 0)
		--nx_value("path_finding"):FindPath(x, -10000, z, 0)
	else
		local beforeX = string.format("%.3f", game_player.PositionX)
		local beforeY = string.format("%.3f", game_player.PositionY)
		local beforeZ = string.format("%.3f", game_player.PositionZ)
		nx_pause(1)
		if nx_is_valid(nx_value("form_common\\form_loading")) then 
			return nil 
		end
		local afterX = string.format("%.3f", game_player.PositionX)
		local afterY = string.format("%.3f", game_player.PositionY)
		local afterZ = string.format("%.3f", game_player.PositionZ)

		local pxd = beforeX - afterX
		local pyd = beforeY - afterY
		local pzd = beforeZ - afterZ

		local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
		if distance <= 0.6 then
			add_chat_info(msg_pre .."X:"..fx.." Y:"..fy.." Z:"..fz)
			show_head_message("Stop: "..nx_string(diff_time), 10000)
			local game_client = nx_value("game_client")
			if game_client ~= nil then
				local player = game_client:GetPlayer()
				if player ~= nil then
					local state = player:QueryProp("State")
					if nx_string(state) == "" or state == nil or state == 0 then
						nx_value("path_finding"):FindPathScene(form_map.current_map, x, y, z, d or 2)
					end
				end
			end
		else
			if has_buff('buf_riding_01') and not has_buff("buf_riding_spurt01") then
				nx_execute("custom_sender", "custom_send_ride_skill", "riding_jiben")
			end
			____last_move_time = os.time()
		end
	end
	return diff_time
end

function move_scene(pos, scene, d, msg_pre, passtest)
	local form_map = nx_value("form_stage_main\\form_map\\form_map_scene")
	local game_visual = nx_value("game_visual")
	if
		pos == nil
		or pos[1] == nil 
		or pos[2] == nil 
		or pos[3] == nil 
		or not nx_is_valid(game_visual) 
		or nx_is_valid(nx_value("form_common\\form_loading")) 
	then
		return nil
	end
	local game_player = game_visual:GetPlayer()
	if not nx_is_valid(game_player) or game_player == nil 
		or not nx_is_valid(nx_value("path_finding"))
		or form_map == nil 
		or not nx_is_valid(form_map)
		or form_map.current_map == nil 
		--or not nx_is_valid(form_map.current_map)
	then
		return nil
	end
	scene = scene or form_map.current_map
	if ____last_move_time == nil then
		____last_move_time = os.time()
	end
	local currentTime = os.time()
	local diff_time = currentTime -  ____last_move_time
	local x, y, z = nx_float(pos[1]), nx_float(pos[2]), nx_float(pos[3])
	local fx, fy, fz = nx_string(x),nx_string(y), nx_string(z)
	fx, fy, fz = string.format("%.3f", fx), string.format("%.3f", fy), string.format("%.3f", fz)
	if msg_pre == nil then msg_pre = "Den Vi Tri: " end
	if passtest ~= nil and passtest == true then
		add_chat_info(msg_pre .."X:"..fx.." Y:"..fy.." Z:"..fz .." map " ..nx_function("ext_widestr_to_utf8", util_text(scene)))
		--____last_move_time = os.time()
		nx_value("path_finding"):FindPathScene(scene, x, y, z, 0)
		--nx_value("path_finding"):FindPath(x, -10000, z, 0)
	else
		local beforeX = string.format("%.3f", game_player.PositionX)
		local beforeY = string.format("%.3f", game_player.PositionY)
		local beforeZ = string.format("%.3f", game_player.PositionZ)
		nx_pause(1)
		if nx_is_valid(nx_value("form_common\\form_loading")) then 
			return nil 
		end
		local afterX = string.format("%.3f", game_player.PositionX)
		local afterY = string.format("%.3f", game_player.PositionY)
		local afterZ = string.format("%.3f", game_player.PositionZ)

		local pxd = beforeX - afterX
		local pyd = beforeY - afterY
		local pzd = beforeZ - afterZ

		local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)
		if distance <= 0.6 then
			add_chat_info(msg_pre .."X:"..fx.." Y:"..fy.." Z:"..fz.." map " ..nx_function("ext_widestr_to_utf8", util_text(scene)))
			show_head_message("Stop: "..nx_string(diff_time), 10000)
			local game_client = nx_value("game_client")
			local player = game_client:GetPlayer()
			local state = player:QueryProp("State")
			if nx_string(state) == "" or state == nil or state == 0 then
				nx_value("path_finding"):FindPathScene(scene, x, y, z, d or 2)
			end
		else
			if has_buff('buf_riding_01') and not has_buff("buf_riding_spurt01") then
				nx_execute("custom_sender", "custom_send_ride_skill", "riding_jiben")
			end
			____last_move_time = os.time()
		end
	end
	return diff_time
end

function den_pos(pos, isStarted, msg_pre)
	local isArrived = false
	local direct_run = true
	local game_client = nx_value("game_client")
	local player = game_client:GetPlayer()
	____last_move_time = os.time()
	while not arrived(pos, 3) and isStarted() and player ~= nil do
		local state = player:QueryProp("LogicState")
		if state == 0 or state == 1 or state == 2 or state == nil then
			local move_time = move(pos, 3, msg_pre, direct_run)
			if move_time ~= nil and move_time > 5 then 
				jump_to_next()
				____last_move_time = os.time()
			end
			direct_run = false
		end
		nx_pause(0.7)
	end
	nx_pause(0.5)
end

function click(pos, npc_id)
	local form_map = nx_value("form_stage_main\\form_map\\form_map_scene")
    local path_finding = nx_value("path_finding")
    path_finding:TraceTargetByID(form_map.current_map, pos[1], pos[2], pos[3], 1.8, npc_id)
end

function safe_jump_to(pos, isStarted)
	local isArrived = false
	while isStarted() and not arrived(pos, 5) do
		nx_pause(1)
		jump_to(pos)
	end
	nx_pause(1)
end

function delay(second)
	nx_pause(second)
end

function noop()
	delay(0.1)
end

function study_book(book_id)
	nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", book_id)
	nx_pause(3)
	local form = util_get_form("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", true)
	nx_execute("form_stage_main\\form_wuxue\\form_skillbook_preview", "on_btn_study_click", form.btn_study)
	nx_pause(5)
end

function den_pos_prevent_lag(possitions, destination, isStarted)
	local count = table.getn(possitions)
	for i = 1, count do
		if arrived(destination, 3) then break end
		local pos = possitions[i]
		den_pos(pos[1], isStarted)
		if pos[2] ~= nil then
			jump_to(pos[2])
		end
	end
	den_pos(destination, isStarted) -- last possition is destination
end

function shortcut_path(points, isReversed)
	if isReversed then
		for i = table.getn(points), 1, -1 do
			jump_to(points[i])
			nx_pause(3)
		end
	else
		for i = 1, table.getn(points) do
			jump_to(points[i])
			nx_pause(3)
		end
	end
end

function xuong_ngua()
	if has_buff('buf_riding_01') then -- dang cuoi ngua xuong ngua
		nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
		nx_pause(0.2)
	end
end

function len_ngua()
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return false
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return false
  end
  local item_pos = 0
  local view_table = client:GetViewList()
  for i = 1, table.getn(view_table) do
    local view = view_table[i]
    if view.Ident == "2" then
      local view_obj_table = view:GetViewObjList()
      for k = 1, table.getn(view_obj_table) do
        local view_obj = view_obj_table[k]
        if view_obj:FindProp("RideBuffer") and view_obj:QueryProp("RideBuffer") and view_obj:QueryProp("ConfigID") then
          local item_pos = view_obj.Ident
          nx_pause(1)
          nx_execute("custom_sender", "custom_use_item", 2, item_pos)
          nx_pause(5)
          break
        end
      end
      break
    end
  end
end

function len_lua(isStarted)
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return false
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return false
	end
	local con_lua = "AIRidePet01"
	local con_lua_call = "mount_1_001"
	while isStarted() and not has_buff('buf_riding_01') and has_item(con_lua_call, 2) do
		nx_pause(0)
		dung_vat_pham(con_lua_call, 1, 0)
		local game_client = nx_value("game_client")
		local game_scence = game_client:GetScene()
		local game_scence_objs = game_scence:GetSceneObjList()
		for i = 1, table.getn(game_scence_objs) do
			if not isStarted() then
				break
			end
			local obj = game_scence_objs[i]
			if
				obj ~= nil 
				and obj:QueryProp("ConfigID") == con_lua 
				and obj:QueryProp("HostName") == utf8ToWstr("Võ.Phong") 
			then
				--jump_to(getPos(obj))
				target_npc_by_ident(obj.Ident)
				--nx_pause(5)
			end
		end
	end
end

function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end

function execute_menu(menu_name)
	local form = util_get_form("form_stage_main\\form_talk_movie")
	if not nx_is_valid(form) then
		return false
	end
	local form_main_chat_logic = nx_value("form_main_chat")
	if not nx_is_valid(form_main_chat_logic) then
		return false
	end
	if menu_title ~= nil then
		local form_title = nx_ws_lower(form_main_chat_logic:DeleteHtml(form.mltbox_title.HtmlText))
		menu_title = nx_ws_lower(nx_widestr(util_text(menu_title)))
		if nx_function("ext_ws_find", form_title, menu_title) == -1 then
			return
		end
	end
	if menu_name == 0 then
		nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(0))
		return
	end
	local found_menu = false
	local menu_table = util_split_wstring(nx_widestr(form.menus), nx_widestr("|"))
	local menu_num1 = table.getn(menu_table)
	if menu_num1 > 4 and not found_menu then
		menu_num1 = round((menu_num1 - 0.1) / 4)
		for k = 0, menu_num1 do
			local menu = form.mltbox_menu
			local temp_menu = {}
			local menu_num = menu.ItemCount
			if nx_int(menu_num) > nx_int(0) and menu.Visible then
				for i = 0, menu_num - 1 do
					if found_menu then
						break
					end
					local htmltext = menu:GetItemTextNoHtml(i)
					htmltext = nx_ws_lower(form_main_chat_logic:DeleteHtml(htmltext))
					htmltext2 = nx_ws_lower(nx_widestr(util_text(menu_name)))
					if nx_function("ext_ws_find", htmltext, htmltext2) ~= -1 then
						found_menu = true
						nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(i))
						break
					end
				end
			end
			if not found_menu then
				form.menu_page = k + 1
				nx_execute("form_stage_main\\form_talk_movie", "update_menu_control", form, form.menus)
			else
				break
			end
		end
	else
		local menu = form.mltbox_menu
		local temp_menu = {}
		local menu_num = menu.ItemCount
		if nx_int(menu_num) > nx_int(0) and menu.Visible then
			for i = 0, menu_num - 1 do
				if found_menu then
					break
				end
				local htmltext = menu:GetItemTextNoHtml(i)
				htmltext = form_main_chat_logic:DeleteHtml(htmltext)
				if nx_function("ext_ws_find", htmltext, nx_widestr(util_text(menu_name))) ~= -1 then
					found_menu = true
					nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(i))
					break
				end
			end
		end
	end
end

function isempty(s)
	return s == nil or s == ""
end

function round(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0) / mult
end

function send_custom_msg_to_server(msg, value)
	local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return
  end
  game_visual:CustomSend(nx_int(msg), nx_int(value))
end

function get_player_prop(prop_name)
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return ""
  end
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return ""
  end
  if not client_player:FindProp(nx_string(prop_name)) then
    return ""
  end
  return client_player:QueryProp(nx_string(prop_name))
end

local SUB_CLIENT_NORMAL_BEGIN = 11 -- noi tu
local SUB_CLIENT_NORMAL_EXIT = 12 -- ket thuc noi tu
local SUB_CLIENT_UPDATE_ACT = 24
local SUB_SERVER_ACT_BEGIN = 21 -- mo form dien vo
local SUB_CLIENT_ACT_EXIT = 22
local SUB_CLIENT_ACT_PAY = 23
function noi_tu(id)
	local is_faculty = check_wuxue_is_faculty(nx_string(id))
	local noi_cong = get_noi_cong_info(id)
	if noi_cong then
		if noi_cong.Level >= noi_cong.MaxLevel then
			return
		end
	end
	if not is_faculty then
		nx_execute("faculty", "set_faculty_wuxue", nx_string(id))
		nx_execute("custom_sender", "custom_send_faculty_msg", SUB_CLIENT_NORMAL_BEGIN)
	end
end

function check_noi_tu()
	local cur_faculty = get_player_prop("FacultyName")
	noi_tu(cur_faculty)
end

function dien_vo(isStarted, times)
	local cur_faculty = get_player_prop("FacultyName")
	if not isempty(cur_faculty) then
		local game_player = nx_value("game_client"):GetPlayer()
		if nx_is_valid(game_player) then
			local day_value = game_player:QueryProp("ActDayValue")
			local cost_value = game_player:QueryProp("ActCostSuiYin")
			local cul_dv = ( day_value - cost_value )
			local type_index = nx_int(0) -- thuoc 0 1 2
			local cost_type = nx_int(1) -- 1 bac khoa, 4: bac nen
			local cost0 = get_dien_vo_item_cost(0)
			local cost1 = get_dien_vo_item_cost(1)
			local count = 0
			times = times or 9999
			while (cul_dv > cost0 or cul_dv > cost1) and isStarted() and not isempty(cur_faculty) and count < times do
				if cul_dv < cost1 then
					type_index = nx_int(0)
				end
				SendNotice("cul_dv:" ..nx_string(cul_dv) .." cost0:" ..nx_string(cost0) .. "cost1:" ..nx_string(cost1))
				nx_execute("custom_sender", "custom_send_faculty_msg", SUB_SERVER_ACT_BEGIN)
				nx_execute("custom_sender", "custom_send_faculty_msg", SUB_CLIENT_ACT_PAY, type_index, cost_type)
				cost_value = game_player:QueryProp("ActCostSuiYin")
				cul_dv = ( day_value - cost_value )
				cur_faculty = get_player_prop("FacultyName")
				cost0 = get_dien_vo_item_cost(0)
				cost1 = get_dien_vo_item_cost(1)
				count = count + 1
				nx_pause(3)
			end
			nx_execute("custom_sender", "custom_send_faculty_msg", SUB_CLIENT_ACT_EXIT)
			return (cul_dv > cost0 or cul_dv > cost1)
		end
	end
end

-- zero-base index
function get_dien_vo_item_cost(index)
	local faculty_query = nx_value("faculty_query")
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  local wuxue_name = client_player:QueryProp("FacultyName")
  local cur_level = client_player:QueryProp("CurLevel")
  local base_value = faculty_query:GetBaseValue(wuxue_name, cur_level, index)
	local price_ratio = faculty_query:GetPriceRatio(wuxue_name, cur_level)
	
  return price_ratio * base_value
end

function set_pass_ruong()
	local file = nx_resource_path() .. "auto\\auto_login.txt"
	if not nx_function("ext_is_file_exist", file) then
	local thth = nx_create("StringList")
		thth:SaveToFile(file)
	end
	local gm_list = nx_create("StringList")
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
	return 0
	end
	local gm_num = gm_list:GetStringCount()
	local game_config = nx_value("game_config")
	for i = 0, gm_num - 1 do
		if nx_widestr(game_config.login_account) == nx_widestr(gm_list:GetStringByIndex(i)) then
			local pw2 = nx_widestr(gm_list:GetStringByIndex(i+2))
			nx_execute("custom_sender", "custom_set_second_word", nx_widestr(pw2), nx_widestr(pw2))
		end
	end
end

function dung_het_vat_pham(isStarted, id, view_id, delay, pick_indices)
	local amount = get_item_amount(id, view_id)
	while isStarted() and amount > 0 do
		nx_pause(0)
		dung_vat_pham_tracking(isStarted, id, amount, delay, pick_indices)
		amount = get_item_amount(id, view_id)
	end
end

function do_confirm()
	local form = util_get_form("form_common\\form_confirm", false, false)
	if nx_is_valid(form) then
		nx_execute("form_common\\form_confirm", "ok_btn_click", form)
	end
end

function get_item_unique_id(item_id, view_id)
	local game_client = nx_value("game_client")
	local view = game_client:GetView(nx_string(view_id))
	local viewobj_list = view:GetViewObjList()
	for index, view_item in pairs(viewobj_list) do
		if view_item:QueryProp("ConfigID") == item_id then
			return view_item:QueryProp("UniqueID")
		end
	end
	return nil
end

function pw2()
	local file = nx_resource_path() .. "auto\\auto_login.txt"
	if not nx_function("ext_is_file_exist", file) then
	local thth = nx_create("StringList")
		thth:SaveToFile(file)
	end
	local gm_list = nx_create("StringList")
	if not gm_list:LoadFromFile(file) then
		nx_destroy(gm_list)
	return 0
	end
	local gm_num = gm_list:GetStringCount()
	local game_config = nx_value("game_config")
	for i = 0, gm_num - 1 do
		if nx_widestr(game_config.login_account) == nx_widestr(gm_list:GetStringByIndex(i)) then
			local pw2 = nx_widestr(gm_list:GetStringByIndex(i+2))
			nx_execute("custom_sender", "check_second_word", nx_widestr(pw2))
		end
	end
end

function hoc_tho_thien_cong_phu_skill(isStarted)
	local has_skill, skill_id = has_item("tbook_CS_jh_cqgf", 2)
	while isStarted() and has_skill do
		nx_pause(0)
		study_book(skill_id)
		has_skill, skill_id = has_item("tbook_CS_jh_cqgf", 2)
	end
end

function hoc_tho_thien_cong_phu(isStarted)
	xoa_tan_thu_items()
	local skill_dao_bo_that_tinh = "CS_jh_cqgf05"
	add_chat_info("Hoc Tho Thien Cong Phu")

	local has_box, box_id = has_item("item_skipsp_001", 2)

	while isStarted() and has_box do
		nx_pause(0)
		dung_vat_pham("item_skipsp_001", 1, 5)

		-- hoc toa thien
		study_book("book_zs_default_01")
		-- hoc am khi
		study_book("book_hw_normal")
		-- hoc lang khong dap hu
		study_book("book_qinggong_4")
		-- dung tuyet lien dang
		dung_vat_pham("additem_0020", 2, 4)
		-- dung tuyet lien qua
		dung_vat_pham("additem_0011", 1, 4)

		hoc_tho_thien_cong_phu_skill(isStarted)
		has_box, box_id = has_item("item_skipsp_001", 2)
	end
	hoc_tho_thien_cong_phu_skill(isStarted)
	
	-- if get_item_amount("item_skipsp_001", 2) > 0 and not da_hoc_skill(skill_dao_bo_that_tinh) then
	-- 	-- dung qua tan thu
	-- 	dung_vat_pham("item_skipsp_001", 1, 5)
	-- 	-- hoc toa thien
	-- 	study_book("book_zs_default_01")
	-- 	-- hoc am khi
	-- 	study_book("book_hw_normal")
	-- 	-- hoc lang khong dap hu
	-- 	study_book("book_qinggong_4")
	-- 	-- hoc skill tho thien : hoai trung bao nguyet
	-- 	study_book("tbook_CS_jh_cqgf03")
	-- 	-- hoc skill tho thien : bach van cai dinh
	-- 	study_book("tbook_CS_jh_cqgf02")
	-- 	-- hoc skill tho thien : dao bo that tinh
	-- 	study_book("tbook_CS_jh_cqgf05")
	-- 	-- dung qua dang nhap lan nua
	-- 	dung_vat_pham("item_skipsp_001", 1, 5)
	-- 	-- dung tuyet lien dang
	-- 	dung_vat_pham("additem_0020", 2, 4)
	-- 	-- dung tuyet lien qua
	-- 	dung_vat_pham("additem_0011", 1, 4)
	-- 	-- hoc skill tho thien : dao bo that tinh
	-- 	study_book("tbook_CS_jh_cqgf05") -- truong hop full ruong nen con sot lai 
	-- end
	add_chat_info("Hoc Tho Thien Cong Phu - DONE")
end

function ngu_phong()
	if not has_buff("buf_ride_yufeng") then
		dung_vat_pham("ride_windrunner_002", 1, 5)
	end
end

function tu_sat()
	local fight = nx_value("fight")
	-- tu sat ma khi tung hoang
	fight:TraceUseSkill("CS_jh_tmjt06", false, false)
	nx_pause(1)
	local player = getPlayer()
	if (not player:FindProp("Dead") or player:QueryProp("Dead") == 0) and player:QueryProp("LogicState") ~= 121 then -- chua chet hoac chua trong thuong
		local pos = getPos(getPlayer())
		local x = nx_float(pos[1])
		local y = nx_float(pos[2])
		local z = nx_float(pos[3])
		local game_visual = nx_value("game_visual")
		local role = nx_value("role")
		local scene_obj = nx_value("scene_obj")
		scene_obj:SceneObjAdjustAngle(role, x, z)
		role.move_dest_orient = role.AngleY
		role.server_pos_can_accept = true
		game_visual:SwitchPlayerState(role, 1, 5)
		game_visual:SwitchPlayerState(role, 1, 6)
		game_visual:SwitchPlayerState(role, 1, 7)
		role:SetPosition(role.PositionX, y, role.PositionZ)
		game_visual:SetRoleMoveDestX(role, x)
		game_visual:SetRoleMoveDestY(role, y)
		game_visual:SetRoleMoveDestZ(role, z)
		game_visual:SetRoleMoveDistance(role, 1)
		game_visual:SetRoleMaxMoveDistance(role, 1)
		game_visual:SwitchPlayerState(role, 1, 103)
	end
end

function get_total_item_amount(item_id, view_id)
	local game_client = nx_value("game_client")
	if not nx_is_valid(game_client) then
		return 0
	end
	local toolbox = game_client:GetView(nx_string(view_id))
	if not nx_is_valid(toolbox) then
		return 0
	end
	local sum = 0
	local toolbox_objlist = toolbox:GetViewObjList()
	for i, obj in pairs(toolbox_objlist) do
		local config_id = obj:QueryProp("ConfigID")
		if nx_string(config_id) == nx_string(item_id) then
			sum = nx_int(sum) + nx_int(obj:QueryProp("Amount"))
		end
	end
	return sum
end

function dung_het_binh_luc(bl_id,  bl_type)
	-- bl_type
	-- 100 do thu
	-- 101 don dao
	-- 102 don kiem
	-- 103 doan kiem
	-- 104 song dao
	-- 105 song kiem
	-- 106 song thich
	-- 107 truong con
	-- 108 doan con
	-- 109 am khi
	local CUSTOMMSG_SUB_MODIFY_BINGLU_ADD_LEVEL = 1
  local item_amount = get_total_item_amount(bl_id, 2)
  custom_modify_binglu(CUSTOMMSG_SUB_MODIFY_BINGLU_ADD_LEVEL, bl_id, nx_number(bl_type), nx_int(item_amount))
end

function get_npc_pos(scene, configId)
	local mgr = nx_value("SceneCreator")
	if nx_is_valid(mgr) then
		local res = mgr:GetNpcPosition(scene, configId)
		if 3 <= table.getn(res) then
			return {res[1], res[2], res[3]}
		end
	end
	return nil
end

function get_bao_ruong(excluded, distance)
	excluded = excluded or ","
	distance = distance or 10
  local game_client = nx_value("game_client")
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_client) then
    return
  end
  if not nx_is_valid(game_visual) then
    return
  end
  local client_scene = game_client:GetScene()
  if not nx_is_valid(client_scene) then
    return
  end
  local visual_player = game_visual:GetPlayer()
  local obj_list = client_scene:GetSceneObjList()
  for i = 1, table.maxn(obj_list) do
    local client_scene_obj = obj_list[i]
    local visual_scene_obj = game_visual:GetSceneObj(client_scene_obj.Ident)
    if nx_is_valid(visual_scene_obj) then
      local dis = distance3d(visual_scene_obj.PositionX, visual_scene_obj.PositionY, visual_scene_obj.PositionZ, visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ)
			local configId = client_scene_obj:QueryProp("ConfigID")
			if 
				dis <= distance
				and client_scene_obj:FindProp("NpcType") 
				and client_scene_obj:QueryProp("NpcType") == 161 
				and not client_scene_obj:FindProp("Dead") 
				and not client_scene_obj:FindProp("CanPick") 
				and not is_in_pick_list(excluded, configId)
			then
				return client_scene_obj
      end
    end
  end
  return nx_null()
end

function getVisualPlayer()
	local game_visual = nx_value("game_visual")
	return game_visual:GetPlayer()
end

function nhat_ruong(ruong)
	local open_range = ruong:QueryProp("OpenRange")
	local client_player = getPlayer()
	local visual_player = getVisualPlayer()
	local x, y, z = ruong.PosiX, ruong.PosiY, ruong.PosiZ
	local player_pos_x = visual_player.PositionX
	local player_pos_y = visual_player.PositionY
	local player_pos_z = visual_player.PositionZ
	local distance = distance2d(player_pos_x, player_pos_z, x, z)
	if open_range >= distance then
		if client_player:QueryProp("State") ~= "interact017" and client_player:QueryProp("State") ~= "interact041" then
			nx_execute("custom_sender", "custom_select", ruong.Ident)
		end
	else
		jump_to({x,y,z})
	end
end

function auto_pickup(pick_list)
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return 0
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return 0
  end
  local client_player = client:GetPlayer()
  local view_table = client:GetViewList()
  for i = 1, table.getn(view_table) do
    local view = view_table[i]
    if view.Ident == "80" then
      local view_obj_table = view:GetViewObjList()
      for k = 1, table.getn(view_obj_table) do
        local view_obj = view_obj_table[k]
				local x = nx_function("ext_widestr_to_utf8", nx_ws_lower(util_text(view_obj:QueryProp("ConfigID"))))
        if pick_list == nil or is_in_pick_list(pick_list, x) then
          nx_execute("custom_sender", "custom_pickup_single_item", view_obj.Ident)
        end
      end
    end
  end
  return true
end

function auto_pickup_id(pick_list)
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return 0
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return 0
  end
  local client_player = client:GetPlayer()
  local view_table = client:GetViewList()
  for i = 1, table.getn(view_table) do
    local view = view_table[i]
    if view.Ident == "80" then
      local view_obj_table = view:GetViewObjList()
      for k = 1, table.getn(view_obj_table) do
        local view_obj = view_obj_table[k]
				local x = view_obj:QueryProp("ConfigID")
        if pick_list == nil or is_in_pick_list(pick_list, x) then
          nx_execute("custom_sender", "custom_pickup_single_item", view_obj.Ident)
        end
      end
    end
  end
  return true
end

function is_in_pick_list(pick_list, content)
	local checking_item = content or ""
	local list = util_split_string(pick_list, ",")
	for i = 1, table.getn(list) do
		local pick_item = list[i]
    if pick_item ~= "" and string.find(checking_item, pick_item) then
      return true
    end
  end
  return false
end

function xoa_het_rac(rac_list)
	for i = 1, table.getn(rac_list) do
		local rac = rac_list[i]
		local amount = get_item_amount(rac.id, rac.view)
		if amount > 0 then
			delete_item_by_id(rac.id, rac.view, amount)
		end
	end
end

function text_vn(id)
	return nx_function("ext_widestr_to_utf8", util_text(id))
end

function get_distance_2d(obj)
	local visual_player = getVisualPlayer()
	local x, y, z = obj.PosiX, obj.PosiY, obj.PosiZ
	local player_pos_x = visual_player.PositionX
	local player_pos_y = visual_player.PositionY
	local player_pos_z = visual_player.PositionZ
	return distance2d(player_pos_x, player_pos_z, x, z)
end

function sap_xep_tui(id)
	dung_vat_pham("noop_item", id)
	local form_bag = util_get_form("form_stage_main\\form_bag", true, false)
	nx_execute("form_stage_main\\form_bag", "on_btn_arrange_click", form_bag.btn_arrange)
end

function tim_item_pos(itemId, viewId, status)
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return -1
  end
	local item_pos = -1
	local id
	local view = client:GetView(nx_string(viewId))
  local view_obj_table = view:GetViewObjList()
	for k = 1, table.getn(view_obj_table) do
		local view_obj = view_obj_table[k]
		local configId = view_obj:QueryProp("ConfigID")
		if configId ~= nil and string.find(configId, itemId) then
			if status == 1 and view_obj:FindProp("BindStatus") then
				item_pos = view_obj.Ident
				id = configId
				break
			elseif (status == nil or status == 0) and not view_obj:FindProp("BindStatus") then
				item_pos = view_obj.Ident
				id = configId
				break
			end
		end
	end
	add_chat_info("item pos:" ..nx_string(item_pos))
  return nx_number(item_pos), id
end

function ___merge(t1, t2)
	for k,v in ipairs(t2) do
		table.insert(t1, v)
	end 

	return t1
end

function xoa_tan_thu_items()
  -- xoa dai linh dan
  local amount = get_item_amount("yaopin_10500", 2)
  if amount > 0 then
    delete_item_by_id("yaopin_10500", 2, amount)
  end
  -- xoa tuyet lien tu
  local amount = get_item_amount("qizhen_0101_01", 2)
  if amount > 0 then
    delete_item_by_id("qizhen_0101_01", 2, amount)
  end
  -- xoa 5 cai man thau
  local amount = get_item_amount("caiyao20007", 2)
  if amount > 0 then
    delete_item_by_id("caiyao20007", 2, amount)
  end
  -- xoa tu than dan
  local amount = get_item_amount("zhenqi_activity_002", 2)
  if amount > 0 then
    delete_item_by_id("zhenqi_activity_002", 2, amount)
  end
  -- xoa tuc menh hoan
  local amount = get_item_amount("yaopin_00500", 2)
  if amount > 0 then
    delete_item_by_id("yaopin_00500", 2, amount)
	end
	local amount = get_item_amount("yaopin_005001", 2)
  if amount > 0 then
    delete_item_by_id("yaopin_005001", 2, amount)
	end
	-- xoa that huyen cam
  local amount = get_item_amount("tool_qs_01", 2)
  if amount > 0 then
    delete_item_by_id("tool_qs_01", 2, amount)
	end
	-- xoa bach khoa toan thu
  local amount = get_item_amount("itm_bxyl_001", 2)
  if amount > 0 then
    delete_item_by_id("itm_bxyl_001", 2, amount)
	end
	-- cuoc nong phu
  local amount = get_item_amount("tool_nf_01", 2)
  if amount > 0 then
    delete_item_by_id("tool_nf_01", 2, amount)
	end
	-- coi duoc su
  local amount = get_item_amount("tool_ys_01", 2)
  if amount > 0 then
    delete_item_by_id("tool_ys_01", 2, amount)
	end
end

function arrange_bag(viewId, checkNumber)
  if viewId == 2 then
		dung_vat_pham("noop", 0,0)
	elseif viewId == 125 then
		dung_item_nhiem_vu("noop", 0, 0)
	elseif viewId == 123 then
		dung_nguyen_lieu("noop", 0, 0)
	end
  local available = check_bag_available(viewId)
  local form_bag = util_get_form("form_stage_main\\form_bag", true, false)
  if available <= checkNumber then
    nx_execute("form_stage_main\\form_bag", "on_btn_arrange_click", form_bag.btn_arrange)
  end
end

function GetAutoConfigFile(type)
  local game_config = nx_value("game_config")
  local account = game_config.login_account
	local dir = nx_resource_path() .."auto\\data\\config\\"..account
  local file = ""
	if not nx_function("ext_is_exist_directory", nx_string(dir)) then
    nx_function("ext_create_directory", nx_string(dir))
  end
  if type == 1 then
    file = dir .. nx_string("\\auto_pickup.txt")
  elseif type == 2 then
    file = dir .. nx_string("\\auto_buff_boss.txt")
  elseif type == 3 then
    file = dir .. nx_string("\\auto_setting.ini")
  elseif type == 4 then
		file = dir .. nx_string("\\auto_thuoc.txt")
	elseif type == CONFIG_FILE_TYPES.SELL_ITEMS then
		file = dir .. nx_string("\\auto_shop_sell.txt")
	elseif type == CONFIG_FILE_TYPES.BUY_ITEMS then
    file = dir .. nx_string("\\auto_shop_buy.txt")
  end
  if not nx_function("ext_is_file_exist", file) then
    local thth = nx_create("StringList")
    if type == 3 then
      thth:AddString("[thth]")
      thth:AddString("auto_reset=true")
      thth:AddString("auto_pickup=true")
      thth:AddString("auto_bathe=false")
      thth:AddString("auto_x2=false")
      thth:AddString("auto_dungvo=false")
      thth:AddString("auto_sonhap=false")
      thth:AddString("auto_thuong=true")
      thth:AddString("auto_oskill=false")
      thth:AddString("auto_ridding=false")
      thth:AddString("free_appoint1=false")
      thth:AddString("free_appoint2=false")
      thth:AddString("free_appoint3=false")
      thth:AddString("free_appoint4=false")
      thth:AddString("use_kcl1=false")
      thth:AddString("use_kcl2=false")
      thth:AddString("use_kcl3=false")
      thth:AddString("use_kcl4=false")
      thth:AddString("selectskill=0")
      thth:AddString("cauhoa=0")
      thth:AddString("tab1=6")
      thth:AddString("tab2=6")
      thth:AddString("tab3=4")
      thth:AddString("tab4=4")
    end
    thth:SaveToFile(file)
  end
  return file
end

-- function getVisualObj(obj)
-- 	if not nx_is_valid(obj) then
-- 		return
-- 	end
-- 	local game_visual = nx_value("game_visual")
-- 	local vObj = game_visual:GetSceneObj(obj.Ident)
-- 	return vObj	
-- end

function setFaceView(obj)
	local role = nx_value("role")
	if not nx_is_valid(role) then
		return
	end
	local vis_obj = getVisualObj(obj)
	if not nx_is_valid(vis_obj) then
		return
	end
	local angle = math.atan((role.PositionX - vis_obj.PositionX) / (role.PositionZ - vis_obj.PositionZ))
	if role.PositionZ > vis_obj.PositionZ then
		angle = angle + math.pi
	end
	role:SetAngle(0, angle, 0)	
end

function getNearestNpc(id)
	local npc = 0
	local npc_pos = nil
	local distance = 999
	local game_client = nx_value("game_client")
	local game_scene = game_client:GetScene()
	if not nx_is_valid(game_scene) then
		return nil
	end
	local obj_lst = game_scene:GetSceneObjList()
	for i, obj in pairs(obj_lst) do
		local cfg = nx_string(obj:QueryProp("ConfigID"))
		if cfg == id then
			local d, pos =  getDistanceToObj(obj)
			if distance > d then
				distance = d
				npc = obj
				npc_pos = pos
			end
		end
	end
	return npc, npc_pos
end

function string_to_pos(stringPos)
	local parts = util_split_string(stringPos, ",")
	local x = tonumber(parts[1])
	local y = tonumber(parts[2])
	local z = tonumber(parts[3])
	local o = tonumber(parts[4])
	return {x,y,z,o}
end

function jump_out_stuck_pos(isStarted, posList)
	for i = 1, table.getn(posList) do
		local parts = util_split_string(posList[i], ";")
		local pos1 = string_to_pos(parts[1])
		local pos2 = string_to_pos(parts[2])

		if arrived(pos1, 3) then
			thanhanh_bay_den(pos2, 50, isStarted)
			break;
		end
	end
end

function stop_move()
	nx_value('path_finding'):StopPathFind(nx_value('game_visual'):GetPlayer())
end

function read_lag_pos(map)
	local file = nx_resource_path() .. "auto\\data\\lag_pos.ini"	
	local pos_str = IniRead(file, map, 1, "")
	local pos_list_str = util_split_string(nx_string(pos_str), "|")
	local result = {}
	for i = 1, table.getn(pos_list_str) do
		result[i] = pos_list_str[i]
	end
	return result
end

--1: hoa binh
--2: giang ho
function change_pk_mode(mode)
	nx_execute("custom_sender", "custom_set_pkmode", mode)
end

function nhan_danh_phan(id)
	local CLIENT_CUSTOMMSG_GET_ORIGIN_PRIZE = 702
	local CLIENT_CUSTOMMSG_GET_ORIGIN = 705
	local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return false
  end
  game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_GET_ORIGIN), nx_int(id))
end

function nhan_thuong_danh_phan(id)
	local CLIENT_CUSTOMMSG_GET_ORIGIN_PRIZE = 702
	local CLIENT_CUSTOMMSG_GET_ORIGIN = 705
	local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return false
  end
  game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_GET_ORIGIN_PRIZE), nx_int(id))
end

function tat_movie()
	local form = util_get_form("form_stage_main\\form_movie_new", false, false)
	if nx_is_valid(form) then
		nx_execute("form_stage_main\\form_movie_new", "on_btn_end_click", form.btn_end)
	end
end

function mac_do_danh_phan()
	local form = util_get_form("form_stage_main\\form_role_info\\form_rp_arm", true)
	nx_execute("form_stage_main\\form_role_info\\form_rp_arm", "on_btn_menpai_click", form.btn_menpai)
end

function can_binh_luc(binh_luc)
	if get_item_amount("binglu111", 2) > 0 then
		dung_het_binh_luc("binglu111", binh_luc)
	end
	if get_item_amount("binglu112", 2) > 0 then
		dung_het_binh_luc("binglu112", binh_luc)
	end
	if get_item_amount("binglu113", 2) > 0 then
		dung_het_binh_luc("binglu113", binh_luc)
	end
end

function catch(what)
	return what[1]
end

function try(what)
	local _catch = what[2] or function() end
	status, err, result = xpcall(what[1], _catch)
	
	if not status then
		_catch(result)
	end
	return result
end

function is_force()

end

function is_dead()
	local client = nx_value("game_client")
	local client_player = client:GetPlayer()
	if client_player:FindProp("Dead") and tonumber(client_player:QueryProp("Dead")) == 1 then
		return true
	end
	return false
end

function is_path_finding()
  local game_client = nx_value("game_client")
  local game_visual = nx_value("game_visual")
  local client_player = game_client:GetPlayer()
  local visual_player = game_visual:GetPlayer()
  if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then
    return false
  end
  if nx_find_custom(visual_player, "path_finding") and visual_player.path_finding then
    return true
  else
    return false
  end
end

function hoi_sinh_lan_can()
	nx_execute("custom_sender", "custom_relive", 2, nx_int(0))
end