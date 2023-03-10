require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')

local THIS_FORM = 'auto_new\\form_auto_blink_set'
function main_form_init(form)
  form.Fixed = false
end
function stop_jump_to_pos_new()
    findPathBusy = false
    nx_execute('form_stage_main\\form_map\\form_map_scene', 'stopJumpToPosMap')
end
function on_main_form_open(form)
	
  init_ui_content(form)
end
function init_ui_content(form)		
	loadBlinkMaps(form)
end
function loadBlinkMaps(form)
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account 
	if not nx_function("ext_is_exist_directory", nx_string(dir)) then
      nx_function("ext_create_directory", nx_string(dir))	
	 nx_pause(1)
    end
	local blink_pos = ""
	local ini_file = dir..'\\auto_blink.ini'
	local countini = nx_execute('auto_new\\autocack','sectionCount',ini_file)
	form.combobox_snatch_target.DropListBox:ClearString()
	if countini > 0 then
		for j = 1, countini do
			blink_pos = getSectionName(ini_file,j)			
			for i = 1, table.getn(blink_pos) do
				form.combobox_snatch_target.DropListBox:AddString(utf8ToWstr(blink_pos[i]))
			end
		end
	form.combobox_snatch_target.DropListBox.SelectIndex = 0
	form.combobox_snatch_target.Text = blink_pos[1]	
	end
end
function on_combobox_snatch_target_selected(btn)
	local form = btn.ParentForm
	local form = btn.ParentForm
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account 
	if not nx_function("ext_is_exist_directory", nx_string(dir)) then
      nx_function("ext_create_directory", nx_string(dir))	
	 nx_pause(1)
    end
	local ini_file = dir..'\\auto_blink.ini'
	local posName = wstrToUtf8(form.combobox_snatch_target.InputEdit.Text)
	if nx_string(readIni(ini_file,posName,'mode','')) == nx_string('true') then
		form.check_dichuyen.Checked = true
	end
end
function btn_del_pos(btn)
	local form = btn.ParentForm
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account 
	if not nx_function("ext_is_exist_directory", nx_string(dir)) then
      nx_function("ext_create_directory", nx_string(dir))	
	 nx_pause(1)
    end
	local blink_pos = ""
	local ini_file = dir..'\\auto_blink.ini'
	local posName = wstrToUtf8(form.combobox_snatch_target.InputEdit.Text)
	removeSection(ini_file,posName)
	loadBlinkMaps(form)
end
function on_btn_close_click(form)
local form = nx_value(THIS_FORM)
	if not nx_is_valid(form) then
		return
	end
	on_main_form_close(form)
end
function on_main_form_close(form)	
	nx_destroy(form)
end
function btn_add_pos(btn)
	local form = btn.ParentForm
	local x,y,z = getCurPos()
	local maps = get_current_map()
	local id = ""
	local mode = form.check_dichuyen.Checked
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account 
	if not nx_function("ext_is_exist_directory", nx_string(dir)) then
      nx_function("ext_create_directory", nx_string(dir))	
	 nx_pause(1)
    end
	local ini_file = dir..'\\auto_blink.ini'
	local dialog1 = nx_execute("util_gui", "util_get_form", "form_common\\form_input_name", true, false)
	dialog1.lbl_title.Text = nx_function("ext_utf8_to_widestr", "Nhập Tên Vị Trí")
	dialog1.info_label.Text = utf8ToWstr("Tên Pos") 
	dialog1:ShowModal()
	local res, new_name = nx_wait_event(100000000, dialog1, "input_name_return")
	if res == "cancel" then
		id = ""
		return 0
	else
		id = wstrToUtf8(new_name)
	end
	writeIni(ini_file,id,'mode',mode)
	writeIni(ini_file,id,'maps',maps)
	writeIni(ini_file,id,'x',x)
	writeIni(ini_file,id,'y',y)
	writeIni(ini_file,id,'z',z)	
	loadBlinkMaps(form)
end
function jumpToPos(inifile,funcname,pos, stepDistance, stepPause,final)
  if stepDistance == nil then
    stepDistance = 80
  end
  if stepPause == nil then
    stepPause = 2
  end
 
  if not tools_move_isArrived(pos[1], pos[2], pos[3], 0.5) then
    local x = nx_float(pos[1])
    local y = nx_float(pos[2])
    local z = nx_float(pos[3])
    local px = string.format('%.3f', nx_string(x))
    local py = string.format('%.3f', nx_string(y))
    local pz = string.format('%.3f', nx_string(z))
    local game_visual = nx_value('game_visual')
    if not nx_is_valid(game_visual) then
      return false
    end
    local role = nx_value('role')
    if not nx_is_valid(role) then
      return false
    end
    local scene_obj = nx_value('scene_obj')
    if not nx_is_valid(scene_obj) then
      return false
    end
	if nx_string(readIni(inifile,funcname,'mode','')) ~= nx_string('true') or final then 	
		scene_obj:SceneObjAdjustAngle(role, x, z)
		role.move_dest_orient = role.AngleY
		role.server_pos_can_accept = true 
		role:SetPosition(role.PositionX, y, role.PositionZ)
		game_visual:SetRoleMoveDestX(role, x)
		game_visual:SetRoleMoveDestY(role, y)
		game_visual:SetRoleMoveDestZ(role, z)
		game_visual:SetRoleMoveDistance(role, stepDistance)
		game_visual:SetRoleMaxMoveDistance(role, stepDistance)
		game_visual:SwitchPlayerState(role, 1, 103)
		nx_pause(stepPause)
	else
		scene_obj:SceneObjAdjustAngle(role, x, z)
		role.move_dest_orient = role.AngleY		
		role.server_pos_can_accept = true 
		role:SetPosition(role.PositionX, y, role.PositionZ)			
		game_visual:SetRoleMoveDestX(role, x)
		game_visual:SetRoleMoveDestY(role, y)
		game_visual:SetRoleMoveDestZ(role, z)
		game_visual:SetRoleMoveDistance(role, stepDistance)
		game_visual:SetRoleMoveSpeed(role, 1000)
		game_visual:SetRoleJumpSpeed(role, 0)
		game_visual:SetRoleMaxMoveDistance(role, 1)
		game_visual:SwitchPlayerState(role, 1, 103)
		if stepPause > 0 then
			nx_pause(stepPause)
			local scene = nx_value("game_scene")
			while (nx_is_valid(scene) and not scene.terrain.LoadFinish) or ((nx_is_valid(player_client) and nx_is_valid(game_player)) and not tools_move_isArrived2D(player_client.DestX, player_client.DestY, player_client.DestZ, 1, {game_player.PositionX, game_player.PositionY, game_player.PositionZ})) do
			   nx_pause(0)
			end
		end
	end
  end
end
function jumpToPos_New(inifile,funcname,pos, stepDistance, stepPause,isFinalPos)
  local form_map = nx_value('form_stage_main\\form_map\\form_map_scene')
  local game_visual = nx_value('game_visual')
  if pos == nil or pos[1] == nil or pos[2] == nil or pos[3] == nil or not nx_is_valid(game_visual) or nx_is_valid(nx_value('form_common\\form_loading')) then
    return nil
  end
  local game_player = game_visual:GetPlayer()
  if not nx_is_valid(game_player) or game_player == nil or not nx_is_valid(nx_value('path_finding')) or form_map == nil or not nx_is_valid(form_map) or form_map.current_map == nil then
    return nil
  end
  local x, y, z = nx_float(pos[1]), nx_float(pos[2]), nx_float(pos[3])
  local fx, fy, fz = nx_string(x), nx_string(y), nx_string(z)
  fx, fy, fz = string.format('%.3f', fx), string.format('%.3f', fy), string.format('%.3f', fz)
  local beforeX = string.format('%.3f', game_player.PositionX)
  local beforeY = string.format('%.3f', game_player.PositionY)
  local beforeZ = string.format('%.3f', game_player.PositionZ) 
    nx_pause(1)
  if nx_is_valid(nx_value('form_common\\form_loading')) then
    return nil
  end
  local afterX = string.format('%.3f', game_player.PositionX)
  local afterY = string.format('%.3f', game_player.PositionY)
  local afterZ = string.format('%.3f', game_player.PositionZ)
  local pxd = beforeX - afterX
  local pyd = beforeY - afterY
  local pzd = beforeZ - afterZ
  local distance = math.sqrt(pxd * pxd + pyd * pyd + pzd * pzd)   
  if distance <= 5 then
    local game_client = nx_value('game_client')
    if not nx_is_valid(game_client) then
      return false
    end
    local player = game_client:GetPlayer()
    if not nx_is_valid(player) then
      return false
    end
    local state = player:QueryProp('State')
    if nx_string(state) == '' or state == nil or state == 0 then			
      jumpToPos(inifile,funcname,pos, stepDistance,stepPause,isFinalPos)	 
    end
  end
  return true
end
function is_path_finding()
  local game_visual = nx_value('game_visual')
  if not nx_is_valid(game_visual) then
    return false
  end
  visual_player = util_get_role_model()
  if nx_is_valid(visual_player) and nx_find_custom(visual_player, 'path_finding') and visual_player.path_finding ~= nil and visual_player.path_finding then
    return true
  end
  return false
end
function jump_to_direct_to_pos(inifile,funcname,dest, stepDistance, stepPause, fixedY)
  if stepDistance == nil then
    stepDistance = 80
  end
  if is_path_finding() then
	local path_finding = nx_value('path_finding')
	local role = nx_value('role')
    local game_visual = nx_value('game_visual')
	path_finding:StopPathFind(nx_value('game_visual'):GetPlayer())
    game_visual:SwitchPlayerState(role, 'static', 1)
  end
  local isFinalPos = false
   local nextPos = nil
  local currentPos = get_current_player_pos()
  if currentPos == nil then
    return false
  end
  local dx = dest[1] - currentPos[1]
  local dz = dest[3] - currentPos[3]
  local a = dz / dx
  local b = dest[3] - a * dest[1]
  local distance = math.sqrt(dx * dx + dz * dz)
  local steps = math.ceil(distance / stepDistance)
  local dxStepDistance = dx / steps
  local current_step = 1
  while steps >= current_step and not nx_value('loading') do
    nx_pause(0.01)
    local scene = nx_value('game_scene')
    if not nx_is_valid(scene) then
      return false
    end
    local terrain = scene.terrain
    if not nx_is_valid(terrain) then
      return false
    end
    local x = currentPos[1] + dxStepDistance * current_step
    local z = a * x + b
	local walkHeight, maxHeight, waterHeight = getInfoHeightOfPos(x, z)		
	y = walkHeight + 20
    if current_step == steps then
      x = dest[1]
      z = dest[3]
      y = y - 20
	  stepPause = stepPause - 1    
      isFinalPos = true
    end
    local pos = {
      x,
      y,
      z
    }
    if fixedY ~= nil then
      if current_step == steps then
        if dest[2] > -1000 then
          pos[2] = dest[2] + 0.5
        end
      else
        pos[2] = fixedY
      end
    end
	if waterHeight == walkHeight then
		pos[2] = pos[2] + 5		
	end
    jumpToPos_New(inifile,funcname,pos, stepDistance, stepPause,isFinalPos)
    current_step = current_step + 1
  end
end
function on_btn_ok_click(btn)
	blinkToPosAuto()
end

function blinkToPosAuto()
	local form = nx_value('auto_new\\form_auto_blink_set')		
	local maps = get_current_map()
	local id = ""
	local game_config = nx_value('game_config')
	local account = game_config.login_account
	local server_ID = game_config.server_id
	local blink_pos
	local dir = nx_function('ext_get_current_exe_path') .. 'nockasdd_'.. account 
	if not nx_function("ext_is_exist_directory", nx_string(dir)) then
      nx_function("ext_create_directory", nx_string(dir))	
	 nx_pause(1)
    end
	local ini_file = dir..'\\auto_blink.ini'
	if nx_is_valid(form) and form.Visible == true then	
		local posName = wstrToUtf8(form.combobox_snatch_target.InputEdit.Text)
		local maps = readIni(ini_file,posName,'maps','')
		local x = readIni(ini_file,posName,'x','')
		local y = readIni(ini_file,posName,'y','')
		local z = readIni(ini_file,posName,'z','')
		if nx_string(get_current_map()) == nx_string(maps) then	
			local lastArrivePos = {nx_number(x),nx_number(y),nx_number(z)}			
			jump_to_direct_to_pos(ini_file,posName,lastArrivePos, 90,4)
		end
	else
		if not nx_is_valid(form) or form.Visible == false  then
			local countini = nx_execute('auto_new\\autocack','sectionCount',ini_file)
			if countini > 0 then
				blink_pos = getSectionName(ini_file,1)
			else
				showUtf8Text(AUTO_LOG_BLINKSET, 3)
			end	
			local maps = readIni(ini_file,blink_pos[1],'maps','')
			local x = readIni(ini_file,blink_pos[1],'x','')
			local y = readIni(ini_file,blink_pos[1],'y','')
			local z = readIni(ini_file,blink_pos[1],'z','')	
			if nx_string(get_current_map()) == nx_string(maps) then
				local pos = {nx_number(x),nx_number(y),nx_number(z)}
				jump_to_direct_to_pos(ini_file,blink_pos[1],pos, 90,4)	
			end
		end
	end	
end