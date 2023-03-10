require("auto_new\\autocack")
if not load_auto_script then
  auto_cack("0")
  auto_cack("1")
  auto_cack("2")
  auto_cack("8")
  auto_cack("11")
  load_auto_script = true
end
function skill_not_follow()
  if run_auto_skill then
    run_auto_skill = false
    showUtf8Text("Stop Auto Skill Non Target")
  else
    run_auto_skill = true
    showUtf8Text("Stop Auto Skill Non Target")
  end
  while run_auto_skill do
    local game_shortcut = nx_value("GameShortcut")
    local form_shortcut = nx_value("form_stage_main\\form_main\\form_main_shortcut")
    local grid = form_shortcut.grid_shortcut_main
    if nx_is_valid(game_shortcut) then
      for i = 0, 9 do
        game_shortcut:on_main_shortcut_useitem(grid, i, false)
      end
    end
    nx_pause(1)
  end
end
local box_list = {
  "BoxNpc10001",
  "BoxNpc10002",
  "BoxNpc10003",
  "BoxNpc10004",
  "BoxNpc10005",
  "BoxNpc10006",
  "BoxNpc10007",
  "BoxNpc10008",
  "BoxNpc10009",
  "BoxNpc10010",
  "BoxNpc10011",
  "BoxNpc10012"
}
function start_stop_auto_speed()
  if nx_running("auto_new\\auto_special_lib", "autoSpeed") then
    nx_execute("auto_new\\auto_special_lib", "set_state_speed", false)
    nx_kill("auto_new\\auto_special_lib", "autoSpeed")
    showUtf8Text("Stop Auto Speed")
  else
    nx_execute("auto_new\\auto_special_lib", "set_state_speed", true)
    nx_execute("auto_new\\auto_special_lib", "autoSpeed")
    showUtf8Text("Start Auto Speed")
  end
end
function start_stop_auto_exit()
  nx_execute("auto_new\\auto_special_lib", "AutoSetEnd")
end
function start_stop_auto_exit_end()
  nx_execute("auto_new\\auto_special_lib", "AutoExitEnd")
end
function start_stop_auto_def()
  if nx_running("auto_new\\auto_special_lib", "autoDefSkillCustom") then
    autoRunDef = false
    nx_kill("auto_new\\auto_special_lib", "autoDefSkillCustom")
    showUtf8Text("Stop Auto Def")
  else
    autoRunDef = true
    nx_execute("auto_new\\auto_special_lib", "autoDefSkillCustom", true)
    showUtf8Text("Start Auto Def")
  end
end
function start_stop_auto_ping_pro()
  if nx_running("auto_new\\auto_special_lib", "crash_skill_test") then
    nx_kill("auto_new\\auto_special_lib", "crash_skill_test")
    showUtf8Text("Stop Auto Ping Pro")
  else
    nx_execute("auto_new\\auto_special_lib", "crash_skill_test", true)
    showUtf8Text("Start Auto Ping Pro")
  end
end
function start_stop_auto_ping_classic()
  if nx_running("auto_new\\auto_special_lib", "crash_skill_test_2") then
    nx_kill("auto_new\\auto_special_lib", "crash_skill_test_2")
    showUtf8Text("Stop Auto Ping Classic")
  else
    nx_execute("auto_new\\auto_special_lib", "crash_skill_test_2", true)
    showUtf8Text("Start Auto Ping Classic")
  end
end
function start_stop_auto_thbb()
  nx_execute("auto_new\\auto_special_lib", "autoTHBB")
end
function start_stop_auto_check_time()
  if nx_running("auto_new\\auto_special_lib", "check_action_skill_time") then
    nx_kill("auto_new\\auto_special_lib", "check_action_skill_time")
    nx_execute("auto_new\\auto_special_lib", "set_check_action_time", false)
    showUtf8Text("Stop Auto Ping Classic")
  else
    nx_execute("auto_new\\auto_special_lib", "check_action_skill_time")
    showUtf8Text("Start Auto Ping Classic")
  end
end
function autoRunDefTarget()
  if nx_running("auto_new\\auto_special_lib", "auto_start_def") then
    nx_kill("auto_new\\auto_special_lib", "auto_start_def")
    showUtf8Text("Stop Auto target", 3)
  else
    nx_execute("auto_new\\auto_special_lib", "auto_start_def")
    showUtf8Text("Start Auto target", 3)
  end
end
function start_stop_auto_swap()
  if nx_running("auto_new\\auto_special_lib", "startSwapAuto") then
    nx_execute("auto_new\\auto_special_lib", "setAutoSwapStateSpec", false)
    nx_kill("auto_new\\auto_special_lib", "startSwapAuto")
    showUtf8Text("Stop Auto Swap")
  else
    nx_execute("auto_new\\auto_special_lib", "setAutoSwapStateSpec", true)
    nx_execute("auto_new\\auto_special_lib", "startSwapAuto")
    showUtf8Text("Start Auto Swap")
  end
end
function auto_swap_add()
  if nx_running(nx_current(), "swapauto") then
    nx_kill(nx_current(), "swapauto")
    setAutoSwapState(false)
    showUtf8Text("Stop Auto Swap")
  else
    setAutoSwapState(true)
    nx_execute(nx_current(), "swapauto")
    showUtf8Text("Start Auto Swap")
  end
end
function break_parry_auto()
  if nx_running("auto_new\\auto_special_lib", "auto_start_undef") then
    nx_kill("auto_new\\auto_special_lib", "auto_start_undef")
    showUtf8Text("Stop Auto Undef")
  else
    nx_execute("auto_new\\auto_special_lib", "auto_start_undef")
    showUtf8Text("Start Auto Undef")
  end
end
function auto_bug_quat()
  if nx_running("auto_new\\auto_special_lib", "auto_start_stop_quat") then
    nx_kill("auto_new\\auto_special_lib", "auto_start_stop_quat")
    showUtf8Text("Stop Auto Bug Qu\225\186\161t")
  else
    nx_execute("auto_new\\auto_special_lib", "auto_start_stop_quat")
    showUtf8Text("Start Auto Bug Qu\225\186\161t")
  end
end
function auto_bug_full_hpmp()
  if nx_running("auto_new\\auto_special_lib", "auto_bug_full_hpmp_full") then
    nx_kill("auto_new\\auto_special_lib", "auto_bug_full_hpmp_full")
    showUtf8Text("Stop Auto Bug HPMP")
  else
    nx_execute("auto_new\\auto_special_lib", "auto_bug_full_hpmp_full")
  end
end
function start_stop_auto_def()
  if nx_running("auto_new\\auto_special_lib", "autoDefSkillCustom") then
    autoRunDef = false
    nx_kill(nx_current(), "autoDefSkillCustom")
    showUtf8Text("Stop Auto Def")
  else
    autoRunDef = true
    nx_execute("auto_new\\auto_special_lib", "autoDefSkillCustom", true)
    showUtf8Text("Start Auto Def")
  end
end
function auto_use_neixiu()
  if nx_running("auto_new\\autocack", "auto_start_ai") or nx_running("auto_new\\form_auto_ai_new", "auto_start_ai") then
    showUtf8Text(AUTO_LOG_RUNNING_AUTO_AI)
    return
  end
  if nx_running(nx_current(), "auto_start_use_item_neixiu") then
    nx_execute(nx_current(), "setItemStateNeixiu", false)
    nx_kill(nx_current(), "auto_start_use_item_neixiu")
    showUtf8Text("Stop Use Item Neixiu")
  else
    nx_execute(nx_current(), "setItemStateNeixiu", true)
    nx_execute(nx_current(), "auto_start_use_item_neixiu")
    showUtf8Text("Start Use Item Neixiu")
  end
end
function find_rabits_obj()
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return
  end
  local game_scene = game_client:GetScene()
  if not nx_is_valid(game_scene) then
    return
  end
  local tmp_distance = 99999
  local tmp_obj
  if nx_is_valid(game_scene) then
    local scene_obj_table = game_scene:GetSceneObjList()
    for k = 1, table.getn(scene_obj_table) do
      local scene_obj = scene_obj_table[k]
      if nx_is_valid(scene_obj) and scene_obj:QueryProp("ConfigID") == "zhongqiu_tuzi_1" then
        local d = getDistance(scene_obj)
        if tmp_distance > d then
          tmp_distance = d
          tmp_obj = scene_obj
        end
      end
    end
  end
  if nx_is_valid(tmp_obj) then
    return tmp_obj
  end
  return nil
end
function auto_catch_rab(num)
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return 0
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return 0
  end
  local game_player = game_visual:GetPlayer()
  local client_player = client:GetPlayer()
  if autorun_rab then
    autorun_rab = false
    showUtf8Text("Stop catch rabbits", 3)
  else
    autorun_rab = true
    showUtf8Text("Start catch rabbits", 3)
  end
  local stage_main_flag = nx_value("stage_main")
  local loading_flag = nx_value("loading")
  local player = getPlayer()
  local x, y, z = getCurPos()
  if num == nil then
    num = 15
  end
  while autorun_rab do
    if nx_is_valid(player) and not loading_flag and nx_string(stage_main_flag) == nx_string("success") then
      local npc = FindObject("zhongqiu_npc_sz")
      if npc and nx_is_valid(npc) then
        local x, y, z = npc.DestX, npc.DestY, npc.DestZ
        if 3 > getDistance(npc) then
          nx_pause(0.5)
          local id = npc.Ident
          autoSelectObj(id)
          talk_with_npc("zhongqiu_sz_cd;zhongqiu_sz_bt_02;zhongqiu_sz_cd_04")
        else
          moveTo(x, y, z)
          nx_pause(0.5)
        end
      elseif nx_number(getDistanceFromPos(x, y, z)) < nx_number(num) then
        local auto_obj_rab = find_rabits_obj()
        if auto_obj_rab and nx_is_valid(auto_obj_rab) then
          local ox, oy, oz = auto_obj_rab.DestX, auto_obj_rab.DestY, auto_obj_rab.DestZ
          if 3 > getDistance(auto_obj_rab) then
            local id = auto_obj_rab.Ident
            autoSelectObj(id)
            use_skill_configid(nx_string("zhongqiu_skill_03_c"), auto_obj_rab, true)
            use_skill_configid(nx_string("zhongqiu_skill_03_d"), auto_obj_rab, true)
          else
            moveTo(ox, oy, oz)
            nx_pause(0.5)
          end
        end
      else
        moveTo(x, y, z)
        nx_pause(1)
      end
    end
    nx_pause(1)
  end
end
function auto_drink(num)
  if run_drink then
    run_drink = false
    showUtf8Text("Stop drink")
  else
    run_drink = true
    showUtf8Text("Start drink")
  end
  if num == nil then
    num = 5
  end
  while run_drink do
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    if nx_is_valid(game_client) and nx_is_valid(game_visual) then
      local player_client = game_client:GetPlayer()
      local game_player = game_visual:GetPlayer()
      local game_scence = game_client:GetScene()
      local goods_grid = nx_value("GoodsGrid")
      local buf_level, buf_time_left, buf_stack = get_buff_info_data("buf_skill_uselimit")
      if goods_grid:GetItemCount("jiu_10001") == 0 then
        BuyItem("jiu_10001", 30)
      elseif not nx_function("find_buffer", player_client, "buf_drunk_1") and not nx_function("find_buffer", player_client, "buf_drunk_2") and not nx_function("find_buffer", player_client, "buf_drunk_3") and player_client:QueryProp("State") ~= "offact289" then
        local form_shop = nx_value("form_stage_main\\form_shop\\form_shop")
        if nx_is_valid(form_shop) then
          nx_value("game_visual"):CustomSend(nx_int(165), 0)
        end
        if not IsBusy() and not nx_is_valid(form_shop) then
          UseItemByID("jiu_10001")
        end
      end
    end
    nx_pause(1)
  end
end
function autoShowHideHpRatioBar()
  local form = nx_value(FORM_MAIN_SELECT)
  if nx_is_valid(form) then
    if not form.prog_hp.TextVisible then
      form.prog_hp.TextVisible = true
    else
      form.prog_hp.TextVisible = false
    end
  end
end
function set_win_title_auto()
  local title = nx_value("game_sock").account
  nx_function("ext_set_window_title", nx_widestr(title))
end
function set_win_title_auto_name()
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return
  end
  local client_player = game_client:GetPlayer()
  if not nx_is_valid(client_player) then
    return
  end
  local title = client_player:QueryProp("Name")
  nx_function("ext_set_window_title", nx_widestr(title))
end
function auto_shop_ghlt()
  local form_shop = nx_value("form_stage_main\\form_shop\\form_shop")
  if nx_is_valid(form_shop) then
    nx_execute("custom_sender", "custom_open_mount_shop", 0)
  else
    nx_execute("custom_sender", "custom_open_mount_shop", 1)
  end
end
function auto_tele_thanhhai()
  local game_visual = nx_value("game_visual")
  game_visual:CustomSend(nx_int(554), nx_int(1))
end
function auto_tele_dhc()
  local game_visual = nx_value("game_visual")
  game_visual:CustomSend(nx_int(521), nx_int(1))
end
function auto_show_bokhoai()
  local game_visual = nx_value("game_visual")
  game_visual:CustomSend(nx_int(926), nx_int(8))
end
function auto_show_haibo()
  util_auto_show_form("form_stage_main\\form_arrest\\form_publish_arrest")
end
function auto_show_tsl()
  util_auto_show_form("form_stage_main\\form_arrest\\form_publish_arrest")
end
DataTransTool = {
  school01 = {
    npc = "Transschool01A",
    mapid = 13
  },
  school02 = {
    npc = "Transschool02A",
    mapid = 13
  },
  school03 = {
    npc = "Transschool03A",
    mapid = 14
  },
  school04 = {
    npc = "Transschool04A",
    mapid = 14
  },
  school05 = {
    npc = "Transschool05A",
    mapid = 17
  },
  school06 = {
    npc = "Transschool06A",
    mapid = 17
  },
  school07 = {
    npc = "Transschool07A",
    mapid = 16
  },
  school08 = {
    npc = "Transschool08A",
    mapid = 16
  },
  school20 = {
    npc = "Transschool08A",
    mapid = 16
  },
  school22 = {
    npc = "Transschool08A",
    mapid = 16
  },
  school23 = {
    npc = "Transschool08A",
    mapid = 16
  },
  school24 = {
    npc = "Transschool08A",
    mapid = 16
  },
  school25 = {
    npc = "Transschool08A",
    mapid = 16
  }
}
function delete_key_auto()
  local game_config = nx_value("game_config")
  local account = game_config.login_account
  local server_ID = game_config.server_id
  local dir1 = nx_function("ext_get_current_exe_path") .. "nockasdd_" .. account .. "_" .. nx_string("7100028")
  local dir2 = nx_function("ext_get_current_exe_path") .. "nockasdd_" .. account .. "_" .. nx_string(server_ID)
  if nx_function("ext_is_exist_directory", nx_string(dir1)) and nx_function("ext_is_exist_directory", nx_string(dir2)) then
    local ini_file1 = dir1 .. "\\Active.ini"
    local ini_file2 = dir2 .. "\\Active.ini"
    writeIni(ini_file1, "key", "lic", "")
    writeIni(ini_file2, "key", "lic", "")
    writeIni(ini_file1, "key", "lic_full", "")
    writeIni(ini_file2, "key", "lic_full", "")
    writeIni(ini_file1, "key", "lic_ab", "")
    writeIni(ini_file2, "key", "lic_ab", "")
  end
end
function find_npc_auto_trans(npc)
  if not npc then
    return nil
  end
  local game_client = nx_value("game_client")
  local game_visual = nx_value("game_visual")
  if nx_is_valid(game_client) and nx_is_valid(game_visual) then
    local game_player = game_visual:GetPlayer()
    local game_scence = game_client:GetScene()
    local game_scence_objs = game_scence:GetSceneObjList()
    local num_objs = table.getn(game_scence_objs)
    for i = 1, num_objs do
      local object = game_scence_objs[i]
      if nx_is_valid(object) and not game_client:IsPlayer(object.Ident) and object:QueryProp("Type") == 4 and object:QueryProp("ConfigID") == npc then
        local vis_object = game_visual:GetSceneObj(object.Ident)
        if nx_is_valid(vis_object) then
          return object
        end
      end
    end
  end
  return nil
end
function autoCreateZhiHua()
  local name_zhenfa = ""
  local text = ""
  local textName = ""
  if CheckCreZhiHua then
    CheckCreZhiHua = false
    showUtf8Text("Stop Create ZhiHua")
  else
    showUtf8Text("Start Create ZhiHua")
    local gui = nx_value("gui")
    local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_input_name", true, false)
    dialog.lbl_title.Text = utf8ToWstr("Nh\225\186\173p T\195\170n ")
    dialog.info_label.Text = utf8ToWstr("T\195\170n L\225\186\173p Tr\225\186\173n")
    dialog.allow_empty = false
    dialog:ShowModal()
    local res, new_name = nx_wait_event(100000000, dialog, "input_name_return")
    if res == "cancel" then
      return 0
    else
      textName = new_name
    end
    nx_pause(0.3)
    local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_inputbox", true, false)
    dialog.info_label.Text = nx_function("ext_utf8_to_widestr", "1:\196\144\225\187\139a,2:Tr\195\173chn,3:Tam,4:\196\144ao,5:S\198\176u,6:Huy\225\187\129n")
    dialog.name_edit.Text = nx_widestr("1")
    dialog:ShowModal()
    local res, text = nx_wait_event(100000000, dialog, "input_box_return")
    if res == "ok" then
      if nx_int(text) == nx_int(1) then
        name_zhenfa = utf8ToWstr("\196\144\225\187\139a Di\225\187\135t Tr\225\186\173n")
      elseif nx_int(text) == nx_int(2) then
        name_zhenfa = utf8ToWstr("Tr\195\173ch Tinh Tr\225\186\173n")
      elseif nx_int(text) == nx_int(3) then
        name_zhenfa = utf8ToWstr("Tam Tuy\225\187\135t Tr\225\186\173n")
      elseif nx_int(text) == nx_int(4) then
        name_zhenfa = utf8ToWstr("\196\144ao V\195\181ng Tr\225\186\173n")
      elseif nx_int(text) == nx_int(5) then
        name_zhenfa = utf8ToWstr("S\198\176u S\195\161t Tr\225\186\173n")
      elseif nx_int(text) == nx_int(6) then
        name_zhenfa = utf8ToWstr("Huy\225\187\129n Th\225\187\167y Tr\225\186\173n")
      else
        showUtf8Text("Auto ch\225\187\137 h\225\187\149 tr\225\187\163 tr\225\186\173n kim lan b\225\186\175t \196\145\225\186\167u l\225\186\161i", 3)
        return
      end
    else
      return
    end
    CheckCreZhiHua = true
  end
  while CheckCreZhiHua do
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    local game_scence = game_client:GetScene()
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    local game_scence_objs = game_scence:GetSceneObjList()
    local stage_main_flag = nx_value("stage_main")
    local loading_flag = nx_value("loading")
    if nx_is_valid(game_client) and nx_is_valid(game_visual) and nx_is_valid(game_scence) and nx_is_valid(client_player) and not loading_flag and nx_string(stage_main_flag) == nx_string("success") and client_player:QueryProp("ZhenFaEffect") ~= "battleform_effect_1c" then
      local nameplayer = targetPlayer(textName)
      nx_pause(0.5)
      if name_zhenfa == utf8ToWstr("\196\144\225\187\139a Di\225\187\135t Tr\225\186\173n") then
        zhenfa = "zhenfa_jiebai_01"
      elseif name_zhenfa == utf8ToWstr("Tr\195\173ch Tinh Tr\225\186\173n") then
        zhenfa = "zhenfa_jiebai_02"
      elseif name_zhenfa == utf8ToWstr("Tam Tuy\225\187\135t Tr\225\186\173n") then
        zhenfa = "zhenfa_jiebai_03"
      elseif name_zhenfa == utf8ToWstr("\196\144ao V\195\181ng Tr\225\186\173n") then
        zhenfa = "zhenfa_jiebai_04"
      elseif name_zhenfa == utf8ToWstr("S\198\176u S\195\161t Tr\225\186\173n") then
        zhenfa = "zhenfa_jiebai_05"
      elseif name_zhenfa == utf8ToWstr("Huy\225\187\129n Th\225\187\167y Tr\225\186\173n") then
        zhenfa = "zhenfa_jiebai_07"
      else
        showUtf8Text("Auto ch\225\187\137 h\225\187\149 tr\225\187\163 tr\225\186\173n kim lan", 3)
        return
      end
      nx_execute("custom_sender", "custom_use_zhenfa", zhenfa)
      nx_pause(5)
      nx_execute("custom_sender", "custom_select_cancel")
    end
    nx_pause(0.1)
  end
end
local max_find_distance = 25
local dn_obj
function targetPlayer(name)
  local game_client = nx_value("game_client")
  local game_visual = nx_value("game_visual")
  local scene = game_client:GetScene()
  local client_player = game_client:GetPlayer()
  local visual_player = game_visual:GetPlayer()
  local scene_obj_table = scene:GetSceneObjList()
  local r = 1000
  local obj
  local move = false
  local mapid = getCurrentScene_id()
  local is_path_finding = nx_value("path_finding")
  for i = 1, table.getn(scene_obj_table) do
    local scene_obj = scene_obj_table[i]
    if nx_is_valid(scene_obj) and scene_obj:QueryProp("Type") == 2 and not nx_id_equal(client_player, scene_obj) and not scene_obj:FindProp("Dead") and scene_obj:QueryProp("Name") == name and getDistance(scene_obj) <= max_find_distance then
      local tmp_r = getDistance(scene_obj)
      if r > tmp_r then
        r = tmp_r
        obj = scene_obj
      end
    end
  end
  if obj ~= nil and nx_is_valid(nx_value("game_visual")) and nx_is_valid(obj) then
    dn_obj = obj
    nx_execute("custom_sender", "custom_select", dn_obj.Ident)
    nx_pause(0.5)
    nx_execute("custom_sender", "custom_select", dn_obj.Ident)
    return true
  end
  return false
end
function auto_findbox()
  local scene_creator = nx_value("SceneCreator")
  local map_query = nx_value("MapQuery")
  for k = 1, table.getn(box_list) do
    local res = scene_creator:GetNpcPosition(map_query:GetCurrentScene(), nx_string(box_list[k]))
    if table.getn(res) >= 3 then
      local x, y, z = 0, 0, 0
      local treex = string.format("%.0f", x)
      local treez = string.format("%.0f", z)
      local count = 1
      for n = 1, table.getn(res) do
        if count >= 3 then
          local name = nx_function("ext_widestr_to_utf8", util_text(box_list[k]))
          if count == 3 then
            z = res[n]
          end
          local form_map = nx_value("form_stage_main\\form_map\\form_map_scene")
          if not nx_is_valid(form_map) then
            return
          end
          nx_execute("form_stage_main\\form_map\\form_map_scene", "add_defined_label", form_map, x, 0, z, 1996, k)
          local content = "<font color=\"#b7c888\">" .. name .. "</font> - T\225\187\141a \196\145\225\187\153 : " .. string.format("%.0f", x) .. "," .. string.format("%.0f", z) .. "<a href=\"findpath," .. map_query:GetCurrentScene() .. "," .. x .. "," .. y .. "," .. z .. "\" style=\"HLStype1\">[\196\144i t\225\187\155i]</a>"
          showSystemUtf8Text(content, 17)
          nx_pause(0.5)
          count = 1
        else
          if count == 1 then
            x = res[n]
          end
          if count == 2 then
            y = res[n]
          end
          if count == 3 then
            z = res[n]
          end
          count = count + 1
        end
      end
    end
  end
end
local tree_list = {
  "Box_jzsj_001",
  "Box_jzsj_002",
  "Box_jzsj_003",
  "Box_jzsj_004",
  "Box_jzsj_005",
  "Box_jzsj_006",
  "Box_jzsj_007",
  "Box_jzsj_008",
  "Box_jzsj_009",
  "Box_jzsj_010",
  "Box_jzsj_011",
  "Box_jzsj_012",
  "Box_jzsj_013",
  "Box_jzsj_014",
  "Box_jzsj_015"
}
function autoFindtreeLocation()
  local scene_creator = nx_value("SceneCreator")
  local map_query = nx_value("MapQuery")
  showUtf8Text(AUTO_LOG_LOCATION_TREE, 3)
  for k = 1, table.getn(tree_list) do
    local res = scene_creator:GetNpcPosition(map_query:GetCurrentScene(), nx_string(tree_list[k]))
    if 3 <= table.getn(res) then
      local x, y, z = 0, 0, 0
      local treex = string.format("%.0f", x)
      local treez = string.format("%.0f", z)
      local count = 1
      for n = 1, table.getn(res) do
        if count >= 3 then
          local name = nx_function("ext_widestr_to_utf8", util_text(tree_list[k]))
          if count == 3 then
            z = res[n]
          end
          local form_map = nx_value("form_stage_main\\form_map\\form_map_scene")
          if not nx_is_valid(form_map) then
            return
          end
          nx_execute("form_stage_main\\form_map\\form_map_scene", "add_defined_label", form_map, x, 0, z, 1996, k)
          local content = "<font color=\"#b7c888\">" .. name .. "</font> - T\225\187\141a \196\145\225\187\153:" .. string.format("%.0f", x) .. "," .. string.format("%.0f", z) .. " <a href=\"findpath," .. map_query:GetCurrentScene() .. "," .. x .. "," .. y .. "," .. z .. "\" style=\"HLStype1\">[\196\144i t\225\187\155i]</a>"
          showSystemUtf8Text(content, 17)
          nx_pause(0.5)
          count = 1
        else
          if count == 1 then
            x = res[n]
          end
          if count == 2 then
            y = res[n]
          end
          if count == 3 then
            z = res[n]
          end
          count = count + 1
        end
      end
    end
  end
end
function Boss_start()
  if nx_running(nx_current(), "startFindBoss") then
    nx_kill(nx_current(), "startFindBoss")
    showUtf8Text(AUTO_LOG_SEARCH_BOSS_STO, 3)
  else
    nx_execute(nx_current(), "startFindBoss")
    showUtf8Text(AUTO_LOG_SEARCH_BOSS_STA, 3)
  end
end
oldMusicianList1 = nil
curMusicianList1 = nil
function startFindBoss()
  if oldMusicianList1 ~= nil then
    for _, v in pairs(oldMusicianList1) do
      v = nil
    end
    oldMusicianList1 = nil
  end
  if curMusicianList1 ~= nil then
    for _, v in pairs(curMusicianList1) do
      v = nil
    end
    curMusicianList1 = nil
  end
  curMusicianList1 = {}
  while true do
    oldMusicianList1 = curMusicianList1
    curMusicianList1 = nil
    curMusicianList1 = {}
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then
      return false
    end
    local client_player = game_client:GetPlayer()
    local scene = game_client:GetScene()
    if not nx_is_valid(scene) then
      return
    end
    local scene_obj_table = scene:GetSceneObjList()
    for i = 1, table.getn(scene_obj_table) do
      local scene_obj = scene_obj_table[i]
      if (nx_is_valid(visual_player) and nx_is_valid(scene_obj) or scene_obj:QueryProp("Type") == 4) and scene_obj:FindProp("NpcType") and scene_obj:QueryProp("NpcType") == 605 then
        local id = util_text(scene_obj:QueryProp("ConfigID"))
        local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
        local info = "Boss Th\195\160nh: <a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStype1\">[" .. wstrToUtf8(id) .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z) .. ")"
        table.insert(curMusicianList1, {id = id, info = info})
      end
    end
    showNewItemsList(oldMusicianList1, curMusicianList1)
    showNewItemsList(oldMusicianList1, curMusicianList1, 17)
    nx_pause(1)
  end
end
oldBookList = nil
curBookList = {}
oldCanBookList = nil
curCanBookList = {}
function searchBook()
  if runsearch then
    runsearch = false
    showUtf8Text(AUTO_SEARCH_BOOK_STOP, 3)
  else
    runsearch = true
    showUtf8Text(AUTO_SEARCH_BOOK_START, 3)
  end
  while runsearch do
    oldBookList = curBookList
    curBookList = {}
    oldCanBookList = curCanBookList
    curCanBookList = {}
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
      return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
      return
    end
    local scene = game_client:GetScene()
    if not nx_is_valid(scene) then
      return
    end
    local scene_obj_table = scene:GetSceneObjList()
    for i = 1, table.getn(scene_obj_table) do
      local scene_obj = scene_obj_table[i]
      if nx_is_valid(game_visual) and nx_is_valid(scene_obj) and scene_obj:QueryProp("Type") == 4 then
        local configID = scene_obj:QueryProp("ConfigID")
        if string.find(configID, "snatchbook_zs") ~= nil then
          local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
          local id = wstrToUtf8(util_text(configID))
          local info = "<a href='findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "' style=\"HLStypebuzz\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z)
          info = info .. ") " .. "C\195\179 tr\195\161p s\195\161ch xung quanh b\225\186\161n h\195\163y click t\225\187\155i l\198\176\225\187\163m"
          table.insert(curBookList, {id = id, info = info})
        end
        if string.find(configID, "cstnpc_zs") ~= nil then
          local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
          local id = wstrToUtf8(util_text(configID))
          local info = "<a href='findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "' style='HLStypebargaining'>[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z)
          info = info .. ") C\195\179 gi\195\161 s\195\161ch h\195\163y \196\145\225\186\191n l\225\186\165y s\195\161ch n\195\160o"
          table.insert(curCanBookList, {id = id, info = info})
        end
      end
      if scene_obj:QueryProp("Type") == 2 then
        for j = 1, 15 do
          local str = nx_string("BufferInfo") .. nx_string(j)
          if scene_obj:FindProp(str) then
            local infoList = util_split_string(scene_obj:QueryProp(str), ",")
            if string.find(nx_string(infoList[1]), "buf_loot_book") ~= nil then
              local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
              local id = wstrToUtf8(scene_obj:QueryProp("Name"))
              local info = "<a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStypelaba\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z)
              info = info .. ") C\195\179 th\225\186\177ng c\195\179 s\195\161ch k\195\172a"
              table.insert(curBookList, {id = id, info = info})
            end
          end
        end
      end
    end
    showNewItemsList(oldBookList, curBookList)
    showNewItemsList(oldCanBookList, curCanBookList)
    showNewItemsList(oldBookList, curBookList, 17)
    showNewItemsList(oldCanBookList, curCanBookList, 17)
    nx_pause(1)
  end
end
function abduct_start()
  if nx_running(nx_current(), "startAbduct") then
    nx_kill(nx_current(), "startAbduct")
    showUtf8Text(AUTO_LOG_SEARCH_AB_STO, 3)
  else
    nx_execute(nx_current(), "startAbduct")
    showUtf8Text(AUTO_LOG_SEARCH_AB_STA, 3)
  end
end
oldAbductedList = nil
curAbductedList = {}
oldCanAbductList = nil
curCanAbductList = {}
function startAbduct()
  while true do
    oldAbductedList = curAbductedList
    curAbductedList = {}
    oldCanAbductList = curCanAbductList
    curCanAbductList = {}
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
      return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
      return
    end
    local scene = game_client:GetScene()
    if not nx_is_valid(scene) then
      return
    end
    local scene_obj_table = scene:GetSceneObjList()
    for i = 1, table.getn(scene_obj_table) do
      local scene_obj = scene_obj_table[i]
      if nx_is_valid(game_visual) and nx_is_valid(scene_obj) and scene_obj:QueryProp("Type") == 2 then
        local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
        local id = wstrToUtf8(scene_obj:QueryProp("Name"))
        local info = "<a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStype1\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z)
        if scene_obj:FindProp("IsAbducted") and scene_obj:QueryProp("OffLineState") == 1 and not scene_obj:FindProp("OfflineTypeTvT") then
          for j = 1, 15 do
            local str = nx_string("BufferInfo") .. nx_string(j)
            if scene_obj:FindProp(str) then
              local infoList = util_split_string(scene_obj:QueryProp(str), ",")
              if nx_string(infoList[1]) == "buf_abducted" then
                local msg_delay = nx_value("MessageDelay")
                if not nx_is_valid(msg_delay) then
                  return is_Return_ITR
                end
                local buf_time = (infoList[4] - msg_delay:GetServerNowTime()) / 1000
                local m = nx_int(nx_int(buf_time) / 60)
                local s = nx_int(buf_time) - nx_int(60 * m)
                info = info .. ") c\195\178n " .. nx_string(m) .. "p " .. nx_string(s) .. "s"
                table.insert(curAbductedList, {id = id, info = info})
              end
            end
          end
        end
        if scene_obj:QueryProp("IsAbducted") == 0 and scene_obj:QueryProp("OffLineState") == 1 and not scene_obj:FindProp("OfflineTypeTvT") then
          info = info .. ") C\195\179c \196\144\195\163 Reset!"
          table.insert(curCanAbductList, {id = id, info = info})
        end
      end
    end
    showNewItemsList(oldAbductedList, curAbductedList)
    showNewItemsList(oldCanAbductList, curCanAbductList)
    showNewItemsList(oldAbductedList, curAbductedList, 17)
    showNewItemsList(oldCanAbductList, curCanAbductList, 17)
    nx_pause(1)
  end
end
function Musician_start()
  if nx_running(nx_current(), "startFindMusician") then
    nx_kill(nx_current(), "startFindMusician")
    showUtf8Text(AUTO_LOG_SEARCH_MUSIC_STO, 3)
  else
    nx_execute(nx_current(), "startFindMusician")
    showUtf8Text(AUTO_LOG_SEARCH_MUSIC_STA, 3)
  end
end
oldMusicianList = nil
curMusicianList = nil
function startFindMusician()
  if oldMusicianList ~= nil then
    for _, v in pairs(oldMusicianList) do
      v = nil
    end
    oldMusicianList = nil
  end
  if curMusicianList ~= nil then
    for _, v in pairs(curMusicianList) do
      v = nil
    end
    curMusicianList = nil
  end
  curMusicianList = {}
  while true do
    oldMusicianList = curMusicianList
    curMusicianList = nil
    curMusicianList = {}
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then
      return false
    end
    local client_player = game_client:GetPlayer()
    local scene = game_client:GetScene()
    if not nx_is_valid(scene) then
      return
    end
    local scene_obj_table = scene:GetSceneObjList()
    for i = 1, table.getn(scene_obj_table) do
      local scene_obj = scene_obj_table[i]
      if (nx_is_valid(visual_player) and nx_is_valid(scene_obj) or scene_obj:QueryProp("Type") == 2) and scene_obj:FindProp("GameState") and scene_obj:QueryProp("GameState") == "QinGameModule" then
        local id = wstrToUtf8(scene_obj:QueryProp("Name"))
        local team = wstrToUtf8(scene_obj:QueryProp("TeamCaptain"))
        local guild = "Kh\195\180ng c\195\179"
        if scene_obj:FindProp("GuildName") then
          guild = wstrToUtf8(scene_obj:QueryProp("GuildName"))
        end
        local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
        local info = "C\225\186\167m S\198\176: <a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStype1\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z) .. ") - [" .. guild .. "] - [" .. team .. "]"
        table.insert(curMusicianList, {id = id, info = info})
      end
    end
    showNewItemsList(oldMusicianList, curMusicianList)
    showNewItemsList(oldMusicianList, curMusicianList, 17)
    nx_pause(1)
  end
end
oldGuildList = nil
curGuildList = nil
function auto_search_guild()
  if oldGuildList ~= nil then
    for _, v in pairs(oldGuildList) do
      v = nil
    end
    oldGuildList = nil
  end
  if curGuildList ~= nil then
    for _, v in pairs(curGuildList) do
      v = nil
    end
    curGuildList = nil
  end
  curGuildList = {}
  local name_zhenfa = ""
  local text = ""
  local textName = ""
  if CheckGuildAuto then
    CheckGuildAuto = false
    showUtf8Text("Stop Create ZhiHua")
  else
    showUtf8Text("Start Create ZhiHua")
    local gui = nx_value("gui")
    local dialog = nx_execute("util_gui", "util_get_form", "form_common\\form_input_name", true, false)
    dialog.lbl_title.Text = utf8ToWstr("Nh\225\186\173p T\195\170n ")
    dialog.info_label.Text = utf8ToWstr("T\195\170n L\225\186\173p Tr\225\186\173n")
    dialog.allow_empty = false
    dialog:ShowModal()
    local res, new_name = nx_wait_event(100000000, dialog, "input_name_return")
    if res == "cancel" then
      return 0
    else
      textName = new_name
    end
    nx_pause(0.3)
    CheckGuildAuto = true
  end
  while CheckGuildAuto do
    oldGuildList = curGuildList
    curGuildList = nil
    curGuildList = {}
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    local game_scence = game_client:GetScene()
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    local game_scence_objs = game_scence:GetSceneObjList()
    local stage_main_flag = nx_value("stage_main")
    local loading_flag = nx_value("loading")
    local scene = game_client:GetScene()
    if nx_is_valid(game_client) and nx_is_valid(game_visual) and nx_is_valid(game_scence) and nx_is_valid(client_player) and not loading_flag and nx_string(stage_main_flag) == nx_string("success") then
      local scene_obj_table = scene:GetSceneObjList()
      for i = 1, table.getn(scene_obj_table) do
        local scene_obj = scene_obj_table[i]
        if nx_is_valid(visual_player) and nx_is_valid(scene_obj) or scene_obj:QueryProp("Type") == 2 then
          local text_name = auto_split_string(wstrToUtf8(textName), ",")
          local guild = wstrToUtf8(scene_obj:QueryProp("GuildName"))
          if isExistInStringList(text_name, guild) then
            local guild_name = wstrToUtf8(scene_obj:QueryProp("GuildName"))
            local id = wstrToUtf8(scene_obj:QueryProp("Name"))
            local team = "Kh\195\180ng c\195\179"
            local memnumber = "0"
            if scene_obj:FindProp("TeamCaptain") then
              team = wstrToUtf8(scene_obj:QueryProp("TeamCaptain"))
              memnumber = nx_string(scene_obj:QueryProp("TeamMemberCount"))
            end
            local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
            local info = "C\195\179 Ng\198\176\225\187\157i: <a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStype1\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z) .. ") - [" .. guild .. "] - Ch\225\187\167 PT: [" .. team .. "] - C\195\179 [" .. memnumber .. "] Ng\198\176\225\187\157i"
            table.insert(curGuildList, {id = id, info = info})
          end
        end
      end
      showNewItemsList(oldGuildList, curGuildList)
      showNewItemsList(oldGuildList, curGuildList, 17)
    end
    nx_pause(0.1)
  end
end
function FindTree_start()
  if nx_running(nx_current(), "startFindTree") then
    nx_kill(nx_current(), "startFindTree")
    showUtf8Text(AUTO_LOG_SEARCH_TREE_STO, 3)
  else
    nx_execute(nx_current(), "startFindTree")
    showUtf8Text(AUTO_LOG_SEARCH_TREE_STA, 3)
  end
end
oldTreeList = nil
curTreeList = nil
oldTreeattact = nil
curTreeattact = nil
function startFindTree()
  if oldTreeList ~= nil then
    for _, v in pairs(oldTreeList) do
      v = nil
    end
    oldTreeList = nil
  end
  if curTreeList ~= nil then
    for _, v in pairs(curTreeList) do
      v = nil
    end
    curTreeList = nil
  end
  curTreeList = {}
  if oldTreeattact ~= nil then
    for _, v in pairs(oldTreeattact) do
      v = nil
    end
    oldTreeattact = nil
  end
  if curTreeattact ~= nil then
    for _, v in pairs(curTreeattact) do
      v = nil
    end
    curTreeattact = nil
  end
  curTreeattact = {}
  while true do
    oldTreeList = curTreeList
    curTreeList = nil
    curTreeList = {}
    oldTreeattact = curTreeattact
    curTreeattact = nil
    curTreeattact = {}
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then
      return false
    end
    local client_player = game_client:GetPlayer()
    local scene = game_client:GetScene()
    if not nx_is_valid(scene) then
      return
    end
    local scene_obj_table = scene:GetSceneObjList()
    for i = 1, table.getn(scene_obj_table) do
      local scene_obj = scene_obj_table[i]
      if (nx_is_valid(visual_player) and nx_is_valid(scene_obj) or scene_obj:QueryProp("Type") == 4) and not isempty(string.find(scene_obj:QueryProp("ConfigID"), "Box_jzsj")) then
        local id = wstrToUtf8(util_text(scene_obj:QueryProp("ConfigID")))
        local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
        local info = "C\195\162y Click Target >>: <a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStype1\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z) .. ")"
        table.insert(curTreeList, {id = id, info = info})
      end
      if (nx_is_valid(visual_player) and scene_obj:QueryProp("Type") == 2 or nx_is_valid(scene_obj)) and nx_function("find_buffer", scene_obj, "buf_jzsj_040") then
        local id = wstrToUtf8(scene_obj:QueryProp("Name"))
        local guild = "Kh\195\180ng c\195\179"
        if scene_obj:FindProp("GuildName") then
          guild = wstrToUtf8(scene_obj:QueryProp("GuildName"))
        end
        local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
        local info = "\195\148m C\195\162y: <a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStype1\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z) .. ") - [" .. guild .. "]"
        table.insert(curTreeattact, {id = id, info = info})
      end
    end
    showNewItemsList(oldTreeList, curTreeList)
    showNewItemsList(oldTreeattact, curTreeattact)
    showNewItemsList(oldTreeList, curTreeList, 17)
    showNewItemsList(oldTreeattact, curTreeattact, 17)
    nx_pause(1)
  end
end
function FindOmCoc_start()
  if nx_running(nx_current(), "startFindOmCoc") then
    nx_kill(nx_current(), "startFindOmCoc")
    showUtf8Text(AUTO_LOG_SEARCH_AB_OBJ_STO, 3)
  else
    nx_execute(nx_current(), "startFindOmCoc")
    showUtf8Text(AUTO_LOG_SEARCH_AB_OBJ_STA, 3)
  end
end
oldabductList = nil
curabductList = nil
function startFindOmCoc()
  if oldabductList ~= nil then
    for _, v in pairs(oldabductList) do
      v = nil
    end
    oldabductList = nil
  end
  if curabductList ~= nil then
    for _, v in pairs(curabductList) do
      v = nil
    end
    curabductList = nil
  end
  curabductList = {}
  while true do
    oldabductList = curabductList
    curabductList = nil
    curabductList = {}
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then
      return false
    end
    local client_player = game_client:GetPlayer()
    local scene = game_client:GetScene()
    if not nx_is_valid(scene) then
      return
    end
    local scene_obj_table = scene:GetSceneObjList()
    for i = 1, table.getn(scene_obj_table) do
      local scene_obj = scene_obj_table[i]
      if (nx_is_valid(visual_player) and nx_is_valid(scene_obj) or scene_obj:QueryProp("Type") == 2) and nx_function("find_buffer", scene_obj, "buf_abductor") then
        local id = wstrToUtf8(scene_obj:QueryProp("Name"))
        local guild = "Kh\195\180ng c\195\179"
        if scene_obj:FindProp("GuildName") then
          guild = wstrToUtf8(scene_obj:QueryProp("GuildName"))
        end
        local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
        local info = "\195\148m C\195\179c: <a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStype1\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z) .. ") - [" .. guild .. "]"
        table.insert(curabductList, {id = id, info = info})
      end
    end
    showNewItemsList(oldabductList, curabductList)
    showNewItemsList(oldabductList, curabductList, 17)
    nx_pause(1)
  end
end
function BoxKHD_start()
  if nx_running(nx_current(), "startFindBoxKHD") then
    nx_kill(nx_current(), "startFindBoxKHD")
    showUtf8Text(AUTO_LOG_SEARCH_KHD_STO, 3)
  else
    nx_execute(nx_current(), "startFindBoxKHD")
    showUtf8Text(AUTO_LOG_SEARCH_KHD_STA, 3)
  end
end
olBoxKHDList = nil
curBoxKHDList = nil
function startFindBoxKHD()
  if oldBoxKHDList ~= nil then
    for _, v in pairs(oldBoxKHDList) do
      v = nil
    end
    oldBoxKHDList = nil
  end
  if curBoxKHDList ~= nil then
    for _, v in pairs(curBoxKHDList) do
      v = nil
    end
    curBoxKHDList = nil
  end
  curBoxKHDList = {}
  while true do
    oldBoxKHDList = curBoxKHDList
    curBoxKHDList = nil
    curBoxKHDList = {}
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then
      return false
    end
    local client_player = game_client:GetPlayer()
    local scene = game_client:GetScene()
    if not nx_is_valid(scene) then
      return
    end
    local scene_obj_table = scene:GetSceneObjList()
    for i = 1, table.getn(scene_obj_table) do
      local scene_obj = scene_obj_table[i]
      if nx_is_valid(visual_player) and nx_is_valid(scene_obj) then
        local obj_cfgprefix = string.sub(nx_string(scene_obj:QueryProp("ConfigID")), 0, 13)
        if obj_cfgprefix == "boxnpc_khd_bx" then
          local id = util_text(scene_obj:QueryProp("ConfigID"))
          local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
          local info = "R\198\176\198\161ng KHD : <a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStype1\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z)
          table.insert(curBoxKHDList, {id = id, info = info})
        end
      end
    end
    showNewItemsList(curBoxKHDList, curBoxKHDList)
    showNewItemsList(curBoxKHDList, curBoxKHDList, 17)
    nx_pause(1)
  end
end
function isempty(s)
  return s == nil or s == ""
end
function init_auto_cack(type_load, check_auto)
  if nx_running("auto_new\\form_auto_ab", "exe_auto_ab_state") then
    nx_execute("auto_new\\form_auto_ab", "turn_off_auto_ab")
  end
  if nx_running("auto_new\\form_auto_ai_new", "get_start_ai_status") then
    nx_execute("auto_new\\form_auto_ai_new", "set_start_ai_status", false)
  end
end
function set_auto_movie()
  if nx_execute("custom_handler", "getStateMovie") then
    showUtf8Text(AUTO_LOG_SKIP_MOVIE_STOP)
    nx_execute("custom_handler", "setStateMovie", false)
  else
    showUtf8Text(AUTO_LOG_SKIP_MOVIE_START)
    nx_execute("custom_handler", "setStateMovie", true)
  end
end
function suicide_auto()
  suicidePlayer(true)
  suicidePlayer(true)
end
function auto_training_music(num)
  if nx_running(nx_current(), "start_training_music") then
    nx_kill(nx_current(), "start_training_music")
    showUtf8Text(AUTO_LOG_START_TRAINING_MUSIC, 3)
  else
    showUtf8Text(AUTO_LOG_STOP_TRAINING_MUSIC, 3)
    showUtf8Text("Turn: " .. nx_string(num))
    nx_execute(nx_current(), "start_training_music", nx_number(num))
  end
end
function auto_start_use_item_in_chat(itemInfoStr)
  if nx_running("auto_new\\form_auto_use_item", "use_item_for_chat") then
    nx_kill("auto_new\\form_auto_use_item", "use_item_for_chat")
    showUtf8Text("Stop Use Item", 3)
  else
    showUtf8Text("Start Use Item", 3)
    nx_execute("auto_new\\form_auto_use_item", "use_item_for_chat", itemInfoStr)
  end
end
function auto_xaphu()
  if nx_execute("auto_new\\autocack", "is_password_locked") then
    showUtf8Text("Unlock Pass 2", 2)
    return
  end
  if auto_start then
    showUtf8Text(AUTO_LOG_XA_PHU_STOP)
    auto_start = false
  else
    showUtf8Text(AUTO_LOG_XA_PHU_START)
    auto_start = true
  end
  while auto_start do
    nx_pause(0.1)
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    if nx_is_valid(game_client) and nx_is_valid(game_visual) then
      local player_client = game_client:GetPlayer()
      local game_player = game_visual:GetPlayer()
      local game_scence = game_client:GetScene()
      local formtran = nx_value("form_stage_main\\form_world_trans_tool")
      local formtalk = nx_value("form_stage_main\\form_talk_movie")
      if nx_is_valid(game_player) and nx_is_valid(player_client) and nx_is_valid(game_scence) and string.find(game_scence:QueryProp("Resource"), "school") and find_npc_auto_trans(DataTransTool[game_scence:QueryProp("Resource")].npc) ~= nil then
        if nx_is_valid(formtran) then
          nx_execute("custom_sender", "custom_create_world_trans_tool", nx_int(2), nx_string(DataTransTool[game_scence:QueryProp("Resource")].mapid))
        elseif formtalk.Visible then
          nx_execute("form_stage_main\\form_talk_movie", "menu_select", 830000000)
        elseif find_npc_auto_trans(DataTransTool[game_scence:QueryProp("Resource")].npc) ~= nil then
          nx_execute("custom_sender", "custom_select", find_npc_auto_trans(DataTransTool[game_scence:QueryProp("Resource")].npc).Ident)
        end
      end
    end
  end
end
function attack_waiting_notice()
  local last_loading_time = 0
  if attack_wait then
    attack_wait = false
    showUtf8Text("D\225\187\171ng th\195\180ng b\195\161o khi b\225\187\139 \196\145\195\161nh")
  else
    attack_wait = true
    showUtf8Text("B\225\186\175t \196\145\225\186\167u th\195\180ng b\195\161o khi b\225\187\139 \196\145\195\161nh")
  end
  while attack_wait do
    local stage = nx_value("stage")
    local loading_flag = nx_value("loading")
    local stage_main_flag = nx_value("stage_main")
    if loading_flag or nx_string(stage_main_flag) ~= nx_string("success") then
      last_loading_time = os.time()
    end
    if tools_difftime(last_loading_time) > 6 and stage == "main" then
      local game_client = nx_value("game_client")
      if not nx_is_valid(game_client) then
        return 0
      end
      local game_visual = nx_value("game_visual")
      if not nx_is_valid(game_visual) then
        return 0
      end
      local visual_player = game_visual:GetPlayer()
      local client_player = game_client:GetPlayer()
      local hp = client_player:QueryProp("HPRatio")
      local target = is_obj_got_targeted(client_player, 2)
      if target ~= nil and client_player:QueryProp("LogicState") == 1 and nx_int(hp) < nx_int(70) then
        if nx_find_custom(visual_player, "mouse_left_key_down") and nx_custom(visual_player, "mouse_left_key_down") then
          attack_wait = false
          break
        end
        nx_function("ext_flash_window")
        local gui = nx_value("gui")
        local sound_file = "snd\\action\\sonar.wav"
        if not gui:FindSound("item_sound_0") then
          gui:AddSound("item_sound_0", nx_resource_path() .. sound_file)
        end
        gui:PlayingSound("item_sound_0")
      end
    end
    nx_pause(1)
  end
end
local autorun = false
function auto_oakhau()
  local client = nx_value("game_client")
  if not nx_is_valid(client) then
    return 0
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return 0
  end
  local game_player = game_visual:GetPlayer()
  local client_player = client:GetPlayer()
  autorun = not autorun
  if autorun then
    showUtf8Text("Start Target", 3)
  else
    showUtf8Text("Stop Target", 3)
  end
  local stage_main_flag = nx_value("stage_main")
  local loading_flag = nx_value("loading")
  local player = getPlayer()
  while autorun do
    if nx_is_valid(player) and not loading_flag and nx_string(stage_main_flag) == nx_string("success") then
      local client = nx_value("game_client")
      if not nx_is_valid(client) then
        return 0
      end
      local game_visual = nx_value("game_visual")
      local game_player = game_visual:GetPlayer()
      local client_player = client:GetPlayer()
      local scene = client:GetScene()
      if nx_is_valid(scene) then
        local scene_obj_table = scene:GetSceneObjList()
        for k = 1, table.getn(scene_obj_table) do
          local scene_obj = scene_obj_table[k]
          if nx_is_valid(scene_obj) then
            local ox, oy, oz = scene_obj.PosiX, scene_obj.PosiY, scene_obj.PosiZ
            local id = scene_obj.Ident
            if scene_obj:QueryProp("ConfigID") == "monster_wokou_08" then
              nx_execute("custom_sender", "custom_select", id)
              nx_pause(0.005)
            end
          end
        end
      end
      nx_pause(0.001)
    end
  end
end
local storm_list = {
  "stormsave_001",
  "stormsave_002",
  "stormsave_003",
  "stormsave_004",
  "stormsave_005",
  "stormsave_006",
  "stormsave_007",
  "stormsave_008"
}
function auto_findstorm()
  local scene_creator = nx_value("SceneCreator")
  local map_query = nx_value("MapQuery")
  for k = 1, table.getn(storm_list) do
    local res = scene_creator:GetNpcPosition(map_query:GetCurrentScene(), nx_string(storm_list[k]))
    if table.getn(res) >= 3 then
      local x, y, z = 0, 0, 0
      local treex = string.format("%.0f", x)
      local treez = string.format("%.0f", z)
      local count = 1
      for n = 1, table.getn(res) do
        if count >= 3 then
          local name = nx_function("ext_widestr_to_utf8", util_text(storm_list[k]))
          if count == 3 then
            z = res[n]
          end
          local form_map = nx_value("form_stage_main\\form_map\\form_map_scene")
          if not nx_is_valid(form_map) then
            return
          end
          nx_execute("form_stage_main\\form_map\\form_map_scene", "add_defined_label", form_map, x, 0, z, 1996, nx_string(k))
          local content = "<font color=\"#b7c888\">" .. name .. "</font> - T\225\187\141a \196\145\225\187\153 : " .. string.format("%.0f", x) .. "," .. string.format("%.0f", z) .. "<a href=\"findpath," .. map_query:GetCurrentScene() .. "," .. x .. "," .. y .. "," .. z .. "\" style=\"HLStype1\">[\196\144i t\225\187\155i]</a>"
          showSystemUtf8Text(content, 17)
          nx_pause(0.5)
          count = 1
        else
          if count == 1 then
            x = res[n]
          end
          if count == 2 then
            y = res[n]
          end
          if count == 3 then
            z = res[n]
          end
          count = count + 1
        end
      end
    end
  end
end
function Find_stomsave_start()
  if nx_running(nx_current(), "startFindStomsave") then
    nx_kill(nx_current(), "startFindStomsave")
    showUtf8Text("K\225\186\191t th\195\186c qu\195\169t d\195\162n b\195\163o c\195\161t", 3)
  else
    nx_execute(nx_current(), "startFindStomsave")
    showUtf8Text("B\225\186\175t \196\145\225\186\167u  qu\195\169t d\195\162n b\195\163o c\195\161t", 3)
  end
end
oldCanAbductList = nil
curCanStormSaveList = nil
function startFindStomsave()
  if oldCanAbductList ~= nil then
    for _, v in pairs(oldCanAbductList) do
      v = nil
    end
    oldCanAbductList = nil
  end
  if curCanStormSaveList ~= nil then
    for _, v in pairs(curCanStormSaveList) do
      v = nil
    end
    curCanStormSaveList = nil
  end
  curCanStormSaveList = {}
  while true do
    oldCanAbductList = curCanStormSaveList
    curCanStormSaveList = nil
    curCanStormSaveList = {}
    local game_client = nx_value("game_client")
    local game_visual = nx_value("game_visual")
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    if not nx_is_valid(client_player) or not nx_is_valid(visual_player) then
      return false
    end
    local client_player = game_client:GetPlayer()
    local scene = game_client:GetScene()
    if not nx_is_valid(scene) then
      return
    end
    local scene_obj_table = scene:GetSceneObjList()
    for i = 1, table.getn(scene_obj_table) do
      local scene_obj = scene_obj_table[i]
      if (nx_is_valid(visual_player) and nx_is_valid(scene_obj) or scene_obj:QueryProp("Type") == 2) and string.find(nx_string(scene_obj:QueryProp("ConfigID")), "stormsave_") ~= nil then
        local id = wstrToUtf8(scene_obj:QueryProp("Name"))
        local x, y, z = scene_obj.DestX, scene_obj.DestY, scene_obj.DestZ
        local info = "D\195\162n \196\144ang \225\187\159: <a href=\"findObj," .. getCurrentScene_id() .. "," .. nx_string(x) .. ", " .. nx_string(y) .. ", " .. nx_string(z) .. ", " .. nx_string(scene_obj.Ident) .. "\" style=\"HLStype1\">[" .. id .. "]</a> (" .. string.format("%.0f", x) .. ", " .. string.format("%.0f", z)
        table.insert(curCanStormSaveList, {id = id, info = info})
      end
    end
    showNewItemsList(oldCanAbductList, curCanStormSaveList)
    showNewItemsList(oldCanAbductList, curCanStormSaveList, 17)
    nx_pause(1)
  end
end
