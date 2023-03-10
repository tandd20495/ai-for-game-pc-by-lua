
function addToSet(set, key)
    set[key] = true
end

function removeFromSet(set, key)
    set[key] = nil
end

function setContains(set, key)
    return set[key] ~= nil
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0) / mult
end

function AutoMove(x, y, z, a, npc_id, mapid)
    local game_visual = nx_value("game_visual")
    if nx_is_valid(game_visual) then
      if mapid == nil then mapid = nx_value("form_stage_main\\form_map\\form_map_scene").current_map end
      local path_finding = nx_value("path_finding")
      if npc_id == nil then
        path_finding:FindPathScene(mapid, nx_float(x), nx_float(y), nx_float(z), nx_float(a))
      else
        path_finding:TraceTargetByID(mapid, nx_float(x), nx_float(y), nx_float(z), 1.8, npc_id)
      end
 
    end
end

function AutoGetCurSelect(type)
  local selectobj = nx_value(GAME_SELECT_OBJECT)
  if not nx_is_valid(selectobj) then
    return nx_widestr("")
  end
  local objtype = selectobj:QueryProp("Type")
  if nx_number(objtype) == 2 then
    return selectobj:QueryProp("Name")
  else
    if type == nil then return selectobj:QueryProp("ConfigID"), selectobj.PosiX, selectobj.PosiY, selectobj.PosiZ, selectobj.Orient
    else return selectobj.Ident
    end
  end
  return nx_widestr("")
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


function GetFileDir( type, content)
  local game_config = nx_value("game_config")
  local account = game_config.login_account
    local dir = nx_function("ext_get_current_exe_path") .. "ht_auto_" .. account 
    local file = ""
    if not nx_function("ext_is_exist_directory", nx_string(dir)) then
      nx_function("ext_create_directory", nx_string(dir))
    end
    if type == 1 then
      file = dir .. nx_string("\\auto_pickup.txt")
    elseif type == 2 then
      file = dir .. nx_string("\\auto_buff_boss.txt")
    elseif type == 3 then
      file = dir .. nx_string("\\auto_ht.ini")
    elseif type == 4 then
      file = dir .. nx_string("\\auto_tim_dan.txt")
    elseif type == 5 then
      file = dir .. nx_string("\\auto_kyngo.txt")
    elseif type == 6 then
      file = dir .. nx_string("\\pos_"..content..".txt")  
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
      thth:AddString("auto_boqua=false")
      thth:AddString("auto_usekcl=false")
      thth:AddString("auto_oskill=false")
      thth:AddString("selectskill=1")
      thth:AddString("tab1=6")
      thth:AddString("tab2=6")
      thth:AddString("tab3=4")
      thth:AddString("tab4=4")
    end
      thth:SaveToFile(file)
    end

    return file
end

function is_in_pick_list( type, content, ntype )
  local file = GetFileDir(type, ntype)
  local gm_list = nx_create("StringList")
  if not gm_list:LoadFromFile(file) then
    nx_destroy(gm_list)
    return 0
  end
  local gm_num = gm_list:GetStringCount()
  for i = 0, gm_num - 1 do
    local gm = gm_list:GetStringByIndex(i)
    if gm ~= "" and gm == content then
      return true
    end
  end
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
      nx_execute("auto\\abduct", "AutoSetCurrent", 2)
      AutoMove(data.pos[2].x,data.pos[2].y,data.pos[2].z,data.pos[2].o)
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