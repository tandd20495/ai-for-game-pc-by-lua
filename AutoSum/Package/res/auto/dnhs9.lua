

local file = assert(loadfile(nx_resource_path() .. "auto\\shared\\core.lua"))
file()


local count = 1

local accounts = {

"tuan030497|t1234567",
"lypt0ng158|01685854781",
"namhainhooo|nguyenthientai",
"action14|ngoinha0",
"asusu655|0937100494",
"action11|ngoinha0110",

}

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
local Hop_Hoa_Son = "box_hsp_wxjz_luh_01"

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
  rut_va_xoa_mail(Hop_Hoa_Son, 2)
end

local items = {
  -- khiep_khach_lenh
  -- hs_lenh,
  --hd_lenh,
  --dao_quan
  --da_ngu_sac
  --bo_de_tu
  Hop_Hoa_Son
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
nx_pause(10)
  add_chat_info("Bắt đầu nhận thư")
  nx_execute("custom_sender", "check_second_word", nx_widestr(pass))
 
    nx_pause(0)
	 for j = 1,5 do
     xoa_thu_rong()
     for i = 1, table.getn(items) do
       rut_qua(items[i], bagTypes[i])
        arrange_bag(2, 0)
       arrange_bag(bagTypes[i], checkNumbers[i])
     end
	 nx_pause(0.2)	 
		 nx_execute("form_stage_main\\form_bag_func", "use_item_by_configid", "box_hsp_wxjz_luh_01")
		
		 nx_pause(2)    
	 for k = 1, 20 do
     nx_execute("custom_sender", "custom_pickup_single_item", k)
	 end
	 nx_pause(1)
	 end
	 
	 local hasItem, id =  has_item(hs_lenh, 125, 0)
		if hasItem then
		add_chat_info("Gui Thu")
      gui_item_di(".Moe..", id, 125)
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
	
	local step = 1
	local diem_ban = {1671.523,142.249,762.728,-0.945}
	local bach_thao_duong = "Reliveschool17A"
	while isStarted do
		nx_pause(0.1)
		local scene = nx_value("form_stage_main\\form_map\\form_map_scene")
		if nx_is_valid(scene) then
			currentMap = LayMapHienTai()
		else
			currentMap = ""
		end
		if step == 0 then
			
		elseif step == 1 then
			local npcId = "npc_hsp_wxjz_lh_04"
			 if getNpcById(npcId) ~= nil then
			 step = 2 
			 else
			 send_homepoint_msg_to_server(Use_HomePoint,X_GetHomeSchool(),4)
      nx_pause(15)
				step = 2 
			end
		elseif step == 2 then
			add_chat_info("Den cho nhan Quest", 3)
			local pos = {1648.378,142.341,742.440,2.666}
			local npcId = "npc_hsp_wxjz_lh_04"
			den_pos(pos, isStarted)
			talk(npcId, {0, 0}, isStarted)
			step = 3
		elseif step == 3 then
			local tran_nhan_id = "npc_hsp_wxjz_lh_01"
			add_chat_info("Dang cho tran nhan xuat hien", 3)
			if getNpcById(tran_nhan_id) ~= nil then 
				step = 4 
			end
		elseif step == 4 then
			jump_to(diem_ban)
			nx_pause(2)
			step = 5
		elseif step == 5 then
			local tran_nhan_id = "npc_hsp_wxjz_lh_01"
			if getNpcById(tran_nhan_id) ~= nil then
				target_npc(tran_nhan_id)
				nx_execute("custom_sender", "custom_huashan_school", nx_int(2), 42)
				if not arrived(diem_ban, 3) then 
					step = 4
				end
			else
				step = 6
			end
		elseif step == 6 then
			local npcId = "npc_hsp_wxjz_lh_04"
			if getNpcById(npcId) ~= nil then
				step = 7
			end
		elseif step == 7 then
			nhanThu()
			step = 8
		end
		if step == 8 then break end
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
