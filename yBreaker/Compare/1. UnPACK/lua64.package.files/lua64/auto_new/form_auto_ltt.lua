require('util_gui')
require("util_move")
require('define\\gamehand_type')
require('const_define')
require('auto_new\\autocack')
if not load_auto_ltt then
	auto_cack('0')
	auto_cack('2')
	auto_cack('6')
	load_auto_ltt = true
end
local THIS_FORM = 'auto_new\\form_auto_ltt'
function main_form_init(form)
  form.Fixed = false
  
end

function on_main_form_open(form)
  init_ui_content(form)
end
function init_ui_content(form)		
	updateBtnText_swap(form)
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
getNpcLTT = function(mapid,npcid)
	local npc = FindObject(npcid)
	local x,y,z = getPosNpc(mapid,npcid)
	local form = nx_value('form_stage_main\\form_talk_movie')	
	local game_visual = nx_value('game_visual')
	local player = getPlayer()
	local visual_player
	if nx_is_valid(player) then
	  visual_player = game_visual:GetSceneObj(player.Ident)
	end 	
	if npc and getDistance(npc) < 10 and not is_path_finding() then
		nx_execute('custom_sender','custom_select',npc.Ident)
		nx_pause(0.5)		
		nx_execute('custom_sender','custom_select',npc.Ident)
		return true
	else			
		local npc_fly = FindObject('FlyNpcscene25002')	
		if npc_fly then
			if getDistanceFromPos(515.549,145.791,193.365) > 2 and getDistance(npc) > 5 then
				local visualObj = game_visual:GetSceneObj(npc_fly.Ident)				
				if npc_fly:FindProp('LinkedChildren') and npc_fly:QueryProp('LinkedChildren') ~= "" then
					if nx_number(string.format("%.0f", visualObj.PositionY)) == nx_number(144) then						
						use_jump_to_dis_round_pos(515.658,145.555,192.021)						
					end
				else
					nx_pause(0)
					if nx_number(string.format("%.0f", visualObj.PositionY)) == nx_number(string.format("%.0f", 116.799)) then						
						if getDistanceFromPos(522.107,116.799,191.64) > 3 then
							moveTo(522.107,116.799,191.64)
						else
							dis_mount()
							nx_pause(0.2)
							nx_call('player_state\\state_input', 'emit_player_input', visual_player,PLAYER_INPUT_HIT_SPACE, true)
						end
					end
				end
			else				
				autoMove(mapid,x,y,z)	
			end
		else	
			if getDistanceFromPos(521.555,116.474,191.632) > 2  then
				autoMove(mapid,521.555,116.474,191.632)	
			end	
		end		
	end
	return false
end
getNpcLTT = function(mapid,npcid)
	local npc = FindObject(npcid)
	local x,y,z = getPosNpc(mapid,npcid)
	local form = nx_value('form_stage_main\\form_talk_movie')	
	local game_visual = nx_value('game_visual')
	local player = getPlayer()
	local visual_player
	if nx_is_valid(player) then
	  visual_player = game_visual:GetSceneObj(player.Ident)
	end 	
	if npc and getDistance(npc) < 10 and not is_path_finding() then
		nx_execute('custom_sender','custom_select',npc.Ident)
		nx_pause(0.5)		
		nx_execute('custom_sender','custom_select',npc.Ident)
		return true
	else			
		local npc_fly = FindObject('FlyNpcscene25002')	
		if npc_fly then
			if getDistanceFromPos(515.549,145.791,193.365) > 2 and getDistance(npc) > 5 then
				local visualObj = game_visual:GetSceneObj(npc_fly.Ident)				
				if npc_fly:FindProp('LinkedChildren') and npc_fly:QueryProp('LinkedChildren') ~= "" then
					if nx_number(string.format("%.0f", visualObj.PositionY)) == nx_number(144) then						
						use_jump_to_dis_round_pos(515.658,145.555,192.021)						
					end
				else
					nx_pause(0)
					if nx_number(string.format("%.0f", visualObj.PositionY)) == nx_number(string.format("%.0f", 116.799)) then						
						if getDistanceFromPos(522.107,116.799,191.64) > 3 then
							moveTo(522.107,116.799,191.64)
						else
							dis_mount()
							nx_pause(0.2)
							nx_call('player_state\\state_input', 'emit_player_input', visual_player,PLAYER_INPUT_HIT_SPACE, true)
						end
					end
				end
			else				
				autoMove(mapid,x,y,z)	
			end
		else	
			if getDistanceFromPos(521.555,116.474,191.632) > 2  then
				autoMove(mapid,521.555,116.474,191.632)	
			end	
		end		
	end
	return false
end
oldPos = {}
stuck = 0
skill_list = {}
autoMoveBreak = 1
function autoMove(mapid, x, y, z, breakroute, npc) 
  local world = nx_value('world')
  local scene = world.MainScene
  if not nx_is_valid(scene) then
    return false
  end
  local terrain = scene.terrain
  if not nx_is_valid(terrain) then
    terrain = nx_value('terrain')
  end
  local game_visual = nx_value('game_visual')
  if nx_is_valid(game_visual) then
    local player = getPlayer()
    if nx_is_valid(player) then
      local role = game_visual:GetSceneObj(player.Ident)
      if nx_is_valid(role) then
        if breakroute ~= nil then
          autoMoveBreak = autoMoveBreak + 1
          if autoMoveBreak >= 30 then
            local path_finding = nx_value('path_finding')
            path_finding:FindPathScene(mapid, x, y, z, 0)
            autoMoveBreak = 1
          end
        end
        if nx_find_custom(role, 'path_finding') then
          if not is_path_finding(role) then
            local path_finding = nx_value('path_finding')
            path_finding:FindPathScene(mapid, x, y, z, 0)
          end
        else
          local path_finding = nx_value('path_finding')
          path_finding:FindPathScene(mapid, x, y, z, 0)
        end
        if oldPos[1] ~= nil then
          local distance = get_distance_pos(oldPos[1], oldPos[2], oldPos[3], player)
          if distance == 0 then
            stuck = stuck + 1
            if stuck >= 50 then
              if nx_function('find_buffer', player, 'buf_riding_01') then
                nx_execute('custom_sender', 'custom_remove_buffer', 'buf_riding_01')
              end
              nx_pause(1)
              nx_execute('custom_sender', 'custom_active_parry', 1, 2)
              nx_pause(1)
              nx_execute('custom_sender', 'custom_active_parry', 0, 2)
              nx_pause(1)
              local distance = 6
              local x = role.PositionX + distance * math.cos(role.AngleZ) * math.sin(role.AngleY)
              local y = role.PositionY + role.height * 0.5
              local z = role.PositionZ + distance * math.cos(role.AngleZ) * math.cos(role.AngleY)
              if npc ~= nil and nx_is_valid(npc) and 6 >= get_distance_obj(player, npc) then
                local target = game_visual:GetSceneObj(npc.Ident)
                x, y, z = target.PositionX, target.PositionY, target.PositionZ
              end
              emit_player_input(role, PLAYER_INPUT_HIT_SPACE, true)
              nx_pause(0.5)
              emit_player_input(role, PLAYER_INPUT_HIT_SPACE, true)
              nx_pause(0.5)
              emit_player_input(role, PLAYER_INPUT_HIT_SPACE, true)
              nx_pause(0.5)
              local higher_floor, higher_floor_y = get_pos_floor_index(role.scene.terrain, x, y, z)
              emit_player_input(role, PLAYER_INPUT_LOGIC, LOGIC_SERVER_JUMP_POS, x, higher_floor_y, z, 1, 1)
              stuck = 0
            end
          end
        end
        oldPos[1], oldPos[2], oldPos[3] = role.PositionX, role.PositionY, role.PositionZ
      end
    end
  end
end
function get_distance_pos(x, y, z, player)
  if not nx_is_valid(player) then
    return -1
  end
  local game_visual = nx_value('game_visual')
  local visual_scene_obj = game_visual:GetSceneObj(player.Ident)
  if not nx_is_valid(visual_scene_obj) then
    return
  end
  local player_x = visual_scene_obj.PositionX
  local player_y = visual_scene_obj.PositionY
  local player_z = visual_scene_obj.PositionZ
  local sx = x - player_x
  local sy = y - player_y
  local sz = z - player_z
  return math.sqrt(sx * sx + sy * sy + sz * sz)
end
function updateBtnText_swap(form)	
	if not nx_is_valid(form) then		
		return
	end
	if nx_running(nx_current(),'autoLangTieu') then
		form.btn_auto_langtieu.Text = nx_widestr("Stop")
	else
		form.btn_auto_langtieu.Text = nx_widestr("Start")
	end
end
function btn_auto_langtieu(btn)
	local form = btn.ParentForm	
	if nx_running(nx_current(),'autoLangTieu') then
		showUtf8Text("Stop "..AUTO_LOG_CHAT_CMD21, 3)
		autoRun_ltt = false
		nx_kill(nx_current(),'autoLangTieu')
	else	
		nx_execute(nx_current(),'autoLangTieu')
	end
	updateBtnText_swap(form)
end
