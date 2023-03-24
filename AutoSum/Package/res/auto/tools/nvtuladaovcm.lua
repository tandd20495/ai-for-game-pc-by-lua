function ___tuladao_vcm_isStarted()
  return tuladao_vcm_bool
end

local vcm_map_id = "school11"
local DIEP_TU_KHAM = {
  id = "wgm_051",
  mapId = vcm_map_id,
  tusatquayve = true,
  menu = {
    10001
  }
}

if not ___tuladao_vcm_isStarted() then
  tuladao_vcm_bool = true
  add_chat_info("Bat dau TU LA DAO")

  function run_story()
    local try_index = 1
    local safe_pos
    while ___tuladao_vcm_isStarted() do
      nx_pause(0)
      local da_nhan_q = da_nhan_quest(11111)
      local thich_khach_id = "wgm_xld_013"
      local ruong_bau_id = "box_wgm_001"
      local pos_list = {
        {-93.711,1.147,307.283,-0.012},
        {-85.387,6.004,245.683,-1.528},
        {1.069,1.160,246.080,1.733},
        {-22.206,1.242,279.809,-1.820},
        {-22.000,1.227,325.000,-2.996},
        {42.323,0.976,334.110,2.694}
      }
      
      if not has_buff("buff_wgm_single") then
        talk_to(DIEP_TU_KHAM, DIEP_TU_KHAM.menu)
      else
        if is_dead() then
          hoi_sinh_lan_can()
        else
          auto_pickup("item_wgm_xld,Tu La Đạo Lệnh Bài")
          local thich_khach = getNearestNpc(thich_khach_id)
          local ruong_bau = getNearestNpc(ruong_bau_id)
          if thich_khach ~= nil then
            pos = getPos(thich_khach)
            if not arrived(pos, 2) then
              thanhanh_bay_den(pos, 50, ___tuladao_vcm_isStarted)
            elseif not thich_khach:FindProp("Dead") or tostring(thich_khach:QueryProp("Dead")) == "" or tostring(thich_khach:QueryProp("Dead")) == "0" then
              target_npc_by_ident(thich_khach.Ident)
              nx_execute("auto", "command_chat", "/ap tool skill,1")
            elseif tostring(thich_khach:QueryProp("Dead")) == "1" and tostring(thich_khach:QueryProp("CanPick")) == 1 then
              target_npc_by_ident(thich_khach.Ident)
            end
          elseif ruong_bau ~= nil then
            local pos = getPos(ruong_bau)
            if not arrived(pos, 2) then
              thanhanh_bay_den(pos, 50, ___tuladao_vcm_isStarted)
            else
              nhat_ruong(ruong_bau)
            end
          else
            if try_index > table.getn(pos_list) then try_index = 1 end
            safe_pos = pos_list[try_index]
            safe_pos = {safe_pos[1], safe_pos[2], safe_pos[3]}
            thanhanh_bay_den(safe_pos, 50, ___tuladao_vcm_isStarted)
            if arrived(safe_pos, 3) then
              try_index = try_index + 1
            end
            nx_pause(3)
          end
        end
      end
    end
  end

  run_story()

  tuladao_vcm_bool = false
  add_chat_info("DONE TU LA DAO")
else 
  tuladao_vcm_bool = false
  add_chat_info("STOP TU LA DAO")
end