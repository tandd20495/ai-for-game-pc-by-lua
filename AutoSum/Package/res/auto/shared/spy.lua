function GetTinhBao()
  local count = 0
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return 0
  end
  local test = client:GetView("125")
  local view_obj_table = test:GetViewObjList()
  for k = 1, table.getn(view_obj_table) do
    local view_obj = view_obj_table[k]
    if nx_string(view_obj:QueryProp("ConfigID")) == "pry_item" then
      count = view_obj:GetRecordRows("InteractList")
      break
    end
  end
  return count
end

function ___spy(spy_school, spy_count, isStarted)
  local ini = nx_create("IniDocument")
  if not nx_is_valid(ini) then
    return
  end
  local file = nx_resource_path() .. "auto\\data\\spy.ini"
  ini.FileName = file
  local section_name = spy_school
  if not ini:LoadFromFile() or not ini:FindSection(section_name) then
    nx_destroy(ini)
    return
  end
  local cur_spy = 0
  local list_lurkpoint = ini:ReadString(spy_school, "lurk_pos", "")
  local lurk_point = util_split_string(list_lurkpoint, ",")
  local spy_map = ini:ReadString(spy_school, "map", "")
  local found_lurknpc = false
  local count_stuck = 0
  local max_spy = spy_count
  while isStarted() do
    nx_pause(1)
    local loading_flag = "form_common\\form_loading"
    if cur_spy >= nx_number(max_spy) then
      -- so tham xong roi
      break
    end
    local client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    local mgr = nx_value("InteractManager")
    local cur_map = LayMapHienTai()
    local school_type = 0
    local school = ""
    local game_player = game_visual:GetPlayer()
    local client_player = client:GetPlayer()
    -- local fight = nx_value("fight")
    if client_player ~= nil and client_player:FindProp("School") then -- bat phai
      school = client_player:QueryProp("School")
      school_type = 1
    elseif client_player:FindProp("Force") then -- the luc
      school = client_player:QueryProp("Force")
      school_type = 2
    elseif client_player:FindProp("NewSchool") then -- an the
      school = client_player:QueryProp("NewSchool")
      school_type = 3
    end
    if school_type == 0 then -- vo mon phai
      school = "wmp"
    end
    local thichthamlenh = get_item_amount("citanling_item", 125)
    if nx_is_valid(mgr) then
      local return_name = ini:ReadString(school, "return_npc", "")
      local type = mgr:GetCurrentTvtType()
      if mgr:GetInteractTime(0) >= 5 then -- da do tham 5 lan trong ngay
        break
      end
      local form = util_get_form("form_stage_main\\form_talk_movie", true, false)
      if form.Visible then
        local sock = nx_value("game_sock")
        if nx_is_valid(sock) then
          if not nx_is_valid(form) then
            return
          end
          local target = nx_execute("form_stage_main\\form_talk_movie", "get_npcconfigid_by_id", nx_string(form.npcid))
          if type == 0 and not isempty(string.find(target, "lurknpc")) then
            execute_menu("80031")
          elseif 0 < GetTinhBao() and target == return_name then
            execute_menu("80015")
            nx_pause(1)
            execute_menu("80017")
            nx_pause(1)
            found_lurknpc = false
            cur_spy = cur_spy + 1
          elseif target == ini:ReadString(school, "main_npc", "") then
            execute_menu(ini:ReadString(school, "main_menu1", ""))
            nx_pause(1)
            execute_menu(ini:ReadString(school, "main_menu2", ""))
            nx_pause(1)
            if execute_menu(spy_school) then
              nx_pause(1)
            elseif execute_menu(spy_school) == execute_menu(ini:ReadString(school, "main_menu3", "")) then
              nx_pause(1)
              execute_menu(ini:ReadString(school, "main_menu4", ""))
              nx_pause(1)
            elseif execute_menu(spy_school) == execute_menu(ini:ReadString(school, "main_menu5", "")) then
              nx_pause(1)
              execute_menu(ini:ReadString(school, "main_menu6", ""))
              nx_pause(1)
            elseif execute_menu(spy_school) == execute_menu(ini:ReadString(school, "main_menu7", "")) then
              nx_pause(1)
              execute_menu(ini:ReadString(school, "main_menu8", ""))
              nx_pause(1)
            elseif execute_menu(spy_school) == execute_menu(ini:ReadString(school, "main_menu9", "")) then
              nx_pause(1)
              execute_menu(ini:ReadString(school, "main_menu10", ""))
              nx_pause(1)
            elseif execute_menu(spy_school) == execute_menu(ini:ReadString(school, "main_menu11", "")) then
              nx_pause(1)
              execute_menu(ini:ReadString(school, "main_menu12", ""))
              nx_pause(1)
            elseif execute_menu(spy_school) == execute_menu(ini:ReadString(school, "main_menu13", "")) then
              nx_pause(1)
              execute_menu(ini:ReadString(school, "main_menu14", ""))
              nx_pause(1)
            elseif execute_menu(spy_school) == execute_menu(ini:ReadString(school, "main_menu15", "")) then
              nx_pause(1)
              execute_menu(ini:ReadString(school, "main_menu16", ""))
              nx_pause(1)
            elseif execute_menu(spy_school) == execute_menu(ini:ReadString(school, "main_menu17", "")) then
              nx_pause(1)
              execute_menu(ini:ReadString(school, "main_menu18", ""))
              nx_pause(1)
            end
          elseif school_type == 3 and target == ini:ReadString(school, "relive_npc", "") then -- noi chuyen voi lien lac su den phai tuong quan
            execute_menu(ini:ReadString(school, "relive_menu", ""))
            nx_pause(1)
            execute_menu(ini:ReadString(school, "relive_menu1", ""))
            nx_pause(1)
            execute_menu(0, ini:ReadString(school, "relive_partner", ""))
          end
        end
      elseif 0 < GetTinhBao() then
        if cur_map ~= ini:ReadString(school, "map", "") then
          if school_type == 3 and cur_map == ini:ReadString(school, "relive_map", "") then
            local list_relive = ini:ReadString(school, "relive_pos", "")
            local relive_point = util_split_string(list_relive, ",")
            local relive_pos = {relive_point[1], relive_point[2], relive_point[3], relive_point[4]}
            if not arrived(relive_pos, 2) then-- and not is_path_finding() then
              -- den lien lac su
              move(relive_pos, 2)
            else
              local scene = client:GetScene()
              if nx_is_valid(scene) then
                local npc = getNpcById(ini:ReadString(school, "relive_npc", ""))
                if npc ~= nil then
                  target_npc_by_ident(npc.Ident)
                  nx_pause(0.5)
                end
              end
            end
          elseif client_player:FindProp("Dead") then
            -- hoi sinh mon phai
            nx_execute("custom_sender", "custom_relive", 0, 0)
          else
            if nx_function("find_buffer", client_player, "buf_riding_01") then
              -- xuong ngua
              nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
            end
            if not nx_function("find_buffer", client_player, "buf_CS_jh_tmjt06") then
              -- tu sat ma khi tung hoang
              -- fight:TraceUseSkill("CS_jh_tmjt06", false, false)
              tu_sat()
            end
          end
        else
          local return_map = ini:ReadString(school, "map", "")
          local return_npc = ini:ReadString(school, "return_npc", "")
          -- local return_list = ini:ReadString(school, "return_point", "")
          -- local return_point = util_split_string(return_list, ",")
          local return_pos = get_npc_pos(return_map, return_npc)-- {return_point[1], return_point[2], return_point[3], return_point[4]}
          if not arrived(return_pos, 5) then --and not is_path_finding() then
            -- tra tinh bao
            move(return_pos, 2)
          else
            local scene = client:GetScene()
            if nx_is_valid(scene) then
              local npc = getNpcById(return_npc)
              if npc ~= nil then
                target_npc_by_ident(npc.Ident)
                nx_pause(0.5)
              end
            end
          end
        end
      elseif type == 0 then
        if not nx_is_valid(nx_value(loading_flag)) and nx_is_valid(game_visual) then
          if get_item_amount("item_wfqb01", 2) > 0 then -- truc dao hoang long
            dung_vat_pham("item_wfqb01", 1, 1)
          else
            local last_x, last_y, last_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ
            local scene = client:GetScene()
            if nx_is_valid(scene) then
              local scene_obj_table = scene:GetSceneObjList()
              for k = 1, table.getn(scene_obj_table) do
                local scene_obj = scene_obj_table[k]
                local id = scene_obj.Ident
                if not isempty(string.find(scene_obj:QueryProp("ConfigID"), "lurknpc")) then
                  local visual_npc = game_visual:GetSceneObj(id)
                  local x, y, z = visual_npc.PositionX, visual_npc.PositionY, visual_npc.PositionZ
                  found_lurknpc = true
                  move({x,y,z}, 3, "Tìm nội ứng")
                  nx_pause(1)
                  target_npc_by_ident(id)
                  nx_pause(0.5)
                  break
                end
              end
            end
            local lurk_pos = {lurk_point[1], lurk_point[2], lurk_point[3], lurk_point[4]}
            if not arrived(lurk_pos, 2) and not found_lurknpc then
              move(lurk_pos, 3, "Tìm nội ứng")
              last_x, last_y, last_z = game_player.PositionX, game_player.PositionY, game_player.PositionZ
            end
          end
        end
      elseif cur_map ~= spy_map then
        local relive_map = ini:ReadString(school, "relive_map", "")
        local relive_npc = ini:ReadString(school, "relive_npc", "")
        if school_type == 3 and cur_map == relive_map then
          -- local list_relive = ini:ReadString(school, "relive_pos", "")
          -- local relive_point = util_split_string(list_relive, ",")
          local pos = get_npc_pos(relive_map, relive_npc) --{relive_point[1], relive_point[2], relive_point[3], relive_point[4]}
          move(pos, 2)
          local scene = client:GetScene()
          if nx_is_valid(scene) then
            local relive_npc = getNpcById(relive_npc)
            if relive_npc ~= nil then
              target_npc_by_ident(relive_npc.Ident)
            end
          end
        elseif thichthamlenh > 0 then
          if cur_map == ini:ReadString(school, "map", "") then -- da den map tuong quang
            local list_main = ini:ReadString(school, "main_pos", "")
            local main_point = util_split_string(list_main, ",")
            local pos = {main_point[1], main_point[2], main_point[3], main_point[4]}
            local scene = client:GetScene()
            if nx_is_valid(scene) then
              move(pos, 2) -- den chuong mon xin do tham
              local chuong_mon = getNpcById(ini:ReadString(school, "main_npc", ""))
              if chuong_mon ~= nil then
                target_npc_by_ident(chuong_mon.Ident)
              end
            end
          elseif client_player:FindProp("Dead") then
            -- hoi sinh ve mon phai
            nx_execute("custom_sender", "custom_relive", 0, 0)
          else
            if nx_function("find_buffer", client_player, "buf_riding_01") then
              -- tu xuong ngu
              nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
            end
            if not nx_function("find_buffer", client_player, "buf_CS_jh_tmjt06") then
              -- tu sat bang ma khi tung hoanh
              -- fight:TraceUseSkill("CS_jh_tmjt06", false, false)
              tu_sat()
            end
          end
        else
          local homepoint = ini:ReadString(spy_school, "homepoint", "")
          local is_exits_point = nx_execute("form_stage_main\\form_homepoint\\home_point_data", "IsExistRecordHomePoint", homepoint)
          if is_exits_point then
            local bRet, hp_info = GetHomePointFromHPid(homepoint)
            if bRet then
              nx_execute("form_stage_main\\form_homepoint\\home_point_data", "send_homepoint_msg_to_server", 1, hp_info[1], hp_info[8])
              nx_pause(10)
            end
          else
            local last_point = client_player:GetRecordRows("HomePointList") - 1
            local point = client_player:QueryRecord("HomePointList", last_point, 0)
            nx_execute("form_stage_main\\form_homepoint\\home_point_data", "send_homepoint_msg_to_server", 3, point)
            nx_pause(1)
            nx_execute("form_stage_main\\form_homepoint\\home_point_data", "send_homepoint_msg_to_server", 2, homepoint)
          end
        end
      else
        -- bat dau do tham
        add_chat_info("Bat Dau Do Tham")
        nx_execute("custom_sender", "custom_send_interact_msg", 6, 0, 0)
      end
    end
  end
end