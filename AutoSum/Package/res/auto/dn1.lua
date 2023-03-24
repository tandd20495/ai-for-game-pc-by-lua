local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\core.lua"))
file()
local count = 1

local accounts = {

"aabb005|ngoinha123",
"aabb006|ngoinha123",
"aabb007|ngoinha123",
"aabb008|ngoinha123",
"aabb009|ngoinha123",
"aabb010|ngoinha123",
}
local pass  ="11111111111111"



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
  -- rut_va_xoa_mail(hd_lenh, 125)
  -- rut_va_xoa_mail(dao_quan, 125)
  --rut_va_xoa_mail(id, bag)
  rut_va_xoa_mail(Hop_da_ngu_sac, 2)
end

local items = {
  -- khiep_khach_lenh
  -- hs_lenh,
  --hd_lenh,
  --dao_quan
  --da_ngu_sac
  --bo_de_tu
  Hop_da_ngu_sac
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
  nx_execute("custom_sender", "check_second_word", nx_widestr(pass))
 
    nx_pause(0)
	 for j = 1,10 do
     xoa_thu_rong()
     for i = 1, table.getn(items) do
       rut_qua(items[i], bagTypes[i])
        arrange_bag(2, 0)
       arrange_bag(bagTypes[i], checkNumbers[i])
     end
	 nx_pause(0.2)	 
		 nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "Box_nlb_taskprize_4")
		
		 nx_pause(2)    
	 for k = 1, 20 do
     nx_execute("custom_sender", "custom_pickup_single_item", k)
	 end
	 nx_pause(1)
	 end
	 
	 local hasItem, id =  has_item(da_ngu_sac, 2, 0)
		if hasItem then
		add_chat_info("Gui Thu")
      gui_item_di(".Moe..", id, 2)
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

function xuong_ngua()
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
function changeAcc1(userName)
	
	local gEffect = nx_value("global_effect")
	if nx_is_valid(gEffect) then
	  gEffect:ClearEffects()
	end
	local team_manager = nx_value("team_manager")
	if nx_is_valid(team_manager) then
	  team_manager:ClearAllData()
	end
	nx_execute("stage", "set_current_stage", "login")
	nx_execute("client", "close_connect")
		
			 local stage = nx_value("stage")
			 if stage == "login" then
				 local form = util_get_form("form_stage_login\\form_login", true)
				 if nx_is_valid(form) then
					 local game_config = nx_value("game_config")
					 local pos = util_split_string(nx_string(userName), "|")
					 form.ipt_1.Text = nx_widestr(pos[1])
					 form.ipt_2:Append(nx_widestr(pos[2]))
					
					 nx_execute("form_stage_login\\form_login", "on_btn_enter_click", form.btn_enter)
					 nx_pause(10)
				 end
			 end
end
function story1(isStarted)
	
	local step =1
local targetboss=nil

while isStarted() do
  nx_pause(0.5)
  nx_execute("form_stage_main\\form_helper\\form_main_helper_manager" , "close_helper_form")
  if step == 1 then
    add_chat_info("Bat Dau")
    local chi_dan_id = "npc_nlb_ww57"

    if getNpcById(chi_dan_id) ~= nil then
      step = 2
    else
      send_homepoint_msg_to_server(Use_HomePoint,X_GetHomeSchool(),4)
      nx_pause(15)
      step = 2
    end
  elseif step == 2 then
    local current_map = LayMapHienTai()
    if current_map == "school15" then
      len_ngua()
      step = 3
    end
  elseif step == 3 then
    nx_pause(1)
    local chi_dan_id = "npc_nlb_ww57"
    local chi_dan_pos = {2097.553955,116.68,771.169,0}
    den_pos(chi_dan_pos, isStarted)
    if getNpcById(chi_dan_id) ~= nil then
      talk(chi_dan_id, {0,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {0,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {0,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {0,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {0,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {1,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {1,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {0,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {0,0}, isStarted)
	  nx_pause(0.2)
      talk(chi_dan_id, {0,0}, isStarted)
	  nx_pause(0.2)
      step = 4
    end

  elseif step == 4 then

    if da_nhan_quest(21362) then
      targetboss = "npc_nlb_ww33"
      local npcToi = "npc_nlb_ww26"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 5
      end
    elseif da_nhan_quest(21331) then
      targetboss = "npc_nlb_ww29"
      local npcToi = "npc_nlb_ww22"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 5
      end
    elseif da_nhan_quest(21360) then
      targetboss = "npc_nlb_ww31"
      local npcToi = "npc_nlb_ww24"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 5
      end
    elseif da_nhan_quest(21349) then
      targetboss = "npc_nlb_ww30"
      local npcToi = "npc_nlb_ww23"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)
        auto_is_running = true
        step = 5
      end
    elseif da_nhan_quest(21363) then
      targetboss = "npc_nlb_ww34"
      local npcToi = "npc_nlb_ww27"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 5
      end
    elseif da_nhan_quest(21361) then
      targetboss = "npc_nlb_ww32"
      local npcToi = "npc_nlb_ww25"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 5
      end
    end
  elseif step == 5 then
    xuong_ngua()
    local target = targetboss

    local game_shortcut = nx_value("GameShortcut")
    while getNpcById(target) == nil do
      local FORM_SHORTCUT = "form_stage_main\\form_main\\form_main_shortcut"
      local form = nx_value(FORM_SHORTCUT)
      local grid = form.grid_shortcut_main

      local actions = get_obj_actions_full(bossID)
      if in_array("parrying_up", actions) then
        game_shortcut:on_main_shortcut_useitem(grid, 0, true)
      end
      local buffNC = get_buff_info("buf_CS_jl_shuangci07")
      if (buffNC == nil or buffNC < 5) and not in_array("hurtdown", actions) then
        game_shortcut:on_main_shortcut_useitem(grid, 3, true)
        nx_pause(0.1)
      end
      -- nhấn 1,2,3,4,5 liên tục
      game_shortcut:on_main_shortcut_useitem(grid, 0, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 1, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 2, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 3, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 0, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 1, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 2, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 3, true)
      nx_pause(0.1)


    end

    step = 6

  elseif step == 6 then
    nx_pause(0.2)
    len_ngua()
    local npcTraQ = targetboss
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      talk(npcTraQ, {0,0,0}, isStarted)

      step = 7
    end

  elseif step == 7 then
    nx_pause(0.2)
	len_ngua()
    local npcTraQ = "npc_nlb_ww57"
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      talk(npcTraQ, {0,0}, isStarted)
      talk(npcTraQ, {0,0}, isStarted)
      step = 8
    end
  elseif step == 8 then
len_ngua()
    if da_nhan_quest(21362) then
      targetboss = "npc_nlb_ww33"
      local npcToi = "npc_nlb_ww26"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 9
      end
    elseif da_nhan_quest(21331) then
      targetboss = "npc_nlb_ww29"
      local npcToi = "npc_nlb_ww22"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 9
      end
    elseif da_nhan_quest(21360) then
      targetboss = "npc_nlb_ww31"
      local npcToi = "npc_nlb_ww24"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 9
      end
    elseif da_nhan_quest(21349) then
      targetboss = "npc_nlb_ww30"
      local npcToi = "npc_nlb_ww23"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)
        auto_is_running = true
        step = 9
      end
    elseif da_nhan_quest(21363) then
      targetboss = "npc_nlb_ww34"
      local npcToi = "npc_nlb_ww27"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 9
      end
    elseif da_nhan_quest(21361) then
      targetboss = "npc_nlb_ww32"
      local npcToi = "npc_nlb_ww25"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0,0}, isStarted)

        step = 9
      end
    end
  elseif step == 9 then
    xuong_ngua()
    local target = targetboss

    local game_shortcut = nx_value("GameShortcut")
    while getNpcById(target) == nil do
      local FORM_SHORTCUT = "form_stage_main\\form_main\\form_main_shortcut"
      local form = nx_value(FORM_SHORTCUT)
      local grid = form.grid_shortcut_main

      local actions = get_obj_actions_full(bossID)
      if in_array("parrying_up", actions) then
        game_shortcut:on_main_shortcut_useitem(grid, 0, true)
      end
      local buffNC = get_buff_info("buf_CS_jl_shuangci07")
      if (buffNC == nil or buffNC < 5) and not in_array("hurtdown", actions) then
        game_shortcut:on_main_shortcut_useitem(grid, 3, true)
        nx_pause(0.1)
      end
      -- nhấn 1,2,3,4,5 liên tục
      game_shortcut:on_main_shortcut_useitem(grid, 0, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 1, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 2, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 3, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 0, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 1, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 2, true)
      nx_pause(0.1)
      game_shortcut:on_main_shortcut_useitem(grid, 3, true)
      nx_pause(0.1)


    end

    step = 10

  elseif step == 10 then
    nx_pause(0.2)
    len_ngua()
    local npcTraQ = targetboss
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      talk(npcTraQ, {0,0,0}, isStarted)

      step = 11
    end

  elseif step == 11 then
    nx_pause(0.2)
	len_ngua()
    local npcTraQ = "npc_nlb_ww57"
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      nx_pause(0.2)
      talk(npcTraQ, {0,0}, isStarted)
      step = 12
    end
  elseif step == 12 then
    add_chat_info("xong Q 3")

    step = 13


    --- Q tra thu
  elseif step == 13 then
len_ngua()
    if da_nhan_quest(21337) then --Cung Mị Vũ

      local npcToi = "npc_nlb_008"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        local chi_dan_pos = {1701.564,113.539,985.778,2.225}
        den_pos(chi_dan_pos, isStarted)
        talk(npcToi, {0,0}, isStarted)
        step = 14
      end
    elseif da_nhan_quest(21341) then --Cung Bích Nhã
      local npcToi = "npc_nlb_009"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 14
      end
    elseif da_nhan_quest(21340) then -- Chi Thanh U
      local npcToi = "npc_nlb_006"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 14
      end
    elseif da_nhan_quest(21339) then --Hiên Viên Thiên Vũ
      local npcToi = "npc_nlb_005"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        local chi_dan_pos = {2417.7900,114.990,1073.259,4.208}
        den_pos(chi_dan_pos, isStarted)
        talk(npcToi, {0,0}, isStarted)
        step = 14
      end
    elseif da_nhan_quest(21332) then  --Hàng Thái Y
      local npcToi = "npc_nlb_007"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 14
      end
    elseif da_nhan_quest(21338) then --Thất Khở Mộng
      local npcToi = "npc_nlb_010"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 14
      end
    end
  elseif step == 14 then
    nx_pause(0.2)
	len_ngua()
    local npcTonChu = "npc_nlb_001"
    move(get_npc_pos("school15",npcTonChu), 1)
    if getNpcById(npcTonChu) ~= nil then
      talk(npcTonChu, {0,0}, isStarted)
      step = 15
    end

  elseif step == 15 then
    nx_pause(0.2)
	len_ngua()
    local npcTraQ = "npc_nlb_ww57"
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      nx_pause(0.2)
      talk(npcTraQ, {0,0}, isStarted)
      nx_pause(0.1)
      talk(npcTraQ, {0,0}, isStarted)
      step = 16
    end


  elseif step == 16 then
  len_ngua()
    if da_nhan_quest(21337) then --Cung Mị Vũ

      local npcToi = "npc_nlb_008"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then

        local chi_dan_pos = {1701.564,113.539,985.778,2.225}
        den_pos(chi_dan_pos, isStarted)

        talk(npcToi, {0,0}, isStarted)
        step = 17
      end
    elseif da_nhan_quest(21341) then  --Cung Bích Nhã
      local npcToi = "npc_nlb_009"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 17
      end
    elseif da_nhan_quest(21340) then
      local npcToi = "npc_nlb_006"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 17
      end
    elseif da_nhan_quest(21339) then
      local npcToi = "npc_nlb_005"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        local chi_dan_pos = {2417.7900,114.990,1073.259,4.208}
        den_pos(chi_dan_pos, isStarted)
        talk(npcToi, {0,0}, isStarted)
        step = 17
      end
    elseif da_nhan_quest(21332) then
      local npcToi = "npc_nlb_007"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 17
      end
    elseif da_nhan_quest(21338) then
      local npcToi = "npc_nlb_010"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 17
      end
    end
  elseif step ==17 then
    nx_pause(0.2)
	len_ngua()
    local npcTonChu = "npc_nlb_001"
    move(get_npc_pos("school15",npcTonChu), 1)
    if getNpcById(npcTonChu) ~= nil then
      talk(npcTonChu, {0,0}, isStarted)
      step = 18
    end
  elseif step == 18 then
    nx_pause(0.2)
	len_ngua()
    local npcTraQ = "npc_nlb_ww57"
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      nx_pause(0.2)
      talk(npcTraQ, {0,0}, isStarted)
      step = 19
    end
  elseif step == 19 then
    add_chat_info("xong Q ")
    step = 20
    -- -- q ho tong
  elseif step == 20 then

    nx_pause(0.2)

    local npcHoTong = "npc_nlb_002"
    move(get_npc_pos("school15",npcHoTong), 1)
    if getNpcById(npcHoTong) ~= nil then
      talk(npcHoTong, {0,0}, isStarted)
      xuong_ngua()
      step = 21
    end
  elseif step == 21 then

    if da_nhan_quest(21343) then --Cung Mị Vũ

      local npcToi = "npc_nlb_008"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        local chi_dan_pos = {1701.564,113.539,985.778,2.225}
        den_pos(chi_dan_pos, isStarted)
        talk(npcToi, {0,0}, isStarted)
        step = 22
      end
    elseif da_nhan_quest(21347) then
      local npcToi = "npc_nlb_009"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 22
      end
    elseif da_nhan_quest(21346) then
      local npcToi = "npc_nlb_006"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 22
      end
    elseif da_nhan_quest(21345) then
      local npcToi = "npc_nlb_005"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        local chi_dan_pos = {2417.7900,114.990,1073.259,4.208}
        den_pos(chi_dan_pos, isStarted)
        talk(npcToi, {0,0}, isStarted)
        step = 22
      end
    elseif da_nhan_quest(21330) then
      local npcToi = "npc_nlb_007"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 22
      end
    elseif da_nhan_quest(21344) then
      local npcToi = "npc_nlb_010"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 22
      end
    end
  elseif step == 22 then
    len_ngua()
    local npcTraQ = "npc_nlb_ww57"
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      nx_pause(0.1)
      talk(npcTraQ, {0,0}, isStarted)
      step = 23
    end


  elseif step == 23 then
    nx_pause(0.2)
    local npcHoTong = "npc_nlb_002"
    move(get_npc_pos("school15",npcHoTong), 1)
    if getNpcById(npcHoTong) ~= nil then
      talk(npcHoTong, {0,0}, isStarted)

      xuong_ngua()
      step = 24
    end
  elseif step == 24 then
    if da_nhan_quest(21343) then --Cung Mị Vũ

      local npcToi = "npc_nlb_008"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        local chi_dan_pos = {1701.564,113.539,985.778,2.225}
        den_pos(chi_dan_pos, isStarted)
        talk(npcToi, {0,0}, isStarted)
        step = 25
      end
    elseif da_nhan_quest(21347) then
      local npcToi = "npc_nlb_009"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 25
      end
    elseif da_nhan_quest(21346) then
      local npcToi = "npc_nlb_006"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 25
      end
    elseif da_nhan_quest(21345) then
      local npcToi = "npc_nlb_005"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        local chi_dan_pos = {2417.7900,114.990,1073.259,4.208}
        den_pos(chi_dan_pos, isStarted)
        talk(npcToi, {0,0}, isStarted)
        step = 25
      end
    elseif da_nhan_quest(21330) then
      local npcToi = "npc_nlb_007"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 25
      end
    elseif da_nhan_quest(21344) then
      local npcToi = "npc_nlb_010"
      move(get_npc_pos("school15",npcToi), 1)
      if getNpcById(npcToi) ~= nil then
        talk(npcToi, {0,0}, isStarted)
        step = 25
      end
    end
  elseif step == 25 then
    nx_pause(0.2)
    len_ngua()
    local npcTraQ = "npc_nlb_ww57"
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      nx_pause(0.2)
      talk(npcTraQ, {0,0}, isStarted)
      step = 26
    end
  elseif step == 26 then
    add_chat_info("xong Q Ho Tong")
    step =27
  elseif step == 27 then


    if da_nhan_quest(21336) then

      local npcToi = "GatherNpc_nlb_cc_01"
      local chi_dan_pos = {1525.24,78.80,1276.189,0.44}
      den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
        --talk(npcToi, {0,0,0}, isStarted)
        step = 41
      end
    elseif da_nhan_quest(21365) then
      local npcToi = "GatherNpc_nlb_cc_02"
      --move(get_npc_pos("school15",npcToi), 1)
      local chi_dan_pos = {1525.24,76.090,1344.124,-0.7}
      den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
        --talk(npcToi, {0,0,0}, isStarted)
        step = 42
      end
    elseif da_nhan_quest(21366) then --
      local npcToi = "GatherNpc_nlb_cc_03"

      local chi_dan_pos = {1845.276,84.65,1227.779,0.206}
      den_pos(chi_dan_pos, isStarted)



      if getNpcById(npcToi) ~= nil then
        move(get_npc_pos("school15",npcToi), 1)
        nx_pause(10)
        talk_Hoa(npcToi, {0}, isStarted)

        step = 28
      end
    elseif da_nhan_quest(21367) then
      local npcToi = "GatherNpc_nlb_cc_04"

      --move(get_npc_pos("school15",npcToi), 1)
      local chi_dan_pos = {2030.952,118.95,1066.901,-2.8169}
      den_pos(chi_dan_pos, isStarted)

      --talk(npcToi, {0,0,0}, isStarted)
      step = 44

    elseif da_nhan_quest(21368) then
      local npcToi = "GatherNpc_nlb_cc_05"


      --move(get_npc_pos("school15",npcToi), 1)
      local chi_dan_pos = {1881.308,102.998,978.1500,-0.893}
      den_pos(chi_dan_pos, isStarted)

      --talk(npcToi, {0,0,0}, isStarted)
      step = 45
    elseif da_nhan_quest(21369) then
      local npcToi = "GatherNpc_nlb_cc_06"

      --move(get_npc_pos("school15",npcToi), 1)
      local chi_dan_pos = {2295.35,117.35,818.90,0.785}
      den_pos(chi_dan_pos, isStarted)

      --talk(npcToi, {0,0,0}, isStarted)
      step = 46
    end
  elseif step == 28 then
    nx_pause(0.2)
    len_ngua()
    local npcTraQ = "npc_nlb_ww57"
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      talk(npcTraQ, {0,0}, isStarted)
      step = 29
    end
  elseif step == 29 then

    if da_nhan_quest(21336) then

      local npcToi = "GatherNpc_nlb_cc_01"
      local chi_dan_pos = {1525.24,78.80,1276.189,0.44}
      den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
        --talk(npcToi, {0,0,0}, isStarted)
        step = 31
      end
    elseif da_nhan_quest(21365) then
      local npcToi = "GatherNpc_nlb_cc_02"
      --move(get_npc_pos("school15",npcToi), 1)
      local chi_dan_pos = {1525.24,76.090,1344.124,-0.7}
      den_pos(chi_dan_pos, isStarted)
      if getNpcById(npcToi) ~= nil then
        --talk(npcToi, {0,0,0}, isStarted)
        step = 32
      end
    elseif da_nhan_quest(21366) then --
      local npcToi = "GatherNpc_nlb_cc_03"

      local chi_dan_pos = {1845.276,84.65,1227.779,0.206}
      den_pos(chi_dan_pos, isStarted)



      if getNpcById(npcToi) ~= nil then
        move(get_npc_pos("school15",npcToi), 1)

        nx_pause(10)
        talk_Hoa(npcToi, {0}, isStarted)
        talk_Hoa(npcToi, {0}, isStarted)
        step = 30
      end
    elseif da_nhan_quest(21367) then
      local npcToi = "GatherNpc_nlb_cc_04"

      --move(get_npc_pos("school15",npcToi), 1)
      local chi_dan_pos = {2030.952,118.95,1066.901,-2.8169}
      den_pos(chi_dan_pos, isStarted)

      --talk(npcToi, {0,0,0}, isStarted)
      step = 34

    elseif da_nhan_quest(21368) then
      local npcToi = "GatherNpc_nlb_cc_05"


      --move(get_npc_pos("school15",npcToi), 1)
      local chi_dan_pos = {1881.308,102.998,978.1500,-0.893}
      den_pos(chi_dan_pos, isStarted)

      --talk(npcToi, {0,0,0}, isStarted)
      step = 35
    elseif da_nhan_quest(21369) then
      local npcToi = "GatherNpc_nlb_cc_06"

      --move(get_npc_pos("school15",npcToi), 1)
      local chi_dan_pos = {2295.35,117.35,818.90,0.785}
      den_pos(chi_dan_pos, isStarted)

      --talk(npcToi, {0,0,0}, isStarted)
      step = 36

    end
  elseif step == 30 then
    nx_pause(0.2)
    len_ngua()
    local npcTraQ = "npc_nlb_ww57"
    move(get_npc_pos("school15",npcTraQ), 1)
    if getNpcById(npcTraQ) ~= nil then
      talk(npcTraQ, {0,0,0}, isStarted)
      step = 100
    end
  elseif step == 32 then
    xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_02"
    jump_to(get_npc_pos("school15",npcToi))
    add_chat_info("dang nhat hoa")
    if getNpcById(npcToi) ~= nil then
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)
      nx_pause(5)
	  
	  local bag = util_get_form("form_stage_main\\form_bag", true, false)
	   local hasItem, id =  has_item("item_nlb_cc_15958", 125, 1)
	  
		if hasItem then
		
      local chi_dan_pos = {1525.24,76.090,1344.124,-0.7}
      jump_to(chi_dan_pos)

      step = 30
	  end
	  
     
    end
  elseif step == 31 then
    xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_01"
    jump_to(get_npc_pos("school15",npcToi))

    if getNpcById(npcToi) ~= nil then
      move(get_npc_pos("school15",npcToi), 1)
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)
      nx_pause(0.5)
      local chi_dan_pos = {1525.24,78.80,1276.189,0.44}
      jump_to(chi_dan_pos)

      step = 30
    end
  elseif step == 34 then
    xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_04"
    jump_to(get_npc_pos("school15",npcToi))
    if getNpcById(npcToi) ~= nil then

      move(get_npc_pos("school15",npcToi), 1)
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)
      nx_pause(5)
      local chi_dan_pos = {2030.952,118.95,1066.901,-2.8169}
      jump_to(chi_dan_pos)

      step = 30
    end
  elseif step == 35 then
    xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_05"
    jump_to(get_npc_pos("school15",npcToi))
    if getNpcById(npcToi) ~= nil then

      move(get_npc_pos("school15",npcToi), 1)
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)
      nx_pause(5)
      local chi_dan_pos = {1881.308,102.998,978.1500,-0.893}
      jump_to(chi_dan_pos)

      step = 30
    end
  elseif step == 36 then
    xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_06"

    --local chi_dan_pos1 = {2340.288,112.149,865.41,0}
    --jump_to(chi_dan_pos1)
    jump_to(get_npc_pos("school15",npcToi))
    nx_pause(0.5)
    if getNpcById(npcToi) ~= nil then
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)

      nx_pause(0.5)
      local chi_dan_pos = {2295.35,117.35,818.90,0.785}
      jump_to(chi_dan_pos)

      step = 30
    end




  elseif step == 42 then
     xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_02"
    jump_to(get_npc_pos("school15",npcToi))

    if getNpcById(npcToi) ~= nil then
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)
      nx_pause(5)
	 local bag = util_get_form("form_stage_main\\form_bag", true, false)
	   local hasItem, id =  has_item("item_nlb_cc_15958", 125, 1)
	  
		if hasItem then
		
      local chi_dan_pos = {1525.24,76.090,1344.124,-0.7}
      jump_to(chi_dan_pos)

      step = 28
	  end
    end
  elseif step == 41 then
    xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_01"
    jump_to(get_npc_pos("school15",npcToi))

    if getNpcById(npcToi) ~= nil then
      move(get_npc_pos("school15",npcToi), 1)
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)
      nx_pause(0.5)
      local chi_dan_pos = {1525.24,78.80,1276.189,0.44}
      jump_to(chi_dan_pos)

      step = 28
    end
  elseif step == 44 then
    xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_04"
    jump_to(get_npc_pos("school15",npcToi))
    if getNpcById(npcToi) ~= nil then

      move(get_npc_pos("school15",npcToi), 1)
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)
      nx_pause(5)
      local chi_dan_pos = {2030.952,118.95,1066.901,-2.8169}
      jump_to(chi_dan_pos)

      step = 28
    end
  elseif step == 45 then
    xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_05"
    jump_to(get_npc_pos("school15",npcToi))
    if getNpcById(npcToi) ~= nil then

      move(get_npc_pos("school15",npcToi), 1)
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)
      nx_pause(5)
      local chi_dan_pos = {1881.308,102.998,978.1500,-0.893}
      jump_to(chi_dan_pos)

      step = 28
    end
  elseif step == 46 then
    xuong_ngua()
    local npcToi = "GatherNpc_nlb_cc_06"
    jump_to(get_npc_pos("school15",npcToi))

    if getNpcById(npcToi) ~= nil then
      move(get_npc_pos("school15",npcToi), 1)
      nx_pause(10)
      talk_Hoa(npcToi, {0}, isStarted)
      nx_pause(0.5)
      local chi_dan_pos = {2295.35,117.35,818.90,0.785}
      jump_to(chi_dan_pos)

      step = 28
    end

  elseif step == 100 then
  nhanThu()
    add_chat_info("Ket Thuc")
    break
  end



end
			
			
	
end
		
function do_action1(action, accounts, isStarted, actionName, step)
	actionName = actionName or "Running account"
	step = step or 1
	local count = 0
	while isStarted() and count <= table.getn(accounts) do
		nx_pause(0.1)
		local stage = nx_value("stage")
		if stage ~= nil and stage == "main" then
		-- cho load map xong
		local stage_main_flag = nx_value("stage_main")
		local loading_flag = nx_value("loading")
		while isStarted() and (loading_flag or nx_string(stage_main_flag) ~= nx_string("success")) do
			nx_pause(0.1)
			stage_main_flag = nx_value("stage_main")
			loading_flag = nx_value("loading")
		end
		
		local game_visual = nx_value("game_visual")
		game_visual.HidePlayer = true
		nx_function("ext_hide_player_F9")
		local world = nx_value("world")
		local scene = world.MainScene
		local game_control = scene.game_control
		game_control.MaxDisplayFPS = 24

		local game_config = nx_value("game_config")
		local account = game_config.login_account
		local msg = "[" ..nx_string(count) .."/" ..nx_string(table.getn(accounts)) .. "] " ..account
		nx_function("ext_set_window_title", nx_function("ext_utf8_to_widestr", msg))			
		action()
		
		
		count = count + step
		local userName = accounts[count]
		if userName ~= nil then
				if isStarted() then
					
					nx_pause(3)
					changeAcc1(userName)
				end
			end
			stage = nx_value("stage")
			
			if stage == "roles" then
				nx_execute("client", "choose_role", 0)
				nx_pause(10)
			end
			if stage == "main" then
					add_chat_info("man hinh chinh", 3)
			end
			
			
			
		end
	end
	add_chat_info("Done Current Multiple " ..actionName)
end


	
function joinschool_isStarted()
	return auto_so_nhap_bat_phai
end

function joinschool()
	if not joinschool_isStarted() then
		auto_so_nhap_bat_phai = true
	
	

		add_chat_info("Start Join School for all accounts")
		function run_story()
			story1(joinschool_isStarted)
		end
		--run_story()
		do_action1(run_story, accounts, joinschool_isStarted, "join school", step)
		add_chat_info("Done joining school")
		auto_so_nhap_bat_phai = false
	else 
		add_chat_info("Stop joining school")
		auto_so_nhap_bat_phai = false
	end
end
joinschool()
