function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0) / mult
end

function IsPlayerHaveBuff(buffid)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if not nx_is_valid(client_player) then
	return false
	end
	local has_buff = nx_function("find_buffer", client_player, nx_string(buffid))

	return has_buff
end

function GetDistanceBetweenTwoPoint(x, y, z, x2, y2, z2)
	if(x2 ~= nil and x ~= nil) then
		local offX = x - x2
		local offY = y - y2
		local offZ = z - z2
		return math.sqrt(offX * offX + offY * offY + offZ * offZ)
	else 
		return 10000 
	end

end

function GetEscortObject(teamid)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then
		local scene = game_client:GetScene()
		local visual_objlist = scene:GetSceneObjList()
		if nx_is_valid(scene) then
			for k = 1, table.getn(visual_objlist) do
				local object = visual_objlist[k]
				if nx_is_valid(object) then
					if not game_client:IsPlayer(object.Ident) and object:QueryProp("Type") == 4 then
						if object:FindProp("NpcType") and object:FindProp("TeamID") then
							if object:QueryProp("NpcType") == 213 and object:QueryProp("TeamID") == teamid then
								return object
							end
						end
					end
				end
			end
		end
	end

	return nil
end

function UseItemById(itemid, bag)
	local result = false
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	if nx_is_valid(client_player) then

		local scene = game_client:GetScene()
		local view_table = game_client:GetViewList()
		for i = 1, table.getn(view_table) do
			local view = view_table[i]
			if view.Ident == nx_string(bag) then
    			local view_obj_table = view:GetViewObjList()
    			for k = 1, table.getn(view_obj_table) do
     				local view_obj = view_obj_table[k]
     				if view_obj:QueryProp("ConfigID") == itemid then
     					nx_execute("custom_sender", "custom_use_item", nx_int(bag), view_obj.Ident)
     					result = true
     					break
     				end
     			end
			end
		end
	end
	return result
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

function AutoShowDialog(content)
  local content = nx_function("ext_utf8_to_widestr", content)
  ShowTipDialog(content)
end


function AutoSendMessage(content)
  local content = nx_function("ext_utf8_to_widestr",  "<img src=\"gui\\guild\\map\\battle.png\" valign=\"bottom\" /><font color=\"#5FD00B\">[HT AUTO]</font> " .. content)
  local form_main_chat_logic = nx_value("form_main_chat")
  form_main_chat_logic:AddChatInfoEx(content, 17, false)
end

function GetHomePointFromHPid(hpid)
  local ini = nx_execute("util_functions", "get_ini", "share\\Rule\\HomePoint.ini")
  if not nx_is_valid(ini) then
    return false
  end
  local index = ini:FindSectionIndex(hpid)
  if index < 0 then
    return false
  end
  local hp_info = {}
  hp_info[1] = hpid
  hp_info[2] = ini:ReadInteger(index, "SceneID", 0)
  hp_info[3] = ini:ReadString(index, "Name", "")
  hp_info[4] = ini:ReadInteger(index, "Safe", 0)
  local pos_text = ini:ReadString(index, "PositonXYZ", "")
  hp_info[5] = util_split_string(nx_string(pos_text), ",")
  hp_info[6] = ini:ReadString(index, "Ui_Introduction", "")
  hp_info[7] = ini:ReadString(index, "Ui_Picture", "")
  hp_info[8] = ini:ReadInteger(index, "Type", 0)
  hp_info[9] = ini:ReadString(index, "SpecialSec", "")
  return true, hp_info
end

function isempty(s)
  return s == nil or s == ''
end

function is_busy()
  local client = nx_value("game_client")
      if not nx_is_valid(client) then
        return 0
      end
  local client_player = client:GetPlayer()
  if client_player:FindProp("State") and not isempty(string.find(client_player:QueryProp("State"), "interact")) then return true end
  if client_player:FindProp("State") and not isempty(string.find(client_player:QueryProp("State"), "life")) then return true end
  return false
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
        -- AutoSetStatus(false)
        return false
      end
      local visual_player = game_visual:GetPlayer()
      local player_pos_x = visual_player.PositionX
      local player_pos_y = visual_player.PositionY
      local player_pos_z = visual_player.PositionZ
      local point, dist = nx_execute("auto\\abduct", "FindNearPoint", player_pos_x, player_pos_y, player_pos_z)
      local data = nx_execute("auto\\abduct", "AutoAbductData", nx_value("form_stage_main\\form_map\\form_map_scene").current_map)
      current_point, dist = nx_execute("auto\\abduct", "FindNearPoint", player_pos_x, player_pos_y, player_pos_z, point)
      nx_execute("auto\\abduct", "AutoSetCurrent", current_point)
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