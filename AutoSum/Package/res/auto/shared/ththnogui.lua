require("util_gui")
require("util_move")
require("util_functions")
require("form_stage_main\\form_tiguan\\form_tiguan_util")
require("share\\server_custom_define")
require("define\\sysinfo_define")
require("share\\chat_define")
require("define\\request_type")
local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\skill.lua"))
file()
local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()
local MAP_FORM = "form_stage_main\\form_map\\form_map_scene"
local FORM_TIGUAN_MAIN = "form_stage_main\\form_tiguan\\form_tiguan_one"
local FORM_TRACE = "form_stage_main\\form_tiguan\\form_tiguan_ds_trace"
local FORM_DETAIL = "form_stage_main\\form_tiguan\\form_tiguan_detail"
local FORM_SKILL = "form_stage_main\\form_main\\form_main_shortcut_extraskill"
local FORM_MAIN_SHORTCUT = 'form_stage_main\\form_main\\form_main_shortcut'
-- local skill_list = {
--   { 
--     ["name"] = "cs_jl_shuangci", --song thich clc
--     ["buff_nochieu"] = "CS_jl_shuangci02",
--     ["nodacthu"] = "CS_jl_shuangci07",
--     ["phadef"] = "CS_jl_shuangci06",
--     ["combo"] = "CS_jl_shuangci04,CS_jl_shuangci05"
--   },
--   { 
--     ["name"] = "cs_tm_jsc", -- kim xa thich
--     ["buff_nochieu"] = "CS_tm_jsc03",
--     ["nochieu"] = "CS_tm_jsc06",
--     ["phadef"] = "CS_tm_jsc04",
--     ["combo"] = "CS_tm_jsc01,CS_tm_jsc07"
--   },
--   { ["name"] = "cs_jh_cqgf" },
--   { ["name"] = "cs_jy_yzq" },
--   { ["name"] = "cs_jy_xsd" },
--   { ["name"] = "CS_hs_hsjf" }
-- }

-- local viagra_list = {
--   {
--     ["name"] = "yp_donghai_03",
--     ["buff"] = "buf_yp_pl_004"
--   },
--   {
--     ["name"] = "yaopin90026",
--     ["buff"] = ""
--   }
-- }

-- local cau_hoa_list = {
--   "",
--   "caiyao20002",
--   "caiyao10197"
-- }

local form = {}

function open_init(form)
  form.Fixed = false
  form.sx = 0
  form.sy = 0
  form.sz = 0
  form.auto_reset = true
  form.auto_pickup = true
  form.auto_bathe = true
  form.auto_x2 = true
  form.auto_thuong = false
  form.auto_dungvo = false
  form.auto_sonhap = true
  form.auto_oskill = true
  form.auto_ridding = true
  form.free_appoint1 = true
  form.free_appoint2 = false
  form.free_appoint3 = false
  form.free_appoint4 = false
  form.use_kcl1 = false
  form.use_kcl2 = false
  form.use_kcl3 = false
  form.use_kcl4 = false
  form.selectskill = 1
  form.cauhoa = 0
  form.dicot = 0
  form.pick_str = ""
  form.boss_str = ""
  form.thuoc_str = ""
  form.binhluc = 106
  form.tab_1_input = {
    ["Text"] = "1"
  }
end

function AutoTiguanStart(form)
  if __auto_tung_hoanh_bool then
    __auto_tung_hoanh_bool = false
    update_status("Ket thuc auto THTH")
  else
    __auto_tung_hoanh_bool = true
    update_status("Bat Dau auto THTH")
  end
end
local err_boss = {
  "bosstg28001;Công Tôn Kỳ;94.712,-3.725,317.090,1.659;94.712,-3.725,317.090,1.659",
  "bosstg27002;Vạn Kiêu Chỉ;-189.254,174.083,712.234,2.984;-189.254,174.083,712.234,2.984",
  "bosstg29001;Lưu Thiết Đảm;1085.125,45.818,378.812,0.876;1085.125,45.818,378.812,0.876",
  "bosstg02001;Đông Phương Hoàn;283.165,42.601,1127.671,-0.305;283.165,42.601,1127.671,-0.305"
}
function CheckIsError(bossid)
  for k = 1, table.getn(err_boss) do
    local boss_info = util_split_string(nx_string(err_boss[k]), ";")
    if boss_info[1] == bossid then
      return boss_info
    end
  end
  return nil  
end

function get_second_from_text(text)
  local num, texttime
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

function get_buff_info(buff_id)
  local form_x = nx_value("form_stage_main\\form_main\\form_main_buff")
  if not nx_is_valid(form_x) then
    return nil
  end
  for i = 1, 24 do
    if nx_string(form_x["lbl_photo" .. tostring(i)].buffer_id) == buff_id then
      local buff_time = get_second_from_text(form_x["lbl_time" .. tostring(i)].Text)
      if buff_time == nil then
        return -1
      else
        return buff_time
      end
    end
  end
  return nil  
end

function Fight_Use(form, fightPos, bossPos)
  while fight_start do
    nx_pause(0.1)
    --local form_map = nx_value(MAP_FORM)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
      return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
      return false
    end
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    local player_pos_x = visual_player.PositionX
    local player_pos_y = visual_player.PositionY
    local player_pos_z = visual_player.PositionZ
    local form_shortcut = nx_value(FORM_MAIN_SHORTCUT)
    local grid = form_shortcut.grid_shortcut_main
    local game_shortcut = nx_value("GameShortcut")
    if nx_is_valid(nx_value(FORM_DETAIL)) and util_get_form(FORM_DETAIL, true).Visible then
      fight_start = false
    end
    local buffAD = get_buff_info("buf_CS_jh_yydld06_4")
    local buffSD = get_buff_info("buf_CS_jh_yydf05")
    local buffTH = get_buff_info("buf_CS_tm_jsc03")
    local buffKF = get_buff_info("buf_CS_jh_cqgf07")
    local buffOT = get_buff_info("buf_CS_jl_shuangci07")
    local buffHD = get_buff_info("buf_CS_jl_shuangci02")
    local boss_obj = select_target_byName(current_boss)
    local fight = nx_value("fight")
    if boss_obj ~= nil and boss_obj:QueryProp("ConfigID") == current_boss and fight:CanAttackNpc(client_player, boss_obj) then
      Use_buff(form)
      if nx_is_valid(game_shortcut) then
        if client_player:QueryProp("SP") >= 50 then
          if (buffOT == nil or buffOT < 5) and (buffSD == nil or buffSD < 5) then
            nx_pause(0.1)
            game_shortcut:on_main_shortcut_useitem(grid, 9, true)
          end
          nx_pause(0.1)
          game_shortcut:on_main_shortcut_useitem(grid, 7, true)
        end
        if (buffAD == nil or buffAD < 5) and (buffKF == nil or buffKF < 5) and (buffTH == nil or buffTH < 5) and (buffHD == nil or buffHD < 5) then
          nx_pause(0.1)
          game_shortcut:on_main_shortcut_useitem(grid, 8, true)
        end
        for k = 1, 6 do
          if nx_function("find_buffer", boss_obj, "BuffInParry") then
            nx_pause(0.1)
            game_shortcut:on_main_shortcut_useitem(grid, 0, true)
          else
            update_status("Đánh theo thứ tự từ 1 đến 6 ...")
            nx_pause(0.1)
            game_shortcut:on_main_shortcut_useitem(grid, k, true)
          end
        end
      end
    end
  end  
end

function Use_buff(form)
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return false
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return false
  end
  local client_player = game_client:GetPlayer()
  local x = nx_function("ext_widestr_to_utf8", nx_ws_lower(util_text(current_boss)))
  local form_skill = nx_value(FORM_SKILL)
  local boss_obj = select_target_byName(current_boss)
  local fight = nx_value("fight")
  if nx_is_valid(form_skill) then
    local grid = form_skill.imagegrid_skill
    local grid_count = grid.ClomnNum * grid.RowNum
    for i = 0, grid_count - 1 do
      local skill_id = nx_execute(FORM_SKILL, "get_skill_id_by_index", i)
      local skill_flag = nx_execute(FORM_SKILL, "get_skill_flag_by_index", i)
      if skill_id ~= "" then
        if form.auto_sonhap then
          if form.auto_bathe and skill_id == "jn_drtg_mf_001" and not nx_function("find_buffer", client_player, "buf_drtg_001_2") and boss_obj ~= nil and boss_obj:QueryProp("ConfigID") and fight:CanAttackNpc(client_player, boss_obj) then
            update_status("Tìm thăy buff bá thể, sử dụng cho loại chơi sơ nhập")
            nx_execute("custom_sender", "custom_extra_skill", form_skill.type, skill_flag)
          elseif form.auto_x2 and skill_id == "jn_drtg_mf_004" and not nx_function("find_buffer", boss_obj, "buf_drtg_004_2") and boss_obj ~= nil and boss_obj:QueryProp("ConfigID") and fight:CanAttackNpc(client_player, boss_obj) then
            update_status("Tìm thăy buff x2, sử dụng cho loại chơi sơ nhập")
            nx_execute("custom_sender", "custom_extra_skill", form_skill.type, skill_flag)
          elseif skill_id == "jn_drtg_mf_009" then
            update_status("Tìm thăy hồi mana hải nạp bách xuyên, sử dụng cho loại chơi sơ nhập")
            nx_execute("custom_sender", "custom_extra_skill", form_skill.type, skill_flag)
          elseif skill_id == "jn_drtg_mf_005" then
            update_status("Tìm thăy Thần Công Hộ Thể, sử dụng cho loại chơi sơ nhập")
            nx_execute("custom_sender", "custom_extra_skill", form_skill.type, skill_flag)
          end
        end
      end
    end
  end
end

function Fight_Skill_thth(form, fightPos, bossPos)
  while fight_start do
    nx_pause(0.1)
    --local form_map = nx_value(MAP_FORM)
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
      return false
    end
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
      return false
    end
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    local player_pos_x = visual_player.PositionX
    local player_pos_y = visual_player.PositionY
    local player_pos_z = visual_player.PositionZ
    local scene = game_client:GetScene()
    if nx_is_valid(nx_value(FORM_DETAIL)) and util_get_form(FORM_DETAIL, true).Visible then
      fight_start = false
    end
    local buffAD = get_buff_info("buf_CS_jh_yydld06_4")
    local buffSD = get_buff_info("buf_CS_jh_yydf05")
    local buffTH = get_buff_info("buf_CS_tm_jsc03")
    local buffKF = get_buff_info("buf_CS_jh_cqgf07")
    local buffOT = get_buff_info("buf_CS_jl_shuangci07")
    local buffHD = get_buff_info("buf_CS_jl_shuangci02")
    local fight = nx_value("fight")
    local boss_obj = select_target_byName(current_boss)

    if boss_obj ~= nil and boss_obj:QueryProp("ConfigID") == current_boss and fight:CanAttackNpc(client_player, boss_obj) then
      local pos = getDest(boss_obj)
      if not arrived(pos, 3) then
        jump_to(pos, 1)
      else
        Use_buff(form)
        if (buffAD == nil or buffAD < 5) and (buffKF == nil or buffKF < 5) and (buffTH == nil or buffTH < 5) and (buffHD == nil or buffHD < 5) then
          nx_pause(0.1)
          fight:TraceUseSkill(skill_list[form.selectskill].buff_nochieu, false, false)
        end
        if buffSD or buffAD then
          if client_player:QueryProp("SP") >= 50 then
            if (buffOT == nil or buffOT < 5) and (buffSD == nil or buffSD < 5) then
              fight:TraceUseSkill(skill_list[form.selectskill].nodacthu, false, false)
            end
            nx_pause(0.1)
            fight:TraceUseSkill(skill_list[form.selectskill].nochieu2, false, false)
          end
          if nx_function("find_buffer", boss_obj, "BuffInParry") then
            nx_pause(0.1)
            fight:TraceUseSkill(skill_list[form.selectskill].phadef2, false, false)
          else
            local skill2 = util_split_string(skill_list[form.selectskill].combo2, ",")
            for m = 1, table.getn(skill2) do
              update_status("T\225\187\177 \196\145\195\161nh chu\225\187\151i li\195\170n chi\195\170u theo b\225\187\153 c\195\179 buff ...")
              nx_pause(0.1)
              fight:TraceUseSkill(skill2[m], false, false)
            end
          end
        else
          if client_player:QueryProp("SP") >= 50 then
            if (buffOT == nil or buffOT < 5) and (buffSD == nil or buffSD < 5) and skill_list[form.selectskill].nodacthu then
              fight:TraceUseSkill(skill_list[form.selectskill].nodacthu, false, false)
            end
            if skill_list[form.selectskill].nochieu then
              nx_pause(0.1)
              fight:TraceUseSkill(skill_list[form.selectskill].nochieu, false, false)
            end
          end
          if nx_function("find_buffer", boss_obj, "BuffInParry") then
            nx_pause(0.1)
            fight:TraceUseSkill(skill_list[form.selectskill].phadef, false, false)
          else
            local skill = util_split_string(skill_list[form.selectskill].combo, ",")
            for n = 1, table.getn(skill) do
              update_status("Tiến hành chuỗi liên chiêu theo bộ ...")
              nx_pause(0.1)
              fight:TraceUseSkill(skill[n], false, false)
            end
          end
        end
      end
    end
  end  
end

function AutoCheckStuck(x, y, z, form)
  if form.sx == 0 then
    form.sx, form.sy, form.sz = x, y, z
    return false
  elseif distance3d(x, y, z, form.sx, form.sy, form.sz) == 0 then
    local game_visual = nx_value("game_visual")
    if not nx_is_valid(game_visual) then
      return false
    end
    local game_client = nx_value("game_client")
    if not nx_is_valid(game_client) then
      return false
    end
    local client_player = game_client:GetPlayer()
    local visual_player = game_visual:GetPlayer()
    visual_player.move_dest_orient = client_player.DestOrient
    visual_player:SetPosition(visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ + 0.5)
    visual_player:SetAngle(0, visual_player.move_dest_orient, 0)
    game_visual:SwitchPlayerState(visual_player, "jump", 5)
    local scene_obj = nx_value("scene_obj")
    scene_obj:LocatePlayer(visual_player, visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ + 0.5, visual_player.move_dest_orient)
    nx_pause(2)
  end
  form.sx, form.sy, form.sz = x, y, z
end

function Move_boss(form)
  local game_client = nx_value("game_client")
  if not nx_is_valid(game_client) then
    return false
  end
  local game_visual = nx_value("game_visual")
  if not nx_is_valid(game_visual) then
    return false
  end
  local client_player = game_client:GetPlayer()
  local visual_player = game_visual:GetPlayer()
  local scene = game_client:GetScene()
  local player_pos_x, player_pos_y, player_pos_z = visual_player.PositionX, visual_player.PositionY, visual_player.PositionZ
  local boss_x, boss_y, boss_z, fight_x, fight_y, fight_z
  local a1 = CheckIsError(current_boss)
  if a1 ~= nil then
    local a2 = util_split_string(a1[4], ",")
    fight_x, fight_y, fight_z = a2[1], a2[2], a2[3]
    a2 = util_split_string(a1[3], ",")
    boss_x, boss_y, boss_z = a2[1], a2[2], a2[3]
  else
    local mgr = nx_value("SceneCreator")
    if nx_is_valid(mgr) then
      local res = mgr:GetNpcPosition(scene:QueryProp("Resource"), current_boss)
      if 3 <= table.getn(res) then
        boss_x, boss_y, boss_z = res[1], res[2], res[3]
        fight_x, fight_y, fight_z = res[1], res[2], res[3]
      end
    end
  end
  if boss_z ~= nil then
    local boss_obj = select_target_byName(current_boss)
    if boss_obj ~= nil then
      if boss_obj:FindProp("LastObject") then
        if 3 >= distance3d(fight_x, fight_y, fight_z, player_pos_x, player_pos_y, player_pos_z) then
          if nx_function("find_buffer", client_player, "buf_riding_01") then
            nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
          end
          if form.auto_thuong then
            fight_start = true
            if fight_start then
              Fight_Use(form, {fight_x, fight_y, fight_z}, {boss_x, boss_y, boss_z})
            end
          elseif form.auto_oskill then
            fight_start = true
            if fight_start then
              Fight_Skill_thth(form, {fight_x, fight_y, fight_z}, {boss_x, boss_y, boss_z})
            end
          end
        else
          update_status("Đến tọa độ chờ - X:" .. string.format("%.0f", fight_x) .. ", Y:" .. string.format("%.0f", fight_z))
          --move({fight_x, fight_y, fight_z})
          thanhanh_bay_ben({fight_x, fight_y, fight_z}, 50, __auto_tung_hoanh_started)
        end
      elseif 3 < distance3d(boss_x, boss_y, boss_z, player_pos_x, player_pos_y, player_pos_z) then
        local find_boss = nx_function("ext_widestr_to_utf8", util_text(current_boss))
        update_status("Đang tìm boss 1: " .. find_boss .. " - X:" .. string.format("%.0f", boss_x) .. ", Y:" .. string.format("%.0f", boss_z))
        local boss_pos = {boss_x, boss_y, boss_z}
        --jump_to_arrived(boss_pos)
        thanhanh_bay_ben(boss_pos, 50, __auto_tung_hoanh_started)
      end
    elseif 3 < distance3d(boss_x, boss_y, boss_z, player_pos_x, player_pos_y, player_pos_z) then
      local find_boss = nx_function("ext_widestr_to_utf8", util_text(current_boss))
      update_status("Đang tìm boss 2: " .. find_boss .. " - X:" .. string.format("%.0f", boss_x) .. ", Y:" .. string.format("%.0f", boss_z))
      --move({boss_x, boss_y, boss_z}, 3)
      thanhanh_bay_ben({boss_x, boss_y, boss_z}, 50, __auto_tung_hoanh_started)
    end
  else
    update_status("Không tìm thấy tọa độ boss !" ..current_boss)
    -- nx_execute("custom_sender", "custom_tiguan_request_leave")
    fight_done = true
    force_done = true
  end

end

function AutoCheckBossInfo(sub, level)
  local form = util_get_form(FORM_TIGUAN_MAIN, false)
  if nx_is_valid(form) and not form.Visible then
    return
  end
  local gui = nx_value("gui")
  local array_name = "guan" .. nx_string(level) .. "sub" .. nx_string(sub)
  local record_guan_id = nx_execute(FORM_TIGUAN_MAIN, "get_tiguan_record", array_name, "value1")
  local record_boss_index = nx_execute(FORM_TIGUAN_MAIN, "get_tiguan_record", array_name, "value2")
  local boss_id = nx_execute(FORM_TIGUAN_MAIN, "get_boss_id", nx_string(record_guan_id), nx_number(record_boss_index))
  local iscomplete = nx_execute(FORM_TIGUAN_MAIN, "get_tiguan_record", array_name, "value7")
  local isbossred = nx_execute(FORM_TIGUAN_MAIN, "FindBossBeArrest", boss_id, sub)
  return boss_id, iscomplete, isbossred, record_guan_id
end

function AutoSwitchTHTHLevel(level)
  local form = util_get_form(FORM_TIGUAN_MAIN, false)
  if nx_is_valid(form) and not form.Visible then
    return
  end
  local btn = "rbtn_level_" .. nx_string(level)
  form[btn].Checked = true
  nx_execute("form_stage_main\\form_tiguan\\form_tiguan_one", "on_rbtn_level_checked_changed", form[btn])
end

function get_boss_id_list(guan_id)
  local ini = nx_execute("util_functions", "get_ini", SHARE_CHANGGUAN_INI)
  if not nx_is_valid(ini) then
    return nil
  end
  local sec_index = ini:FindSectionIndex(nx_string(guan_id))
  local str_id = ini:ReadString(sec_index, "BossList", "")
  return util_split_string(str_id, ";")
end

function tim_ngua()
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
          update_status("Chờ lên ngựa...")
          nx_pause(5)
          break
        end
      end
      break
    end
  end
  return nx_number(item_pos)
end

function auto_pickup_thth()
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
        if is_in_pick_list_thth(1, x) then
          nx_execute("custom_sender", "custom_pickup_single_item", view_obj.Ident)
        end
      end
    end
  end
  return true
end

function setContains(set, key)
  return set[key] ~= nil
end

function nhat_ruong_thth(form)
  local form_map = nx_value(MAP_FORM)
  if nx_is_valid(form_map) then
    local obj = get_bao_ruong()
    auto_pickup_thth()
    local pick_form = nx_value("form_stage_main\\form_pick\\form_droppick")
    if nx_is_valid(pick_form) then
      nx_execute("custom_sender", "custom_close_drop_box")
    end
    if nx_is_valid(obj) then
      local game_visual = nx_value("game_visual")
      if not nx_is_valid(game_visual) then
        return false
      end
      local game_client = nx_value("game_client")
      if not nx_is_valid(game_client) then
        return false
      end
      local client_player = game_client:GetPlayer()
      local visual_player = game_visual:GetPlayer()
      local player_pos_x = visual_player.PositionX
      local player_pos_y = visual_player.PositionY
      local player_pos_z = visual_player.PositionZ
      local open_range = obj:QueryProp("OpenRange")
      local box_name = obj:QueryProp("ConfigID")
      local x, y, z = obj.PosiX, obj.PosiY, obj.PosiZ
      local id = obj.Ident
      local strData = nx_string("findpath,") .. nx_string(form_map.current_map) .. "," .. nx_string(x) .. "," .. nx_string(y) .. "," .. nx_string(z)
      local distance = distance2d(player_pos_x, player_pos_z, x, z)
      if open_range >= distance then
        if client_player:QueryProp("State") ~= "interact017" and client_player:QueryProp("State") ~= "interact041" then
          update_status("Bắt đầu mở rương ...")
          nx_execute("custom_sender", "custom_select", id)
        end
      else
        update_status("Đang gần rương boss ... X:" .. string.format("%.0f", x) .. ", Y:" .. string.format("%.0f", z))
        jump_to({x, y, z})
      end
    else
      failed_get_bao_ruong = failed_get_bao_ruong + 1
      update_status("Tự rời khiêu chiến tung hòanh sau: " .. 5 - failed_get_bao_ruong .. " giây")
      if failed_get_bao_ruong >= 5 then
        update_status("Rời khiêu chiến tung hoành")
        nx_execute("custom_sender", "custom_tiguan_request_leave")
        nx_pause(5)
        fight_done = false
        start_fight = false
      end
    end
  end
end

function __auto_tung_hoanh_started()
  return __auto_tung_hoanh_bool
end

function auto_thth_start_(skill, bl)
  form.selectskill = tonumber(skill)
  local a = skill_list[form.selectskill]
  add_chat_info(a.name)
  add_chat_info(bl)
end

function auto_thth_start(skill, bl)
  pw2()
  open_init(form)
  set_auto_do_don()
  form.selectskill = tonumber(skill)
  form.binhluc = tonumber(bl)
  local game_config_info = nx_value("game_config_info")
  if form.auto_oskill and form.selectskill == 0 then
    update_status("Chọn bộ skill sử dụng trước")
    return false
  end
  if form.auto_thuong == false and form.auto_oskill == false then
    update_status("Chọn chế độ đánh, thường hoặc theo bộ")
    return false
  end
  if __auto_tung_hoanh_started() then
    AutoTiguanStart(false)
    fight_start = false
    start_fight = false
    fight_done = false
  else
    AutoTiguanStart(true)
    if nx_is_valid(nx_value(FORM_TIGUAN_MAIN)) and not util_get_form(FORM_TIGUAN_MAIN, true).Visible then
      util_auto_show_hide_form(FORM_TIGUAN_MAIN)
		end
  end
  while __auto_tung_hoanh_started() do
    nx_pause(1)
    check_noi_tu()
    add_chat_info("dang thth")
    if not __auto_tung_hoanh_started() then 
      add_chat_info("da ket thuc thth")
      break
    end
    if __auto_tung_hoanh_started() then
      local form_tiguan = util_get_form(FORM_TIGUAN_MAIN, true)
      local form_trace = util_get_form(FORM_TRACE, false)
      local form_detail = util_get_form(FORM_DETAIL, false)
      local form_map = nx_value(MAP_FORM)
      local loading_flag = nx_value("loading")
      local form_login = "form_stage_login\\form_login"
      if nx_is_valid(nx_value(form_login)) then
        AutoTiguanStart(false)
        break
      end
      local chose_char = "form_stage_roles\\form_roles"
      if nx_is_valid(nx_value(chose_char)) then
        AutoTiguanStart(false)
        break
      end
      if nx_is_valid(form) then
        if form.auto_ridding then
          util_set_property_key(game_config_info, "is_ride_on_path", 0)
        else
          util_set_property_key(game_config_info, "is_ride_on_path", 1)
        end
      end
      if not loading_flag then
        if nx_is_valid(form_trace) and form_trace.Visible and not fight_done then
          if nx_is_valid(nx_value(FORM_TIGUAN_MAIN)) and util_get_form(FORM_TIGUAN_MAIN, true).Visible then
            util_auto_show_hide_form(FORM_TIGUAN_MAIN)
          end
          if nx_is_valid(form_map) then
            Move_boss(form)
          end
        else
          if nx_is_valid(nx_value(FORM_DETAIL)) and util_get_form(FORM_DETAIL, true).Visible then
            --util_auto_show_hide_form(FORM_DETAIL)
            fight_done = true
          end
          if fight_done then
            update_status("Khiêu chiến boss thành công")
            if nx_is_valid(form_map) then
              if form.auto_pickup then
                nhat_ruong_thth(form)
              else
                update_status("Rời khiêu chiến Tung Hoành")
                nx_execute("custom_sender", "custom_tiguan_request_leave")
                fight_done = false
                start_fight = false
              end
            end
          elseif not start_fight then
            local game_client = nx_value("game_client")
            if not nx_is_valid(game_client) then
              return false
            end
            local client_player = game_client:GetPlayer()
            if client_player:QueryProp("TeamCaptain") == client_player:QueryProp("Name") then
              update_status("Kiểm tra nếu có tổ đội, thì rời tổ đội ...")
              nx_execute("custom_sender", "custom_leave_team")
            end
            if has_buff("buff_baosd_01") or has_buff("buf_baosd_01") then
              dung_vat_pham("caiyao20002", 1, 0)
            end
            if (client_player:QueryProp("HPRatio") < 100 or 100 > client_player:QueryProp("MPRatio")) and client_player:QueryProp("LogicState") ~= 102 then
              if nx_function("find_buffer", client_player, "buf_riding_01") then
                nx_execute("custom_sender", "custom_remove_buffer", "buf_riding_01")
              end
              update_status("Ngồi thiền hồi máu, mana ...")
              local fight = nx_value("fight")
              fight:TraceUseSkill("zs_default_01", false, false)
              if nx_is_valid(nx_value(FORM_TIGUAN_MAIN)) and util_get_form(FORM_TIGUAN_MAIN, true).Visible then
                util_auto_show_hide_form(FORM_TIGUAN_MAIN)
              end
            elseif client_player:QueryProp("HPRatio") >= 100 and 100 <= client_player:QueryProp("MPRatio") then
              if client_player:FindProp("LogicState") and client_player:QueryProp("LogicState") == 102 then
                update_status("Hồi máu, mana xong ...")
                local fight = nx_value("fight")
                fight:TraceUseSkill("zs_default_01", false, false)
              end
              if nx_is_valid(nx_value(FORM_TIGUAN_MAIN)) and not util_get_form(FORM_TIGUAN_MAIN, true).Visible then
                update_status("Mở bảng THTH")
                util_auto_show_hide_form(FORM_TIGUAN_MAIN)
              else
              end
            end
          end
        end
      end
      -- if form_tiguan.friend_card_count == 0 then
      -- end
      if not start_fight and not loading_flag and not nx_is_valid(nx_value(FORM_DETAIL)) 
        and nx_is_valid(nx_value(FORM_TIGUAN_MAIN)) and util_get_form(FORM_TIGUAN_MAIN, true).Visible
      then
        if nx_is_valid(form_tiguan) and form_tiguan.Visible then
          local current_tab = form_tiguan.cur_tiguan_level
          local max_level = "tab_" .. current_tab .. "_input"
          failed_get_bao_ruong = 0
          for i = 1, nx_number(form[max_level].Text) do
            if not __auto_tung_hoanh_started() then
              return
            end
            local next_btn = "cbtn_arrestboss" .. nx_string(i)
            update_status("Bắt đầu chọn boss ???")
            current_boss, iscomplete, isbossred, guan_id = AutoCheckBossInfo(i, current_tab)
            if iscomplete == 2 or force_done then
              force_done = false
              if i >= nx_number(form[max_level].Text) then
                if current_tab == form_tiguan.cur_level_limit then
                  if 0 < form_tiguan.reset_times then
                    if form.auto_reset == true then
                      if 1 < form_tiguan.reset_times then
                        if form_tiguan.btn_double_model.Enabled and form.auto_dungvo then
                          nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_DOUBLE_MODEL)
                          update_status("Chọn turn dũng võ")
                        else
                          nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_OFFSET_OMIT)
                          update_status("Reset lại turn")
                        end
                        nx_pause(1)
                        AutoSwitchTHTHLevel(1)
                      else
                        if form_tiguan.btn_double_model.Enabled then
                          if not form.auto_dungvo then
                            update_status("Auto t\225\187\177 \196\145\225\187\153ng d\225\187\171ng khi ch\225\187\137 c\195\178n 1 turn v\195\160 ch\198\176a d\197\169ng v\195\181")
                            AutoTiguanStart(false)
                          else
                            nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_DOUBLE_MODEL)
                          end
                        else
                          nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_OFFSET_OMIT)
                        end
                      end
                    else
                      update_status("\196\144\195\163 ho\195\160n th\195\160nh xong turn!")
                      AutoTiguanStart(false)
                    end
                  else
                    update_status("\196\144\225\186\161t gi\225\187\155i h\225\186\161n c\225\187\167a Tu\225\186\167n, auto d\225\187\171ng")
                    AutoTiguanStart(false)
                  end
                elseif current_tab >= form_tiguan.cur_level_limit then
                  AutoTiguanStart(false)
                else
                  AutoSwitchTHTHLevel(current_tab + 1)
                  nx_pause(1)
                end
              end
            else
              if not isbossred and form_tiguan.btn_start.Enabled then
                if 0 < form_tiguan.free_appoint then
                  if form.free_appoint1 then
                    update_status("Chọn lượt free Cấp 1")
                    if form_tiguan.cur_tiguan_level == 1 and current_tab == form_tiguan.cur_level_limit then
                      local btn = "btn_choice" .. nx_string(i)
                      nx_pause(2)
                      nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", form_tiguan[btn])
                    end
                  end
                  if form.free_appoint2 then
                    update_status("Chọn lượt free Cấp 2")
                    if form_tiguan.cur_tiguan_level == 2 and current_tab == form_tiguan.cur_level_limit then
                      local btn = "btn_choice" .. nx_string(i)
                      nx_pause(2)
                      nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", form_tiguan[btn])
                    end
                  end
                  if form.free_appoint3 then
                    update_status("Chọn lượt free Cấp 3")
                    if form_tiguan.cur_tiguan_level == 3 and current_tab == form_tiguan.cur_level_limit then
                      local btn = "btn_choice" .. nx_string(i)
                      nx_pause(2)
                      nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", form_tiguan[btn])
                    end
                  end
                  if form.free_appoint4 then
                    update_status("Chọn lượt free Cấp 4")
                    if form_tiguan.cur_tiguan_level == 4 and current_tab == form_tiguan.cur_level_limit then
                      local btn = "btn_choice" .. nx_string(i)
                      nx_pause(2)
                      nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", form_tiguan[btn])
                    end
                  end
                  local form_choice = nx_value(FORM_TIGUAN_CHOICE_BOSS)
                  if nx_is_valid(form_choice) then
                    local boss_list = get_boss_id_list(guan_id)
                    if boss_list ~= nil then
                      form_choice.cbtn_spent_item.Checked = true
                      local boss_count = table.getn(boss_list)
                      for f = 1, boss_count do
                        local boss_id = nx_string(boss_list[f])
                        local taget_boss = nx_function("ext_widestr_to_utf8", util_text(boss_id))
                        local find_boss = nx_function("ext_widestr_to_utf8", util_text(current_boss))
                        if nx_execute(FORM_TIGUAN_MAIN, "FindBossBeArrest", boss_id, current_tab) then
                          if find_boss == taget_boss then
                            update_status("Trong danh sách truy nã: " .. taget_boss .. " bỏ qua")
                            current_boss = boss_id
                            nx_pause(1)
                            form_choice:Close()
                          else
                            update_status("Chọn boss trong danh sách truy nã: " .. taget_boss)
                            nx_pause(2)
                            nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_APPOINT_BOSS, current_tab, f, 1)
                            current_boss = boss_id
                            nx_pause(1)
                            form_choice:Close()
                          end
                        end
                      end
                    end
                  end
                else
                  local item
                  update_status("Tìm vật phẩm khiêu chiến lệnh")
                  if current_tab == 1 and form.use_kcl1 then
                    update_status("Sử dụng vật phẩm khiêu chiến lệnh Cấp 1")
                    item = nx_execute("tips_data", "get_item_in_view", nx_int(2), "tiguan_reset_item_01")
                  end
                  if current_tab == 2 and form.use_kcl2 then
                    update_status("Sử dụng vật phẩm khiêu chiến lệnh Cấp 2")
                    item = nx_execute("tips_data", "get_item_in_view", nx_int(2), "tiguan_reset_item_01")
                  end
                  if current_tab == 3 and form.use_kcl3 then
                    update_status("Sử dụng vật phẩm khiêu chiến lệnh Cấp 3")
                    item = nx_execute("tips_data", "get_item_in_view", nx_int(2), "tiguan_reset_item_02")
                  end
                  if current_tab == 4 and form.use_kcl4 then
                    update_status("Sử dụng vật phẩm khiêu chiến lệnh Cấp 4")
                    item = nx_execute("tips_data", "get_item_in_view", nx_int(2), "tiguan_reset_item_03")
                  end
                  if item ~= nil then
                    if form.use_kcl1 and form_tiguan.cur_tiguan_level == 1 and current_tab == 1 then
                      local btn = "btn_choice" .. nx_string(i)
                      nx_pause(1)
                      nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", form_tiguan[btn])
                    end
                    if form.use_kcl2 and form_tiguan.cur_tiguan_level == 2 and current_tab == 2 then
                      local btn = "btn_choice" .. nx_string(i)
                      nx_pause(1)
                      nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", form_tiguan[btn])
                    end
                    if form.use_kcl3 and form_tiguan.cur_tiguan_level == 3 and current_tab == 3 then
                      local btn = "btn_choice" .. nx_string(i)
                      nx_pause(1)
                      nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", form_tiguan[btn])
                    end
                    if form.use_kcl4 and form_tiguan.cur_tiguan_level == 4 and current_tab == 4 then
                      local btn = "btn_choice" .. nx_string(i)
                      nx_pause(1)
                      nx_execute(FORM_TIGUAN_MAIN, "on_btn_choice_click", form_tiguan[btn])
                    end
                    local form_choice = nx_value(FORM_TIGUAN_CHOICE_BOSS)
                    if nx_is_valid(form_choice) then
                      local boss_list = get_boss_id_list(guan_id)
                      if boss_list ~= nil then
                        local boss_count = table.getn(boss_list)
                        for l = 1, boss_count do
                          local boss_id = nx_string(boss_list[l])
                          local taget_boss = nx_function("ext_widestr_to_utf8", util_text(boss_id))
                          local find_boss = nx_function("ext_widestr_to_utf8", util_text(current_boss))
                          if nx_execute(FORM_TIGUAN_MAIN, "FindBossBeArrest", boss_id, current_tab) then
                            if find_boss == taget_boss then
                              update_status("Tr\195\185ng danh s\195\161ch truy n\195\163: " .. taget_boss .. " b\225\187\143 qua")
                              current_boss = boss_id
                              nx_pause(1)
                              form_choice:Close()
                            else
                              update_status("Ch\225\187\141n boss trong danh s\195\161ch truy n\195\163: " .. taget_boss)
                              nx_pause(2)
                              nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_APPOINT_BOSS, current_tab, l, 0)
                              current_boss = boss_id
                              nx_pause(1)
                              form_choice:Close()
                            end
                          end
                        end
                      end
                    end
                  else
                  end
                end
              end
              if current_tab == form_tiguan.cur_level_limit and form.auto_sonhap and form_tiguan.btn_easy.Enabled then
                update_status("Chọn turn Sơ Nhập")
                nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_PRACTICE_MODEL)
              end
              nx_pause(2)
              if form_tiguan ~= nil and nil ~= form_tiguan[next_btn] and not form_tiguan.btn_start.Enabled then
                nx_execute(FORM_TIGUAN_MAIN, "on_cbtn_arrestboss_click", form_tiguan[next_btn])
                update_status("Chọn boss thành công")
                break
              end
              nx_pause(2)
              if not nx_is_valid(nx_value(FORM_TIGUAN_CHOICE_BOSS)) then
                update_status("Dọn thư")
                rut_het_qua_trong_thu(thth_nogui_is_started, true)
                arrange_bag(2, 9999)
                update_status("Nhận quà THTH")
                nhan_qua_thth(form)
                local game_client = nx_value("game_client")
                local client_player = game_client:GetPlayer()
                if form.auto_ridding and not has_buff("buf_riding_01") then
                  tim_ngua(item)
                end
                update_status("Bắt đầu khiêu chiến")
                nx_execute("custom_sender", "custom_send_danshua_tiguan_msg", CLIENT_MSG_DS_BEGIN, nx_number(current_tab), 0)
                start_fight = true
              end
              break
            end
          end
        end
      end
    end 
  end
end

function thth_nogui_is_started()
  return __auto_tung_hoanh_started()
end

function nhan_qua_thth(form)
  jump_to_the_air()
  local serial = get_mail_by_item("alonebox")
  while __auto_tung_hoanh_started() and serial ~= nil do
    rut_xoa_thu_by_serial(serial, 2)
    nx_pause(0)
    -- while __auto_tung_hoanh_started() and has_item("alonebox1a", 2) do
    --   dung_vat_pham("alonebox1a",1,3,{1,2})
    -- end
    -- while __auto_tung_hoanh_started() and has_item("alonebox2a", 2) do
    --   dung_vat_pham("alonebox2a",1,3,{1,2})
    -- end
    -- while __auto_tung_hoanh_started() and has_item("alonebox3a", 2) do
    --   dung_vat_pham("alonebox3a",1,3,{1,2})
    -- end
    -- while __auto_tung_hoanh_started() and has_item("alonebox4a", 2) do
    --   dung_vat_pham("alonebox4a",1,3,{1,2})
    -- end
    while __auto_tung_hoanh_started() and has_item("alonebox1", 2) do
      dung_vat_pham("alonebox1",1,3,{1,2})
    end
    -- while __auto_tung_hoanh_started() and has_item("alonebox2", 2) do
    --   dung_vat_pham("alonebox2",1,3,{1,2})
    -- end
    -- while __auto_tung_hoanh_started() and has_item("alonebox3", 2) do
    --   dung_vat_pham("alonebox3",1,3,{1,2})
    -- end
    -- while __auto_tung_hoanh_started() and has_item("alonebox4", 2) do
    --   dung_vat_pham("alonebox4",1,3,{1,2})
    -- end
    serial = get_mail_by_item("alonebox")
  end
  serial = get_mail_by_item("numberbox")
  while __auto_tung_hoanh_started() and serial ~= nil do
    rut_xoa_thu_by_serial(serial, 2)
    nx_pause(0)
    while __auto_tung_hoanh_started() and has_item("numberbox1", 2) do
      dung_vat_pham("numberbox1",1,3,{1,2})
    end
    while __auto_tung_hoanh_started() and has_item("numberbox2", 2) do
      dung_vat_pham("numberbox2",1,3,{1,2})
    end
    while __auto_tung_hoanh_started() and has_item("numberbox3", 2) do
      dung_vat_pham("numberbox3",1,3,{1,2})
    end
    serial = get_mail_by_item("numberbox")
  end
  add_chat_info("Can Binh Luc")
  dung_het_binh_luc("binglu111", form.binhluc)
  dung_het_binh_luc("binglu112", form.binhluc)
  dung_het_binh_luc("binglu113", form.binhluc)
end

function is_in_pick_list_thth(type, content)
  local dir = nx_function("ext_get_current_exe_path") .. "kenfly51cack"
  local file = dir .. nx_string("\\auto_pickup.txt")
  local gm_list = nx_create("StringList")
  if not gm_list:LoadFromFile(file) then
    nx_destroy(gm_list)
    return 0
  end
  local list_num = gm_list:GetStringCount()
  for i = 0, list_num - 1 do
    local pick_items = gm_list:GetStringByIndex(i)
    if pick_items ~= "" and pick_items == content then
      return true
    end
  end
  return false
end

function update_status(status)
  add_chat_info(status)
end

return auto_thth_start