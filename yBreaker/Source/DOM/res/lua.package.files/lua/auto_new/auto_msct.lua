require('auto_new\\autocack')

function FindPlayerTask(taskId, desc) 
  local game_client = nx_value("game_client")
  local client_player = game_client:GetPlayer()
  local row = client_player:FindRecordRow("Task_Accepted", 0, nx_int(taskId), 0)
  if row < 0 then
    return false
  else
    local step = client_player:QueryRecord("Task_Accepted", row, 8)
    if step == desc then
      return true
    else
      return false
    end
  end

  return false
end

function FindNearNPCQuest(configid)
 local dis = 1000
 local obj = nil
 local game_client = nx_value("game_client")
 local client_player = game_client:GetPlayer()
 if nx_is_valid(client_player) then
   local scene = game_client:GetScene()
   local visual_objlist = scene:GetSceneObjList()
   if nx_is_valid(scene) then
     for k = 1, table.getn(visual_objlist) do
       local object = visual_objlist[k]
       if nx_is_valid(object) then
         if not game_client:IsPlayer(object.Ident) then
           if nx_find_custom(object, "Head_Effect_Flag") and nx_number(object.Head_Effect_Flag) == nx_number(configid) then
             local distance = get_distance_obj(client_player, object)
             if distance < dis then
               dis = distance
               obj = object
             end
           end
         end
       end
     end
   end
 end
 return obj
end
function AutoExecMenu(title, name, pos)
  local form = util_get_form("form_stage_main\\form_talk_movie")
    if not nx_is_valid(form) or not form.Visible then
        return 0
    end
    local form_main_chat_logic = nx_value("form_main_chat")
    if not nx_is_valid(form_main_chat_logic) then
      return 0
    end
    local form_title = nx_ws_lower(form_main_chat_logic:DeleteHtml(form.mltbox_title.HtmlText))
    local check_title = nx_ws_lower(nx_widestr(util_text("menu_title_sale_faild_job_error")))
    if nx_function("ext_ws_find", form_title, check_title) ~= -1 then
      local game_visual = nx_value("game_visual")
      if not nx_is_valid(game_visual) then        
        return false
      end
      local visual_player = game_visual:GetPlayer()
      local player_pos_x = visual_player.PositionX
      local player_pos_y = visual_player.PositionY
      local player_pos_z = visual_player.PositionZ
      local point, dist = nx_execute(nx_current(), "FindNearPoint", player_pos_x, player_pos_y, player_pos_z)
      local data = nx_execute(nx_current(), "AutoAbductData", nx_value("form_stage_main\\form_map\\form_map_scene").current_map)
      current_point, dist = nx_execute(nx_current(), "FindNearPoint", player_pos_x, player_pos_y, player_pos_z, point)
      nx_execute(nx_current(), "AutoSetCurrent", current_point)
      AutoMove(data.pos[current_point].x,data.pos[current_point].y,data.pos[current_point].z,data.pos[current_point].o)
      nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(0))
      return 
    else
      check_title = nx_ws_lower(nx_widestr(util_text("menu_title_sale_faild_cd_error")))
      if nx_function("ext_ws_find", form_title, check_title) ~= -1 then
        nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(0))
        return 
      end
    end

    if title ~= nil then
        title = nx_ws_lower(nx_widestr(util_text(title)))
        if nx_function("ext_ws_find", form_title, title) == -1 then
            return
        end
    end
    if pos ~= nil then
      nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(pos))
    else
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
                      if found_menu then break end
                      local htmltext = menu:GetItemTextNoHtml(i)
                      htmltext = nx_ws_lower(form_main_chat_logic:DeleteHtml(htmltext))
                      htmltext2 = nx_ws_lower(nx_widestr(util_text(name)))
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
                  if found_menu then break end
                  local htmltext = menu:GetItemTextNoHtml(i)
                  htmltext = form_main_chat_logic:DeleteHtml(htmltext)
                  if nx_function("ext_ws_find", htmltext, nx_widestr(util_text(name))) ~= -1 then
                    found_menu = true
                      nx_execute("form_stage_main\\form_talk_movie", "menu_select", form.mltbox_menu:GetItemKeyByIndex(i))
                      break
                  end
              end
          end
      end
  end
end
getQuestID = function(ID)                                                                                                            
	local player = nx_value('game_client'):GetPlayer()                                                                                 
	if not player:FindRecord('Task_Accepted') then                                                                                      
		return nil                                                                                                                        
	end                                                                                                                                  
	local row_num = player:GetRecordRows('Task_Accepted')                                                                                
	for i = 0, row_num - 1 do                                                                                                         
		local id = player:QueryRecord('Task_Accepted', i, 0)                                                                           
		if id ~= nil then                                                                                                               
			local idtask = player:QueryRecord('Task_Accepted', i, 5)                                  
			if idtask == ID then                                               
				return id                                                                                                               
			end                                                                                                                          
		end                                                                                                                             
	end                                                                                                                              
	return nil                                                                                                                         
end  
function FindNearObject(configid)
 local dis = 1000
 local obj = nil
 local game_client = nx_value("game_client")
 local client_player = game_client:GetPlayer()
 if nx_is_valid(client_player) then
   local scene = game_client:GetScene()
   local visual_objlist = scene:GetSceneObjList()
   if nx_is_valid(scene) then
     for k = 1, table.getn(visual_objlist) do
       local object = visual_objlist[k]
       if nx_is_valid(object) then
         if not game_client:IsPlayer(object.Ident) then
           if object:FindProp("ConfigID") and nx_string(object:QueryProp("ConfigID")) == nx_string(configid) then
             local distance = get_distance_obj(client_player, object)
             if distance < dis then
               dis = distance
               obj = object
             end
           end
         end
       end
     end
   end
 end
 return obj
end

function auto_run_msct()
	--if getAutoByNockasdd_CackFree() then
		if runauto then
			runauto = false
			showUtf8Text('Dừng auto Msct')
		else
			runauto = true
			showUtf8Text('Bắt đầu auto Msct')
		end
		while runauto do
		nx_pause(1)
			local game_client = nx_value("game_client")
			local client_player = game_client:GetPlayer()
			local map_query = nx_value("MapQuery")	
			local game_visual = nx_value('game_visual')
			local game_player = game_visual:GetPlayer()
			local fight = nx_value("fight")
			local mapid = get_current_map()
			if not loading_flag and not nx_is_valid(form_load) then
				nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
				local loading_flag = nx_value("loading")				
				local curseloading = nx_value("form_stage_main\\form_main\\form_main_curseloading")
				if string.find(map_query:GetCurrentScene(), 'born_single_01') ~= nil then
					if FindPlayerTask(1340, 1) then
					local npc = FindNearObject("funnpcborn003031")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end
				  if FindPlayerTask(1347, 1) or FindPlayerTask(1347, 2) or FindPlayerTask(1347, 3) or FindPlayerTask(1347, 4) then
					local npc = FindNearObject("funnpcborn003035")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end
				  if FindPlayerTask(1341, 1) then
					local npc = FindNearObject("NpcBorn003011")
					if npc ~= nil then
					  if get_distance_obj(client_player, npc) > 3 then
						local target = game_visual:GetSceneObj(npc.Ident)
						autoMove(map_query:GetCurrentScene(), target.PositionX, target.PositionY, target.PositionZ, 1)
					  else
						nx_execute("custom_sender", "custom_select", npc.Ident)
						nx_execute("custom_sender", "custom_select", npc.Ident)
						local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
						local game_shortcut = nx_value("GameShortcut")
						local grid = form_shortcut.grid_shortcut_main
						
						for i=0,9 do
						  game_shortcut:on_main_shortcut_useitem(grid, i, true)
						end
					  end
					end
				  end
				  if FindPlayerTask(1341, 2) then
					local npc = FindNearObject("bossborn003001")
					if npc ~= nil then
					  if get_distance_obj(client_player, npc) > 3 then
						local target = game_visual:GetSceneObj(npc.Ident)
						autoMove(map_query:GetCurrentScene(), target.PositionX, target.PositionY, target.PositionZ, 1)
					  else
						nx_execute("custom_sender", "custom_select", npc.Ident)
						nx_execute("custom_sender", "custom_select", npc.Ident)
						local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
						local game_shortcut = nx_value("GameShortcut")
						local grid = form_shortcut.grid_shortcut_main
						
						for i=0,9 do
						  game_shortcut:on_main_shortcut_useitem(grid, i, true)
						end
					  end
					else
					  autoMove(map_query:GetCurrentScene(), 162, -10000, -100, 1)
					end
				  end
				  if FindPlayerTask(1342, 1) or FindPlayerTask(1342, 3) or FindPlayerTask(1342, 4) or FindPlayerTask(1342, 5) then
					local npc = FindNearObject("funnpcborn003032")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  else
						autoMove(map_query:GetCurrentScene(), 128, -10000, -85, 1)
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end
				  if FindPlayerTask(1342, 2) then
					local item = nx_execute("tips_data", "get_item_in_view", nx_int(2), "book_zs_default_01") 
					if item ~= nil then
					  nx_execute("custom_sender", "custom_use_item", 2, item.Ident)
					else
					  fight:TraceUseSkill("zs_default_01", false, false)
					end
				  end
				  if FindPlayerTask(1343, 1) then
					if client_player:QueryProp("LogicState") == 102 then
					  fight:TraceUseSkill("zs_default_01", false, false)
					end
					local npc = FindNearObject("Npcborn003005")
					if npc ~= nil and not npc:FindProp("Dead") then
					  if get_distance_obj(client_player, npc) > 3 then
						local target = game_visual:GetSceneObj(npc.Ident)
						autoMove(map_query:GetCurrentScene(), target.PositionX, target.PositionY, target.PositionZ, 1)
					  else
						nx_execute("custom_sender", "custom_select", npc.Ident)
						nx_execute("custom_sender", "custom_select", npc.Ident)
						local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
						local game_shortcut = nx_value("GameShortcut")
						local grid = form_shortcut.grid_shortcut_main
						
						for i=0,9 do
						  game_shortcut:on_main_shortcut_useitem(grid, i, true)
						end
					  end
					end
				  end
				  if FindPlayerTask(1343, 2) then
					local npc = FindNearObject("funnpcborn003042")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  else
						autoMove(map_query:GetCurrentScene(), 128, -10000, -85, 1)
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end
				  if FindPlayerTask(1343, 3) then
					local item = nx_execute("tips_data", "get_item_in_view", nx_int(125), "useitem_museborn_2") 
					if item ~= nil then
					  if distance3d(game_player.PositionX, game_player.PositionY, game_player.PositionZ, 103.375,12.452,-121.671,-2.517) <= 3 then
						nx_execute("custom_sender", "custom_use_item", 125, item.Ident)
					  else
						autoMove(map_query:GetCurrentScene(), 103.375,12.452,-121.671,-2.517, 1)
					  end
					end
				  end
				  if FindPlayerTask(1343, 4) then
					local npc = FindNearObject("bossborn003002")
					if npc ~= nil then
					  if get_distance_obj(client_player, npc) > 3 then
						local target = game_visual:GetSceneObj(npc.Ident)
						autoMove(map_query:GetCurrentScene(), target.PositionX, target.PositionY, target.PositionZ, 1)
					  else
						nx_execute("custom_sender", "custom_select", npc.Ident)
						nx_execute("custom_sender", "custom_select", npc.Ident)
						local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
						local game_shortcut = nx_value("GameShortcut")
						local grid = form_shortcut.grid_shortcut_main
						
						for i=1,9 do
						  game_shortcut:on_main_shortcut_useitem(grid, i, true)
						end
					  end
					else
					  autoMove(map_query:GetCurrentScene(), 86, -10000, -94, 1)
					end
				  end
				  
				  if FindPlayerTask(1344, 1) or FindPlayerTask(1344, 2) or FindPlayerTask(1344, 5) then
					local npc = FindNearObject("funnpcborn003033")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  step_jump = 1
						end
					  else
						autoMove(map_query:GetCurrentScene(), 26, -10000, -108, 1)
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end

				  if FindPlayerTask(1344, 3) then
					local npc = FindNearObject("GatherBorn003001")
					if npc ~= nil then
					  
					  nx_execute("custom_sender", "custom_select", npc.Ident)
					  nx_execute("custom_sender", "custom_select", npc.Ident)
					  nx_pause(1)					 
					  if step_jump == 1 then
						emit_player_input(game_player, PLAYER_INPUT_HIT_SPACE, true)
						nx_pause(0.7)
						emit_player_input(game_player, PLAYER_INPUT_LOGIC, LOGIC_SERVER_JUMP_POS, 23.547,24.657,-114.188, 1, 1)
						nx_pause(3)
						step_jump = 2
					  elseif step_jump == 2 then
						emit_player_input(game_player, PLAYER_INPUT_HIT_SPACE, true)
						nx_pause(0.7)
						emit_player_input(game_player, PLAYER_INPUT_LOGIC, LOGIC_SERVER_JUMP_POS, 20.106,28.398,-114.499, 1, 1)
						nx_pause(3)
						step_jump = 3
					  elseif step_jump == 3 then
						emit_player_input(game_player, PLAYER_INPUT_HIT_SPACE, true)
						nx_pause(0.7)
						emit_player_input(game_player, PLAYER_INPUT_LOGIC, LOGIC_SERVER_JUMP_POS, 18.938,29.848,-111.966, 1, 1)
						nx_pause(3)
						step_jump = 4
					  end
					end
				  end
				  if FindPlayerTask(1344, 4) then
					local npc = FindNearObject("funnpcborn003033")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  if step_jump == 4 then
							emit_player_input(game_player, PLAYER_INPUT_HIT_SPACE, true)
							nx_pause(0.7)
							emit_player_input(game_player, PLAYER_INPUT_LOGIC, LOGIC_SERVER_JUMP_POS, 20.106,28.398,-114.499, 1, 1)
							nx_pause(3)
							step_jump = 5
						  elseif step_jump == 5 then
							emit_player_input(game_player, PLAYER_INPUT_HIT_SPACE, true)
							nx_pause(0.7)
							emit_player_input(game_player, PLAYER_INPUT_LOGIC, LOGIC_SERVER_JUMP_POS, 23.547,24.657,-114.188, 1, 1)
							nx_pause(3)
							step_jump = 6
						  elseif step_jump == 6 then
							emit_player_input(game_player, PLAYER_INPUT_HIT_SPACE, true)
							nx_pause(0.7)
							emit_player_input(game_player, PLAYER_INPUT_LOGIC, LOGIC_SERVER_JUMP_POS, npc.PosiX, npc.PosiY, npc.PosiZ, 1, 1)
							nx_pause(3)
							step_jump = 7
						  end
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  else
						-- autoMove(map_query:GetCurrentScene(), 26, -10000, -108, 1)
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end
				  if FindPlayerTask(1348, 1)  then
					local npc = FindNearObject("funnpcborn003040")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  else
						autoMove(map_query:GetCurrentScene(), 26, -10000, -108, 1)
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end

				  if FindPlayerTask(1348, 2) then
					local item = nx_execute("tips_data", "get_item_in_view", nx_int(2), "ng_tbook_jh_001")
					if item ~= nil then
					  nx_execute("custom_sender", "custom_use_item", 2, item.Ident)
					else
					  nx_execute("custom_sender", "custom_jingmai_msg", 1, nx_string("jm_dantian"))
					  local npc = FindNearObject("funnpcborn003040")
					  local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					  if not form_talk.Visible then
						if npc ~= nil then
						  if get_distance_obj(client_player, npc) > 3 then
							autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						  else
							nx_execute("custom_sender", "custom_select", npc.Ident)
							nx_execute("custom_sender", "custom_select", npc.Ident)
						  end
						else
						  autoMove(map_query:GetCurrentScene(), 26, -10000, -108, 1)
						end
					  else
						AutoExecMenu(nil, nil, 0)
					  end
					end
				  end


				  if FindPlayerTask(1349, 1) or FindPlayerTask(1349, 2) or FindPlayerTask(1349, 3)  then
					local npc = FindNearObject("funnpcborn003044")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  else
						autoMove(map_query:GetCurrentScene(), 26, -10000, -108, 1)
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end

				  if FindPlayerTask(1349, 4) then
					local npc = FindNearObject("funnpcborn003043")
					if npc ~= nil then
					  if get_distance_obj(client_player, npc) > 3 then
						local target = game_visual:GetSceneObj(npc.Ident)
						autoMove(map_query:GetCurrentScene(), target.PositionX, target.PositionY, target.PositionZ, 1)
					  else
						nx_execute("custom_sender", "custom_select", npc.Ident)
						nx_execute("custom_sender", "custom_select", npc.Ident)
						local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
						local game_shortcut = nx_value("GameShortcut")
						local grid = form_shortcut.grid_shortcut_main
						
						for i=1,9 do
						  game_shortcut:on_main_shortcut_useitem(grid, i, true)
						end
					  end
					else
					  autoMove(map_query:GetCurrentScene(), 35.735,21.647,-108.888, 1)
					end
				  end


				  if FindPlayerTask(1597, 1) then
					local npc = FindNearObject("funnpcborn003044")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  else
						autoMove(map_query:GetCurrentScene(), 26, -10000, -108, 1)
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end



				  if FindPlayerTask(1345, 1) then
					local npc = FindNearObject("funnpcborn003037")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  else
						autoMove(map_query:GetCurrentScene(), 26, -10000, -108, 1)
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end

				  if FindPlayerTask(1346, 1) or FindPlayerTask(1346, 2) then
					local npc = FindNearObject("bossborn003003")
					if npc ~= nil then
					  if get_distance_obj(client_player, npc) > 3 then
						local target = game_visual:GetSceneObj(npc.Ident)
						autoMove(map_query:GetCurrentScene(), target.PositionX, target.PositionY, target.PositionZ, 1)
					  else
						nx_execute("custom_sender", "custom_select", npc.Ident)
						nx_execute("custom_sender", "custom_select", npc.Ident)
						fight:TraceUseSkill("skill_musejuben_1", true, true)
						fight:TraceUseSkill("skill_musejuben_2", true, true)
						fight:TraceUseSkill("skill_musejuben_3", true, true)
						fight:TraceUseSkill("skill_musejuben_4", true, true)
						fight:TraceUseSkill("skill_musejuben_5", true, true)
						fight:TraceUseSkill("skill_musejuben_6", true, true)
						fight:TraceUseSkill("skill_musejuben_7", true, true)
						fight:TraceUseSkill("skill_musejuben_8", true, true)
					  end
					else
					  autoMove(map_query:GetCurrentScene(), -55, -10000, -120, 1)
					end
				  end


				  if FindPlayerTask(1346, 3) then
					local npc = FindNearObject("funnpcborn003034")
					local form_talk = util_get_form("form_stage_main\\form_talk_movie", true)
					if not form_talk.Visible then
					  if npc ~= nil then
						if get_distance_obj(client_player, npc) > 3 then
						  autoMove(map_query:GetCurrentScene(), npc.PosiX, npc.PosiY, npc.PosiZ, 1)
						else
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						  nx_execute("custom_sender", "custom_select", npc.Ident)
						end
					  end
					else
					  AutoExecMenu(nil, nil, 0)
					end
				  end	  
				end
			end	
		end
	--end
end
