local file = assert(loadfile(nx_resource_path() .. "auto\\autoCreate\\so_nhap.lua"))
local so_nhap = file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\multiple.lua"))
multiple = file()

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\thanhanh.lua"))
file()


local pass  ="123qqqqqqqqqqq"



local hs_lenh = "item_hsp_exchange01"
local minh_linh_dan = "faculty_yanwu_jhdw06"
local ngu_uan = "item_exchange_xm_mark" 
local the_thoi_trang = "haiwai_box_pingzheng_001"
local co_pho = "cjbook_CS_"
local tan_quyen = "ng_cjbook_jh_"
local hnp = "equip_tihuan_601"
local khiep_khach_lenh = "tiguan_ward_item_01"
local hd_lenh = "Item_xdm_exchange01"
local dao_quan = "item_xdm_dy_xgdh"
local mang_dong = "cropper_40020"
local duoc_kim_cham = "item_wgm_"
local duoc_lt = "item_jzsj_sh_"
local mang_xao_ruou = "caiyao10030"
local da_ngu_sac = "item_nlb_exchange01"
local Hop_da_ngu_sac = "Box_nlb_taskprize_4"
local bo_de_tu = "item_dmp_ptz"

function rut_qua(id, bag)
  add_chat_info("Đang nhận thư")
  -- rut_va_xoa_mail(ngu_uan, 125)
  -- rut_va_xoa_mail(the_thoi_trang, 2)
  -- rut_va_xoa_mail(hnp, 123)
  -- rut_va_xoa_mail(co_pho, 123)
  -- rut_va_xoa_mail(tan_quyen, 123)
  -- rut_va_xoa_mail(khiep_khach_lenh, 2)
  -- rut_va_xoa_mail(hs_lenh, 125)
  rut_va_xoa_mail(hd_lenh, 125)
  -- rut_va_xoa_mail(dao_quan, 125)
  --rut_va_xoa_mail(id, bag)
  --rut_va_xoa_mail(Hop_da_ngu_sac, 2)
end

local items = {
  -- khiep_khach_lenh
  -- hs_lenh,
  hd_lenh
  --dao_quan
  --da_ngu_sac
  --bo_de_tu
  --Hop_da_ngu_sac
}

local bagTypes = {
  2,
  --125,
  --125,
  --125,
  -- 2
  --125
}

local checkNumbers = {
  --0,
  --10,
  3,
  --10
}
function nhanThu()


  add_chat_info("Bắt đầu nhận thư")
 
 
    nx_pause(0)
	 for j = 1,5 do
     xoa_thu_rong()
     for i = 1, table.getn(items) do
       rut_qua(items[i], bagTypes[i])
        arrange_bag(2, 0)
       arrange_bag(bagTypes[i], checkNumbers[i])
     end
	 nx_pause(0.2)	 
		 nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", hd_lenh)
		
		 nx_pause(2)    
	 for k = 1, 20 do
     nx_execute("custom_sender", "custom_pickup_single_item", k)
	 end
	 nx_pause(1)
	 end
	 
	 local hasItem, id =  has_item(hd_lenh, 2, 0)
		if hasItem then
		add_chat_info("Gui Thu")
      gui_item_di(".Man..", id, 2)
      nx_execute("form_stage_main\\form_mail\\form_mail", "auto_show_mail_form")
	  nx_pause(2)    
	 end
	
  


end


send_homepoint_msg_to_server = function(...)
local game_visual = nx_value("game_visual")
if not nx_is_valid(game_visual) then
  return
end
game_visual:CustomSend(nx_int(CLIENT_CUSTOMMSG_SET_HOMEPOINT), unpack(arg))
end

function X_GetHomeSchool()
local game_client = nx_value("game_client")
if not nx_is_valid(game_client) then
  return nil
end
local client_player = game_client:GetPlayer()
local home_tele_id = nil
local maxhp = GetRecordHomePointCount()
for index = maxhp-1, 0, -1 do
  if nx_is_valid(client_player) then
    local home_tele_index = client_player:QueryRecord(HomePointList, index, 1)
    if nx_string(home_tele_index) == "2" then
      home_tele_id = nx_string(client_player:QueryRecord(HomePointList, index, 0))
      break
    end
  end
end
return home_tele_id
end


function  xuong_ngua()
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

function story(isStarted)
local step =4
local targetboss=nil

while isStarted() do
  nx_pause(0.5)
  nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
  if step == 1 then
    add_chat_info("Bat Dau")
	

			nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "Item_xdm_shaqi_001")
	  nx_pause(2)    
	
		send_homepoint_msg_to_server(Use_HomePoint,X_GetHomeSchool(),4)
      nx_pause(15)
		 --CS_xd_dyshd
      step = 2
   
  elseif step == 2 then
					local npc_vao_cong = "npc_xdm_in"
					move(get_npc_pos("born02", npc_vao_cong), 1)
					talk(npc_vao_cong, {0,0}, isStarted)
					nx_pause(10)
					
					
      step = 3

  elseif step == 3 then
    nx_pause(1)
    local chi_dan_id = "NPC_xdm_dy_hs"
    local chi_dan_pos = {-449.628998,309.592987,-229.417007,1.497}
    den_pos(chi_dan_pos, isStarted)
    if getNpcById(chi_dan_id) ~= nil then
      talk(chi_dan_id, {1,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {2,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {0,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {4,1,0}, isStarted)
	  nx_pause(0.2)
	  talk(chi_dan_id, {4,0,0}, isStarted)
	  nx_pause(0.2)
     
      step = 4
    end

  elseif step == 4 then

if da_nhan_quest(20991) then
	local tu_tu_moi_bat = "NPC_xdm_dy_lszf1"
	local hoa = "Gather_xdm_dy_zczf1"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						local fight = nx_value("fight")
						fight:TraceUseSkill("CS_xd_dyshd02", false, false)
						nx_pause(1)
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end
					else 
					if getNpcById(hoa) ~= nil then
					
					step = 5
					end
					end
    elseif da_nhan_quest(20992) then
	local tu_tu_moi_bat = "NPC_xdm_dy_lszf2"
	local hoa = "Gather_xdm_dy_zczf2"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						 local fight = nx_value("fight")
						fight:TraceUseSkill("CS_xd_dyshd02", false, false)
						nx_pause(1)
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end
					else 
					if getNpcById(hoa) ~= nil then
					
					step = 5
					end
					end
					

					
	elseif da_nhan_quest(20993) then
	local tu_tu_moi_bat = "NPC_xdm_dy_lszf3"
	local hoa = "Gather_xdm_dy_zczf3"

					move(get_npc_pos("school13",tu_tu_moi_bat), 1)
					nx_pause(5)
					 
					if getNpcById(tu_tu_moi_bat) ~= nil then
					local fight = nx_value("fight")
						fight:TraceUseSkill("CS_xd_dyshd02", false, false)
						nx_pause(1)
						while getNpcById(tu_tu_moi_bat) ~= nil do

							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end
					else 
					if getNpcById(hoa) ~= nil then
					
					step = 5
					end	
					end

    elseif da_nhan_quest(20994) then
	local tu_tu_moi_bat = "NPC_xdm_dy_lszf4"
	local hoa = "Gather_xdm_dy_zczf4"

					move(get_npc_pos("school13",tu_tu_moi_bat), 1)
					nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
					local fight = nx_value("fight")
						fight:TraceUseSkill("CS_xd_dyshd02", false, false)
						nx_pause(1)
						while getNpcById(tu_tu_moi_bat) ~= nil do

							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end
					else 
					if getNpcById(hoa) ~= nil then
					
					step = 5
					end
					end

    end
  elseif step == 5 then
  if da_nhan_quest(20991) then
	
	local hoa = "Gather_xdm_dy_zczf1"
	local chi_dan_pos = {-658.445,262.161,-298.438,5.258}
					jump_to(chi_dan_pos)
	nx_pause(5)			
					if getNpcById(hoa) ~= nil then
					jump_to(chi_dan_pos)
					nx_pause(10)
					talk_Hoa((hoa), {0}, isStarted)
					elseif getNpcById(hoa) == nil then
					
					step = 6
					end
  elseif da_nhan_quest(20992) then
	
	local hoa = "Gather_xdm_dy_zczf2"
	local chi_dan_pos = {-640.252,272.833,-275.398,-2.544}
					jump_to(chi_dan_pos)
	nx_pause(5)			
					if getNpcById(hoa) ~= nil then
					jump_to(chi_dan_pos)
					nx_pause(10)
					talk_Hoa((hoa), {0}, isStarted)
					elseif getNpcById(hoa) == nil then
					step = 6
					
					end
					

					
	elseif da_nhan_quest(20993) then
	local hoa = "Gather_xdm_dy_zczf3"
	local chi_dan_pos = {-666.207,286.601,-262.592,-0.202}
					jump_to(chi_dan_pos)
	nx_pause(5)			
					if getNpcById(hoa) ~= nil then
					local chi_dan_pos = {-666.207,286.601,-262.592,-0.202}
					jump_to(chi_dan_pos)
					nx_pause(10)
					talk_Hoa((hoa), {0}, isStarted)
					elseif getNpcById(hoa) == nil then
					local temp_pos = {-654.308,286.601,-264.210,0.5904}
					jump_to(temp_pos)
					step = 6
					
					end

    elseif da_nhan_quest(20994) then
	local hoa = "Gather_xdm_dy_zczf4"
	 local chi_dan_pos = {-612.706,286.601,-210.291,1.085}
					jump_to(chi_dan_pos)
	nx_pause(5)			
					if getNpcById(hoa) ~= nil then
					 local chi_dan_pos = {-612.706,286.601,-210.291,1.085}
					jump_to(chi_dan_pos)
					nx_pause(10)
					talk_Hoa((hoa), {0}, isStarted)
					elseif getNpcById(hoa) == nil then
					step = 6
					
					end

    end
 elseif step == 6 then
 local npcTraQ = "NPC_xdm_dy_hs"
	move(get_npc_pos("school13",npcTraQ), 1)
	nx_pause(5)	
	if getNpcById(npcTraQ) ~= nil then
	talk(npcTraQ, {0,0}, isStarted)
	  nx_pause(0.2)
	  step = 7
	end
elseif step == 7 then
if da_nhan_quest(20991) then
	local tu_tu_moi_bat = "NPC_xdm_dy_lszf1"
	local hoa = "Gather_xdm_dy_zczf1"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end
					else 
					if getNpcById(hoa) ~= nil then
					
					step = 8
					end
					end
    elseif da_nhan_quest(20992) then
	local tu_tu_moi_bat = "NPC_xdm_dy_lszf2"
	local hoa = "Gather_xdm_dy_zczf2"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end
					else 
					if getNpcById(hoa) ~= nil then
					
					step = 8
					end
					end
					

					
	elseif da_nhan_quest(20993) then
	local tu_tu_moi_bat = "NPC_xdm_dy_lszf3"
	local hoa = "Gather_xdm_dy_zczf3"

					move(get_npc_pos("school13",tu_tu_moi_bat), 1)
					nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						while getNpcById(tu_tu_moi_bat) ~= nil do

							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end
					else 
					if getNpcById(hoa) ~= nil then
					
					step = 8
					end	
					end

    elseif da_nhan_quest(20994) then
	local tu_tu_moi_bat = "NPC_xdm_dy_lszf4"
	local hoa = "Gather_xdm_dy_zczf4"

					move(get_npc_pos("school13",tu_tu_moi_bat), 1)
					nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						while getNpcById(tu_tu_moi_bat) ~= nil do

							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end
					else 
					if getNpcById(hoa) ~= nil then
					
					step = 8
					end
					end

    end
  elseif step == 8 then
  if da_nhan_quest(20991) then
	
	local hoa = "Gather_xdm_dy_zczf1"
	local chi_dan_pos = {-658.445,262.161,-298.438,5.258}
					jump_to(chi_dan_pos)
	nx_pause(5)			
					if getNpcById(hoa) ~= nil then
							jump_to(chi_dan_pos)
					nx_pause(10)
					talk_Hoa((hoa), {0}, isStarted)
					elseif getNpcById(hoa) == nil then
					
					step = 9
					
					end
  elseif da_nhan_quest(20992) then
	
	local hoa = "Gather_xdm_dy_zczf2"
	local chi_dan_pos = {-640.626,272.574,-276.369,-0.506}
					jump_to(chi_dan_pos)
	nx_pause(5)			
					if getNpcById(hoa) ~= nil then
					jump_to(chi_dan_pos)
					nx_pause(10)
					talk_Hoa((hoa), {0}, isStarted)
					elseif getNpcById(hoa) == nil then
					step = 9
					
					end
					

					
	elseif da_nhan_quest(20993) then
	local hoa = "Gather_xdm_dy_zczf3"
	local chi_dan_pos = {-666.207,286.601,-262.592,-0.202}
					jump_to(chi_dan_pos)
	nx_pause(5)			
					if getNpcById(hoa) ~= nil then
					local chi_dan_pos = {-666.207,286.601,-262.592,-0.202}
					jump_to(chi_dan_pos)
					nx_pause(10)
					talk_Hoa((hoa), {0}, isStarted)
					elseif getNpcById(hoa) == nil then
					local temp_pos = {-654.308,286.601,-264.210,0.5904}
					jump_to(temp_pos)
					step = 9
					
					end

    elseif da_nhan_quest(20994) then
	local hoa = "Gather_xdm_dy_zczf4"
	 local chi_dan_pos = {-612.706,286.601,-210.291,1.085}
					jump_to(chi_dan_pos)
	nx_pause(5)			
					if getNpcById(hoa) ~= nil then
					 local chi_dan_pos = {-612.706,286.601,-210.291,1.085}
					jump_to(chi_dan_pos)
					nx_pause(10)
					talk_Hoa((hoa), {0}, isStarted)
					elseif getNpcById(hoa) == nil then
					step = 9
					
					end

    end
 elseif step == 9 then
 local npcTraQ = "NPC_xdm_dy_hs"
	move(get_npc_pos("school13",npcTraQ), 1)
	nx_pause(5)	
	if getNpcById(npcTraQ) ~= nil then
	talk(npcTraQ, {0,0}, isStarted)
	  nx_pause(0.2)
	  if da_nhan_quest(20991) or da_nhan_quest(20992) or da_nhan_quest(20993) or da_nhan_quest(20994) then
	  step = 8
	  else 
	  step = 10
	  end
	end	
  elseif step == 10 then
  if da_nhan_quest(20996) then
	local tu_tu_moi_bat = "NPC_xdm_dy_mpzf1"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end									
					step = 11
					end
	elseif da_nhan_quest(20997) then
	local tu_tu_moi_bat = "NPC_xdm_dy_mpzf2"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end									
					step = 11
					end
	 elseif da_nhan_quest(20998) then
	local tu_tu_moi_bat = "NPC_xdm_dy_mpzf3"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end									
					step = 11
					end
	 elseif da_nhan_quest(20999) then
	local tu_tu_moi_bat = "NPC_xdm_dy_mpzf4"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						 
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end	
					local chi_dan_pos = {-635.941,266.176,-301.805,-1.17}
					jump_to(chi_dan_pos)						
					step = 11
					end
	
	end
	 elseif step == 11 then
	local npcTraQ = "NPC_xdm_dy_hs"
	move(get_npc_pos("school13",npcTraQ), 1)
	nx_pause(5)	
	if getNpcById(npcTraQ) ~= nil then
	talk(npcTraQ, {0,0}, isStarted)
	  nx_pause(0.2)
	  step = 12
	end	
	
	elseif step == 12 then
	if da_nhan_quest(20996) then
	local tu_tu_moi_bat = "NPC_xdm_dy_mpzf1"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						 
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end									
					step = 13
					end
	 elseif da_nhan_quest(20997) then
	local tu_tu_moi_bat = "NPC_xdm_dy_mpzf2"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						 
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end									
					step = 13
					end
	 elseif da_nhan_quest(20998) then
	local tu_tu_moi_bat = "NPC_xdm_dy_mpzf3"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						 
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end									
					step = 13
					end
	 elseif da_nhan_quest(20999) then
	local tu_tu_moi_bat = "NPC_xdm_dy_mpzf4"
	move(get_npc_pos("school13",tu_tu_moi_bat), 1)
	nx_pause(5)
					if getNpcById(tu_tu_moi_bat) ~= nil then
						nx_pause(7)
						 
						while getNpcById(tu_tu_moi_bat) ~= nil do
						
							Fight_Skill(tu_tu_moi_bat, nil, 10)

						end									
					step = 13
					end
	
	end
	 elseif step == 13 then
	local npcTraQ = "NPC_xdm_dy_hs"
	move(get_npc_pos("school13",npcTraQ), 1)
	nx_pause(5)	
	if getNpcById(npcTraQ) ~= nil then
	talk(npcTraQ, {0,0}, isStarted)
	  nx_pause(0.2)
	  if da_nhan_quest(20996) or da_nhan_quest(20997) or da_nhan_quest(20998) or da_nhan_quest(20999) then
	  step = 12
	  else 
	  step = 100
	  end
	  
	end	
	
	
	
	
  elseif step == 100 then
	 local npcToi = "NPC_xdm_dy_slr"
      move(get_npc_pos("school13",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)
        step = 101
      end
 elseif step == 101 then
 local npcToi = "Gather_xdm_dy_xg1"
      local chi_dan_pos = {-546.026978, -6.46151, -1514.140991, 5.283185}
    
	 jump_to(chi_dan_pos)
	 --den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
	   nx_pause(2)
        talk_Hoa(npcToi, {0}, isStarted)
		
        step = 102
      end  
	elseif step == 102 then
	 local npcToi = "NPC_xdm_dy_slr"
      if getNpcById(npcToi) ~= nil then
       talk(npcToi, {0,0,0}, isStarted)
        step = 103
      end
 elseif step == 103 then
 local npcToi = "Gather_xdm_dy_xg1"
      local chi_dan_pos = {-546.026978, -6.46151, -1514.140991, 5.283185}
    
	 jump_to(chi_dan_pos)
	 --den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
	   nx_pause(2)
        talk_Hoa(npcToi, {0}, isStarted)
		
        step = 104
      end    
	elseif step == 104 then
	 local npcToi = "NPC_xdm_dy_slr"
      if getNpcById(npcToi) ~= nil then
       talk(npcToi, {0,0,0}, isStarted)
        step = 105
      end
 elseif step == 105 then
 local npcToi = "Gather_xdm_dy_xg1"
      local chi_dan_pos = {-546.026978, -6.46151, -1514.140991, 5.283185}
    
	 jump_to(chi_dan_pos)
	 --den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
	   nx_pause(2)
        talk_Hoa(npcToi, {0}, isStarted)
		
        step = 106
      end    
	elseif step == 106 then
	 local npcToi = "NPC_xdm_dy_slr"
      if getNpcById(npcToi) ~= nil then
       talk(npcToi, {0,0,0}, isStarted)
        step = 107
      end
 elseif step == 107 then
 local npcToi = "Gather_xdm_dy_xg1"
      local chi_dan_pos = {-546.026978, -6.46151, -1514.140991, 5.283185}
    
	 jump_to(chi_dan_pos)
	 --den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
	   nx_pause(2)
        talk_Hoa(npcToi, {0}, isStarted)
		
        step = 108
      end    
	elseif step == 108 then
	 local npcToi = "NPC_xdm_dy_slr"
      if getNpcById(npcToi) ~= nil then
       talk(npcToi, {0,0,0}, isStarted)
        step = 109
      end
 elseif step == 109 then
 local npcToi = "Gather_xdm_dy_xg1"
      local chi_dan_pos = {-546.026978, -6.46151, -1514.140991, 5.283185}
    
	 jump_to(chi_dan_pos)
	 --den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
	   nx_pause(2)
        talk_Hoa(npcToi, {0}, isStarted)
		
        step = 110
      end    
	  
	  
	  
	  
	  elseif step == 120 then
	 
		local npcToi = "Gather_xdm_dy_xg1"
      local chi_dan_pos = {-571.122009 ,-6.124799 ,-1520.456055 ,5.283185}
    
	 jump_to(chi_dan_pos)
	 --den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then  
	  nx_pause(2)	  
        talk_Hoa(npcToi, {0}, isStarted)		
        step = 103
      end  
	  elseif step == 103 then
	  
 local npcToi = "Gather_xdm_dy_xg1"
      local chi_dan_pos = {-576.372009, -6.32458, -1485.741943, 5.283185}
    
	 jump_to(chi_dan_pos)
	 --den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
	   nx_pause(2)
        talk_Hoa(npcToi, {0}, isStarted)
        step = 104
      end  
	  elseif step == 104 then
 local npcToi = "Gather_xdm_dy_xg1"
      local chi_dan_pos = {-615.265991, -6.168944, -1530.953003 ,5.283152}
    
	 jump_to(chi_dan_pos)
	 --den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
	   nx_pause(2)
        talk_Hoa(npcToi, {0}, isStarted)
        step = 105
      end  
	  elseif step == 105 then
 local npcToi = "Gather_xdm_dy_xg1"
      local chi_dan_pos = {-565.461975, -6.57379, -1580.36499, 5.283185}
    
	 jump_to(chi_dan_pos)
	 --den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
	   nx_pause(5)
        talk_Hoa(npcToi, {0}, isStarted)
        step = 106
      end  
	 elseif step == 106 then
	  local chi_dan_pos = {-502.86499, -5.615, -1528.963013, 4.29185}
    
	 jump_to(chi_dan_pos)
	 step = 107
	 elseif step == 107 then
	  local npcToi = "NPC_xdm_dy_slr"
      if getNpcById(npcToi) ~= nil then
        step = 108
      end
	 
	 
	 
	  elseif step == 110 then
	local npcTraQ = "NPC_xdm_dy_hs"
	move(get_npc_pos("school13",npcTraQ), 1)
	nx_pause(5)	
	if getNpcById(npcTraQ) ~= nil then
	talk(npcTraQ, {0,0}, isStarted)
	  nx_pause(0.2)
	  step = 111
	end	
	elseif step == 111 then
	nhanThu()
	step =112
	
	elseif step == 112 then
	send_homepoint_msg_to_server(Use_HomePoint,X_GetHomeSchool(),4)
      nx_pause(15)
	 add_chat_info("Ket Thuc")
	 break
  end



end
end

			

function joinschool_isStarted()
return auto_so_nhap_bat_phai
end

function joinschool()
if not joinschool_isStarted() then
  auto_so_nhap_bat_phai = true

  add_chat_info("Start Join School for all accounts")
  function run_story()

    story(joinschool_isStarted)
  end
  run_story()

  auto_so_nhap_bat_phai = false
else
  add_chat_info("Stop joining school")
  auto_so_nhap_bat_phai = false
end
end
joinschool()
